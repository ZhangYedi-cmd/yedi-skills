---
name: claude-code-dispatch
description: >
  通过 tmux + cron 派发和监控 Claude Code CLI 任务。支持任务状态追踪、
  自动重试、飞书消息通知和 OpenClaw Agent 回调。适用于 OpenClaw 需要
  异步派发 Claude Code 任务的场景，如定时选题挖掘、图文生成等。
  从 ai-tmux-swarm 提炼，去掉 git worktree、DAG 依赖、多引擎，
  只保留单任务派发的核心能力。
---

# Claude Code Dispatch

通过 tmux + cron 异步派发和监控 Claude Code 任务。

## 核心能力

- tmux session：任务可见、可 attach、有日志
- cron 监控：每分钟检测任务状态，自动处理完成/失败
- 自动重试：失败后自动重启（可配置次数）
- 双层通知：飞书直发 + Agent 回调

## 快速使用

```bash
# 派发一个任务
~/.openclaw/skills/claude-code-dispatch/scripts/dispatch.sh \
  --workdir ~/xhs-auto-gen \
  --task-name "周一选题挖掘" \
  --prompt "使用 /xhs-topic-miner 技能，执行 research 模式，找出 5 个蓝海选题" \
  --agent xhs-miner \
  --feishu-target oc_3713128577cb7c3ea50e38af0764269e \
  --feishu-account xhs-miner

# 查看任务状态
cat ~/xhs-auto-gen/.claude-dispatch/state.json

# attach 到 tmux 看实时输出
tmux attach -t claude-dispatch-xxx

# 查看日志
tail -f ~/xhs-auto-gen/.claude-dispatch/logs/xxx.log
```

## 参数

| 参数 | 必填 | 说明 | 示例 |
|---|---|---|---|
| `--workdir` | 是 | Claude Code 工作目录 | `~/xhs-auto-gen` |
| `--task-name` | 是 | 任务显示名称 | `周一选题挖掘` |
| `--prompt` | 是 | 传给 `claude -p` 的提示 | `使用 /xhs-topic-miner ...` |
| `--agent` | 否 | 回调 Agent ID | `xhs-miner` |
| `--feishu-target` | 否 | 飞书群 chat_id | `oc_xxx` |
| `--feishu-account` | 否 | 飞书账户 ID | `xhs-miner` |
| `--allowed-tools` | 否 | Claude Code 工具白名单 | `Skill,Write,Read,...` |
| `--max-retries` | 否 | 最大重试次数（默认 2） | `3` |
| `--model` | 否 | Claude 模型（默认 claude-sonnet-4-6） | `claude-opus-4-5-20251101` |

## 状态流转

```
dispatch.sh 创建 → pending
dispatch.sh 启动 tmux → running
                          │
             cron monitor.sh 每分钟检查
                          │
              ┌───────────┼───────────┐
              ↓           ↓           ↓
        tmux 还在     exit 0      exit != 0
         running       done     retry_count < max?
                        ↓        ├─ 是 → retrying → running
                    移除 cron     └─ 否 → failed
                    通知用户              ↓
                                     移除 cron
                                     通知用户
```

## 文件结构

任务运行时在工作目录下创建 `.claude-dispatch/`：

```
{workdir}/
└── .claude-dispatch/
    ├── state.json        # 任务状态
    └── logs/
        └── {task-id}.log # 任务日志（claude 输出 tee 到这里）
```

## 通知机制

状态进入终态（done/failed）时触发两层通知：

1. **飞书直发**（格式可控，即时到达）
2. **Agent 回调**（Agent 可做后续逻辑，如等待用户审核后触发下一步）

## 脚本说明

| 脚本 | 职责 |
|---|---|
| `dispatch.sh` | 入口：解析参数、写 state.json、开 tmux、装 cron |
| `run_task.sh` | tmux 内执行：`claude -p "..." \| tee log`，退出时记录 exit code |
| `monitor.sh` | cron 每分钟跑：检查 tmux 存活、更新状态、触发重试/通知 |
