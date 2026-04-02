---
name: task-spec-gen
description: >
  将技术方案或需求描述转化为子 Agent 可执行的结构化 Task Spec。
  读代码库验证文件路径、找参考实现、拆 bite-sized tasks，
  产出精确到文件路径 + 验收标准的 spec 文件。
  Use when: "生成 spec", "拆任务", "出实施计划", "task spec",
  "generate spec", "break down tasks", "拆解任务", "写 spec",
  "implementation spec", "spec 生成", "任务拆解".
user-invocable: true
---

# Task Spec Generator

> 你的产出是子 Agent 的「工作合同」。Agent 拿到 spec 后严格按照执行，
> 不探索、不猜测、不超范围。spec 的质量直接决定 Agent 的输出质量。

## 输入场景

### 场景 A：完整链路（有技术方案）

输入：技术方案（来自 techplan-agent-v2）+ 代码库路径

技术方案来源（按优先级）：
1. 文件：`.clawdbot/{task_id}-techplan.md`（编排器流程中 techplan-agent-v2 已保存）
2. 上下文：如果在同一 OpenClaw 会话中刚跑完 techplan-agent-v2，方案在对话历史中

从技术方案中提取：
- 第五章：改动文件清单 + 数据结构 + 接口定义 + 交互逻辑
- 6.1：文件级任务拆分 + 依赖关系
- 5.5：Off-limits / 边界约束

结合代码库验证和补充。

### 场景 B：快速链路（无技术方案）

输入：需求描述 + 代码库路径

自己做轻量代码侦察：
1. 读 package.json / tsconfig.json → 确定技术栈和测试框架
2. 从需求关键词搜索定位文件
3. 找参考实现（代码库中类似功能的现有页面/组件）
4. 确认测试文件位置和覆盖率命令

**复杂度检查**：如果分析后发现涉及 > 5 个文件或跨 3 个以上模块，
建议用户先跑 `techplan-agent-v2` 出技术方案，再来生成 spec。

---

## 工作流程

```
- [ ] Step 1: 理解输入 ⛔ BLOCKING
  - [ ] 1.1 识别输入类型（场景 A / 场景 B）
  - [ ] 1.2 场景 A: 提取技术方案关键章节
  - [ ] 1.2 场景 B: 轻量代码侦察
  - [ ] 1.3 确认 task_id 和输出路径
- [ ] Step 2: 代码验证 ⛔ BLOCKING
  - [ ] 2.1 验证所有文件路径存在
  - [ ] 2.2 读参考实现，确认模式可复用
  - [ ] 2.3 识别测试框架 + 测试文件位置
  - [ ] 2.4 识别覆盖率命令
- [ ] Step 3: 拆 Tasks
  - [ ] 3.1 拆分为 bite-sized tasks（每个 = 一次 commit）
  - [ ] 3.2 按依赖排序
  - [ ] 3.3 每个 task 填入: Files + What to change + Reference + Acceptance + Test
- [ ] Step 4: 组装 Spec
  - [ ] 4.1 填入 Objective / Codebase Context / Tasks / Boundaries / Validation
  - [ ] 4.2 保存为 .clawdbot/{task_id}-spec.md
- [ ] Step 5: 输出给用户确认 ⚠️ REQUIRED
```

---

## Step 1: 理解输入

### 场景 A：从技术方案提取

读技术方案，重点关注：

| 章节 | 提取什么 |
|------|---------|
| 第五章 5.1 核心改动文件 | 文件路径 + 改动说明 → 变成 Tasks 的 Files |
| 第五章 5.2 数据结构/接口 | TypeScript 类型、API 入参出参 → 放入 Codebase Context 或 task 的 What to change |
| 第五章 5.3 交互逻辑 | 关键流程 → 变成 Acceptance Criteria |
| 第五章 5.4 边界条件 | 异常场景 → 变成边界测试 task |
| 第五章 5.5 边界约束 | Off-limits + 约束 → 直接放入 Boundaries |
| 6.1 任务拆分 | 文件级 task 列表 + 依赖 → 作为拆 task 的骨架 |

### 场景 B：轻量代码侦察

```
1. 读 package.json → 技术栈、测试框架（jest/vitest/mocha）、主要依赖
2. 搜索需求关键词 → 定位入口文件（页面组件/路由配置）
3. 从入口追踪 1-2 层 → 确认涉及的文件范围
4. 搜索参考实现 → grep 类似功能的关键词，找到现有页面作为模板
5. 检查测试目录 → __tests__/ 或 *.test.ts 或 *.spec.ts
```

## Step 2: 代码验证

**不管场景 A 还是 B，都要做验证。** 不验证就可能给 Agent 一个不存在的文件路径。

```
2.1 文件路径验证
    对每个 spec 中要列的文件路径，用 Glob/Read 确认存在。
    新建文件不需要验证，但要确认父目录存在。

2.2 参考实现验证
    读参考文件的关键代码段，确认模式确实可复用。
    记录具体行号，写入 spec 的 Reference 字段。

2.3 测试框架识别
    从 package.json scripts 中的 test 命令识别：
    - "vitest" → npx vitest run
    - "jest"   → npx jest
    - "mocha"  → npx mocha
    确认 __tests__/ 或 *.test.* 的命名规范

2.4 覆盖率命令识别
    - vitest: npx vitest run --coverage
    - jest:   npx jest --coverage
    - 有 .nycrc 或 c8: npx c8 ...
    如果识别不到，在 spec 中标注 "覆盖率命令需用户确认"
```

## Step 3: 拆 Tasks

### 粒度原则

**每个 Task = 一次有意义的 commit。** 不是 2-5 分钟那么碎（那是 subagent 循环的粒度），
而是"一组紧密相关的文件改动 + 对应的测试"。

好的拆法：
- Task 1: 创建 usePagination hook + 测试
- Task 2: 改造 UserList 页面 + 对接 hook + 测试
- Task 3: 补充边界场景测试

坏的拆法（太碎）：
- Task 1: 创建 usePagination.ts 文件
- Task 2: 写 usePagination 的类型定义
- Task 3: 写 usePagination 的实现
- Task 4: 写 usePagination 的测试

坏的拆法（太粗）：
- Task 1: 完成所有功能

### 排序规则

- 被依赖的 task 排前面
- 基础设施（hooks/utils）→ 页面组件 → 联调测试
- 如果有跨文件依赖，在 task 描述中标明

### Task 字段

每个 Task **必须包含**以下字段：

| 字段 | 说明 | 示例 |
|------|------|------|
| **Files** | Create / Modify / Test / Reference | `Modify: src/pages/user-list/index.tsx` |
| **What to change** | 方向描述，不是完整代码。指明参考哪个文件的哪段 | "参考 order-list/index.tsx line 30-55 的分页模式" |
| **Acceptance** | 可验证的条件，用 WHEN...THEN 格式 | "WHEN cursor 为空 THEN 返回第一页" |
| **Test** | 具体测试命令 | `npx vitest run src/hooks/__tests__/usePagination.test.ts` |

**What to change 的原则**：
- 写方向，不写完整代码（Agent 是专业 coder，给方向就够）
- 但 TypeScript 类型定义 / API 接口入参出参 **可以写**（这是"契约"不是"实现"）
- **必须标注参考实现**（告诉 Agent "照这个文件的模式做"）

**Acceptance 的原则**：
- 必须是可验证的（能跑测试或手动验证）
- 不要写 "功能正常工作"，要写 "GET /api/users?cursor=X 返回 20 条 + nextCursor"
- 不要写 "有良好的错误处理"，要写 "请求失败时展示 ErrorBoundary + 重试按钮"

## Step 4: 组装 Spec

按以下格式输出，**格式必须严格遵守**（launch.sh 通过 `## Tasks` 标记检测 Spec 模式）：

```markdown
# Task Spec: {task_id}

## Objective
{一句话说清楚要做什么，面向结果}

## Codebase Context
- 框架: {React 18 + TypeScript + ...}
- 状态管理: {zustand / redux / context}
- API 层: {src/services/ 使用 axios/fetch/useSWR}
- 测试: {vitest / jest + @testing-library/react}
- 参考实现: {src/pages/xxx 的 yyy 模式}

## Tasks

### Task 1: {名称}
**Files:**
- Create: `exact/path/to/new-file.ts`
- Modify: `exact/path/to/existing.tsx`
- Test: `exact/path/to/__tests__/file.test.ts`
- Reference: `exact/path/to/reference.tsx` (line N-M, 描述什么模式)

**What to change:**
{方向描述 + 参考实现指引}

**Acceptance:**
- WHEN {条件} THEN {预期结果}
- WHEN {条件} THEN {预期结果}

**Test:**
{具体测试命令}

### Task 2: {名称}
...

## Boundaries
- Off-limits: `path/` — {原因}
- Constraint: {具体约束}

## Validation
{全局验证命令}
Expected: ALL PASS
```

### 保存位置

- 编排器调用时：`.clawdbot/{task_id}-spec.md`
- 用户直接调用时：当前目录下 `{task_id}-spec.md`，或用户指定路径

## Step 5: 用户确认

输出 spec 后必须等用户确认：

"Spec 已生成，请确认：
1. 通过，继续执行
2. 需要修改（请说明调整点）
3. 仅查看，不执行"

⚠️ 未经确认，不得将 spec 交给编排器 launch。

---

## 下游消费

此 SKILL 产出的 `.clawdbot/{task_id}-spec.md` 由 `turing-coding-orchestrator` 的
`launch.sh` 消费。launch.sh 检测到 `## Tasks` 标记后自动切换到 Spec 模式 prompt，
注入硬约束（TDD / 边界 / 验收 / 三层降级）。

如果 techplan-agent-v2 产出了技术方案（`.clawdbot/{task_id}-techplan.md`），
launch.sh 会将其复制到 worktree，供子 Agent 在 spec 不够明确时查阅。

---

## Anti-Patterns

- **路径不验证**：列了 `src/hooks/usePagination.ts` 但项目里 hooks 目录叫 `src/composables/`
- **没有参考实现**：spec 说 "创建分页组件"，但不说 "参考 order-list 的模式"——Agent 会发明自己的模式
- **验收不可验证**："分页功能正常" → 这不是验收标准
- **太碎**：把一个函数拆成 5 个 task → 浪费 commit 和上下文
- **太粗**："完成所有功能" → 这不是 spec，是 raw 需求
- **编造文件路径**：没验证就写进 spec → Agent 找不到文件会卡住
- **遗漏 Boundaries**：没写 Off-limits → Agent 可能"顺便"重构了公共组件

## Pre-Delivery Checklist

- [ ] 每个 Task 都有 Files 字段，路径已验证存在（或标注 Create）
- [ ] 每个 Task 都有 Reference 字段，指向代码库中的参考实现
- [ ] 每个 Acceptance 条目都是可验证的（能写测试或运行命令验证）
- [ ] 每个 Task 都有具体的 Test 命令
- [ ] Boundaries 包含 Off-limits 和 Constraints
- [ ] Validation 有全局测试命令
- [ ] 格式包含 `## Tasks` 和 `### Task N` 标记（launch.sh 依赖这个检测）
- [ ] 没有编造的文件路径或接口
