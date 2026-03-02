# 信息源配置规范（sources.yaml）

## 概述

`_config/sources.yaml` 定义知识库追踪的主题和对应的信息源配置。
`patrol` 命令读取此文件，按配置自动执行 agent-reach 搜索并摄入高质量内容。

## 文件位置

```
~/Documents/Knowledge Forge/_config/sources.yaml
```

## 顶层结构

```yaml
version: "1.0"                    # Schema 版本

topics:                           # 主题列表（数组）
  - name: "..."                   # 主题配置（见下方字段约束）
```

## 主题字段约束

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| `name` | String | 是 | 主题名（唯一标识，不可重复） |
| `description` | String | 是 | 一句话描述 |
| `priority` | String | 是 | `high` / `medium` / `low`，决定 patrol 执行顺序 |
| `daily` | Array | 否 | 每日巡逻的搜索配置 |
| `weekly` | Array | 否 | 每周深度搜索配置 |
| `quality_threshold` | Number | 否 | 质量评分门槛 0-1（默认 0.5） |
| `max_daily_ingest` | Number | 否 | 每日最大摄入条数（默认 5） |

**至少需要 `daily` 或 `weekly` 之一。**

## 搜索项字段约束

每个 daily/weekly 数组的元素:

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| `platform` | String | 是 | agent-reach 平台标识 |
| `query` | String | 是 | 搜索关键词 |
| `n` | Number | 否 | 结果数量（默认 10） |
| `sub` | String | 条件 | Reddit 专用：subreddit 名称 |
| `lang` | String | 条件 | GitHub 专用：编程语言 |

### platform 取值与 agent-reach 命令映射

| platform 值 | agent-reach 命令 | 说明 |
|-------------|-----------------|------|
| `web` | `agent-reach search "query"` | Exa 全网搜索 |
| `twitter` | `agent-reach search-twitter "query"` | Twitter/X |
| `reddit` | `agent-reach search-reddit "query" --sub xxx` | Reddit |
| `github` | `agent-reach search-github "query" --lang xxx` | GitHub |
| `youtube` | `agent-reach search-youtube "query"` | YouTube |
| `bilibili` | `agent-reach search-bilibili "query"` | B站 |
| `xhs` | `agent-reach search-xhs "query"` | 小红书 |
| `instagram` | `agent-reach search-instagram "query"` | Instagram |
| `linkedin` | `agent-reach search-linkedin "query"` | LinkedIn |
| `rss` | `agent-reach read <feed-url>` | RSS/Atom Feed |

## 完整示例

```yaml
version: "1.0"

topics:
  - name: "AI Agents"
    description: "AI Agent 架构、LLM 应用、MCP、工具调用"
    priority: high
    daily:
      - platform: web
        query: "AI agent framework 2026"
        n: 10
      - platform: twitter
        query: "LLM agent MCP tool use"
        n: 20
      - platform: reddit
        query: "AI agent framework"
        sub: LocalLLaMA
        n: 10
    weekly:
      - platform: github
        query: "AI agent framework stars:>100"
        lang: python
        n: 10
      - platform: youtube
        query: "AI agent tutorial 2026"
        n: 5
    quality_threshold: 0.6
    max_daily_ingest: 5

  - name: "小红书运营"
    description: "小红书内容策略、爆款分析、平台趋势"
    priority: medium
    daily:
      - platform: xhs
        query: "AI工具种草"
        n: 30
      - platform: twitter
        query: "小红书运营 内容策略"
        n: 15
    quality_threshold: 0.5
    max_daily_ingest: 5

  - name: "编程技术"
    description: "Rust、TypeScript、系统设计等技术话题"
    priority: medium
    daily:
      - platform: web
        query: "Rust systems programming 2026"
        n: 10
      - platform: github
        query: "rust typescript stars:>50 pushed:>2026-01-01"
        n: 10
      - platform: reddit
        query: "systems programming"
        sub: programming
        n: 10
    weekly:
      - platform: youtube
        query: "systems design tutorial"
        n: 5
    quality_threshold: 0.5
    max_daily_ingest: 5

  - name: "产品创业"
    description: "产品设计、独立开发、商业模式"
    priority: medium
    daily:
      - platform: web
        query: "indie hacker product launch 2026"
        n: 10
      - platform: twitter
        query: "indie hacker solo founder"
        n: 15
    weekly:
      - platform: reddit
        query: "side project launch"
        sub: SideProject
        n: 10
    quality_threshold: 0.5
    max_daily_ingest: 3
```

## 质量评分说明

`quality_threshold` 用于 patrol 流程中筛选搜索结果。评分逻辑：

| 信号 | 权重 | 说明 |
|------|------|------|
| 来源权威性 | 0.3 | 知名作者/机构 > 个人博客 > 未知来源 |
| 内容新鲜度 | 0.2 | 24h 内 > 7 天内 > 30 天内 > 更早 |
| 标题信息密度 | 0.2 | 有具体术语/数据 > 泛泛而谈 |
| 平台权重 | 0.15 | 论文/GitHub > 技术博客 > 社交媒体 |
| 与已有知识关联度 | 0.15 | 标题包含已有 Atom 概念名 > 无关联 |

**评分 < quality_threshold 的结果跳过 `agent-reach read`，不进入 ingest 流程。**

## 修改指南

用户可随时修改 `sources.yaml`:
- 添加新主题：追加 topic 配置块
- 调整搜索词：修改 query 字段
- 增减平台：添加/删除 daily/weekly 中的搜索项
- 调整信息量：修改 `n` 和 `max_daily_ingest`

修改后下次 `patrol` 自动生效，无需重启。
