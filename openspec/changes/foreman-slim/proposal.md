## Why

包工头当前承担了完整流水线职责（spec 生成、reviewer 审核、shipper 合并），导致 SOUL.md 膨胀至 244 行，职责过重且难以维护。在只需要"启动 swarm → 监控进度 → 通知用户"的轻量场景下，完整流水线是不必要的复杂度。同时，ai-tmux-swarm 启动过程需要包工头手动复制脚本、写 config.env、再执行 start_all.sh，缺乏统一入口命令。

## What Changes

- **新增** `ai-tmux-swarm/scripts/launch_swarm.sh`：统一封装 scaffold 安装 + config.env 写入 + start_all.sh 启动，一条命令完成 swarm 启动全流程
- **重写** `foreman/SOUL.md`：去除 spec/review/ship 流水线，只保留三个职责：启动 swarm、监听 cron action tag、发送飞书消息
- **重写** `foreman/AGENTS.md`：流程图精简为三步流
- **更新** `foreman/IDENTITY.md`：Creature 描述从"规划调度"改为"执行调度"
- **更新** `foreman/TOOLS.md`：补充 launch_swarm.sh 路径说明

## Capabilities

### New Capabilities

- `launch-swarm`: 统一 swarm 启动命令，接收 repo-path 及飞书/agent 配置参数，幂等安装 scaffold、写入 config.env、启动 start_all.sh
- `foreman-slim-agent`: 精简版包工头行为规范，只处理 swarm 启动和进度通知，不参与 spec/review/ship 流程

### Modified Capabilities

（无）

## Impact

- `openclaw/dev/ai-tmux-swarm/scripts/launch_swarm.sh`：新文件
- `openclaw/dev/dev-workflow/agents/foreman/SOUL.md`：全量重写
- `openclaw/dev/dev-workflow/agents/foreman/AGENTS.md`：重写
- `openclaw/dev/dev-workflow/agents/foreman/IDENTITY.md`：小改
- `openclaw/dev/dev-workflow/agents/foreman/TOOLS.md`：补充内容
- 原有 reviewer、shipper、taizi 不受影响（此次变更仅裁剪包工头职责）
