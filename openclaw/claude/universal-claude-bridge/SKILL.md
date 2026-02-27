---
name: universal-claude-bridge
description: Bidirectional bridge between OpenClaw and Claude Code. Handles Claude Code hooks (ask_user_question, permission_prompt, idle_prompt, tool_result, task_complete) via HTTP POST, forwards them to Telegram users, and routes user replies back to Claude Code sessions. Use when: (1) User wants to interact with Claude Code sessions via Telegram, (2) Receiving HTTP webhooks from Claude Code, (3) Managing persistent Claude Code sessions through OpenClaw.
---

# Universal Claude Code Bridge

全异步交互的双向桥接 Skill。

## 配置要求

- Hook 端口：默认 `18789`
- 项目目录：`~/Projects/claude-image-gen`（可通过环境变量 `CLAUDE_PROJECT_DIR` 修改）
- Claude Code 路径：确保 `claude` 命令可用

## 核心逻辑

### 1. 接收 Claude Code Hook

当收到 `POST /api/claude/hook` 时：

**处理 `ask_user_question` / `permission_prompt` / `idle_prompt`：**

```javascript
// 保存状态
state.set("claude_active_session_" + telegramChatId, sessionId);

// 保存 tool_use_id（如果有）
if (toolUseId) {
  state.set("claude_tool_use_" + telegramChatId, toolUseId);
}

// 发送消息给用户
message = "🦞 Claude Code 需要你决策：\n" + question;

// 如果有 options，用 inline 按钮显示
if (options && options.length > 0) {
  // 创建按钮，序号或文字
}

// 回复用户："已收到 Claude 请求，回复任意消息即可继续"
```

**处理 `tool_result` / `task_complete`：**

```javascript
// 转发 result / result_path / summary 给用户
if (resultPath && isImage(resultPath)) {
  // 上传图片
} else {
  // 发送文字 result
}
```

### 2. 用户回复处理

当收到普通 Telegram 消息时：

```javascript
sessionId = state.get("claude_active_session_" + chatId);

if (sessionId) {
  // 执行 Claude Code continue
  exec(`cd ${projectDir} && claude continue --session ${sessionId} --input "${userMessage}"`);
  
  // 清空状态
  state.clear("claude_active_session_" + chatId);
  
  // 回复用户："✅ 已注入 Claude Code，继续执行中……"
}
```

### 3. 额外指令

- `/claude status` - 显示当前 active session
- `/claude switch {{session_id}}` - 切换到指定 session

## HTTP API

### POST /api/claude/hook

```json
{
  "type": "ask_user_question" | "permission_prompt" | "idle_prompt" | "tool_result" | "task_complete",
  "session_id": "uuid",
  "question": "Claude's question",
  "options": ["option1", "option2"],
  "tool_use_id": "uuid",
  "result": "result text",
  "result_path": "/path/to/file",
  "summary": "task summary",
  "telegram": {
    "chat": { "id": 123456789 }
  }
}
```

## 环境变量

- `CLAUDE_PROJECT_DIR` - Claude Code 项目目录（默认：~/Projects/claude-image-gen）
- `CLAUDE_BRIDGE_PORT` - Hook 端口（默认：18789）
- `CLAUDE_CODE_PATH` - claude 命令路径（默认：claude）

## 示例

```bash
# 启动 Claude Code 会话
claude -d ~/Projects/my-project --permission-mode plan

# 通过此 bridge，用户可以在 Telegram 收到问题提醒并回复继续
```
