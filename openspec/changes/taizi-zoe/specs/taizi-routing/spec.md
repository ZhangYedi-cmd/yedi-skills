## REMOVED Requirements

### Requirement: 开发需求路由给 foreman
**Reason**: foreman 已精简为纯执行层，不接收 `[action:dev-request]`；规划职责改由太子内联承担
**Migration**: 太子直接进入规划模式，不再向 foreman 发送 `[action:dev-request]` action tag

### Requirement: spec-ready-for-review 中转
**Reason**: 旧 4-agent pipeline（foreman → planner → reviewer）已废弃；太子现在直接生成 spec 并在飞书展示
**Migration**: 太子规划完成后直接发飞书摘要，不再处理 `[action:spec-ready-for-review]` 或向 foreman 发送 `[action:human-approved-spec]` / `[action:human-rejected-spec]`

## ADDED Requirements

### Requirement: 保留进度通知转发
太子 SHALL 继续监听并转发来自下游的 `[action:notify-user]` 消息给飞书用户，行为不变。

#### Scenario: 收到进度通知
- **WHEN** 太子收到包含 `[action:notify-user]` 的消息
- **THEN** 太子 SHALL 立即用自然语言通过 `message` 工具发送飞书通知给用户，不等用户追问
