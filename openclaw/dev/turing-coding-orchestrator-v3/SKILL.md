--
name: cli-coding-orchestrator
description: >
  Orchestrate coding-agent task sessions via ACPX.
  Handles task intake, session launch, status checks, steering,
  clarification routing, retry after failed tests or invalid callbacks, PR
  creation, and cleanup. Use when: "X项目有个Y需求", "帮我实现Z功能",
  "梳理这个问题", "start agent", "开 session", "看下进度", "告诉 <session>
  换个方向", "继续修测试", "创建 PR", "停止 session", "cleanup session",
  "dispatch task", "run agent", "check task status", "派发任务", "调度 Agent",
  "帮我做", "跑一下", "看看进展".
user-invocable: true
---

# Turing Coding Orchestrator

> 你是编排者，不是执行编码的 Worker。你负责把任务送进正确的 Agent，
> 会话运行期间持续观测、纠偏、收尾。

## 0. Session Startup

每次被唤醒时，按顺序执行：

1. **环境检查**：
   - `command -v acpx && acpx --version`
   - 确认 `ANTHROPIC_API_KEY` 已设置
   - 确认 `~/.acpx/config.json` 已配置 `@agentclientprotocol/claude-agent-acp`
   - 任一缺失 → 告知用户并引导修复，不继续
2. 读 `MEMORY.md` → 有无在途任务（`running` / `repairing` / `blocked`）
3. 解析用户意图 → 路由到 §4（新任务）或 §5（已有 session）

有在途任务时，先汇报状态再处理新请求。

## 1. 角色与优先级

- 默认把真实编码任务交给专业 coding harness，而不是让 Main 模型自己长时间编码。
- 通过 ACPX 原生 session 模式派发和管理任务。
- 优先复用仓库内的现成脚本，不要手拼命令：
  - `scripts/setup.sh` — 初始化环境
  - `scripts/launch.sh` — 启动 Agent + watchdog
  - `scripts/watchdog.py` — 后台监控
- 复杂流程按 `references/TASK-LIFECYCLE.md` 的状态与转移执行。

## 2. 用户意图路由

| 用户意图 | 你的动作 |
|---------|---------|
| 新需求 / 修 bug / 调研问题 | → §4 新任务 Playbook |
| 查看进度 / status | → §5 查看进度 |
| 告诉某 session 改方向 | → §5 中途干预 |
| 继续修测试 / 补 callback | → §5 修复回合 |
| Agent 要澄清问题 | 转发 summary 给用户，等回复后送回 session |
| 创建 PR | 只在 callback 合法且独立验证通过后执行 |
| 停止 / 清理 session | 终止 session，确认后清理 worktree 和分支 |

## 3. 状态机

权威定义在 `references/TASK-LIFECYCLE.md`。最小规则：

| 状态 | 含义 | 关键约束 |
|------|------|---------|
| `pending` | 环境已初始化，Agent 未启动 | 必须有 task_id、branch、worktree、MEMORY.md 条目 |
| `running` | Agent 执行中，等待 callback | — |
| `repairing` | callback `completed` 但 `failed > 0` | 必须在原 session 修复，不能宣告成功；连续修复超过重试上限（默认 3）→ `failed` |
| `blocked` | Agent 返回 `need_clarification` | 转给用户，等回复后继续 |
| `verified` | callback 合法 + `failed=0`，等待独立验证或 PR | watchdog 检测到合法 callback 后转入 |
| `pr_created` | 分支已推送且 PR 已创建 | `git push` + `gh pr create` 成功 |
| `completed` | 任务成功闭环 | 终态 |
| `failed` | 明确失败或 callback 契约违规超限 | 终态 |
| `crashed` | session 丢失 | 终态 |
| `abandoned` | 用户主动停止 | 终态 |

**硬规则**：
- `completed + failed>0` 不是成功，而是 `repairing`
- 没有合法 callback，不能建 PR
- 不得把 ACPX `[done]` 当作成功，除非同时拿到合法 callback

## 4. 新任务 Playbook

### Step 1: 理解任务

任务来源不限（自然语言、GitHub issue、文档链接、代码审查意见）。
必要时：`gh issue view <N> --json title,body,labels`

### Step 2: 生成任务标识 + 确认

生成语义化 `task_id`、`branch`、`worktree_dir`。例如：
- 分页需求 → `add-pagination`, `feat/add-pagination`
- issue #78 → `issue-78`, `fix/issue-78`

**确认门**：向用户确认 task_id、branch、agent 选择，再继续。

### Step 3: 初始化环境

```bash
scripts/setup.sh <task_id> <branch> <worktree_dir> "<task_desc>"
```

### Step 4: 启动 Agent

```bash
scripts/launch.sh <task_id> <worktree_dir> <prompt_file> [agent]
```

Agent 选择：Claude Code（默认）| Gemini CLI（超长上下文）| Codex CLI（用户指定）

### Step 5: 告知用户

只报告：session 名、agent、任务已开始、完成后会通知。

## 5. 已有 Session Playbook

### 查看进度

```bash
acpx --cwd <worktree_dir> claude sessions show <session>
acpx --cwd <worktree_dir> claude sessions history --limit 20 <session>
```

注意：ACPX session 绑定 cwd，必须传 `--cwd` 指向 worktree。

**总结原则**：报告当前状态、最近 milestone、阻塞原因。不要倾倒 raw JSON 或重复 prompt 内容。

### 中途干预

```bash
# 追加指令
acpx --cwd <dir> --approve-all claude prompt -s <session> --no-wait "<instruction>"
# 取消
acpx --cwd <dir> claude cancel -s <session>
# 关闭
acpx --cwd <dir> claude sessions close <session>
```

### 修复回合

以下情况保持同一 session，继续监控：
- callback 合法但测试失败
- callback 缺失或 JSON 非法

不要新开 session 来修补旧 session 的问题。

## 6. Callback 路由

callback 协议详情见 `references/CALLBACK-PROTOCOL.md`。
`launch.sh` 已自动将 callback schema 注入 prompt，编排者只需处理路由：

| callback 条件 | 你的动作 |
|--------------|---------|
| `completed` + `failed=0` | watchdog 标记 `verified` → 编排者独立验证 → 可选 PR → `completed` |
| `completed` + `failed>0` | 进入 `repairing`，发修复指令到原 session |
| `failed` | 更新状态，通知失败原因 |
| `need_clarification` | 转发 summary 给用户，等待答复 |
| 缺失 / 非法 | 要求 Agent 补交 callback，继续监控 |

## 7. 边界

### Always

- 创建隔离 worktree
- 保持 `MEMORY.md` 与 `.clawdbot/active-tasks.json` 同步
- 发现 callback 缺失/非法时要求修正
- 在宣告成功前做独立验证

### Ask First

- `git push` / `gh pr create`（`auto_pr: true` 或用户明确要求时视为已授权）
- `git worktree remove --force` / `git branch -d`

### Never

- 通过 prompt 传递 API key 或其他 secrets
- 把 `[done]` 无 callback 视为成功
- 销毁不相关的 session、worktree、branch
- 覆盖不属于当前任务的用户改动
- 不读 MEMORY.md 就创建任务（可能重复）
- 用过期的 worktree 路径查 session（cwd 不匹配会查不到）

## 8. 文件职责

| 文件 | 职责 |
|------|------|
| `references/TASK-LIFECYCLE.md` | 状态转移权威定义 |
| `references/SKILL-REFERENCE.md` | ACPX 命令速查、已知陷阱、脚本用法 |
| `references/CALLBACK-PROTOCOL.md` | callback JSON schema 与验证规则 |
| `references/ACPX-CLI.md` | ACPX 官方 CLI 完整文档（子命令、选项、session 行为、exit codes） |
| `scripts/setup.sh` | 初始化 branch / worktree / memory |
| `scripts/launch.sh` | 启动 Agent + 注入 callback 契约 + 拉起 watchdog |
| `scripts/watchdog.py` | 后台监控 session、提取 callback、状态转换、crash 检测 |
| `workflows/issue-to-pr.lobster` | issue 到 PR 的确定性流程 |
