# Callback Protocol

Agent 完成任务后必须输出的结构化回调协议。

## Schema

````text
```callback-json
{
  "task_id": "<task_id>",
  "status": "completed|failed|need_clarification",
  "branch": "<branch>",
  "files_changed": ["file1.go", "file2_test.go"],
  "test_results": { "passed": 42, "failed": 0, "skipped": 1 },
  "duration_minutes": 12,
  "summary": "简要描述做了什么"
}
```
````

## Status Values

| status | 含义 |
|--------|------|
| `completed` | 任务完成（需检查 `test_results.failed`） |
| `failed` | 任务失败，无法继续 |
| `need_clarification` | 被阻塞，需要用户澄清 |

## Validation Rules

- callback 必须是合法 JSON
- `task_id` 必须匹配当前任务
- `status` 必须是上述三个值之一
- `test_results` 必须包含 `passed`、`failed`、`skipped`
- Agent 必须先 commit、跑测试，再输出 callback

## Watchdog 解析行为

watchdog.py 的 `CallbackParser` 扫描 Agent 输出中所有 ` ```callback-json ``` ` 块，
取**最后一个有效的**（避免 prompt 中的占位符模板被误判为真实 callback）。

无效 callback（JSON 解析失败、task_id 不匹配、status 不合法、缺少必填字段）会被跳过。

## Injection

`launch.sh` 构建 prompt 时自动将上述 schema 注入 prompt 末尾。
编排者无需手动拼 callback 模板——直接用 `launch.sh` 即可。
