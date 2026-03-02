# Ingest 工作流

## 使用场景

将一个或多个 URL 的内容摄入知识库。适用于：
- 用户手动提供 URL 想要入库
- patrol 流程批量摄入搜索结果
- 其他技能产出的内容存档

## 触发命令

```bash
/knowledge-forge ingest <url>                    # 单条
/knowledge-forge ingest <url1> <url2> ...        # 批量
/knowledge-forge ingest --file urls.txt          # 从文件
```

## 依赖工具

| 工具 | 用途 | 必须？ |
|------|------|--------|
| `agent-reach read` | 读取 URL 内容 | 是（有降级） |
| `defuddle` | 降级时的网页提取 | 否 |
| `WebFetch` | 二次降级 | 否 |

降级策略：
1. 优先使用 `agent-reach read <url> --json`
2. 若 agent-reach 不可用 → 尝试 `defuddle`
3. 若 defuddle 不可用 → 尝试 `WebFetch`
4. 全部不可用 → 终止并提示用户

---

## Phase 0: 去重检查

**执行者**: 读取 `_index/processed-urls.json`

**目标**: 避免重复处理已入库的 URL

```
读取 _index/processed-urls.json
IF url 已存在:
  输出: "⏭️ 已处理过: {url}，跳过。原笔记: {note_path}"
  跳过后续所有 Phase
ELSE:
  继续 Phase 1
```

**URL 规范化规则**:
- 去掉 URL 末尾的 `/`
- 去掉 tracking 参数（`utm_*`, `ref`, `source`）
- Twitter: `x.com` 和 `twitter.com` 视为同一 URL
- 小红书: `xhslink.com` 短链先解析为完整 URL

---

## Phase 1: 内容获取

**执行者**: `agent-reach read <url> --json`

**目标**: 获取结构化的内容和元数据

```bash
# 执行命令
agent-reach read <url> --json
```

**输出处理**:
- 解析 JSON 输出，提取: title, author, content, date, platform 等
- 若返回非 JSON（降级到纯文本模式），手动解析内容

**降级流程**:
```
agent-reach read <url> --json
  ↓ 失败
agent-reach read <url>        # 不带 --json
  ↓ 失败
defuddle <url>                # 降级到 defuddle
  ↓ 失败
WebFetch <url>                # 二次降级
  ↓ 失败
终止: "无法读取此 URL，请检查 agent-reach 安装"
```

**完成条件**: 获得非空的文本内容

---

## Phase 2: L1 元数据提取

**执行者**: AI 处理 Phase 1 的输出

**目标**: 构建 source note 的 YAML frontmatter

**提取规则**:

| 字段 | 提取方式 |
|------|----------|
| `type` | 固定值 `source` |
| `title` | 从 JSON 的 title 字段，或 AI 从内容生成 |
| `source_url` | 用户输入的 URL |
| `source_platform` | 从 URL 域名自动识别（参考 information-layers.md 的平台识别规则） |
| `author` | 从 JSON 的 author 字段，Twitter 为 @handle |
| `published_date` | 从 JSON 的 date 字段，无法获取则留空 |
| `ingested_date` | 当天日期 |
| `tags` | AI 从内容中提取 3-5 个关键标签 |
| `language` | AI 检测内容语言：`en` / `zh` |
| `content_type` | AI 判断内容类型：article/thread/video/repo/discussion/post/paper |

**标签提取规则**:
- 提取 3-5 个最能代表内容主题的关键词
- 优先使用已有 Atom 笔记的标签（保持标签体系一致）
- 用英文小写，用 `-` 连接多词标签（如 `tool-use`）
- 不加 `#` 前缀（Obsidian frontmatter 格式）

**slug 生成规则**:
- 从 title 提取 3-5 个英文关键词
- kebab-case 连接，全小写
- 去掉标点和特殊字符
- 最长 50 字符
- 中文标题: AI 翻译为英文关键词后生成 slug

**完成条件**: 所有必填字段非空

---

## Phase 3: L2 摘要生成

**执行者**: AI 处理

**目标**: 生成 3-5 句话的核心摘要

**规则**:
1. 总字数 ≤ 200 字（中文）/ 150 words（英文）
2. 跟随原文语言（英文内容用英文写摘要）
3. 必须包含三要素:
   - 主要论点: 这篇内容的核心主张
   - 关键证据: 支撑论点的数据/案例/推理
   - 结论/启示: 对读者意味着什么
4. 不得使用 "这篇文章讲了..." 的元叙述句式
5. 语气客观，不加个人评价

**输出**: 写入 source note 的 `## Summary` 和 `## Key Points` 部分

---

## Phase 4: L3 原子概念拆解

**执行者**: AI 处理

**目标**: 从内容中拆解出 1-5 个独立的原子概念

**拆解判断标准**:

| 信号 | 是否创建 Atom | 示例 |
|------|-------------|------|
| 新术语（知识库中无对应笔记） | ✅ 创建 | `Model Context Protocol` |
| 新框架/模型 | ✅ 创建 | `STEPPS 传播力模型` |
| 有引用价值的新数据 | ✅ 创建 | `70km/decade 物种迁移速度` |
| 反直觉的新洞察 | ✅ 创建 | `工具可靠性 > 工具数量` |
| 已有笔记的补充信息 | ⚠️ 更新已有 Atom | 给已有 Atom 追加新来源 |
| 常识性/无新意的内容 | ❌ 不创建 | `AI 很有前途` |

**创建流程**:
```
对每个识别出的概念:
  1. 检查 40-Atoms/ 是否已有同名或语义相同的笔记
     - 已有 → 考虑更新已有笔记（追加来源、补充描述）
     - 没有 → 创建新 Atom Note
  2. 文件名: 优先使用能直观表意的名称（允许中英混合，如 Context-Engineering-上下文工程.md）
  3. 正文: 用自己的话重述，≤ 500 字
  4. 添加 sources link: 回链到 source note
  5. 添加 tags: 用 concept/ 前缀
```

**完成条件**:
- 每个 Atom ≤ 500 字
- 有明确的单一概念
- 有 `sources` 回链
- 有足够上下文供 query 调用时能给出有意义的答案

---

## Phase 5: 关联与索引更新

**执行者**: AI 处理

**目标**: 将新笔记织入已有知识网络，更新去重索引

### 5.1 关联扫描

```
读取 40-Atoms/ 下所有笔记的文件名和 frontmatter tags
对每个新创建的 Atom:
  - 找到语义相关的已有 Atom（标题相似或标签重叠）
  - 在新 Atom 的 ## Related 中添加 [[wikilink]]
  - 可选: 在已有 Atom 中也追加反向 [[wikilink]]
```

**矛盾检测**:
```
IF 新 Atom 的观点与已有 Atom 矛盾:
  在 ## Related 中标记: [[已有概念]] ⚡ 矛盾点说明
  将已有 Atom 的 status 改为 conflict（如果原来是 active）
```

### 5.2 Source Note 回链

在 source note 的 `## Atoms` 部分列出所有生成的 Atom 链接:
```markdown
## Atoms

- [[concept-a]]
- [[concept-b]]
- [[concept-c]]
```

### 5.3 索引更新

更新 `_index/processed-urls.json`（新条目追加到 `urls` 数组末尾，不按批次分组）:

```json
{
  "version": "1.0",
  "urls": [
    {
      "url": "https://...",
      "platform": "web",
      "captured_at": "2026-03-01",
      "source_note": "00-Inbox/web-2026-03-01-slug.md",
      "atoms": [
        "40-Atoms/concept-a.md",
        "40-Atoms/concept-b.md"
      ]
    }
  ]
}
```

> 注：现有历史数据不迁移，仅新条目遵循此 schema。

---

## 完成条件（端到端）

- [ ] `00-Inbox/` 下生成了 source note，frontmatter 完整
- [ ] `## Summary` 非空，3-5 句话，≤ 200 字
- [ ] `## Key Points` 列出 2-5 个要点
- [ ] `40-Atoms/` 下生成了 1-5 个 atom notes
- [ ] 每个 atom 有 `sources` 回链、`tags`、`## Related`，≤ 500 字
- [ ] `_index/processed-urls.json` 已更新（新条目追加到 urls 数组末尾）
- [ ] 重复摄入同一 URL 会跳过

## 输出示例

**Source Note**: `00-Inbox/web-2026-03-01-mcp-protocol-announcement.md`

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
---

## Summary

Anthropic introduces Model Context Protocol (MCP), an open standard for LLM-tool
communication using client-server architecture over JSON-RPC. The protocol decouples
tool implementation from LLM providers, enabling reusable tool servers. With 20+
community implementations already available, MCP could become the de facto standard
for AI agent tool integration.

## Key Points

- MCP uses client-server architecture with JSON-RPC for LLM-tool communication
- Tools are exposed as typed schemas, enabling cross-provider compatibility
- 20+ community server implementations cover filesystems, databases, and APIs
- Open-source specification aims to prevent vendor lock-in

## Atoms

- [[model-context-protocol]]
- [[json-rpc]]
- [[tool-server]]

## Source

[Model Context Protocol](https://www.anthropic.com/news/model-context-protocol)
```
