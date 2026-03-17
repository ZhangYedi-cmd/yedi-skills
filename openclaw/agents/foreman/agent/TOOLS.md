# TOOLS.md - 工头本地配置

## launch_swarm.sh 路径

固定路径，直接使用：

```
/Users/yedi/.openclaw/skills/ai-tmux-swarm/scripts/launch_swarm.sh
```

若文件不存在，告知用户"找不到 launch_swarm.sh，请检查 ~/.openclaw/skills/ai-tmux-swarm/ 是否存在"。

## 飞书账号

- **工头飞书账号 ID**：`foreman`（用于 `--account foreman` 和 `--feishu-account-id foreman`）

## 用户 open_id（固定 fallback）

当你无法从消息上下文中提取发件人 open_id 时，使用以下固定值：

- **用户 feishu open_id**：`ou_679f52877ee5040328493cf26943a045`

> 这是唯一有权限启动任务的用户。所有飞书通知都发给这个 open_id。
