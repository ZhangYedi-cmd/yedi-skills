# OpenClaw 项目范式（Project Paradigm）

## 为什么需要项目范式

OpenClaw 默认通过对话 Memory 调度 Claude Code，这会导致：

- 流程依赖对话上下文，不可复现
- 产物散落各处，无法追溯
- OpenClaw 不知道有哪些 Claude Code Skills 可用
- 每次生产过程都是重新"发明"的

**项目范式的核心洞察**：把"需要被记住的"全部外化为文件系统。OpenClaw 在需要时 JIT 加载对应项目 Skill，就能获得完整的上下文——工作流、可用工具、产物规范——而不依赖不可靠的对话 Memory。

---

## Skill vs Project 的区别

| | Skill | Project |
|---|---|---|
| **作用域** | 单一能力（做一件事） | 协调多个 Skill 完成一类生产任务 |
| **执行者** | Claude Code 或 OpenClaw 单独执行 | OpenClaw 编排，Claude Code 执行 |
| **入口** | `SKILL.md` | `SKILL.md`（含工作流入口） |
| **复杂度** | 单步或少数步骤 | 多步骤，有阻塞点和审核环节 |
| **示例** | `baoyu-xhs-images`（生成图片） | `xhs-auto-post`（完整小红书生产） |

---

## 角色边界原则

### OpenClaw = 导演

- 理解用户意图，生成 Brief
- 按工作流编排步骤，决定调用哪个 Claude Code Skill
- 在关键节点做质量审核（通过 / 打回）
- 记录运行状态（run.log）

### Claude Code = 执行者

- 接收 Brief 或明确输入，执行具体 Skill
- 操作文件系统，输出规范产物
- 不做决策，只执行

**关键原则**：OpenClaw 不直接"干活"；Claude Code 不做决策。

---

## 标准目录结构

```
openclaw/
└── <namespace>/
    └── <project-name>/
        ├── SKILL.md                    ← OpenClaw 入口（必须）
        └── references/
            ├── workflow.md             ← 工作流详细定义（必须）
            ├── cc-skills.md            ← 可用 Claude Code Skills（必须）
            └── artifacts.md            ← 产物管理规范（必须）
```

`openclaw/` 作用域通过 `skillsync sync openclaw` 自动同步到 `~/.openclaw/skills/`，OpenClaw 可按需 JIT 加载。

---

## SKILL.md 结构规范

```yaml
---
name: <project-name>
description: <一句话描述，包含触发词>
---
```

Body 必须包含以下章节（顺序固定）：

1. **项目概述** — 一句话说明这个项目生产什么
2. **角色边界** — 列出 OpenClaw 做什么、Claude Code 做什么
3. **工作流摘要** — 步骤编号列表（指向 references/workflow.md）
4. **可用 Claude Code Skills** — 简短列表（详见 references/cc-skills.md）
5. **产物目录** — 根路径和结构（详见 references/artifacts.md）
6. **质量检查点** — 明确哪几步 OpenClaw 需要 review
7. **参考文件** — 指向 references/ 下各文件的链接

---

## 工作流定义规范

`references/workflow.md` 中每个 Step 的格式：

```markdown
## Step N: <名称>

- **执行者**: [OpenClaw] 或 [ClaudeCode: <skill-name>]
- **输入**: 描述输入来源和内容
- **输出**: 描述输出文件和路径
- **完成条件**: 何时视为该步骤完成
- ⛔ **阻塞点**: 必须满足后才能进入下一步（可选）
```

---

## 产物管理规范

### 根目录约定

`~/Projects/<project-name>/runs/`

### Run 命名

`YYYY-MM-DD-NNN/`（NNN 从 001 递增，同一天多次运行时递增）

### run.log 格式

每步完成后追加一行：

```
[YYYY-MM-DD HH:MM] Step: <step-name> | Status: ok/fail | Notes: <可选说明>
```

---

## 如何新建一个 Project

1. 在 `openclaw/<namespace>/<project-name>/` 下创建目录
2. 按规范创建 `SKILL.md`（参考本文档和现有示例）
3. 创建 `references/workflow.md`、`references/cc-skills.md`、`references/artifacts.md`
4. 运行 `skillsync sync openclaw` 同步

---

## 现有项目

| Project | 路径 | 描述 |
|---|---|---|
| xhs-auto-post | `openclaw/xhs/xhs-auto-post/` | 小红书图文自动生成 |
