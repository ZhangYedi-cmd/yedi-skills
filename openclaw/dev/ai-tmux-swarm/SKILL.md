---
name: ai-tmux-swarm
description: 使用 tmux + git worktree + 系统 cron 编排多个 AI 编码子任务并行开发。提供可复制到仓库内的 swarm scaffold，支持 manifest 驱动任务定义、依赖感知调度、异常重试、OpenClaw system event 通知，以及可选 Telegram 回退通知。适用于需要在本地仓库里长期并行跑多个 Codex / Claude Code 子任务的场景，例如模块并行实现、分阶段集成、验收合并。
---

# AI Tmux Swarm

使用一个受版本控制的 `.swarm/` scaffold，在目标仓库内编排本地多 agent 开发。

## 支持引擎

| 引擎 | CLI 命令 | 默认模型 |
|---|---|---|
| `codex` | `codex exec` | `gpt-5.3-codex` |
| `claude` | `claude -p` | `claude-sonnet-4-6` |

## 核心行为

1. 安装 `.swarm/` scaffold 到目标仓库。
2. 使用 `.swarm/tasks.json` 定义任务、依赖、引擎和重试策略。
3. 为每个任务派生唯一的 `git worktree`、`tmux session`、分支名和日志文件。
4. `start_all.sh` 只启动依赖已满足的任务。
5. 系统 `cron` 每分钟拉起 `monitor.sh`：
   - 刷新任务状态
   - 在未超重试上限时自动重试
   - 解锁并启动下游任务
   - 仅在状态变化时发送 `openclaw system event`
6. 所有任务进入终态后自动移除该项目对应的 cron 监控。

## 快速使用

```bash
# 1) 安装 scaffold（默认 codex）
~/.openclaw/skills/ai-tmux-swarm/scripts/install_swarm.sh <repo-path> [chat-id]

# 使用 Claude 作为默认引擎
~/.openclaw/skills/ai-tmux-swarm/scripts/install_swarm.sh <repo-path> [chat-id] --engine claude

# 2) 可选：复制配置模板，打开 Telegram fallback 或调整轮询频率
cd <repo-path>
cp .swarm/config.env.example .swarm/config.env

# 3) 启动 swarm
./.swarm/scripts/start_all.sh [chat-id] [engine] [model]

# 4) 查看运行时状态
cat .swarm/state/tasks.json
tmux ls | grep openclaw-
```

## Manifest

`.swarm/tasks.json` 是 source of truth，结构如下：

```json
{
  "version": 1,
  "defaults": {
    "base_branch": "main",
    "engine": "codex",
    "model": "gpt-5.3-codex",
    "reasoning": "high",
    "max_restarts": 3
  },
  "tasks": [
    {
      "id": "backend",
      "description": "Implement the backend service",
      "prompt_file": "prompts/backend.md"
    },
    {
      "id": "qa",
      "description": "Validate integrated output",
      "prompt_file": "prompts/qa.md",
      "depends_on": ["backend"]
    }
  ]
}
```

约束：

- `id` 必须唯一，且 slug 化后仍唯一。
- `prompt_file` 必须存在。
- `depends_on` 只能引用已定义任务，且依赖图不能有环。
- 每个任务可以覆盖 `engine`、`model`、`reasoning`、`branch`、`max_restarts`。

## 通知

通知分两层：

1. **Agent 感知**（始终开启）：每次状态变化都通知派发任务的 OpenClaw Agent，使其能感知进度并决定下一步操作（合并分支、跑验收等）。
2. **人的通知**（可选）：通过 `SWARM_NOTIFY_MODE` 控制发送给人的渠道。

### Agent 感知

通过 `SWARM_AGENT_ID` 指定接收通知的 Agent：

```env
# 指定哪个 Agent 派发了这个 swarm（如 foreman）
# 状态变化时通过 `openclaw agent --agent <id>` 投递
SWARM_AGENT_ID=foreman
```

若 `SWARM_AGENT_ID` 为空，回退到 `openclaw system event`。

### 人的通知

| 模式 | 行为 |
|---|---|
| `none`（默认） | 仅 Agent 感知，不发人的通知 |
| `telegram` | 同时发送到 Telegram |
| `feishu` | 同时发送到飞书/Lark |
| `both` | 同时发送到 Telegram + 飞书 |

```env
# Telegram
TELEGRAM_CHAT_ID=
TELEGRAM_THREAD_ID=

# 飞书/Lark（FEISHU_ACCOUNT_ID 必填）
FEISHU_CHAT_ID=oc_xxx 或 user:openId
FEISHU_ACCOUNT_ID=foreman
```

通知消息包含任务描述、分支名、耗时等结构化信息，全部完成时附带待合并分支列表。

- `start_all.sh` 的 `chat-id` 位置参数只作为 Telegram fallback 的运行时覆盖值。
- 飞书通知依赖 `openclaw message send --channel feishu`；若 `openclaw` CLI 不可用则静默跳过。

## 日志系统

所有组件使用统一日志格式：

```
[2026-03-16 17:03:00] [component] [LEVEL] message
```

### 日志级别

通过 `SWARM_LOG_LEVEL` 环境变量控制（默认 `INFO`）：

| 级别 | 说明 |
|------|------|
| `DEBUG` | 详细信息：状态快照、tmux 存活检查、worktree 复用、CLI 响应 |
| `INFO` | 常规操作：任务启动/完成、状态转换、通知发送、cron 安装 |
| `WARN` | 异常但可恢复：任务重试、依赖失败导致阻塞、feishu 配置缺失 |
| `ERROR` | 操作失败：tmux 启动失败、worktree 创建失败、manifest 校验错误 |

### 组件标识

| 组件 | 来源 |
|------|------|
| `init-run` | `swarm_state.py` — manifest 校验与 state 初始化 |
| `start-task` | `swarm_state.py` — worktree 创建、tmux 启动、状态写入 |
| `record-exit` | `swarm_state.py` — 任务退出码记录 |
| `monitor` | `swarm_state.py` — 状态轮询与调度 |
| `notify` | `swarm_state.py` — 通知发送（Agent + 人的渠道） |
| `worktree` | `swarm_state.py` — git worktree 操作 |
| `all-terminal` | `swarm_state.py` — 终态检查 |
| `run-task` | `run_task.sh` — 单个任务执行 |
| `start-all` | `start_all.sh` — swarm 编排入口 |

### 日志文件

| 文件 | 内容 |
|------|------|
| `.swarm/logs/monitor.log` | 所有 monitor sweep + start_all 首次启动的日志 |
| `.swarm/logs/<task>.log` | 单个任务的执行日志（引擎输出 + 启动/退出记录） |
| `.swarm/logs/notifications.log` | 发给 Agent / 人的完整通知内容（全文存档） |
| `.swarm/logs/<task>.claude-debug.log` | Claude debug 模式的详细日志（可选） |

- `start_all.sh` 自动将输出 tee 到 `monitor.log`，首次启动日志不再丢失。
- cron 模式的 `monitor.sh` 通过 `>> monitor.log 2>&1` 追加。

## Claude 日志

- 默认会为 Claude 任务开启 `stream-json` 输出、partial messages 和 `--verbose`，方便在 tmux 和 `.swarm/logs/*.log` 里观察更细的执行流。
- 可以通过 `.swarm/config.env` 调整：
  - `SWARM_CLAUDE_LOG_FORMAT=text|json|stream-json`
  - `SWARM_CLAUDE_INCLUDE_PARTIAL_MESSAGES=0|1`
  - `SWARM_CLAUDE_VERBOSE=0|1`
  - `SWARM_CLAUDE_DEBUG=0|1`
  - `SWARM_CLAUDE_DEBUG_FILTER=api,hooks`
  - `SWARM_CLAUDE_DEBUG_TO_FILE=0|1`
- 当 `SWARM_CLAUDE_DEBUG=1` 且 `SWARM_CLAUDE_DEBUG_TO_FILE=1` 时，会额外写入 `.swarm/logs/<task>.claude-debug.log`。

## 运行约束

- 一个子任务 = 一个 worktree = 一个 tmux session。
- 不允许多个 agent 并发写同一工作目录。
- 下游任务只会在全部依赖 `done` 后启动；依赖失败会让下游任务直接进入 `failed`。
- 运行时唯一状态文件是 `.swarm/state/tasks.json`。

## 验收建议

```bash
ls .swarm/worktree
cat .swarm/state/tasks.json

# 合并到 main 后再跑项目自己的验收命令
pytest -q
```

参考：`references/merge-checklist.md`
