# Skill Reference

这个文件承载 `SKILL.md` 中不需要每次都注入上下文的背景信息和速查内容。

## Backend Policy

| 维度 | acpx-exec（推荐） | tmux |
|------|------|------|
| 启动命令 | `acpx --approve-all claude exec -f prompt.md` | `claude --print --permission-mode bypassPermissions < prompt.md` |
| 连接模型 | 客户端全程持有 stdio，任务完成才退出 | claude 进程前台跑，stdout tee 到文件 |
| 输出落盘 | tee 到 `<task_id>-output.log` | tee 到 `<task_id>-output.log` |
| watchdog 模式 | `acpx-exec`（tmux session 存活 + output.log） | `tmux`（同上） |
| 中途追加指令 | ❌ exec 是一次性的，无法追加 | `tmux send-keys` |
| 取消 | `tmux send-keys C-c` | `tmux send-keys C-c` |

**默认用 acpx-exec**。需要多轮对话或中途干预时才用 tmux。

### ⚠️ 已知陷阱（血泪教训）

**ACPX `prompt --no-wait` 会导致 Agent 被 cancel**
- 根因：`--no-wait` 投完即退，客户端断连 → stdio 关闭 → Agent 收到 `session/cancel`
- Agent 可能已经写完代码，但没有输出 callback
- **禁止使用 `acpx prompt --no-wait` 派发任务**

**`acpx sessions show` 的 `historyEntries` 不可靠**
- `historyEntries: 0` 不代表 Agent 没在跑，只是 stats 未更新
- 不要用它来判断 prompt 是否送达

**watchdog 不要用 `acpx sessions show` 判断 acpx-exec session 是否存活**
- `exec` 模式不建 named session，`sessions show` 必然返回空
- 正确方式：判断 tmux session 是否存活 + output.log 是否有输出

## Why This Skill Exists

- Main 模型负责编排，不应该自己长时间扮演 coding worker
- 专业 coding harness 的质量和模型能力同等重要
- worktree 隔离 + callback 契约 + memory 持久化，才能形成可恢复的无人流程

## Helper Scripts

### `scripts/setup.sh`

用途：
- 创建 branch / worktree
- 初始化 `MEMORY.md`
- 注册 `.clawdbot/active-tasks.json`
- 写入当日 memory

用法：

```bash
scripts/setup.sh <task_id> <branch> <worktree_dir> "<task_desc>" [backend]
```

### `scripts/launch.sh`

用途：
- 自动选择 backend / agent
- 构造带 callback 契约的 prompt
- 启动 ACPX 或 tmux session
- 更新 memory / active-tasks
- tmux 下自动拉起 watchdog

用法：

```bash
scripts/launch.sh <task_id> <worktree_dir> <prompt_file> [backend] [agent]
```

### `scripts/watchdog.sh`

用途：
- 零 token 监控 session
- 提取 callback-json
- 更新状态与里程碑
- 检测 crash / stall
- 在测试失败或 callback 违规时发起修复回合

用法：

```bash
scripts/watchdog.sh [task_id]
```

## Command Cheat Sheet

### ACPX exec（推荐派发方式）

```bash
# 派发任务（在 tmux pane 里跑，客户端全程持有连接）
acpx --approve-all claude exec -f <prompt_file> 2>&1 | tee <output_log>

# 查看 Agent 输出
cat .clawdbot/<task_id>-output.log

# 中断（进入 tmux pane 后 Ctrl-C）
tmux -S /tmp/openclaw-tmux/openclaw.sock send-keys -t <task_id> C-c
```

> `launch.sh` 传入 `backend=acpx` 时自动走 exec 模式，无需手动拼命令。

### ACPX（禁止用于任务派发）

```bash
# ❌ 禁止：--no-wait 会导致 Agent 被 cancel
acpx prompt -s <session> --no-wait -f prompt.md

# ✅ 仅用于查询
acpx claude sessions list
acpx claude sessions show <session>
acpx claude sessions history <session>
acpx claude sessions read --tail 50 <session>
```

### tmux

```bash
tmux new-session -d -s <session> -c <dir>
tmux send-keys -t <session> "<instruction>" Enter
tmux capture-pane -p -t <session> -S -20
tmux kill-session -t <session>
```

### Git / GitHub

```bash
gh issue view <N> --json title,body,labels
git worktree add <dir> -b <branch> main
git worktree remove <dir> --force
git push -u origin <branch>
gh pr create --title "..." --body "..." --base main --head <branch>
```

## Runtime Notes

- `MEMORY.md` 是跨 session、跨 backend 的共享状态
- `.clawdbot/active-tasks.json` 是脚本侧注册表
- callback 缺失或非法时，必须在原 session 修补
- `completed + failed>0` 进入修复回合，不是成功

## When To Move Beyond This Skill

出现以下情况时，应该上 Lobster 或等价工作流引擎：

- 多个 Agent 并行协作
- 审批门和多轮重试
- 固定次数循环
- 复杂冲突检测
- 外部 webhook / event-driven 驱动
