# 笔记 Schema 规范

所有笔记使用 Obsidian 兼容的 YAML frontmatter。参考 obsidian-markdown 的 PROPERTIES.md。

## 笔记语言规则

**跟随原文语言**: 英文来源产出英文笔记，中文来源产出中文笔记。`language` 字段标记。

---

## Type 1: Source Note

**存储位置**: `00-Inbox/`
**命名**: `{platform}-{YYYY-MM-DD}-{slug}.md`
**用途**: 记录一个 URL 来源的结构化摘要

### Frontmatter Schema

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| `type` | Text | 是 | 固定值 `source` |
| `title` | Text | 是 | 内容标题（原文标题或 AI 生成） |
| `source_url` | Text | 是 | 原始 URL |
| `source_platform` | Text | 是 | 平台标识（见下方列表） |
| `author` | Text | 推荐 | 作者名（Twitter 为 @handle） |
| `published_date` | Date | 推荐 | 原文发布日期 |
| `ingested_date` | Date | 是 | 入库日期（自动填充当天） |
| `tags` | List | 是 | AI 自动标签（3-5 个） |
| `language` | Text | 是 | `en` / `zh` |
| `content_type` | Text | 是 | 内容类型（见下方列表） |
| `aliases` | List | 否 | 备选标题（用于 Obsidian 链接建议） |

**source_platform 取值**: `twitter` / `reddit` / `github` / `web` / `youtube` / `bilibili` / `xhs` / `instagram` / `linkedin` / `rss`

**content_type 取值**: `article` / `thread` / `video` / `repo` / `discussion` / `post` / `paper`

### 正文结构

```markdown
---
type: source
title: "Model Context Protocol: A New Standard for LLM Tool Use"
source_url: "https://www.anthropic.com/news/model-context-protocol"
source_platform: web
author: "Anthropic"
published_date: 2026-02-15
ingested_date: 2026-03-01
tags:
  - AI
  - MCP
  - tool-use
  - protocol
language: en
content_type: article
aliases:
  - "MCP Protocol Announcement"
---

## Summary

[3-5 句话，≤ 200 字。必含论点 + 证据 + 结论]

## Key Points

- [要点 1]
- [要点 2]
- [要点 3]

## Atoms

- [[model-context-protocol]]
- [[client-server-architecture]]

## Source

[Model Context Protocol](https://www.anthropic.com/news/model-context-protocol)
```

---

## Type 2: Atom Note

**存储位置**: `40-Atoms/`
**命名**: `{concept-name}.md`（优先使用能直观表意的名称，允许中英混合，如 `Context-Engineering-上下文工程.md`）
**用途**: 一个独立概念的知识单元（Zettelkasten 风格）

### Frontmatter Schema

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| `title` | Text | 是 | 概念名称 |
| `created` | Date | 是 | 创建日期 |
| `updated` | Date | 否 | 最后更新日期（多 source 补充时） |
| `tags` | List | 是 | 概念标签（用 `concept/` 前缀） |
| `sources` | Links | 是 | 来源笔记的 wikilink（支持多来源） |
| `language` | Text | 是 | `en` / `zh` |

### 正文结构

```markdown
---
title: "Model Context Protocol"
created: 2026-03-01
tags:
  - concept/AI
  - concept/protocol
  - concept/tool-use
sources:
  - "[[web-2026-03-01-mcp-protocol-announcement]]"
language: en
---

[用自己的话重述概念，≤ 500 字。有足够上下文供 query 调用时能给出有意义的答案]

Model Context Protocol (MCP) is an open standard by Anthropic that defines how LLMs
communicate with external tools. It uses a client-server architecture where the LLM
acts as a client, sending JSON-RPC requests to tool servers. Each server exposes a
set of tools with typed schemas. This decouples tool implementation from LLM providers,
enabling a shared ecosystem of reusable tool servers.

## Related

- [[function-calling]] — MCP builds upon but standardizes function calling
- [[json-rpc]] — The underlying communication protocol
- [[agent-tool-use]] — MCP is one approach to agent tool use
```

### Atom 质量检查清单

- [ ] ≤ 500 字
- [ ] 一个笔记只讲一个概念
- [ ] 用自己的话重述，不照搬原文
- [ ] 有 `sources` 链接回 source note
- [ ] 有 `## Related` 部分，至少 1 个 [[wikilink]]
- [ ] 有足够上下文供 query 调用时能给出有意义的答案

---

## Type 3: Daily Brief

**存储位置**: `60-Briefs/daily/`
**命名**: `{YYYY-MM-DD}.md`
**用途**: 每日知识简报，用户 5 分钟消化

### Frontmatter Schema

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| `type` | Text | 是 | 固定值 `brief` |
| `period` | Text | 是 | `daily` |
| `date` | Date | 是 | 简报日期 |
| `stats` | Object | 是 | 统计数据（见下方） |
| `tags` | List | 是 | 固定 `[brief/daily]` |

**stats 子字段**:
- `ingested`: Number — 今日摄入条数
- `new_atoms`: Number — 新增原子概念数
- `new_links`: Number — 新增关联数

### 正文结构

```markdown
---
type: brief
period: daily
date: 2026-03-01
stats:
  ingested: 8
  new_atoms: 5
  new_links: 12
tags:
  - brief/daily
---

## 今日一句话

[一句话总结今日最重要的发现，突出核心洞察]

## 信息流概览

- 摄入: 8 条 | 新概念: 5 个 | 新关联: 12 条
- 高频标签: #AI, #MCP, #agent
- 来源分布: web 4 | twitter 2 | github 1 | reddit 1

## 值得你花 5 分钟看的

1. [[web-2026-03-01-mcp-protocol-announcement]] — Anthropic 发布新协议，可能成为 Agent 工具调用标准
2. [[twitter-2026-03-01-claude-agent-sdk]] — Claude Agent SDK 开源，值得关注架构设计
3. [[github-2026-03-01-mcp-server-collection]] — 社区已有 20+ MCP server 实现，可直接使用

## 新增原子概念

- [[model-context-protocol]] — LLM 与工具通信的开放标准
- [[claude-agent-sdk]] — Anthropic 官方 Agent 开发框架
- [[json-rpc]] — MCP 底层使用的通信协议
- [[agent-memory]] — Agent 长期记忆的实现方式
- [[tool-server]] — MCP 中暴露工具的服务端组件

## 下一步建议

1. **立即可做**：[来自今日内容的零成本可试动作]
2. **值得跟进**：[需要花 30 分钟以上的事项]
3. **待观察**：[不需要行动，但值得持续关注的信号]
```

---

## Type 4: Weekly Brief

**存储位置**: `60-Briefs/weekly/`
**命名**: `{YYYY-MM-DD}.md`（日期为该周周一）
**用途**: 每周知识地图，趋势分析

### Frontmatter Schema

与 Daily Brief 相同，但 `period: weekly`，stats 汇总整周数据。

### 正文结构（在 Daily 基础上增加）

```markdown
---
type: brief
period: weekly
date: 2026-02-24
stats:
  ingested: 42
  new_atoms: 23
  new_links: 67
tags:
  - brief/weekly
---

## 本周一句话

[...]

## 信息流概览

[同 daily 格式，但为整周数据]

## 本周趋势

### 🔥 升温话题
- **MCP Protocol**: 本周出现 12 次（上周 3 次），多个平台同时讨论
- **Agent Memory**: 出现 8 次，与 RAG 话题高度关联

### 📉 降温话题
- **Prompt Engineering**: 本周仅 2 次，正在被 Agent 工作流取代

## 本周 TOP 5 原子概念

1. [[model-context-protocol]] — 被 7 个 source 引用
2. [[claude-agent-sdk]] — 被 5 个 source 引用
3. ...

## 知识图谱变化

- "AI Agent" 集群新增 8 个节点
- "编程技术" 与 "AI Agent" 集群产生新连接（通过 [[rust-wasm-agent]]）
- 2 个孤岛笔记待处理: [[xxx]], [[yyy]]

## 本周推荐深读（TOP 3）

1. [[source-note-1]] — 推荐理由
2. [[source-note-2]] — 推荐理由
3. [[source-note-3]] — 推荐理由

## 下一步建议

1. **立即可做**：[来自本周内容的零成本可试动作]
2. **值得跟进**：[需要花 30 分钟以上的事项]
3. **待观察**：[不需要行动，但值得持续关注的信号]
```

---

## Tag 命名规范

| 前缀 | 用途 | 示例 |
|------|------|------|
| `concept/` | 概念域标签 | `concept/AI`, `concept/protocol` |
| `platform/` | 来源平台 | `platform/twitter`, `platform/github` |
| `brief/` | 简报类型 | `brief/daily`, `brief/weekly` |
| `project/` | 项目关联 | `project/xhs-content` |
| `status/` | 状态标记 | `status/conflict`, `status/trending` |

无前缀标签用于通用主题: `AI`, `MCP`, `Rust`, `创业` 等。
