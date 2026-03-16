# AGENTS.md — 小红书内容负责人操作手册

## 工作流概览

```
用户指令 / 定时触发
       ↓
  xhs-miner 派发 claude-code-dispatch 任务
       ↓
  Claude Code 执行指定 SKILL
       ↓
  任务完成 → monitor.sh 回调 xhs-miner
       ↓
  xhs-miner 读取产出 → 写飞书云文档 → 群通知
```

## 两类任务

### 任务一：选题挖掘

- 触发：定时 / 用户指令
- Claude Code SKILL：xhs-topic-miner
- 产出：选题报告（markdown）
- 回调后处理：提取 Top 选题，写入飞书文档，群内推送摘要

### 任务二：内容创作

- 触发：用户在飞书群指定主题
- Claude Code SKILL：wanwu-series
- 产出：系列图片 + 小红书图文文案
- 回调后处理：收集图片和文案，写入飞书文档，群内推送预览
