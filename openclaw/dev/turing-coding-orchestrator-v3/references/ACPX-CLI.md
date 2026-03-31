# ACPX CLI Reference

> 来源：https://github.com/openclaw/acpx/blob/main/docs/CLI.md
> 同步日期：2026-03-31

## 命令结构

```
acpx [global_options] [agent] [subcommand] [options] [prompt_text]
```

默认 agent 为 `claude code`（未指定时）。

## 全局选项

| 选项 | 说明 |
|------|------|
| `--agent <command>` | 自定义 ACP adapter 命令（escape hatch） |
| `--cwd <dir>` | 工作目录（默认当前目录） |
| `--approve-all` | 自动批准所有权限请求 |
| `--approve-reads` | 仅自动批准读操作（默认） |
| `--deny-all` | 拒绝所有权限请求 |
| `--format <fmt>` | 输出格式：`text`（默认）/ `json` / `quiet` |
| `--suppress-reads` | 将文件内容替换为 `[read output suppressed]` |
| `--json-strict` | 严格 JSON 模式，抑制 stderr |
| `--timeout <seconds>` | 最大等待时间 |
| `--ttl <seconds>` | Queue owner 空闲超时（默认 300，0=永驻） |
| `--model <id>` | 指定 agent 模型 |
| `--verbose` | 启用调试日志 |

**互斥**：`--approve-all` / `--approve-reads` / `--deny-all` 三选一。

## 内置 Agent

| Agent | 底层命令 |
|-------|---------|
| `claude` | `npx -y @agentclientprotocol/claude-agent-acp` |
| `codex` | `npx @zed-industries/codex-acp` |
| `gemini` | gemini adapter |
| `openclaw` | `openclaw acp` |
| `pi` | `npx pi-acp` |

未知 token 作为自定义 agent 命令处理。

## 子命令

### prompt（持久 session）

查找或创建 cwd 作用域的 session，发送 prompt，等待完成。

```bash
acpx claude -s <name> "prompt text"
acpx claude -s <name> --no-wait -f prompt.md
```

| 选项 | 说明 |
|------|------|
| `-s, --session <name>` | 使用命名 session（非 cwd 默认） |
| `--no-wait` | 排入队列后立即返回 |
| `-f, --file <path>` | 从文件读取 prompt（`-` 表示 stdin） |

### exec（一次性）

创建临时 session，执行一次后丢弃。不保留会话历史。

```bash
acpx claude exec "summarize this repo"
acpx claude exec -f prompt.md
cat file.md | acpx claude exec --file -
```

### sessions

管理已保存的 session：

| 子命令 | 说明 | 用法 |
|--------|------|------|
| `list` | 列出所有 session | `acpx claude sessions list` |
| `new [--name <name>]` | 创建新 session | `acpx claude sessions new --name my-task` |
| `ensure [--name <name>]` | 确保 session 存在（幂等） | `acpx claude sessions ensure --name my-task` |
| `close [name]` | 关闭 session | `acpx claude sessions close my-task` |
| `show [name]` | 显示 session 元数据 | `acpx claude sessions show my-task` |
| `history [name] [--limit N]` | 查看历史（默认 20 条） | `acpx claude sessions history --limit 50 my-task` |

**注意**：session name 是位置参数，不是 `-s` flag。`-s` 只用于 `prompt`/`status`/`cancel` 子命令。

### cancel

协作式取消正在运行的 prompt（通过 queue-owner IPC）。

```bash
acpx claude cancel -s <session>
```

### status

报告本地 agent 进程状态：`running` / `dead` / `no-session`。

```bash
acpx claude status -s <session>
```

输出包含 PID、uptime、last exit code。

### set-mode / set

```bash
acpx claude set-mode plan              # 切换 session 模式
acpx claude set model <id>             # 切换模型
acpx claude set <key> <value>          # 设置配置项
```

## Session 行为

### 自动恢复

prompt 命令自动按 `(agentCommand, cwd, optionalName)` 三元组定位已有 session。

### Prompt 队列

如果一个 prompt 正在运行，后续 prompt 通过 IPC 排队到同一个 queue owner，不会启动重复进程。

- 默认：等待完成
- `--no-wait`：排队确认后立即返回

### CWD 作用域

Session 按绝对路径的 cwd 作用域查找。从其他目录查询必须加 `--cwd`。

### Soft-close

在同一作用域创建新 session 会自动 soft-close 之前的 open session。

## Flow 执行

```bash
acpx flow run <file> [--input-json <json>] [--input-file <path>] [--default-agent <name>]
```

执行用户编写的工作流模块。产物持久化到 `~/.acpx/flows/runs/<runId>/`。

## 配置

| 文件 | 路径 | 优先级 |
|------|------|--------|
| 全局 | `~/.acpx/config.json` | 低 |
| 项目 | `.acpxrc.json` | 高（merge 覆盖） |

支持的配置项：`defaultAgent`、`defaultPermissions`、`nonInteractivePermissions`、`authPolicy`、`ttl`、`timeout`、`format`、自定义 agent 定义、auth credentials。

```bash
acpx config show    # 显示合并后的配置
acpx config init    # 初始化默认全局配置
```

## Exit Codes

| 代码 | 含义 |
|------|------|
| `0` | 成功 |
| `1` | 一般错误 |
| `2` | 用法错误 |
| `3` | Prompt 超时 |
| `4` | Session 未找到（仅 prompt 命令） |
| `5` | 权限拒绝 |
| `6` | Agent 进程失败 |

## 常用模式速查

```bash
# 启动持久 session
acpx codex 'initial prompt'

# 继续对话
acpx codex 'follow-up question'

# 一次性查询
acpx codex exec 'what does this repo do'

# 命名 session（注意：-s 是 agent 级选项，应放在 agent 名之后）
acpx codex -s debug 'debug issue'

# 非阻塞派发（必须搭配 --ttl 0 防止超时 kill）
acpx --approve-all --ttl 0 claude -s task-1 --no-wait -f prompt.md

# 自定义 agent
acpx --agent './local-acp-server' 'prompt'

# 脚本自动化
acpx --approve-all --format json flow run ./workflow.ts --input-file ./config.json
```
