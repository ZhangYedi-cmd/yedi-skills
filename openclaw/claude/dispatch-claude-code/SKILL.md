---
name: dispatch-claude-code
description: 当用户在聊天中请求启动 Claude Code 执行任务时使用此技能。例如："帮我做个爬虫"、"写个脚本"、"用Claude Code写个东西"等。使用 /Users/yedi/claude-code-hooks/scripts/dispatch-claude-code.sh 派发任务。
---

# Dispatch Claude Code

当用户请求用 Claude Code 完成任务时，使用 dispatch-claude-code.sh 脚本派发任务。

## 用法

```bash
/Users/yedi/claude-code-hooks/scripts/dispatch-claude-code.sh \
  -p "<任务描述>" \
  -n "<任务名>" \
  -g "<群ID>" \
  -w <工作目录>
```

## 参数说明

| 参数 | 必需 | 说明 |
|------|------|------|
| `-p` | 是 | 任务提示（用户的需求）|
| `-n` | 否 | 任务名称（默认随机）|
| `-g` | 是 | 群ID（结果发送到此群）|
| `-w` | 否 | 工作目录（默认当前目录）|

## 常用选项

- `--agent-teams` — 启用 Agent Teams 模式
- `--permission-mode "bypassPermissions"` — 绕过权限限制

## 示例

用户说 "帮我写个Python爬虫抓取豆瓣电影":

```bash
/Users/yedi/claude-code-hooks/scripts/dispatch-claude-code.sh \
  -p "写一个Python爬虫，抓取豆瓣电影Top250" \
  -n "douban-spider" \
  -g "-5269739055" \
  -w "/Users/yedi/projects"
```

## 注意事项

1. 群ID从上下文获取（当前群是 -5269739055）
2. 工作目录建议用 /Users/yedi/projects 或 ~/projects
3. 任务完成后结果会自动发送到群里
