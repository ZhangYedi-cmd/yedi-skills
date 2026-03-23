# dispatch.sh 参数

| 参数 | 必填 | 说明 | 默认值 | 示例 |
|---|---|---|---|---|
| `--workdir` | 是 | Claude Code 工作目录 | — | `~/xhs-auto-gen` |
| `--task-name` | 是 | 任务显示名称 | — | `周一选题挖掘` |
| `--prompt` | 是 | 传给 `claude -p` 的提示 | — | `使用 /xhs-topic-miner ...` |
| `--agent` | 否 | 回调 Agent ID（任务完成/失败时通知该 Agent） | 空 | `xhs-miner` |
| `--feishu-target` | 否 | 飞书群 chat_id | 空 | `oc_3713128577cb7c3ea50e38af0764269e` |
| `--feishu-account` | 否 | 飞书账户 ID（用于发送消息的 openclaw 账户） | 空 | `xhs-miner` |
| `--allowed-tools` | 否 | Claude Code 工具白名单，逗号分隔 | `Skill,Write,Read,WebSearch,WebFetch,Bash,Agent,Glob,Grep` | `Skill,Read,Bash` |
| `--max-retries` | 否 | 最大重试次数 | `2` | `3` |
| `--model` | 否 | Claude 模型 | `claude-sonnet-4-6` | `claude-opus-4-5-20251101` |

## 通知参数组合

飞书通知需要 `--feishu-target` 和 `--feishu-account` 同时提供才生效。
Agent 回调只需 `--agent`。两者可同时使用，形成双层通知。

## 项目级配置文件

位置：`{workdir}/.claude-dispatch/config.json`

首次使用时由 Claude 对话式创建（询问用户通知偏好后写入），也可手动编辑。
示例见 `config-example.json`。

**优先级**：CLI 参数 > config.json > 硬编码默认值

| config 字段 | 对应 CLI 参数 | 说明 |
|---|---|---|
| `model` | `--model` | 默认模型 |
| `max_retries` | `--max-retries` | 默认重试次数 |
| `allowed_tools` | `--allowed-tools` | 默认工具白名单 |
| `notify.feishu_target` | `--feishu-target` | 飞书群 chat_id |
| `notify.feishu_account` | `--feishu-account` | 飞书账户 |
| `notify.agent_id` | `--agent` | 回调 Agent ID |
