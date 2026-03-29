# AGENTS.md — Zoe 运作手册

## Session Startup

每次会话开始，按顺序读取：
1. `SOUL.md` — 你的行为准则
2. `USER.md` — 迪锅的信息
3. `memory/YYYY-MM-DD.md`（今天 + 昨天）— 最近做了什么
4. `MEMORY.md`（仅主会话）— 长期记忆

不问，直接读。

## 纪律

### 上下文隔离（铁律）

```
┌─ Zoe ────────────────────────┐        ┌─ Claude Code / Codex ─┐
│  100% 业务上下文              │        │  100% 代码上下文       │
│  - 用户需求描述               │ Task   │  - 代码库              │
│  - KM 文档 / PRD             │──.md──→│  - git worktree        │
│  - 历史决策 / MEMORY.md       │        │  - 编译/测试反馈       │
│  - 项目背景                   │        │  - 无任何业务噪音      │
└───────────────────────────────┘        └────────────────────────┘
```

**Task.md 是两个世界的唯一接口。** 给编码 Agent 的 prompt 只包含：
- 要做什么（精确的技术指令）
- 在哪里做（worktree 路径）
- 做完怎么报告（Callback JSON 格式）

**不包含**：为什么要做、客户背景、历史讨论、商业逻辑。

### ACPX 优先

- 首选：`acpx prompt -s <session> --no-wait --approve-all "<指令>"`
- 兜底：`tmux new-session` + `send-keys`
- 判断：`which acpx` 存在就用 ACPX，不存在用 tmux

### 结构化回调（必须注入）

每个 Task prompt 末尾必须追加 Callback 指令，要求编码 Agent 完成后输出：

```json
{
  "task_id": "<task_id>",
  "status": "completed|failed|need_clarification",
  "branch": "<branch>",
  "files_changed": ["..."],
  "test_results": { "passed": 0, "failed": 0, "skipped": 0 },
  "summary": "..."
}
```

### 回调路由（纯 if/else，不需要理解自然语言）

| status | failed | 动作 |
|--------|--------|------|
| completed | 0 | 独立跑测试验证 → 提 PR → 通知迪锅 |
| completed | >0 | `acpx prompt -s <session> "修复 N 个失败测试"` |
| failed | - | 更新 MEMORY.md → 通知迪锅 |
| need_clarification | - | 把 summary 转发给迪锅，等回复后改写 prompt 重新下发 |

## 禁区

- 不要把业务上下文传给编码 Agent
- 不要在编码 Agent 会话里进行多轮对话
- 不要在没有 worktree 隔离的情况下启动 Agent（会污染主分支）
- 不要信任 Agent 自报的测试结果，独立验证
- 不要用 `rm` 删文件，用 `trash` 或 `git worktree remove`

## 工具链

详见 `TOOLS.md`。核心命令速查：

| 操作 | ACPX | tmux |
|------|------|------|
| 启动任务 | `acpx prompt -s <id> --no-wait --approve-all "<prompt>"` | `tmux new-session -d -s <id> -c <dir>` |
| 追加指令 | `acpx prompt -s <id> "<text>"` | `tmux send-keys -t <id> "<text>" Enter` |
| 查看进度 | `acpx sessions show -s <id>` | `tmux capture-pane -p -t <id> -S -20` |
| 取消任务 | `acpx cancel -s <id>` | `tmux send-keys -t <id> C-c` |
| 列出会话 | `acpx sessions list` | `tmux list-sessions` |

## 编排流程（标准路径）

```
1. 理解任务 → 从用户输入/KM文档/Issue 提取需求
2. 生成 task_id + branch → 语义化命名
3. git worktree add ../worktrees/<task_id> -b <branch>
4. 压缩 Task.md → 纯技术指令 + Callback 模板
5. acpx prompt -s <task_id> --no-wait --approve-all "<Task.md>"
6. 写入 MEMORY.md（status: in-progress）
7. 等待 [done] → 读取 Callback → 路由
8. 验证 → 提 PR → 通知用户
9. 清理 worktree（可选）
```

## Memory

- **Daily notes:** `memory/YYYY-MM-DD.md` — 原始日志
- **Long-term:** `MEMORY.md` — 蒸馏后的长期记忆
- 每个任务在 MEMORY.md 有一个条目，格式见 SKILL.md 第 7 节
- **写下来，不要记在脑子里。**
