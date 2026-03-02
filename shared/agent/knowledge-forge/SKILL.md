---
name: knowledge-forge
description: >
  AI 第二大脑：知识锻造炉。将互联网信息通过 agent-reach 抓取，经三层加工
  （元数据→摘要→原子概念）存入 Obsidian Vault，自动织网关联，生成每日知识简报。
  与 agent-reach（信息获取）和 xhs-topic-miner（内容创作）形成完整知识流水线。
  当用户提到"知识库"、"知识管理"、"每日简报"、"信息抓取"、"帮我学习"、
  "knowledge base"、"daily brief"、"ingest"、"知识锻造"时使用此技能。
---

# 知识锻造炉 Knowledge Forge

将「信息矿石」冶炼成「知识金属」。

## Usage

```bash
/knowledge-forge ingest <url>           # 单条 URL 精读入库
/knowledge-forge ingest <url1> <url2>   # 批量 URL
/knowledge-forge ingest --file urls.txt # 从文件读取 URL 列表

/knowledge-forge brief                  # 今日日报（默认）
/knowledge-forge brief --period weekly  # 本周周报
/knowledge-forge brief --focus "topic"  # 特定主题简报

/knowledge-forge query "问题"           # 自然语言查询知识库
```

## 前置条件速查

| 命令 | 硬前置条件（缺一不可） | 缺失时行为 |
|------|--------------------|------------|
| `ingest` | agent-reach 可用 | 降级：用 defuddle 或 WebFetch 读取 |
| `brief` | `60-Briefs/` 或 `40-Atoms/` 中有笔记 | 提示先 ingest 内容 |
| `query` | `40-Atoms/` 中有笔记 | 提示先积累知识 |

补充规则：
- `ingest` 是最基础命令，几乎无阻塞条件。
- `brief` 在库中无内容时无法生成，会引导用户先 `ingest`。

## 核心理念：三层信息加工

```
原始信息 ──→ L1 元数据 ──→ L2 摘要 ──→ L3 原子概念
              "这是什么"    "说了什么"    "意味着什么"
```

参考 `references/frameworks/information-layers.md`

| 层级 | 产出 | 存储位置 | 质量标准 |
|------|------|---------|---------|
| L1 元数据 | YAML frontmatter | 00-Inbox/ source note | 字段完整，可检索 |
| L2 摘要 | 3-5 句话 ≤ 200 字 | source note ## Summary | 读完能判断是否值得深读 |
| L3 原子概念 | 每概念一个笔记 ≤ 500 字 | 40-Atoms/ | 有足够上下文供 query 调用时能给出有意义的答案 |

## 笔记语言规则

**跟随原文语言**：英文来源产出英文笔记，中文来源产出中文笔记。frontmatter 的 `language` 字段标记语言。

## 核心工作流

### Step 1: 信息摄入（`ingest`）

参考 `references/workflows/ingest-workflow.md`

```
输入：URL（任意平台）
工具：agent-reach read <url> --json
流程：
  Phase 1 内容获取：agent-reach read → 结构化内容
  Phase 2 L1 元数据：提取来源、作者、日期、自动标签
  Phase 3 L2 摘要：3-5 句话提炼核心观点
  Phase 4 L3 原子概念：拆解为 1-5 个独立概念笔记
  Phase 5 去重与关联：检查 processed-urls.json，扫描已有笔记添加 [[wikilinks]]
输出：
  00-Inbox/{platform}-{date}-{slug}.md    Source Note
  40-Atoms/{concept-name}.md              Atom Notes（1-5 个）
  _index/processed-urls.json              更新去重索引
```

**降级策略**：
- agent-reach 不可用时 → 尝试 defuddle
- defuddle 不可用时 → 尝试 WebFetch
- 全部不可用 → 提示用户检查工具安装

### Step 2: 知识简报（`brief`）

参考 `references/workflows/brief-workflow.md`

```
输入：无（自动扫描最近笔记）
流程：
  Phase 1 数据扫描：扫描过去 24h/7d 的新增笔记
  Phase 2 统计汇总：摄入数、新概念数、高频标签
  Phase 3 精选推荐：选出最值得深读的 3-5 条
  Phase 5 生成简报：写入 60-Briefs/daily/ 或 weekly/
输出：
  60-Briefs/daily/{YYYY-MM-DD}.md     日报
  60-Briefs/weekly/{YYYY-MM-DD}.md    周报（--period weekly）
```

### Step 3: 知识查询（`query`）

参考 `references/workflows/query-workflow.md`

```
输入：自然语言问题
流程：
  Phase 1 关键词提取：从问题提取 2-4 个搜索词
  Phase 2 文件扫描：glob/grep 40-Atoms/ 和 00-Inbox/
  Phase 3 相关性排序：优先 Atom 笔记，其次 Source Note 摘要
  Phase 4 综合回答：自然语言回答，附 [[wikilink]] 引用
  Phase 5 来源追溯：列出引用的笔记路径
输出：带引用的自然语言回答
```

## Vault 结构

参考 `references/config/vault-schema.md`

```
~/Documents/Knowledge Forge/
├── 00-Inbox/      # Agent 写入的 source notes
├── 40-Atoms/      # 原子概念笔记
├── 60-Briefs/     # 知识简报
│   ├── daily/
│   └── weekly/
├── _index/        # 元数据索引（processed-urls.json）
└── _config/       # 配置（当前空置，留存备用）
```

## 笔记 Schema

参考 `references/config/note-schema.md`

4 种笔记类型：Source Note（来源笔记）、Atom Note（原子概念）、Daily Brief（日报）、Weekly Brief（周报）。

## 进度追踪格式

```
知识锻造 进度：
- [ ] Step 1: 读取内容 (agent-reach read)
- [ ] Step 2: L1 元数据提取
- [ ] Step 3: L2 摘要生成
- [ ] Step 4: L3 原子概念拆解
- [ ] Step 5: 关联已有笔记
- [ ] Step 6: 写入 Vault
```

## 与其他技能的衔接

```
agent-reach (眼：搜索/阅读)
    ↓
knowledge-forge (脑：摄入/加工/关联/简报)
    ↓                              ↓
brief → 用户阅读 5min          xhs-topic-miner → retro-enc → 发布
                                   ↑
                              知识库提供内容弹药
```

**联动场景**：
- knowledge-forge 发现某 AI 话题连续升温（🔥trending）→ 建议 xhs-topic-miner 评估选题潜力
- 用户的知识库成为内容创作的弹药库，每篇图鉴都有知识支撑

## 依赖

| 依赖 | 工具 | 用途 | 必须？ |
|------|------|------|--------|
| agent-reach | `read <url>` | 读取任意 URL 内容 | 是（有降级） |
| obsidian-markdown | — | Obsidian 笔记格式规范 | 参考用 |
| defuddle | — | 降级时的网页提取 | 否（降级备选） |
| xhs-topic-miner | — | 下游内容创作对接 | 否 |

## 方法论基础

| 模块 | 理论来源 | 文件 |
|------|----------|------|
| 信息加工 | 三层加工模型（L1/L2/L3） | `references/frameworks/information-layers.md` |
| 笔记方法 | Zettelkasten（Luhmann） | `references/config/note-schema.md` |
| 摄入流程 | 五阶段工作流 | `references/workflows/ingest-workflow.md` |
| 简报生成 | 知识蒸馏 + 趋势检测 | `references/workflows/brief-workflow.md` |
| 查询流程 | 关键词扫描 + 语义综合 | `references/workflows/query-workflow.md` |

## 关键设计决策

### 为什么 Source Note + Atom Note 分离？
- Source Note 是「别人说的」（可能过时、有偏见、有立场）
- Atom Note 是「我理解的」（提炼后的知识，可独立存在）
- 同一个概念可能来自多个 source，atom 做合并和演化

### 为什么用 processed-urls.json 而不是数据库？
- JSON 文件可 git 版本控制
- 对 Agent 读写最简单（无需安装额外依赖）
- 规模在几万条内性能足够
- 未来可迁移到 SQLite

### 为什么笔记语言跟随原文？
- 保留原文术语的精确性（如 "Model Context Protocol" 翻译损失信息）
- 混合语言搜索在 Obsidian 中表现良好
- 避免翻译引入的理解偏差

### 未来扩展
patrol（定期主动巡逻信息源）当 Phase 1 积累足够数据后再评估。
