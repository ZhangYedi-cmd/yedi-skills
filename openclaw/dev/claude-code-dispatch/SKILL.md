---
name: claude-code-dispatch
description: >-
  异步派发 Claude Code 任务到后台 tmux session 执行。当用户说"派发任务"、
  "后台跑一下"、"dispatch"、"异步执行"，或 OpenClaw Agent 需要异步调用
  Claude Code 时使用此技能。有副作用（启动进程、装 cron、发飞书），
  必须经用户确认后执行。
disable-model-invocation: true
allowed-tools: Bash, Read, Write
---

# Claude Code Dispatch

通过 tmux + cron 异步派发 Claude Code 任务，支持状态追踪、自动重试、飞书通知和 Agent 回调。

## Inputs

- `workdir`（必填）：Claude Code 工作目录，必须是已存在的路径
- `task-name`（必填）：任务显示名称
- `prompt`（必填）：传给 `claude -p` 的完整提示
- 通知和模型等可选参数可通过项目级 config 预设，无需每次手动传入
- 完整参数说明见 `references/parameters.md`

## Process

1. 检查 `{workdir}/.claude-dispatch/config.json` 是否存在。
   - **不存在**：询问用户通知偏好（飞书群 chat_id？飞书账户？Agent ID？默认模型？），
     不需要的字段留空。然后按 `references/config-example.json` 格式写入 config.json。
   - **存在**：读取并简要告知用户当前默认配置。
2. 确认用户提供了 workdir、task-name、prompt 三个必填参数。
   缺少任何一个，**先向用户提问**，不要猜测或使用默认值。
3. 验证 workdir 路径存在且是有效目录。不存在则告知用户。
4. 构造并执行 dispatch.sh（config 中的通知参数自动生效，无需手动传 `--feishu-target` 等）：
   ```bash
   ~/.openclaw/skills/claude-code-dispatch/scripts/dispatch.sh \
     --workdir <path> \
     --task-name "<name>" \
     --prompt "<prompt>"
   ```
5. 检查命令输出，确认 tmux session 已启动、cron 已安装。如果失败，读取输出中的错误信息告知用户。
6. 向用户报告派发结果：任务 ID、`tmux attach` 命令、日志路径、state.json 路径。

## 查看已有任务

如果用户想查看任务状态（而非派发新任务）：
1. 读取 `{workdir}/.claude-dispatch/state.json` 获取当前状态。
2. 状态含义见 `references/state-machine.md`。

## Output

向用户返回：
- 派发状态：成功 / 失败
- tmux session 名称和 attach 命令
- 日志路径
- state.json 路径

如果派发失败，返回错误原因和建议的排查步骤。
