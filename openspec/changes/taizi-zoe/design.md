## Context

当前 taizi 是消息分拣 Agent，职责单一：判断是否开发需求 → 转发 foreman。但随着 foreman-slim 改造完成，foreman 已不再做任何规划，旧的 4-agent pipeline（taizi → foreman → planner → reviewer → shipper）已被废弃。规划空缺需要由 taizi 直接填补。

taizi 使用 MiniMax M2.5 模型，运行在 OpenClaw Agent 框架上，有 `message` 工具（飞书）和 bash 执行能力，能够调用文件系统工具（Read/Glob/Grep/Write）。

## Goals / Non-Goals

**Goals:**
- taizi 能在飞书会话中接收"repo 路径 + 需求描述"并自主规划，生成完整的 swarm 执行产物
- 规划前读取项目知识库，规划后展示摘要并等待用户确认
- 保留进度通知转发能力 (`[action:notify-user]`)
- 知识库结构简单，用户可以用文本编辑器直接维护

**Non-Goals:**
- taizi 不自动触发 foreman（用户手动）
- 不构建向量检索/语义搜索型知识库（plain markdown 足够）
- 不修改 foreman、swarm-planner SKILL、其他 Agent

## Decisions

### 决策 1：taizi 内联规划 vs 调用 swarm-planner 子进程

**选择：内联规划**（taizi 自己探索代码库并生成产物）

原因：
- swarm-planner SKILL 是给 Claude Code CLI 用的 prompt 指令集，不是可执行程序
- 触发子进程需要知道 claude CLI 路径、处理异步、跨进程通信，复杂度高
- taizi (Claude) 本身就有 Read/Glob/Grep/Write 能力，直接用即可
- 内联规划让对话上下文保持连续（用户可以中途修改需求）

### 决策 2：知识库路径约定

**选择：`~/.openclaw/zoe-memory/projects/<repo-name>/context.md`**

- `<repo-name>` = repo 目录的最后一段（`basename <repo_path>`）
- 文件不存在时静默跳过（规划照常进行，不报错）
- 内容格式：自由 markdown，用户自己维护

原因：固定路径约定 > 配置文件，零配置开箱即用。

### 决策 3：规划触发方式

**选择：关键词 + repo 路径识别**

用户消息包含 repo 路径（绝对路径 `/...` 或相对路径）+ 开发意图词 → 触发规划模式。
若用户只说需求未给路径 → 太子追问一次"请告诉我 repo 的绝对路径"。

### 决策 4：人工确认门

**选择：飞书消息内确认，非 action tag**

太子在飞书发摘要后等待用户回复。
- 收到"确认/OK/开干"等肯定词 → 回复"好的，请让包工头启动：`openclaw message foreman '启动 <repo_path>'`"
- 收到修改意见 → 重新规划（最多 2 轮修改，超出后建议用户手动调整 spec.md）

原因：用户明确说"手动让包工头启动"，不需要自动 action tag 路由。

## Risks / Trade-offs

- **规划质量依赖模型能力** → 使用 MiniMax M2.5（reasoning 模式），复杂项目可能需要用户补充 context.md
- **大型代码库探索耗时** → 探索阶段限制读取文件数（先 package.json/README/入口文件，按需深入），避免超时
- **artifacts 覆盖风险** → 写 `.swarm/` 前检查是否已存在，若存在则提示用户确认是否覆盖

## Migration Plan

1. 更新 `taizi/SOUL.md` 和 `AGENTS.md`（源文件）
2. 同步到 `~/.openclaw/agents/taizi/agent/`（生效）
3. 创建 `~/.openclaw/zoe-memory/projects/` 目录 + 模板
4. 重启 taizi session（或等 session 自然刷新）

无回滚风险：旧的 `[action:dev-request]` 路由在 foreman-slim 后已无效，删除不影响任何正在运行的流程。

## Open Questions

- MiniMax M2.5 的文件读写工具是否默认开启？需在测试中验证 taizi 能否直接 Write 到 `<repo_path>/.swarm/`
