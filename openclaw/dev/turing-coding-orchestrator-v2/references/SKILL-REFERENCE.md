# Skill Reference

这个文件承载 `SKILL.md` 中不需要每次都注入上下文的背景信息和速查内容。

## Backend Policy

| 维度 | ACPX | tmux |
|------|------|------|
| 通信模型 | 全双工 JSON-RPC over stdio | PTY 刮削 |
| 输出格式 | 类型化 ndjson | 原始终端文本 |
| 中途追加指令 | prompt 队列，天然安全 | `send-keys`，有时序风险 |
| 完成检测 | `[done]` + callback-json | callback-json / capture-pane |
| 取消 | 协作式 cancel | `Escape` / `C-c` |
| 崩溃恢复 | 会话级恢复更强 | session 可能活着，Agent 可能已死 |

默认新任务用 ACPX。只有在 ACPX 不可用、不稳定，或需要 tmux 可视化监控时才回退 tmux。

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

### `scripts/watchdog.py`

用途：
- 零 token 监控 session
- 提取 callback-json
- 更新状态与里程碑
- 检测 crash / stall
- 在测试失败或 callback 违规时发起修复回合
- 将合法 callback 落盘为 `.clawdbot/<task_id>-callback.json`

用法：

```bash
python3 scripts/watchdog.py [task_id]
```

## Command Cheat Sheet

### ACPX

```bash
acpx prompt -s <session> "<instruction>"
acpx prompt -s <session> --no-wait "<instruction>"
acpx prompt -s <session> --approve-all "<instruction>"
acpx sessions list
acpx sessions show -s <session>
acpx cancel -s <session>
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
