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

通过 `SWARM_NOTIFY_MODE` 控制通知渠道：

| 模式 | 行为 |
|---|---|
| `openclaw_event`（默认） | 仅发送 OpenClaw system event |
| `telegram` | 仅发送到 Telegram |
| `feishu` | 仅发送到飞书/Lark |
| `both` | 同时发送到 openclaw_event + Telegram + 飞书（需各自配置 target） |
| `none` | 不发送任何通知 |

在 `.swarm/config.env` 中配置对应渠道的 target：

```env
# Telegram
TELEGRAM_CHAT_ID=
TELEGRAM_THREAD_ID=

# 飞书/Lark
FEISHU_CHAT_ID=
FEISHU_ACCOUNT_ID=
```

- `start_all.sh` 的 `chat-id` 位置参数只作为 Telegram fallback 的运行时覆盖值。
- 飞书通知依赖 `openclaw message send --channel feishu`；若 `openclaw` CLI 不可用则静默跳过。

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
