## 1. 新建 launch_swarm.sh

- [x] 1.1 在 `openclaw/dev/ai-tmux-swarm/scripts/` 下新建 `launch_swarm.sh`，定义参数接口（repo-path、--agent-id、--feishu-chat-id、--feishu-account-id、--engine、--notify）
- [x] 1.2 实现参数解析与必填校验，缺少 repo-path 或 --agent-id 时打印 usage 并以退出码 1 退出
- [x] 1.3 实现调用 `install_swarm.sh` 步骤（通过 `$SCRIPT_DIR` 定位同级脚本）
- [x] 1.4 实现 config.env 合并写入逻辑（只覆盖负责的 5 个键：SWARM_AGENT_ID、OPENCLAW_EVENT_MODE、SWARM_NOTIFY_MODE、FEISHU_CHAT_ID、FEISHU_ACCOUNT_ID）
- [x] 1.5 实现调用 `bash .swarm/scripts/start_all.sh` 并透传其退出码
- [x] 1.6 添加 `chmod +x` 确保脚本可执行

## 2. 重写 foreman SOUL.md

- [x] 2.1 删除所有流水线相关 action 处理（dev-request、plan-approved、plan-rejected、human-approved-spec、human-rejected-spec、code-rejected、shipped）
- [x] 2.2 编写"收到飞书消息 → 解析 repo_path + open_id → 调用 launch_swarm.sh"的处理逻辑
- [x] 2.3 编写"收到 action:done → 发飞书"的处理逻辑
- [x] 2.4 编写"收到 action:escalate → 发飞书告警"的处理逻辑
- [x] 2.5 编写"收到 action:merge → 发飞书汇总"的处理逻辑
- [x] 2.6 编写"无法解析 repo_path"和"launch_swarm.sh 失败"的错误处理

## 3. 重写 foreman AGENTS.md

- [x] 3.1 删除原有完整流水线流程图
- [x] 3.2 编写精简版三步流程图（收到飞书消息 → 启动 swarm → 监听 action tag 发飞书）
- [x] 3.3 删除 coordinator-state.json 相关说明（精简版不使用）

## 4. 更新其他 foreman 配置文件

- [x] 4.1 更新 `IDENTITY.md`：Creature 字段改为"执行调度 AI（执行层）"
- [x] 4.2 更新 `TOOLS.md`：补充 launch_swarm.sh 路径获取方式（`openclaw skills path ai-tmux-swarm` + `/scripts/launch_swarm.sh`）
