---
name: ai-tmux-swarm
description: 使用 tmux + git worktree + cron 编排多个 AI 编码子任务并行开发、自动监控、异常重启、分钟级进度推送与自动停监控。支持 Codex 和 Claude Code 双引擎。适用于"只描述目标，由 OpenClaw 自主拆分并派发多个编码任务"的长时编码任务（如全栈系统开发、模块并行实现、验收合并）。
---

# AI Tmux Swarm

使用 tmux + git worktree + cron 编排多个 AI 编码 Agent 并行开发。

## 支持引擎

| 引擎 | CLI 命令 | 默认模型 |
|---|---|---|
| `codex` | `codex exec` | `gpt-5.3-codex` |
| `claude` | `claude -p` | `claude-sonnet-4-6` |

## 核心流程

1. 初始化目标仓库与 swarm scaffold
2. 需求拆解为 backend / frontend / qa 等独立子任务
3. 每个子任务分配独立 `git worktree` + `tmux session`
4. 以选定引擎（Codex 或 Claude Code）并行执行
5. 安装 cron 监控（每分钟）：
   - 检查 session 存活
   - 异常自动重启
   - Telegram 分钟级进度汇报
6. 全任务终态（done/failed）后自动卸载该项目 cron 监控
7. 验收并合并分支到 main

## 快速使用

```bash
# 1) 安装 scaffold（默认 codex 引擎）
~/.openclaw/skills/ai-tmux-swarm/scripts/install_swarm.sh <repo-path> [chat-id]

# 使用 Claude Code 引擎
~/.openclaw/skills/ai-tmux-swarm/scripts/install_swarm.sh <repo-path> [chat-id] --engine claude

# 2) 启动并行任务 + 启动 cron 监控
cd <repo-path>
./.swarm/scripts/start_all.sh [chat-id] [engine] [model]

# 3) 查看状态
tmux ls | grep openclaw-
cat .swarm/state/tasks.json
```

## 约束

- 一个子任务 = 一个 worktree = 一个 tmux session。
- 禁止多个 agent 在同一工作目录并发写代码。
- 每个任务 prompt 必须写 DoD（启动、测试、提交标准）。
- 监控脚本必须支持自动重启和自动停 cron。

## 验收建议

执行：

```bash
# 在 main 汇总前先看三路产物
ls .swarm/worktree

# 合并分支后跑验收
python3 -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt
pytest -q
```

参考：`references/merge-checklist.md`
