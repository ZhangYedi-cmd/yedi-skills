## Why

太子目前是纯消息分拣 Agent，将开发需求路由给 foreman，自身不具备规划能力。随着 foreman 精简为纯执行层，规划职责出现了空缺——需要一个 Agent 能在飞书会话中与用户对话、探索代码库、生成完整的 swarm 执行产物（spec.md + tasks.json + prompts/），并持有项目业务上下文。

## What Changes

- **升级太子 SOUL.md**：从消息路由器升级为"规划调度 Agent (Zoe 角色)"，新增"规划模式"，移除旧的 `[action:dev-request]` → foreman 路由和 `[action:spec-ready-for-review]` 中转逻辑
- **升级太子 AGENTS.md**：工作流从 4-agent pipeline 简化为 3 模式直线流
- **新增知识库结构**：`~/.openclaw/zoe-memory/` 下按项目组织的 context.md，太子规划前读取

## Capabilities

### New Capabilities

- `taizi-planning-mode`: 太子规划模式——接收 repo 路径 + 需求描述 → 读知识库 → 探索代码库 → 生成 `.swarm/spec.md + tasks.json + prompts/` → 飞书摘要 → 等待用户确认
- `zoe-memory`: 项目知识库结构 `~/.openclaw/zoe-memory/projects/<repo>/context.md`，存储项目背景、技术栈、历史决策

### Modified Capabilities

- `taizi-routing`: 移除 `[action:dev-request]` 路由行为，改为内联规划；移除 `[action:spec-ready-for-review]` 中转；保留 `[action:notify-user]` 进度通知转发

## Impact

- `openclaw/dev/dev-workflow/agents/taizi/SOUL.md` — 重写
- `openclaw/dev/dev-workflow/agents/taizi/AGENTS.md` — 重写
- `~/.openclaw/agents/taizi/agent/SOUL.md` — 同步
- `~/.openclaw/agents/taizi/agent/AGENTS.md` — 同步
- `~/.openclaw/zoe-memory/` — 新建目录 + 模板文件
- 不影响 foreman、swarm-planner SKILL、任何其他 Agent
