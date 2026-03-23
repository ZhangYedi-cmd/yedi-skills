# 状态流转

## 状态定义

| 状态 | 含义 | 终态？ |
|------|------|--------|
| `pending` | dispatch.sh 已写入 state.json，尚未启动 tmux | 否 |
| `running` | tmux session 正在执行 claude CLI | 否 |
| `retrying` | 上次失败，正在重新启动（瞬态，很快变回 running） | 否 |
| `done` | claude 退出码为 0，任务成功完成 | 是 |
| `failed` | 重试用尽仍失败，或 tmux 启动失败 | 是 |

## 流转图

```
dispatch.sh 创建 → pending
dispatch.sh 启动 tmux → running
                          │
             cron monitor.sh 每分钟检查
                          │
              ┌───────────┼───────────┐
              ↓           ↓           ↓
        tmux 还在     exit 0      exit != 0
         running       done     retry_count < max?
                        ↓        ├─ 是 → retrying → running
                    移除 cron     └─ 否 → failed
                    通知用户              ↓
                                     移除 cron
                                     通知用户
```

## 终态处理

进入 `done` 或 `failed` 时，monitor.sh 自动：
1. 移除 cron job
2. 飞书直发通知（格式可控，即时到达）
3. Agent 回调（Agent 可做后续逻辑，如等待用户审核后触发下一步）

## 运行时文件结构

```
{workdir}/
└── .claude-dispatch/
    ├── state.json        # 任务状态（JSON，包含所有参数和状态）
    └── logs/
        ├── {task-id}.log # 任务日志（claude 输出 tee 到这里）
        └── monitor.log   # monitor.sh 的运行日志
```
