## ADDED Requirements

### Requirement: 太子能进入规划模式
当用户在飞书消息中提供 repo 路径（绝对路径）和开发需求描述时，太子 SHALL 进入规划模式，自主完成代码库探索和 swarm 产物生成，而非将请求路由给 foreman。

#### Scenario: 用户提供路径和需求
- **WHEN** 用户发送包含绝对路径和开发需求的飞书消息（如"帮我给 /path/to/repo 加一个搜索功能"）
- **THEN** 太子进入规划模式，依次执行：读知识库 → 探索代码库 → 生成 .swarm/ 产物 → 飞书发摘要

#### Scenario: 用户只说需求未给路径
- **WHEN** 用户发送开发需求但未提供 repo 路径
- **THEN** 太子 SHALL 追问一次："请告诉我 repo 的绝对路径"，等待用户回复后再进入规划模式

### Requirement: 规划前读取项目知识库
太子 SHALL 在探索代码库前，尝试读取 `~/.openclaw/zoe-memory/projects/<repo-name>/context.md`（其中 `<repo-name>` 为 repo 路径的最后一段目录名）。

#### Scenario: 知识库文件存在
- **WHEN** `~/.openclaw/zoe-memory/projects/<repo-name>/context.md` 文件存在
- **THEN** 太子 SHALL 读取其内容，并在规划时将项目背景、技术栈约束、历史决策纳入考量

#### Scenario: 知识库文件不存在
- **WHEN** 对应知识库文件不存在
- **THEN** 太子 SHALL 静默跳过，不报错，直接进行代码库探索

### Requirement: 代码库探索生成 swarm 产物
太子 SHALL 通过读取 repo 文件（package.json / README / 入口文件 / 关键模块）分析项目结构，并在 `<repo_path>/.swarm/` 下生成以下产物：
- `spec.md`：技术方案（目标、任务拆分、文件改动、验收标准）
- `tasks.json`：任务配置（遵循 ai-tmux-swarm tasks.json schema）
- `prompts/<task-id>.md`：各任务的详细 prompt

#### Scenario: 生成完整 swarm 产物
- **WHEN** 太子完成代码库探索
- **THEN** `.swarm/spec.md`、`.swarm/tasks.json`、`.swarm/prompts/` 下各任务 prompt 文件 SHALL 均存在且内容完整

#### Scenario: .swarm 目录已存在且有内容
- **WHEN** `<repo_path>/.swarm/` 目录已存在且包含文件
- **THEN** 太子 SHALL 在飞书提示用户"该 repo 已有 .swarm 配置，是否覆盖？"，等待确认后再写入

### Requirement: 规划完成后发飞书摘要并等待确认
太子 SHALL 在产物生成后，通过飞书发送规划摘要并等待用户明确确认后再告知下一步。

#### Scenario: 发送摘要
- **WHEN** swarm 产物生成完毕
- **THEN** 太子 SHALL 发送飞书消息，包含：任务数量、每个任务一行描述、产物路径

#### Scenario: 用户确认
- **WHEN** 用户回复"确认"/"OK"/"开干"/"没问题"等肯定词
- **THEN** 太子 SHALL 回复引导语："好的，请告诉包工头启动：`<repo_path>`"

#### Scenario: 用户提出修改意见
- **WHEN** 用户回复包含修改意见（非肯定词）
- **THEN** 太子 SHALL 根据意见重新规划（最多 2 轮），超出后建议用户直接编辑 `.swarm/spec.md`
