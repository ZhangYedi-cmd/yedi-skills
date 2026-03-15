# 技术方案：<需求标题>

> 由 swarm-planner 生成 | 日期：<YYYY-MM-DD> | 版本：v1

---

## 需求理解

### 做什么
- [ ] 功能点 1：具体描述
- [ ] 功能点 2：具体描述

### 不做什么
- 明确排除项 1
- 明确排除项 2

---

## 技术方案

### 改动范围

| 文件/目录 | 操作 | 说明 |
|---|---|---|
| `path/to/new_file.py` | 新增 | 新模块，负责 XX 功能 |
| `path/to/existing.py` | 修改 | 在 XX 函数中增加 YY 逻辑 |
| `path/to/deprecated.py` | 删除 | 已被新模块替代 |

### 接口契约

#### 新增接口

```
POST /api/v1/resource
  Request Body:
    {
      "field_a": string (required),
      "field_b": number (optional, default: 0)
    }
  Response 200:
    {
      "id": string,
      "field_a": string,
      "created_at": string (ISO 8601)
    }
  Response 400:
    { "error": string, "details": object }
```

#### 数据模型变更

```
Model: ResourceName
  字段:
    - id: UUID, PK
    - field_a: VARCHAR(255), NOT NULL
    - field_b: INTEGER, DEFAULT 0
    - created_at: TIMESTAMP, DEFAULT NOW()
```

### 技术决策

| 决策项 | 选择 | 理由 |
|---|---|---|
| ORM 方案 | SQLAlchemy | 项目现有技术栈 |
| 验证层 | Pydantic v2 | 与 FastAPI 深度集成 |

---

## 任务拆分

### 模块划分

| Task ID | 描述 | 涉及文件 | 预估复杂度 | 依赖 |
|---|---|---|---|---|
| `data-model` | 定义数据模型和迁移 | `models/`, `migrations/` | 低 | 无 |
| `api-endpoint` | 实现 API 端点 | `routes/`, `schemas/` | 中 | `data-model` |
| `business-logic` | 实现核心业务逻辑 | `services/` | 中 | `data-model` |
| `integration` | 集成测试和接口联调 | `tests/` | 中 | `api-endpoint`, `business-logic` |

### DAG 依赖图

```
data-model ──► api-endpoint ──► integration
data-model ──► business-logic ──► integration
```

### 拆分原则

- 每个 task 对应独立 git worktree，不允许两个 task 修改同一文件
- 无依赖的 task 并行执行
- 依赖关系形成 DAG（无环）
- 每个 task 的工作量控制在单个 Codex/CC worker 30 分钟内可完成

---

## 风险与约束

### 潜在冲突
- `path/to/shared_config.py` 可能被多个 task 间接依赖，需确保只在一个 task 中修改

### 不能动的代码
- `path/to/core/auth.py` — 认证模块，任何修改需单独审批
- `path/to/migrations/0001_initial.py` — 已有迁移文件，不可修改

### 其他约束
- 数据库迁移必须可逆（支持 downgrade）
- API 响应格式必须兼容现有前端
- 不引入新的第三方依赖（除非 Spec 中明确批准）

---

## 验收标准

| Task ID | 验收条件 |
|---|---|
| `data-model` | 1) 模型定义完整，字段类型正确 2) 迁移脚本可正常执行和回滚 3) 不影响现有表结构 |
| `api-endpoint` | 1) 端点可正常访问 2) 请求参数验证完整 3) 错误响应格式正确 4) 符合接口契约定义 |
| `business-logic` | 1) 核心逻辑覆盖全部功能点 2) 边界条件处理 3) 单元测试通过 |
| `integration` | 1) 端到端流程跑通 2) 集成测试覆盖主要场景 3) 无回归 |

---

## ⚠️ 不确定项

> 以下内容是静态分析无法确认的部分。Worker 执行时可根据实际情况自行判断，
> 不需要为此暂停或请求审核。Reviewer 评审时对这些项给予合理自由度。

- 数据库连接池配置是否需要调整（取决于运行时负载）
- 第三方 API 的实际响应格式（文档可能与实际不一致）
- 现有测试中标记为 skip 的用例是否影响本次改动

---

## 修订记录

| 版本 | 日期 | 修订内容 | 触发原因 |
|---|---|---|---|
| v1 | <YYYY-MM-DD> | 初始版本 | — |
