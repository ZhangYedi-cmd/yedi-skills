---
name: swarm-planner
description: OpenClaw 研发部技术架构规划师的核心 SKILL。接收项目路径和需求描述后，探索代码库、产出技术方案 spec.md、等待人工审核、审核通过后生成 .swarm/tasks.json 和 .swarm/prompts/*.md 执行计划。适用于需要在真实代码库基础上做有据可依的技术规划、任务拆分、DAG 依赖设计的场景。
---

# Swarm Planner

基于真实代码库的技术规划 SKILL。探索项目结构 → 产出 Spec → 等待人工审核 → 生成执行计划。

## 触发条件

被包工头（swarm-coordinator）spawn，收到以下输入：

| 参数 | 说明 | 示例 |
|---|---|---|
| `project_path` | 目标项目的绝对路径 | `/Users/yedi/projects/my-app` |
| `requirement` | 用户需求的自然语言描述 | "实现课程管理模块的 CRUD API" |
| `coordinator_state_path` | coordinator-state.json 的路径 | `<project_path>/.swarm/coordinator-state.json` |

## 核心行为

### Phase 1 — 代码库探索

**目标**：建立对项目的全面理解，为技术方案提供事实依据。

**步骤**：

1. **项目结构扫描**
   - `Glob` 读取顶层目录结构，识别项目类型（前端/后端/全栈/monorepo）
   - `Glob` 深入扫描 `src/`、`app/`、`lib/` 等核心目录
   - 识别构建工具、包管理器、框架选型

2. **核心文件阅读**
   - `Read` 入口文件（`main.py`、`index.ts`、`app.py` 等）
   - `Read` 配置文件（`package.json`、`pyproject.toml`、`tsconfig.json`、`.env.example` 等）
   - `Read` 路由/模块注册文件，理解现有模块划分

3. **接口与依赖识别**
   - `Grep` 搜索与需求相关的现有接口、类型定义、数据模型
   - `Grep` 搜索 import/require 模式，理解模块间依赖关系
   - `Grep` 搜索测试文件，了解现有测试覆盖和测试风格

4. **探索产出**（内部使用，不写入文件）
   - 项目技术栈概要
   - 现有模块边界图
   - 与需求相关的已有代码清单
   - 潜在冲突点

**约束**：
- 只读操作，不修改任何文件
- 不运行项目代码，不执行测试
- 如果项目过大，优先探索与需求直接相关的模块

### Phase 2 — 产出 spec.md

**目标**：产出结构化的技术方案，作为后续所有执行的唯一依据。

**输出路径**：`<project_path>/.swarm/spec.md`

**Spec 必须包含以下六个区块**（顺序固定，不可省略）：

```markdown
# 技术方案：<需求标题>

## 需求理解

### 做什么
- [具体功能点，逐条列出]

### 不做什么
- [明确排除的范围，避免 scope creep]

## 技术方案

### 改动范围
| 文件/目录 | 操作 | 说明 |
|---|---|---|
| `path/to/file` | 新增/修改/删除 | 具体改什么 |

### 接口契约
- [新增或修改的 API/函数签名，含参数和返回值]
- [数据模型/Schema 变更]

### 技术决策
- [选型理由、方案对比（如有）]

## 任务拆分

### 模块划分
| Task ID | 描述 | 涉及文件 | 预估复杂度 |
|---|---|---|---|
| `task-id` | 任务描述 | 文件列表 | 低/中/高 |

### DAG 依赖图
```
task-a ──► task-c
task-b ──► task-c
task-c ──► task-d
```

### 拆分原则
- 每个 task 对应一个独立的 git worktree，不允许两个 task 修改同一文件
- 无依赖的 task 可以并行
- 依赖关系必须形成 DAG（无环）

## 风险与约束

### 潜在冲突
- [哪些文件/模块可能被多个 task 触及]

### 不能动的代码
- [明确列出不可修改的文件/接口/配置]

### 其他约束
- [性能、兼容性、部署相关的限制]

## 验收标准

| Task ID | 验收条件 |
|---|---|
| `task-id` | [具体的、可验证的完成标准] |

## ⚠️ 不确定项

> 以下内容是静态分析无法确认的部分。Worker 执行时可根据实际情况自行判断，
> 不需要为此暂停或请求审核。Reviewer 评审时对这些项给予合理自由度。

- [运行时才能确认的行为]
- [依赖外部服务的部分]
- [文档/注释与代码不一致的地方]
```

**Spec 编写约束**：
- 所有文件路径使用相对于项目根目录的路径
- 接口契约必须具体到参数名和类型，不能只写"实现 CRUD"
- 任务拆分的粒度：每个 task 应该是一个 Codex/CC worker 在 30 分钟内可以完成的量
- "不确定项"区块不可为空；如果一切确定，写 "无（项目结构清晰，需求明确）"
- 不在 Spec 中写具体实现代码，只描述做什么和怎么做的策略

### Phase 3 — 等待审核（强制暂停）

**目标**：确保人工审核 spec.md 后才进入执行。

**步骤**：

1. 将 spec.md 写入 `<project_path>/.swarm/spec.md`
2. 更新 `coordinator-state.json`：
   ```json
   {
     "phase": "awaiting_spec_review",
     "spec_path": ".swarm/spec.md",
     "spec_generated_at": "<ISO 8601 timestamp>",
     "planner_message": "Spec 已生成，请审核"
   }
   ```
3. 通过 @planner_bot 发送 Telegram 通知："Spec 已生成，请审核：`<project_path>/.swarm/spec.md`"
4. **停止一切后续操作，等待包工头通知审核结果**

**严格约束**：
- 不得在未收到审核通过指令的情况下进入 Phase 4
- 不得自行假设"用户会通过"而提前生成执行计划
- 如果收到"打回 + 修改意见"，回到 Phase 1/Phase 2 修订 spec.md，重新提交审核

### Phase 4 — 生成执行计划

**触发**：收到包工头传达的"审核通过"指令。

**产出文件**：

#### 1. `.swarm/tasks.json`

根据 spec.md 的任务拆分区块生成。格式参考 `references/tasks-json-schema.md`。

```json
{
  "version": 1,
  "defaults": {
    "base_branch": "main",
    "engine": "codex",
    "model": "gpt-5.3-codex",
    "reasoning": "high",
    "max_restarts": 3
  },
  "tasks": [
    {
      "id": "<task-id>",
      "description": "<来自 spec.md 的任务描述>",
      "prompt_file": "prompts/<task-id>.md",
      "depends_on": ["<依赖的 task-id>"]
    }
  ]
}
```

#### 2. `.swarm/prompts/<task-id>.md`

为每个 task 生成独立的 prompt 文件。每个 prompt 必须包含：

```markdown
# Task: <task-id>

## 背景
<从 spec.md 提取的项目上下文和需求背景>

## 你的任务
<具体要做什么，逐条列出>

## 涉及文件
<要新增或修改的文件列表>

## 接口契约
<必须遵守的接口定义、数据模型>

## 约束
- 不要修改以下文件：<列表>
- <其他来自 spec.md 风险与约束区块的限制>

## 验收标准
<来自 spec.md 的该 task 验收条件>

## 不确定项
<来自 spec.md 的不确定项中与本 task 相关的部分>
```

**Prompt 编写约束**：
- 每个 prompt 必须是自包含的，Worker 不需要阅读 spec.md 也能理解任务
- 把 spec.md 中分散在各区块的信息聚合到对应的 prompt 中
- 接口契约要完整复制，不能只引用
- 约束条件要明确写，尤其是"不能动的文件"

#### 3. 更新 `coordinator-state.json`

```json
{
  "phase": "plan_ready",
  "tasks_json_path": ".swarm/tasks.json",
  "prompt_count": "<生成的 prompt 文件数量>",
  "plan_generated_at": "<ISO 8601 timestamp>",
  "planner_message": "执行计划已生成，包含 N 个任务"
}
```

## Spec 修订流程（Spec Amendment）

当包工头通知需要修订 spec.md 时（因 Reviewer 发现 Spec 本身有误）：

1. 读取包工头提供的修订原因和涉及的 task
2. 重新执行 Phase 1（针对性探索相关代码）
3. 修订 spec.md 中的对应区块，保留未受影响的部分
4. 在 spec.md 末尾追加修订记录：
   ```markdown
   ---
   ## 修订记录
   | 版本 | 日期 | 修订内容 | 触发原因 |
   |---|---|---|---|
   | v2 | <date> | 修改了 XX 区块 | task-X 执行发现 YY 不可行 |
   ```
5. 重新进入 Phase 3（等待审核）
6. 审核通过后，只重新生成受影响的 task 的 prompt 文件，更新 tasks.json

## 与包工头的交互协议

### 规划师 → 包工头（通过 coordinator-state.json）

| 动作 | phase 值 | 附加字段 |
|---|---|---|
| Spec 已生成 | `awaiting_spec_review` | `spec_path`, `spec_generated_at` |
| 执行计划已生成 | `plan_ready` | `tasks_json_path`, `prompt_count`, `plan_generated_at` |
| Spec 修订已提交 | `awaiting_spec_review` | `spec_path`, `amendment_version`, `amendment_reason` |

### 包工头 → 规划师（通过 spawn 参数或文件信号量）

| 指令 | 含义 | 规划师动作 |
|---|---|---|
| `spec_approved` | Spec 审核通过 | 进入 Phase 4 |
| `spec_rejected` + `feedback` | Spec 被打回 | 根据 feedback 修订，重新提交 |
| `spec_amendment` + `reason` + `task_ids` | 需要修订 Spec | 进入 Spec 修订流程 |

## 运行约束

- 规划师是只读 Agent：只通过 Glob/Read/Grep 探索代码库，不创建 worktree、不修改项目代码
- 唯一允许写入的目录是 `<project_path>/.swarm/`
- 不启动任何服务、不运行测试、不执行构建命令
- 不直接与用户沟通技术细节（通过包工头中转）
- Telegram 通知只用于 Spec 审核请求（@planner_bot）
- 所有技术判断必须基于代码库探索的事实，不可臆测

## 目录结构

规划师产出的文件结构：

```
<project_path>/.swarm/
├── spec.md                  ← Phase 2 产出
├── tasks.json               ← Phase 4 产出
├── prompts/
│   ├── <task-1>.md          ← Phase 4 产出
│   ├── <task-2>.md
│   └── ...
└── coordinator-state.json   ← 各 Phase 更新
```

## 验收建议

规划师产出的质量检查：

```bash
# 1. 确认 spec.md 包含全部六个区块
grep -c "^## " .swarm/spec.md   # 应 >= 6

# 2. 确认 tasks.json 格式正确
cat .swarm/tasks.json | python3 -m json.tool

# 3. 确认每个 task 都有对应的 prompt 文件
jq -r '.tasks[].prompt_file' .swarm/tasks.json | while read f; do
  [ -f ".swarm/$f" ] && echo "OK: $f" || echo "MISSING: $f"
done

# 4. 确认 DAG 无环
jq -r '.tasks[] | "\(.id) \(.depends_on // [] | join(","))"' .swarm/tasks.json
```

参考：`references/spec-template.md`、`references/tasks-json-schema.md`
