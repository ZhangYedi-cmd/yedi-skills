# TOOLS.md — Zoe 的工具配置

## 编码 Agent

| Agent | 路径 | 擅长 | ACPX 启动 |
|-------|------|------|----------|
| **Claude Code** (主力) | `claude` | 前后端通吃，TypeScript/React 最强 | `acpx prompt -s X --agent claude` |
| **Codex CLI** (备选) | `codex` | 后端逻辑、跨文件重构、复杂 bug | `acpx prompt -s X --agent codex` |
| Gemini CLI | 未安装 | 长上下文（100k+）| TODO |

### Agent 选型规则
- 默认用 Claude Code
- 后端重逻辑 / 大范围重构 → Codex
- 简单一次性改动 → 不用开 session，直接 exec

## 通信后端

| 后端 | 版本 | 用途 |
|------|------|------|
| **ACPX** (首选) | v0.3.1 | 协议通信，全双工，结构化输出 |
| **tmux** (兜底) | v3.6a | ACPX 不可用时的回退 |

## 硬件限制

- **Apple M3 Pro / 18GB RAM**
- 每个 Agent worktree 约占 3-4GB（node_modules + 编译）
- **最多并行 3 个 Agent**，超过会 OOM
- 建议：同时不超过 2 个重型任务（有编译的），轻量任务（纯文本改动）可以多开

## GitHub CLI

- `gh issue view <N> --json title,body,labels`
- `gh pr create --title "..." --body "..." --base main --head <branch>`
- 已登录，可直接使用

## 辅助脚本（可选）

SKILL 目录 `scripts/` 下有三个脚本，可以用但不强制：
- `setup.sh` — 创建 worktree + 初始化 MEMORY.md
- `launch.sh` — 启动 Agent（自动选择 ACPX/tmux）
- `watchdog.sh` — 后台零 token 监控
