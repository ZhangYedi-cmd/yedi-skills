## 1. 重写 taizi SOUL.md

- [x] 1.1 删除旧的 `[action:dev-request]` 路由逻辑和 `[action:spec-ready-for-review]` 中转逻辑
- [x] 1.2 新增"规划模式"触发条件：检测用户消息中的 repo 路径 + 开发意图
- [x] 1.3 新增规划流程：读知识库 → 探索代码库 → 生成 .swarm 产物 → 发飞书摘要
- [x] 1.4 新增 .swarm 覆盖确认逻辑（目录已存在时提示用户）
- [x] 1.5 新增用户确认门：肯定词 → 引导启动包工头；修改意见 → 重新规划（最多 2 轮）
- [x] 1.6 保留 `[action:notify-user]` 进度通知转发逻辑（内容不变）

## 2. 重写 taizi AGENTS.md

- [x] 2.1 将工作流图更新为 3 模式（闲聊 / 规划模式 / 进度通知）
- [x] 2.2 更新通信对象表（移除 foreman 发出行，移除 shipper/planner/reviewer 接收行）

## 3. 初始化知识库结构

- [x] 3.1 创建 `~/.openclaw/zoe-memory/projects/` 目录
- [x] 3.2 创建 `~/.openclaw/zoe-memory/projects/_template/context.md` 模板文件（含 4 个可选节：项目背景、技术栈、重要约束、历史决策）

## 4. 同步到 OpenClaw 全局配置

- [x] 4.1 将新 SOUL.md 复制到 `~/.openclaw/agents/taizi/agent/SOUL.md`
- [x] 4.2 将新 AGENTS.md 复制到 `~/.openclaw/agents/taizi/agent/AGENTS.md`
- [x] 4.3 重启 taizi session（清空 sessions.json，下次交互自动重载）
