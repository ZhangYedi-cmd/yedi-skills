# TOOLS.md — Zoe 的工具配置

## 编码 Agent

| Agent | 擅长 | 选型 |
|-------|------|------|
| **Claude Code** (主力) | 前后端通吃，TypeScript/React 最强 | 默认 |
| **Codex CLI** (备选) | 后端逻辑、跨文件重构、复杂 bug | 后端重逻辑时 |
| **Gemini CLI** (备选) | 超长上下文（100k+）| 大仓库全量分析时 |

## 通信后端

| 后端 | 用途 |
|------|------|
| **ACPX** (首选) | ACP 协议通信，session 管理，结构化输出 |
| **tmux** (兜底) | ACPX 不可用时的回退 |

ACPX 核心命令：

| 操作 | 命令 |
|------|------|
| 启动任务 | `acpx --approve-all --ttl 0 --cwd <dir> claude -s <id> --no-wait -f <prompt>` |
| 追加指令 | `acpx --cwd <dir> --approve-all claude prompt -s <id> --no-wait "<text>"` |
| 查看进度 | `acpx --cwd <dir> claude sessions show <id>` |
| 查看历史 | `acpx --cwd <dir> claude sessions history --limit 20 <id>` |
| 取消任务 | `acpx --cwd <dir> claude cancel -s <id>` |

⚠️ ACPX session 绑定 cwd，必须传 `--cwd` 指向 worktree。

## Spec 工作流 SKILL

| SKILL | 位置 | 用途 |
|-------|------|------|
| `techplan-agent-v2` | `openclaw/dev/techplan-agent-v2/` | 读代码库 → 结构化技术方案 |
| `task-spec-gen` | `openclaw/dev/task-spec-gen/` | 技术方案/需求 → Task Spec |
| `turing-coding-orchestrator` | `openclaw/dev/turing-coding-orchestrator-v3/` | 全流程编排（setup + launch + watchdog） |

## 编排器脚本

| 脚本 | 用途 |
|------|------|
| `scripts/setup.sh` | 创建 branch + worktree + 初始化 MEMORY.md |
| `scripts/launch.sh` | 双模板 prompt（Raw/Spec）+ 拉起 watchdog |
| `scripts/watchdog.py` | 后台零 token 监控，callback 提取，状态转移 |

## 运行时产物（.clawdbot/）

| 文件 | 产出者 | 消费者 |
|------|--------|--------|
| `{task_id}-desc.md` | setup.sh | launch.sh（Raw 模式） |
| `{task_id}-techplan.md` | techplan-agent-v2 | task-spec-gen + launch.sh |
| `{task_id}-spec.md` | task-spec-gen | launch.sh（Spec 模式） |
| `{task_id}-full-prompt.md` | launch.sh | ACPX session |
| `{task_id}-callback.json` | watchdog | 编排器 |
| `{task_id}-watchdog.log` | watchdog | 排障用 |

## 硬件限制

- **Apple M3 Pro / 18GB RAM**
- 每个 Agent worktree 约占 3-4GB（node_modules + 编译）
- **最多并行 3 个 Agent**，超过会 OOM
- 建议：同时不超过 2 个重型任务

## GitHub CLI

- `gh issue view <N> --json title,body,labels`
- `gh pr create --title "..." --body "..." --base main --head <branch>`
- 已登录，可直接使用
