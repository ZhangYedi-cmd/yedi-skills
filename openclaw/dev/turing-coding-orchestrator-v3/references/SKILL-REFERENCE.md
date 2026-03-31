# Skill Reference

这个文件承载 `SKILL.md` 中不需要每次都注入上下文的背景信息和速查内容。

## Backend: ACPX 原生 Session 模式

| 维度 | 说明 |
|------|------|
| 启动命令 | `acpx --approve-all --ttl 0 --cwd <dir> claude -s <id> --no-wait -f prompt.md` |
| 进程模型 | ACPX queue owner 持有 Agent，独立于调用者 shell |
| 输出获取 | `acpx --cwd <dir> claude sessions history --limit N <session>` |
| watchdog 模式 | `sessions show` 探活 + `sessions history` 读输出 + `status` 查进程 |
| 中途追加指令 | `acpx --cwd <dir> --approve-all claude prompt -s <session> --no-wait "msg"` |
| 取消 | `acpx --cwd <dir> claude cancel -s <session>` |

### ⚠️ 已知陷阱（血泪教训）

**不带 `--ttl 0` 使用 `--no-wait` 会导致 Agent 被 kill**
- 根因：queue owner 默认 idle TTL 为 300 秒，超时后进程退出
- `--ttl 0` 让 queue owner 永驻，确保长任务不被中断
- **`--no-wait` 必须搭配 `--ttl 0`**

**ACPX session 绑定 cwd**
- `sessions show`、`sessions history`、`status` 都按 cwd 查找 session
- 从其他目录查询必须加 `--cwd <worktree_dir>` 全局参数
- watchdog 的 `AcpxClient` 已内置 `--cwd` 处理

**`@zed-industries/claude-agent-acp` 已废弃**
- 新包名：`@agentclientprotocol/claude-agent-acp`
- 必须在 `~/.acpx/config.json` 中配置，否则 `sessions new` 报 internal error
- 同时需要设置 `ANTHROPIC_API_KEY` 环境变量

**`sessions show` 的 `historyEntries` 不可靠**
- `historyEntries: 0` 不代表 Agent 没在跑，只是 stats 未更新
- 不要用它来判断 prompt 是否送达

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
scripts/setup.sh <task_id> <branch> <worktree_dir> "<task_desc>"
```

### `scripts/launch.sh`

用途：
- 自动选择 agent
- 构造带 callback 契约的 prompt
- 通过 ACPX session 模式启动 Agent
- 更新 memory / active-tasks
- 自动拉起 watchdog

用法：

```bash
scripts/launch.sh <task_id> <worktree_dir> <prompt_file> [agent]
```

### `scripts/watchdog.py`

用途：
- 零 token 监控 ACPX session（通过 sessions API：show 探活、history 读输出、status 查进程）
- 提取 callback-json
- 更新状态与里程碑
- 检测 crash / stall
- 在测试失败或 callback 违规时发起修复回合

用法：

```bash
python3 scripts/watchdog.py [task_id]
```

## Command Cheat Sheet

### ACPX session（推荐派发方式）

```bash
# 创建 session（全局选项在 agent 子命令之前）
acpx --cwd <worktree_dir> claude sessions ensure --name <task_id>

# 派发任务（--ttl 0 保活 queue owner，--no-wait 立即返回）
acpx --approve-all --ttl 0 --cwd <worktree_dir> claude \
  -s <task_id> --no-wait -f <prompt_file>

# 查看 session 状态
acpx --cwd <worktree_dir> claude sessions show <task_id>

# 查看 Agent 输出历史
acpx --cwd <worktree_dir> claude sessions history --limit 50 <task_id>

# 查看 Agent 进程状态
acpx --cwd <worktree_dir> claude status -s <task_id>

# 追加指令
acpx --cwd <worktree_dir> --approve-all claude prompt -s <task_id> --no-wait "fix the tests"

# 取消
acpx --cwd <worktree_dir> claude cancel -s <task_id>

# 关闭 session
acpx --cwd <worktree_dir> claude sessions close <task_id>
```

> `launch.sh` 始终使用 ACPX session 模式，无需手动拼命令。

### ACPX 查询命令

```bash
acpx claude sessions list                              # 列出所有 session
acpx --cwd <dir> claude sessions show <session>        # session 元数据
acpx --cwd <dir> claude sessions history --limit 20 <session>  # 输出历史
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

- `MEMORY.md` 是跨 session 的共享状态
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
