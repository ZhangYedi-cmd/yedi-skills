---
name: swarm-dashboard
description: 零依赖 Web Dashboard，实时监控 ai-tmux-swarm 的任务 DAG、状态变化和日志流。基于 Python stdlib HTTP server + SSE + dagre DAG 渲染，无需安装任何 pip/npm 依赖。
---

# Swarm Dashboard

零依赖的只读 Web 监控面板，为 ai-tmux-swarm 提供实时任务 DAG 可视化、状态监控和日志流查看。

## 技术栈

| 层 | 选择 | 理由 |
|---|---|---|
| 后端 | Python stdlib (`http.server.ThreadingHTTPServer`) | 零 pip 依赖，单文件启动 |
| 实时推送 | SSE (Server-Sent Events) | 单向推送，比 WebSocket 简单 |
| 状态监听 | mtime 轮询 (2s) | 无需 watchdog/inotify |
| DAG 渲染 | dagre (本地副本) | 纯布局计算，无需 D3 |
| 前端 | 原生 HTML + JS + CSS | 无构建步骤，无 node_modules |

## 快速使用

```bash
# 指向任意 repo 的 .swarm 目录
python3 ~/.openclaw/skills/swarm-dashboard/scripts/swarm_dashboard.py \
  --swarm-dir /path/to/repo/.swarm

# 或在 repo 内自动检测
cd /path/to/repo && python3 ~/.openclaw/skills/swarm-dashboard/scripts/swarm_dashboard.py

# 自定义端口
python3 ~/.openclaw/skills/swarm-dashboard/scripts/swarm_dashboard.py --port 9000
```

输出: `Swarm Dashboard running at http://127.0.0.1:8420`

## 功能

### DAG 可视化
- 自动从 `state/tasks.json` 构建任务依赖图
- 节点颜色反映任务状态：pending (灰)、running (蓝)、retrying (黄)、done (绿)、failed (红)
- Running 节点有脉冲动画
- 支持鼠标拖拽平移和滚轮缩放

### 任务详情
- 点击节点查看：ID、描述、引擎/模型、分支（可复制）、时间戳、尝试/重启次数、退出码、note、依赖列表
- 折叠展示 prompt 文件内容

### 日志查看器
- Tab 切换到日志视图
- SSE 实时追加日志内容
- 自动滚动 + 暂停/清除按钮
- ANSI 转义自动剥离

### 实时更新
- SSE 连接状态变化时自动更新 DAG 颜色、详情面板、Header 统计
- 断线自动重连（指数退避: 1s → 2s → 4s → ... → max 30s）
- Header 显示：repo 名、运行时长（动态计时）、各状态任务数

### API

#### REST

| 方法 | 路径 | 说明 |
|---|---|---|
| GET | `/` | 主页面 |
| GET | `/static/*` | 静态资源 |
| GET | `/api/state` | 运行时状态 |
| GET | `/api/manifest` | 任务清单 |
| GET | `/api/config` | config.env (敏感值脱敏) |
| GET | `/api/logs/{slug}` | 日志最后 500 行 |
| GET | `/api/prompt/{slug}` | Prompt 文件内容 |

#### SSE

| 路径 | 说明 |
|---|---|
| `/api/events/state` | 状态变化推送 |
| `/api/events/logs/{slug}` | 日志增量推送 |

## 注意事项

- 这是只读监控面板，不会修改任何 swarm 状态
- Dashboard 是独立观察者，不应被复制进目标仓库的 `.swarm/` scaffold
- 敏感配置值（TOKEN、SECRET、KEY、PASSWORD 等）会自动脱敏显示
