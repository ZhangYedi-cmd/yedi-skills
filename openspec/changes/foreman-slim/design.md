## Context

包工头目前是完整开发流水线的中枢，负责 spec 生成 → 人工审批 → 技术审核 → swarm 执行 → 代码审核 → 合并交付全链路。当用户只需要"给定 tasks.json + prompts，跑 swarm，结果通知我"时，这套重量级流程是多余的负担。

同时，ai-tmux-swarm 的启动过程在包工头 SOUL.md 中手动实现（检查脚本是否存在、cp -r 复制脚本、chmod、写 config.env、执行 start_all.sh），这些步骤应该由 skill 自身提供统一入口封装。

## Goals / Non-Goals

**Goals:**
- 新建 `launch_swarm.sh`，一条命令完成 scaffold 安装 + config 写入 + 启动
- 包工头 SOUL.md 精简至只描述三个职责，去除所有流水线逻辑
- 包工头能从飞书消息中解析 repo_path 和用户 open_id，动态传入 launch_swarm.sh

**Non-Goals:**
- 不改动 ai-tmux-swarm 的核心运行机制（start_all.sh / monitor.sh / swarm_state.py）
- 不改动 reviewer、shipper、taizi agent
- 不实现 spec 生成、代码审核等功能（这是完整流水线的职责）

## Decisions

### 1. launch_swarm.sh 放在 ai-tmux-swarm/scripts/ 下

**选择**：与 install_swarm.sh 同级，由 skill 提供。

**理由**：skill 对自身启动逻辑负责，包工头只是调用方。包工头通过 `openclaw skills path ai-tmux-swarm` 动态获取路径，不硬编码。

**备选**：放在包工头自己的 scripts/ → 拒绝，因为启动逻辑不属于包工头，属于 swarm skill。

### 2. launch_swarm.sh 内部调用 install_swarm.sh（幂等）

**选择**：launch_swarm.sh 内部先调 install_swarm.sh，再写 config.env，再执行 start_all.sh。

**理由**：install_swarm.sh 用 rsync 实现幂等复制，重复执行安全。这样 launch_swarm.sh 可以在 .swarm/ 不存在或已存在的情况下都正确工作。

### 3. config.env 由 launch_swarm.sh 写入，不由包工头手动构造

**选择**：launch_swarm.sh 接收 --agent-id、--feishu-chat-id 等参数，内部写 config.env。

**理由**：config.env 的格式是 swarm skill 的内部细节，不应暴露给包工头。launch_swarm.sh 是唯一知道如何正确配置的地方。

**写入策略**：合并写入（merge），保留用户已有的自定义配置，只覆盖传入的参数对应的键。

### 4. 包工头的 action tag 处理只保留三种

- `[action:done]`：单任务完成，转发给飞书用户
- `[action:escalate]`：任务失败，告警给飞书用户
- `[action:merge]`：全部完成，汇总发飞书

**拒绝的**：`[action:review-code]`、`[action:ship]`、`[action:plan-approved]` 等流水线 action —— 精简版包工头不处理这些。

### 5. feishu-chat-id 从用户消息动态解析

包工头从飞书收到消息时，消息上下文携带发件人 open_id，直接读取用于后续通知，不需要硬编码。

## Risks / Trade-offs

- **config.env 合并写入可能冲突** → 约定：launch_swarm.sh 只写入它负责的键（SWARM_AGENT_ID、FEISHU_CHAT_ID、FEISHU_ACCOUNT_ID、SWARM_NOTIFY_MODE、OPENCLAW_EVENT_MODE），其他键保持不变
- **精简版包工头无法处理完整流水线请求** → 这是设计意图，不是缺陷；完整流水线场景需要使用原有的完整版 agent 配置
- **launch_swarm.sh 路径依赖 openclaw skills path** → 若 skill 未安装，包工头需给出明确错误提示

## Migration Plan

1. 备份现有 foreman SOUL.md（git 历史保留，无需额外操作）
2. 新建 launch_swarm.sh
3. 重写 foreman 的 SOUL.md / AGENTS.md / IDENTITY.md / TOOLS.md
4. 无需数据迁移，无运行时状态依赖
5. 回滚：git revert 对应 commit 即可
