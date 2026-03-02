# 三层信息加工模型

## 核心理念

信息是矿石，知识才是金属。原始信息必须经过冶炼才能成为可复用的知识资产。

```
原始内容 ──→ L1 元数据 ──→ L2 摘要 ──→ L3 原子概念
 (矿石)      (分类标记)    (初炼)      (精炼金属)
```

## L1 元数据层 — "这是什么"

**自动化程度**: 100%（从 agent-reach 结构化输出直接提取）

**提取字段**:

| 字段 | 类型 | 来源 | 示例 |
|------|------|------|------|
| `source_url` | Text | URL 参数 | `https://twitter.com/...` |
| `source_platform` | Text | URL 域名自动识别 | `twitter` |
| `author` | Text | agent-reach --json 输出 | `@anthropic` |
| `published_date` | Date | agent-reach --json 输出 | `2026-03-01` |
| `ingested_date` | Date | 系统当前日期 | `2026-03-01` |
| `auto_tags` | List | AI 自动打标（3-5 个） | `[AI, agent, MCP]` |
| `language` | Text | AI 检测 | `en` / `zh` |
| `content_type` | Text | AI 判断 | `article` / `thread` / `video` |

**产出**: source note 的 YAML frontmatter

**质量标准**: 所有必填字段非空，platform 从预定义列表中选取。

**平台识别规则**:

| URL 模式 | platform 值 |
|----------|-------------|
| `twitter.com` / `x.com` | `twitter` |
| `reddit.com` | `reddit` |
| `github.com` | `github` |
| `youtube.com` / `youtu.be` | `youtube` |
| `bilibili.com` / `b23.tv` | `bilibili` |
| `xiaohongshu.com` / `xhslink.com` | `xhs` |
| `instagram.com` | `instagram` |
| `linkedin.com` | `linkedin` |
| RSS/Atom feed | `rss` |
| 其他 | `web` |

## L2 摘要层 — "说了什么"

**自动化程度**: 100%（AI 生成）

**规则**:
- 3-5 句话提炼核心观点
- 总字数 ≤ 200 字（中文）/ 150 words（英文）
- 必须包含三要素：
  1. **主要论点**：这篇内容的核心主张是什么
  2. **关键证据**：支撑论点的数据、案例或推理
  3. **结论/启示**：对读者意味着什么

**产出**: source note 的 `## Summary` 部分

**质量标准**: 读完摘要后，应能在 5 秒内判断「这篇值不值得我亲自去读原文」。

**Bad example** (不合格):
> 这篇文章讲了 MCP 协议的一些内容，很有意思。

**Good example** (合格):
> Anthropic 发布 Model Context Protocol (MCP)，一个标准化 LLM 与外部工具通信的开放协议。
> 核心设计是 client-server 架构，LLM 作为 client 通过 JSON-RPC 调用 server 暴露的工具。
> 已有 20+ 社区 server 实现，覆盖文件系统、数据库、API 等场景。
> 这可能成为 AI Agent 工具调用的事实标准，值得关注其生态发展。

## L3 原子概念层 — "意味着什么"

**自动化程度**: 90%（AI 生成 + 用户可调整）

**Zettelkasten 原则**:
1. **一个笔记 = 一个概念**：不混合多个主题
2. **用自己的话重述**：不照搬原文，而是内化后表达
3. **≤ 300 字**：强制简洁，迫使提炼精华
4. **必须有 [[wikilinks]]**：孤立的知识没有价值

**拆解判断标准** — 从一篇内容中识别 1-5 个独立概念:

| 信号 | 说明 | 示例 |
|------|------|------|
| 新术语 | 首次出现的专有名词 | `Model Context Protocol` |
| 新框架 | 可复用的思考模型 | `Client-Server 架构` |
| 新数据 | 有引用价值的数据点 | `70km/decade 物种迁移速度` |
| 新洞察 | 反直觉或有启发的观点 | `工具可靠性 > 工具数量` |
| 新方法 | 可操作的方法论 | `STEPPS 传播力评估` |

**命名规则**: 概念名用英文 kebab-case（如 `model-context-protocol.md`），即使内容是中文。这确保文件名的一致性和可链接性。

**关联规则**:
- 新概念创建时，扫描 `40-Atoms/` 已有笔记标题
- 语义相关的概念添加 `[[wikilink]]` 到 `## Related` 部分
- 发现矛盾时标记 `⚡ conflict`：`[[概念A]] ⚡ 与本概念在 X 方面矛盾`

**产出**: `40-Atoms/` 下的独立 Markdown 文件

**质量标准**: 脱离 source note 后，atom note 仍可独立阅读和理解。

## 三层之间的关系

```
一篇文章 (URL)
    │
    ├── Source Note (00-Inbox/)
    │   ├── L1: frontmatter 元数据
    │   └── L2: ## Summary 摘要
    │
    └── Atom Notes (40-Atoms/)    ← L3
        ├── concept-a.md ──→ [[concept-x]] (已有)
        ├── concept-b.md ──→ [[concept-y]] (已有)
        └── concept-c.md ──→ (新概念，暂无关联)
```

**信息流向**: Source Note 是「入口」，Atom Note 是「沉淀」。随时间推移，Source Note 可能过时归档，但 Atom Note 持续生长和互联。

## 设计理由

1. **L1 支持检索**: 按平台、日期、标签过滤，快速定位
2. **L2 支持决策**: 5 秒判断是否值得深读，避免信息过载
3. **L3 支持复用**: 原子概念可跨来源关联，是真正的知识资产。同一个概念被多个 source 提及时，atom note 会越来越丰富
