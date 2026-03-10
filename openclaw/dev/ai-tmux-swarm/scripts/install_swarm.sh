#!/usr/bin/env bash
set -euo pipefail

usage() { echo "Usage: $0 <repo-path> [chat-id] [--engine codex|claude]" >&2; exit 1; }
[[ $# -lt 1 ]] && usage

REPO="$1"; shift
CHAT_ID="${1:-8319497931}"; [[ "${1:-}" != --* ]] && shift || true
ENGINE="codex"
while [[ $# -gt 0 ]]; do
  case "$1" in
    --engine) ENGINE="$2"; shift 2 ;;
    *) shift ;;
  esac
done
[[ "$ENGINE" == "codex" || "$ENGINE" == "claude" ]] || { echo "Error: --engine must be codex or claude" >&2; exit 1; }

DEFAULT_MODEL="gpt-5.3-codex"
[[ "$ENGINE" == "claude" ]] && DEFAULT_MODEL="claude-sonnet-4-6"
mkdir -p "$REPO"
cd "$REPO"

if [[ ! -d .git ]]; then
  git init -b main >/dev/null
fi
if ! git rev-parse HEAD >/dev/null 2>&1; then
  echo "# project" > README.md
  git add README.md
  git commit -m "chore: bootstrap repository" >/dev/null 2>&1 || true
fi

mkdir -p .swarm/{scripts,prompts,logs,state,worktree}

cat > .swarm/prompts/backend.md <<'P'
你是 Codex 后端 Agent。
实现 FastAPI + SQLAlchemy + SQLite 后端，完成 students/courses/enrollments 全 CRUD。
DoD：可启动、接口齐全、提交 commit。
P

cat > .swarm/prompts/frontend.md <<'P'
你是 Codex 前端 Agent。
实现 Jinja2 + Bootstrap 页面：仪表盘、学生/课程/选课管理（列表/搜索/增删改）。
DoD：页面可用、错误提示清晰、提交 commit。
P

cat > .swarm/prompts/qa.md <<'P'
你是 Codex QA Agent。
补齐 pytest、README、.env.example；跑测试并修复问题。
DoD：pytest 通过、README 可复现、提交 commit。
P

cat > .swarm/scripts/run_task.sh <<'P'
#!/usr/bin/env bash
set -euo pipefail
TASK_ID="$1"; WORKDIR="$2"; PROMPT_FILE="$3"; LOG_FILE="$4"; DONE_FILE="$5"; FAIL_FILE="$6"; MODEL="${7:-}"; REASONING="${8:-high}"; ENGINE="${9:-codex}"
[[ -z "$MODEL" ]] && { [[ "$ENGINE" == "claude" ]] && MODEL="claude-sonnet-4-6" || MODEL="gpt-5.3-codex"; }
mkdir -p "$(dirname "$LOG_FILE")"
rm -f "$DONE_FILE" "$FAIL_FILE"
{
  echo "[$(date '+%F %T')] start task=$TASK_ID engine=$ENGINE model=$MODEL"
  cd "$WORKDIR"
  if [[ "$ENGINE" == "claude" ]]; then
    claude -p "$(cat "$PROMPT_FILE")" --model "$MODEL" --dangerously-skip-permissions
  else
    codex exec --skip-git-repo-check --model "$MODEL" -c "model_reasoning_effort=$REASONING" --dangerously-bypass-approvals-and-sandbox - < "$PROMPT_FILE"
  fi
  EC=$?
  echo "[$(date '+%F %T')] exit task=$TASK_ID code=$EC"
  if [[ "$EC" -eq 0 ]]; then touch "$DONE_FILE"; else touch "$FAIL_FILE"; fi
  exit "$EC"
} 2>&1 | tee -a "$LOG_FILE"
P

cat > .swarm/scripts/start_task.sh <<'P'
#!/usr/bin/env bash
set -euo pipefail
TASK_ID="$1"; SESSION="$2"; WORKDIR="$3"; PROMPT_FILE="$4"; LOG_FILE="$5"; DONE_FILE="$6"; FAIL_FILE="$7"; MODEL="${8:-}"; REASONING="${9:-high}"; ENGINE="${10:-codex}"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
if tmux has-session -t "$SESSION" 2>/dev/null; then tmux kill-session -t "$SESSION" || true; fi
CMD="bash '$SCRIPT_DIR/run_task.sh' '$TASK_ID' '$WORKDIR' '$PROMPT_FILE' '$LOG_FILE' '$DONE_FILE' '$FAIL_FILE' '$MODEL' '$REASONING' '$ENGINE'"
tmux new-session -d -s "$SESSION" -c "$WORKDIR" "$CMD"
P

cat > .swarm/scripts/monitor.sh <<'P'
#!/usr/bin/env bash
set -euo pipefail
export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:${PATH:-}"
BASE="$(cd "$(dirname "$0")/.." && pwd)"
STATE="$BASE/state/tasks.json"
LOCKDIR="$BASE/state/.monitor.lock"
[[ -f "$STATE" ]] || exit 0
if ! mkdir "$LOCKDIR" 2>/dev/null; then exit 0; fi
trap 'rmdir "$LOCKDIR" 2>/dev/null || true' EXIT

python3 - <<'PY' "$STATE"
import json,sys,subprocess,datetime
from pathlib import Path
p=Path(sys.argv[1])
d=json.loads(p.read_text())
summary=[]

def alive(s):
  return subprocess.run(["tmux","has-session","-t",s],stdout=subprocess.DEVNULL,stderr=subprocess.DEVNULL).returncode==0

for t in d["tasks"]:
  done=Path(t["done_file"]).exists(); fail=Path(t["fail_file"]).exists(); a=alive(t["session"])
  if done: t["status"]="done"
  elif a: t["status"]="running"
  else:
    if fail and t.get("restart_count",0)>=t.get("max_restarts",3): t["status"]="failed"
    else:
      t["restart_count"]=t.get("restart_count",0)+1
      t["status"]="restarting"
      subprocess.run([str(Path(p).parents[1]/"scripts"/"start_task.sh"),t["id"],t["session"],t["workdir"],t["prompt_file"],t["log_file"],t["done_file"],t["fail_file"],t["model"],t.get("reasoning","high"),t.get("engine","codex")],stdout=subprocess.DEVNULL,stderr=subprocess.DEVNULL)
  lp=Path(t["log_file"])
  last=(lp.read_text(errors='ignore').splitlines()[-1][:120] if lp.exists() and lp.read_text(errors='ignore').splitlines() else "")
  t["last_log"]=last
  summary.append(f"{t['id']}: {t['status']} | restart={t.get('restart_count',0)} | {last}")

d["updated_at"]=datetime.datetime.now(datetime.timezone.utc).isoformat()
p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+"\n")
engines=set(t.get("engine","codex") for t in d["tasks"])
engine_label="/".join(sorted(engines)).upper()
subprocess.run(["openclaw","message","send","--channel","telegram","--target",d.get("chat_id","8319497931"),"--message",f"📋 {engine_label} 并行任务进度\n"+"\n".join(["- "+x for x in summary])],stdout=subprocess.DEVNULL,stderr=subprocess.DEVNULL)
PY

ALL=$(jq -r '[.tasks[].status] | if length==0 then false else all(.=="done" or .=="failed") end' "$STATE" 2>/dev/null || echo false)
if [[ "$ALL" == "true" ]]; then
  TMP=$(mktemp)
  ((crontab -l 2>/dev/null || true) | grep -v "$BASE/scripts/monitor.sh" || true) > "$TMP"
  crontab "$TMP"; rm -f "$TMP"
  openclaw message send --channel telegram --target "$(jq -r '.chat_id // "8319497931"' "$STATE")" --message "✅ 所有Agent任务已结束，已自动停止本次cron监控。" >/dev/null 2>&1 || true
fi
P

cat > .swarm/scripts/start_all.sh <<P
#!/usr/bin/env bash
set -euo pipefail
PROJECT_ROOT="\$(cd "\$(dirname "\$0")/../.." && pwd)"
BASE="\$PROJECT_ROOT/.swarm"
CHAT_ID="\${1:-$CHAT_ID}"
ENGINE="\${2:-$ENGINE}"
MODEL="\${3:-$DEFAULT_MODEL}"
mkdir -p "\$BASE"/{worktree,logs,state}
cd "\$PROJECT_ROOT"

mk(){
  local b="\$1"; local d="\$2"
  if [[ ! -d "\$d" ]]; then
    git worktree add -b "\$b" "\$d" main >/dev/null 2>&1 || git worktree add "\$d" "\$b" >/dev/null 2>&1 || true
  fi
}

mk feat/backend-core "\$BASE/worktree/backend"
mk feat/frontend-ui "\$BASE/worktree/frontend"
mk feat/qa-docs "\$BASE/worktree/qa"

"\$BASE/scripts/start_task.sh" backend  openclaw-student-backend  "\$BASE/worktree/backend"  "\$BASE/prompts/backend.md"  "\$BASE/logs/backend.log"  "\$BASE/logs/backend.done"  "\$BASE/logs/backend.failed"  "\$MODEL" "high" "\$ENGINE"
"\$BASE/scripts/start_task.sh" frontend openclaw-student-frontend "\$BASE/worktree/frontend" "\$BASE/prompts/frontend.md" "\$BASE/logs/frontend.log" "\$BASE/logs/frontend.done" "\$BASE/logs/frontend.failed" "\$MODEL" "high" "\$ENGINE"
"\$BASE/scripts/start_task.sh" qa       openclaw-student-qa       "\$BASE/worktree/qa"       "\$BASE/prompts/qa.md"       "\$BASE/logs/qa.log"       "\$BASE/logs/qa.done"       "\$BASE/logs/qa.failed"       "\$MODEL" "high" "\$ENGINE"

cat > "\$BASE/state/tasks.json" <<JSON
{
  "chat_id": "\$CHAT_ID",
  "updated_at": null,
  "tasks": [
    {"id":"backend","session":"openclaw-student-backend","workdir":"\$BASE/worktree/backend","prompt_file":"\$BASE/prompts/backend.md","log_file":"\$BASE/logs/backend.log","done_file":"\$BASE/logs/backend.done","fail_file":"\$BASE/logs/backend.failed","model":"\$MODEL","reasoning":"high","engine":"\$ENGINE","status":"running","restart_count":0,"max_restarts":3},
    {"id":"frontend","session":"openclaw-student-frontend","workdir":"\$BASE/worktree/frontend","prompt_file":"\$BASE/prompts/frontend.md","log_file":"\$BASE/logs/frontend.log","done_file":"\$BASE/logs/frontend.done","fail_file":"\$BASE/logs/frontend.failed","model":"\$MODEL","reasoning":"high","engine":"\$ENGINE","status":"running","restart_count":0,"max_restarts":3},
    {"id":"qa","session":"openclaw-student-qa","workdir":"\$BASE/worktree/qa","prompt_file":"\$BASE/prompts/qa.md","log_file":"\$BASE/logs/qa.log","done_file":"\$BASE/logs/qa.done","fail_file":"\$BASE/logs/qa.failed","model":"\$MODEL","reasoning":"high","engine":"\$ENGINE","status":"running","restart_count":0,"max_restarts":3}
  ]
}
JSON

ENTRY="* * * * * \$BASE/scripts/monitor.sh >> \$BASE/logs/monitor.log 2>&1"
TMP=\$(mktemp)
((crontab -l 2>/dev/null || true) | grep -v "\$BASE/scripts/monitor.sh" || true) > "\$TMP"
echo "\$ENTRY" >> "\$TMP"
crontab "\$TMP"
rm -f "\$TMP"

echo "started all tasks + cron monitor"
P

chmod +x .swarm/scripts/*.sh

echo "Installed codex tmux swarm scaffold in: $REPO/.swarm"
