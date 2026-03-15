# 评审报告模板

所有评审报告必须严格使用以下模板。包工头通过解析 frontmatter 自动处理评审结果。

---

## 模板

```markdown
---
task_id: <task-id>
verdict: pass | fail
spec_error: false
error: false
attempt: <当前评审轮次>
reviewed_at: <ISO 8601 时间戳>
criteria_total: <验收标准总条数>
criteria_passed: <通过条数>
criteria_failed: <未通过条数>
---

# 评审报告：task-<task-id>

## 基本信息

| 项目 | 值 |
|---|---|
| Task ID | <task-id> |
| 评审轮次 | attempt <N> |
| Prompt 文件 | .swarm/prompts/<task-id>.md |
| 分支 | swarm/<task-id> |
| Diff 行数 | <总变更行数> |
| 评审时间 | <ISO 8601> |

## 验收标准逐条评估

### [PASS] 标准 1：<验收标准原文>

**结论**：满足

**依据**：<在代码变更中的具体对应位置和实现方式>

---

### [FAIL] 标准 2：<验收标准原文>

**结论**：不满足

**问题**：<具体描述缺失/错误的内容>

**位置**：`<文件路径>` L<起始行>-L<结束行>

**修改方向**：<可操作的具体修改建议>

---

### [PASS] 标准 3：...

（每条验收标准重复上述格式）

## Spec 约束检查

| 约束项 | 结果 | 说明 |
|---|---|---|
| 禁止修改的文件 | PASS / FAIL | <具体说明> |
| 接口契约 | PASS / FAIL | <具体说明> |
| 与其他 task 冲突 | PASS / FAIL | <具体说明> |

## 安全与技术债检查

| 检查项 | 结果 | 说明 |
|---|---|---|
| 硬编码密钥/密码 | PASS / FAIL | <具体说明> |
| 性能陷阱 | PASS / FAIL | <具体说明> |
| 未标注的 TODO/FIXME | PASS / FAIL | <具体说明> |

## 不确定项观察

（仅当 Worker 对 Spec "不确定项"有值得记录的处理方式时填写，不作为 verdict 依据）

- <观察内容>

## Spec 错误（仅在 spec_error: true 时填写）

**问题描述**：<Spec 中哪条内容有误>

**依据**：<为什么判断是 Spec 的问题而非执行问题>

**建议**：<对 Spec 修订的建议方向>

## 总结

**verdict**: <pass / fail>

**概要**：<1-2 句话总结评审结论>

## 评审历史

（重试场景下，记录之前的评审摘要）

| 轮次 | 时间 | verdict | 概要 |
|---|---|---|---|
| 1 | <时间> | fail | <上次评审摘要> |
| 2 | <时间> | pass | <本次评审摘要> |
```

---

## 字段说明

### Frontmatter 字段

| 字段 | 类型 | 必填 | 说明 |
|---|---|---|---|
| `task_id` | string | 是 | 任务标识，与 tasks.json 中的 id 一致 |
| `verdict` | enum | 是 | `pass` 或 `fail`，二元判定 |
| `spec_error` | bool | 是 | 是否发现 Spec 本身有误 |
| `error` | bool | 是 | 是否因技术原因（如无法获取 diff）无法完成评审 |
| `attempt` | int | 是 | 当前评审轮次，从 1 开始 |
| `reviewed_at` | string | 是 | ISO 8601 格式时间戳 |
| `criteria_total` | int | 是 | 该 task 的验收标准总条数 |
| `criteria_passed` | int | 是 | 通过的条数 |
| `criteria_failed` | int | 是 | 未通过的条数 |

### verdict 判定规则

- `criteria_failed == 0` 且 Spec 约束检查全部 PASS → `verdict: pass`
- 其他情况 → `verdict: fail`
- 安全与技术债检查中的 FAIL 项：若属于 Spec 验收标准范围内 → 影响 verdict；若属于 Spec 未涉及的额外发现 → 在报告中记录但**不影响 verdict**（遵守"只认 Spec"原则）
