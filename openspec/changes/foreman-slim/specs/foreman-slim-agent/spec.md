## ADDED Requirements

### Requirement: 包工头只承担三个职责
精简版包工头 SOUL.md SHALL 只描述以下三个职责，不包含 spec 生成、reviewer 审核、shipper 合并等流水线逻辑：
1. 启动 ai-tmux-swarm（调用 launch_swarm.sh）
2. 监听来自 swarm cron 的 action tag 消息
3. 发送飞书消息给用户

#### Scenario: 收到不属于三个职责的 action tag
- **WHEN** 包工头收到 `[action:review-plan]`、`[action:plan-approved]`、`[action:ship]` 等流水线 action
- **THEN** 包工头不处理，记录日志："精简版包工头不处理此 action，请检查配置"

### Requirement: 收到飞书消息后启动 swarm
包工头 SHALL 从用户飞书私信中解析 repo_path，并从消息上下文中获取发件人 open_id，然后调用 launch_swarm.sh 启动 swarm。

#### Scenario: 用户发送 repo_path
- **WHEN** 用户在飞书私信包工头，消息中包含有效的 repo_path（绝对路径或可解析路径）
- **THEN** 包工头提取 repo_path 和用户 open_id，执行：
  ```bash
  bash <skill-root>/scripts/launch_swarm.sh <repo_path> \
    --agent-id foreman \
    --feishu-chat-id <user_open_id> \
    --feishu-account-id foreman \
    --notify feishu
  ```
  并回复用户"swarm 已启动"

#### Scenario: 消息中无法解析 repo_path
- **WHEN** 用户消息中没有有效路径
- **THEN** 包工头回复飞书："请告诉我要跑的项目路径，例如：/path/to/repo"

#### Scenario: launch_swarm.sh 启动失败
- **WHEN** launch_swarm.sh 执行返回非零退出码
- **THEN** 包工头通过飞书告知用户："swarm 启动失败，请检查路径或 .swarm/tasks.json 是否存在"

### Requirement: 监听并转发 swarm action tag
包工头 SHALL 监听以下来自 swarm cron 的 action tag，并发送对应飞书消息。

| action | 触发条件 | 飞书消息内容 |
|--------|---------|------------|
| `action:done` | 单个任务完成 | 任务 ID、分支名、耗时 |
| `action:escalate` | 任务失败（已耗尽重试） | 任务 ID、失败原因、已用重试次数 |
| `action:merge` | 全部任务完成 | 汇总：成功数、失败数、待合并分支列表 |

#### Scenario: 收到 action:done
- **WHEN** 包工头收到含 `[action:done task_id=X branch=Y]` 的消息
- **THEN** 发送飞书消息给用户："✅ 任务 X 完成，分支：Y"

#### Scenario: 收到 action:escalate
- **WHEN** 包工头收到含 `[action:escalate task_id=X ...]` 的消息
- **THEN** 发送飞书消息给用户："❌ 任务 X 失败，已耗尽重试，需要人工介入"

#### Scenario: 收到 action:merge（全部完成）
- **WHEN** 包工头收到含 `[action:merge branches=A,B,C done_count=N failed_count=M]` 的消息
- **THEN** 发送飞书汇总消息，列出成功任务、失败任务、待合并分支列表

### Requirement: AGENTS.md 精简流程图
AGENTS.md SHALL 只包含精简版三步流程图，去除原有完整流水线描述。

#### Scenario: AGENTS.md 内容正确
- **WHEN** 读取 foreman/AGENTS.md
- **THEN** 只包含以下三步流：收到飞书消息 → 启动 swarm → 监听 action tag 发飞书

### Requirement: IDENTITY.md 更新描述
IDENTITY.md 的 Creature 字段 SHALL 从"规划调度 AI（中书省）"改为"执行调度 AI（执行层）"，反映职责变化。

#### Scenario: IDENTITY.md 内容正确
- **WHEN** 读取 foreman/IDENTITY.md
- **THEN** Creature 字段值为"执行调度 AI（执行层）"

### Requirement: TOOLS.md 补充 launch_swarm.sh 路径
TOOLS.md SHALL 记录 launch_swarm.sh 的获取方式，方便包工头 AI 快速查到正确路径。

#### Scenario: TOOLS.md 包含路径说明
- **WHEN** 读取 foreman/TOOLS.md
- **THEN** 包含以下内容：通过 `openclaw skills path ai-tmux-swarm` 获取 skill 根目录，拼接 `/scripts/launch_swarm.sh` 即为启动脚本路径
