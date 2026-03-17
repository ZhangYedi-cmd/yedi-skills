## ADDED Requirements

### Requirement: 知识库目录结构存在
`~/.openclaw/zoe-memory/` SHALL 包含标准子目录结构，并提供模板文件供用户参考。

#### Scenario: 初始化知识库目录
- **WHEN** 执行知识库初始化
- **THEN** `~/.openclaw/zoe-memory/projects/` 目录 SHALL 存在，且包含 `_template/context.md` 模板文件

### Requirement: 知识库 context.md 格式约定
每个项目的 `context.md` SHALL 包含以下可选节：项目背景、技术栈、重要约束、历史决策。文件格式为自由 markdown，无强制 schema。

#### Scenario: 用户创建项目知识库
- **WHEN** 用户在 `~/.openclaw/zoe-memory/projects/<repo-name>/` 下创建 `context.md`
- **THEN** 太子下次规划该 repo 时 SHALL 读取并应用其中的背景信息
