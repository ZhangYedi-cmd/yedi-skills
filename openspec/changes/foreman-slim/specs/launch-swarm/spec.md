## ADDED Requirements

### Requirement: 统一 swarm 启动入口
`launch_swarm.sh` SHALL 作为 ai-tmux-swarm skill 的统一启动命令，封装 scaffold 安装、config.env 写入、start_all.sh 执行三个步骤，使调用方无需了解内部细节。

脚本位置：`<skill-root>/scripts/launch_swarm.sh`

接口：
```
launch_swarm.sh <repo-path> \
  --agent-id <agent_id> \
  --feishu-chat-id <open_id> \
  --feishu-account-id <account_id> \
  [--engine codex|claude] \
  [--notify none|feishu|telegram|both]
```

#### Scenario: 全新 repo，首次启动
- **WHEN** 目标 repo 的 `.swarm/` 目录不存在
- **THEN** 脚本依次执行：install_swarm.sh（创建 scaffold）→ 写入 config.env → bash start_all.sh，并以 start_all.sh 的退出码退出

#### Scenario: scaffold 已存在，重复调用
- **WHEN** 目标 repo 的 `.swarm/scripts/start_all.sh` 已存在
- **THEN** install_swarm.sh 幂等运行（rsync 不覆盖已有 config.env），config.env 中传入的键被更新，start_all.sh 正常启动

#### Scenario: 缺少必填参数
- **WHEN** 调用时缺少 `<repo-path>` 或 `--agent-id`
- **THEN** 打印 usage 并以退出码 1 退出

### Requirement: config.env 合并写入
`launch_swarm.sh` SHALL 以合并方式写入 config.env，只覆盖它负责的键，不影响用户已设置的其他键。

负责的键：`SWARM_AGENT_ID`、`OPENCLAW_EVENT_MODE`、`SWARM_NOTIFY_MODE`、`FEISHU_CHAT_ID`、`FEISHU_ACCOUNT_ID`。

#### Scenario: config.env 不存在
- **WHEN** `.swarm/config.env` 不存在
- **THEN** 从 `config.env.example` 复制后写入参数对应的键值

#### Scenario: config.env 已存在且含自定义配置
- **WHEN** `.swarm/config.env` 已存在，且含有 `SWARM_POLL_INTERVAL_MINUTES=2` 等非负责键
- **THEN** 该键保持不变，只更新负责的键

### Requirement: skill 路径自动解析
调用方 SHALL 通过 `openclaw skills path ai-tmux-swarm` 动态获取 launch_swarm.sh 的绝对路径，不硬编码。

#### Scenario: skill 已安装
- **WHEN** 执行 `openclaw skills path ai-tmux-swarm`
- **THEN** 返回 skill 根目录的绝对路径，调用方拼接 `/scripts/launch_swarm.sh` 即可调用

#### Scenario: skill 未找到
- **WHEN** `openclaw skills path ai-tmux-swarm` 返回空或报错
- **THEN** 调用方打印明确错误："找不到 ai-tmux-swarm skill，请先安装"，并停止
