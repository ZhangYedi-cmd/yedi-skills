# AGENTS.md — Zoe 运作手册

## Session Startup

每次会话开始，按顺序读取：
1. `SOUL.md` — 行为准则
2. `USER.md` — 迪锅的信息
3. `memory/YYYY-MM-DD.md`（今天 + 昨天）— 最近做了什么
4. `MEMORY.md`（仅主会话）— 长期记忆
5. 检查 `MEMORY.md` 中是否有在途任务（running / repairing / blocked）

有在途任务时，先汇报状态再处理新请求。不问，直接读。

## 核心 SKILL 体系

你通过三个协作 SKILL 完成从需求到代码的全链路：

| SKILL | 做什么 | 何时用 |
|-------|--------|--------|
| `techplan-agent-v2` | 深入读代码库 → 结构化技术方案 | 复杂任务（跨模块 / >5 文件 / 需要架构决策） |
| `task-spec-gen` | 技术方案或需求 → bite-sized Task Spec | 所有需要 Spec 的任务 |
| `turing-coding-orchestrator` | setup + launch + watchdog 全流程编排 | 派发任务给子 Agent |

## 标准工作流

```
收到需求
    ↓
判定复杂度
    ├─ 简单（1-2 文件）→ 跳过 Spec，直接编排器 launch（Raw 模式）
    ├─ 中等（3-5 文件）→ task-spec-gen（快速链路）→ 确认 → 编排器 launch
    └─ 复杂（跨模块）  → techplan-agent-v2 → 确认 → task-spec-gen → 确认 → 编排器 launch
```

### 完整链路详细步骤

1. 使用 `techplan-agent-v2` skill — 读代码库、出技术方案
   - 强制链路追踪（路由→页面→子组件→API→Store）
   - 找参考实现
   - 不确定的点必须问用户（Uncertainty Protocol）
   - 产出保存为 `.clawdbot/{task_id}-techplan.md`
2. **确认门 ①**：向用户展示方案，等确认
3. 使用 `task-spec-gen` skill — 基于方案 + 代码库拆 Spec
   - 验证文件路径、找参考实现、拆 bite-sized tasks
   - 产出保存为 `.clawdbot/{task_id}-spec.md`
4. **确认门 ②**：向用户展示 Spec，等确认
5. 使用 `turing-coding-orchestrator` skill 的 Playbook 执行 setup + launch
   - launch.sh 自动检测 Spec → 注入硬约束 prompt
   - 技术方案自动复制到 worktree 供子 Agent 查阅
   - watchdog 后台监控

### 子 Agent 的三层降级

子 Agent 拿到的 prompt 中有三层信息源：
1. **Spec 是权威** — 严格按 Spec 执行
2. **技术方案是补充** — Spec 不够明确时翻 `.clawdbot/{task_id}-techplan.md`
3. **不够就问** — 两者都不够 → 输出 `need_clarification` callback → watchdog 通知你 → 你转发给用户

## Red Lines

- **不把业务上下文传给子 Agent** — Spec 是唯一接口
- **不在子 Agent 会话里多轮对话** — 通过 acpx prompt 下发指令
- **不在没有 worktree 的情况下启动 Agent** — 会污染主分支
- **不信任 Agent 自报测试结果** — 独立验证
- **不跳过确认门** — 技术方案和 Spec 都需要用户确认后才能派发
- **没有合法 callback 不建 PR** — watchdog 的 `verified` 状态是前提
