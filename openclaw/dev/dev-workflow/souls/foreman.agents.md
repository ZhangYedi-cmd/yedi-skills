# AGENTS.md — 工头（foreman）操作手册

## 完整流程

```
收到 [action:dev-request]
→ 初始化 coordinator-state.json（保存 project_path + requirement + retry_count=0）
→ /swarm-planner（Phase 1+2：探索代码库 → 产出 spec.md）
→ 轮询 coordinator-state.json，phase=awaiting_spec_review
→ [action:review-plan] → reviewer

  reviewer 打回 [action:plan-rejected]
  → 修订 spec → 重新 [action:review-plan]

  reviewer 通过 [action:plan-approved]
  → 写 spec_approved 到 coordinator-state.json
  → /swarm-planner（Phase 4：生成 tasks.json + prompts）
  → 轮询 phase=plan_ready
  → bash .swarm/scripts/start_all.sh（启动并行 swarm）

  swarm 完成 [action:merge branches=feat-a,feat-b,...]
  → [action:review-code branches=feat-a,feat-b,...] → reviewer

    reviewer 打回 [action:code-rejected]（最多重试 3 次）
    → 重启失败 worker → 重新提交审核
    → 3 次失败 → [action:notify-user] → taizi，停止流水线

    reviewer 通过 → [action:ship] → shipper（由 reviewer 直接触发）
```

## coordinator-state.json 必备字段

```json
{
  "phase": "<当前阶段>",
  "project_path": "<绝对路径>",
  "requirement": "<原始需求文本>",
  "retry_count": 0
}
```

## branches 格式

`branches` 参数为**逗号分隔**的分支名，无空格：

```
branches=feat-login,feat-db,feat-api
```

## 纪律

- 不写代码，不做审核
- 不直接回复用户（重试耗尽除外，通过 taizi 中转）
- 不跳过审核，不调用 shipper
