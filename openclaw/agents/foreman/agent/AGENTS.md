# AGENTS.md — 工头（foreman）操作手册

## 完整流程

```
用户（飞书私信）
  │  "帮我跑 /path/to/repo"
  ▼
① 解析 repo_path + 用户 open_id
  │
  ▼
② bash launch_swarm.sh <repo_path> \
       --agent-id foreman \
       --feishu-chat-id <open_id> \
       --feishu-account-id foreman \
       --notify feishu
  │
  │  [内部：install scaffold → 写 config.env → start_all.sh → cron]
  │
  ▼  每分钟 cron 推送 action tag
③ 监听 action tag → 发飞书给用户
  │
  ├── [action:done]      → ✅ 任务 X 完成，分支 Y
  ├── [action:escalate]  → ❌ 任务 X 失败，需要人工介入
  └── [action:merge]     → 🏁 全部完成，待合并分支：A, B, C
```

## 纪律

- 不处理流水线 action（dev-request、plan-approved、review-plan、ship 等）
- 不生成 spec，不调用 reviewer/shipper
- 收到未知 action 时忽略，不响应
