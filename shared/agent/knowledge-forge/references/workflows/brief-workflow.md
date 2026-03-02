# Brief 工作流

## 使用场景

生成知识简报，帮助用户在 5 分钟内消化当天/本周的知识库变化。
- **日报 (daily)**: 每天结束时运行，总结当日摄入的信息
- **周报 (weekly)**: 每周末运行，做趋势分析和知识地图更新
- **主题简报 (focus)**: 针对特定主题生成深度简报

## 触发命令

```bash
/knowledge-forge brief                           # 今日日报（默认）
/knowledge-forge brief --period weekly           # 本周周报
/knowledge-forge brief --focus "AI agent"        # 特定主题简报
```

## 依赖工具

| 工具 | 用途 | 必须？ |
|------|------|--------|
| 文件系统读取 | 扫描 00-Inbox/ 和 40-Atoms/ | 是 |
| `_index/processed-urls.json` | 统计数据 | 是 |

无外部依赖，纯本地处理。

## 前置条件

- `00-Inbox/` 或 `40-Atoms/` 中有笔记
- 如果库中无内容，提示: "知识库还是空的，先用 `/knowledge-forge ingest <url>` 摄入一些内容吧"

---

## Phase 1: 数据扫描

**执行者**: 读取文件系统

**目标**: 收集时间范围内的所有新增笔记

### Daily 模式

```
扫描 00-Inbox/ 下所有 .md 文件:
  读取 frontmatter.ingested_date
  过滤: ingested_date == 今天

扫描 40-Atoms/ 下所有 .md 文件:
  读取 frontmatter.created
  过滤: created == 今天
```

### Weekly 模式

```
同上，但过滤条件改为: 过去 7 天内
```

### Focus 模式

```
同 Daily/Weekly，但增加额外过滤:
  frontmatter.tags 包含 focus 关键词
  OR 文件名包含 focus 关键词
  OR 正文内容包含 focus 关键词
```

**完成条件**: 得到两个列表 — `today_sources[]` 和 `today_atoms[]`

---

## Phase 2: 统计汇总

**执行者**: AI 处理扫描结果

**目标**: 计算关键统计指标

**计算项**:

| 指标 | 计算方式 |
|------|----------|
| 摄入条数 | `len(today_sources)` |
| 新概念数 | `len(today_atoms)` |
| 新关联数 | 统计 today_atoms 中 `## Related` 的 [[wikilink]] 总数 |
| 高频标签 TOP 5 | 统计所有 today_sources + today_atoms 的 tags，取频率最高的 5 个 |
| 来源分布 | 按 source_platform 分组计数 |

**趋势检测** (简化版，Phase 2 将增强):
```
对高频标签:
  IF 某标签在过去 7 天内出现 ≥ 3 次:
    标记为 🔥 trending
```

**完成条件**: 所有统计指标计算完成

---

## Phase 3: 精选推荐

**执行者**: AI 分析 today_sources

**目标**: 选出最值得用户深读的 3-5 条 source notes

**选择标准** (按优先级排序):

1. **信息密度**: 产出 Atom 数量多的 source 优先（说明信息量大）
2. **关联强度**: 新 Atom 与已有知识关联多的 source 优先（说明与用户知识体系相关）
3. **来源权威**: 知名作者/机构的内容优先
4. **内容新颖度**: 包含 🔥 trending 标签的优先

**输出格式** (每条推荐):
```markdown
1. [[source-note-title]] — [一句话推荐理由，说明为什么值得读]
```

**推荐理由要求**:
- 不超过 30 字
- 说明「为什么值得你亲自读」而不是「内容是什么」
- 例: "可能成为 Agent 工具调用的事实标准" ✅
- 反例: "讲了 MCP 协议的设计" ❌

**完成条件**: 3-5 条带推荐理由的 source note 链接

---

## Phase 4: 知识图谱变化（Phase 2 解锁后启用）

**当前状态**: MVP 中跳过此 Phase

**Phase 2 实现后将包含**:
- 新增节点统计（哪些概念集群在增长）
- 跨集群连接（原本不相关的概念域产生连接）
- 孤岛笔记检测（没有任何 [[wikilink]] 的 Atom）
- 集群活跃度变化（哪些话题升温/降温）

---

## Phase 5: 生成简报

**执行者**: AI 组装最终简报

**目标**: 写入标准格式的简报文件

### Daily 输出

**文件路径**: `60-Briefs/daily/{YYYY-MM-DD}.md`

```markdown
---
type: brief
period: daily
date: {YYYY-MM-DD}
stats:
  ingested: {摄入条数}
  new_atoms: {新概念数}
  new_links: {新关联数}
tags:
  - brief/daily
---

## 今日一句话

[一句话总结今日最重要的发现。不超过 50 字。突出核心洞察而非罗列事实]

## 信息流概览

- 摄入: {X} 条 | 新概念: {Y} 个 | 新关联: {Z} 条
- 高频标签: #{tag1}, #{tag2}, #{tag3}, #{tag4}, #{tag5}
- 来源分布: {platform1} {n1} | {platform2} {n2} | ...
{IF trending}
- 🔥 趋势: {topic}（连续 {N} 天出现）
{ENDIF}

## 值得你花 5 分钟看的

1. [[{source-note-1}]] — {推荐理由}
2. [[{source-note-2}]] — {推荐理由}
3. [[{source-note-3}]] — {推荐理由}

## 新增原子概念

- [[{atom-1}]] — {一句话描述}
- [[{atom-2}]] — {一句话描述}
- ...
```

### Weekly 输出

**文件路径**: `60-Briefs/weekly/{YYYY-MM-DD}.md`（日期为该周周一）

在 Daily 基础上增加:
- `## 本周趋势`（升温/降温话题）
- `## 本周 TOP 5 原子概念`（按被引用次数排序）
- `## 知识图谱变化`（Phase 2 解锁后启用）
- `## 本周推荐深读 TOP 3`

### Focus 输出

**文件路径**: `60-Briefs/daily/{YYYY-MM-DD}-{focus-topic}.md`

结构同 Daily，但:
- 只包含与 focus 主题相关的内容
- `今日一句话` 聚焦于该主题
- 增加 `## 该主题知识进展` 部分

---

## 完成条件（端到端）

- [ ] 简报文件已生成到 `60-Briefs/` 对应目录
- [ ] frontmatter 完整（type, period, date, stats）
- [ ] `今日一句话` 非空，≤ 50 字
- [ ] `信息流概览` 包含统计数据
- [ ] `值得你花 5 分钟看的` 有 3-5 条推荐（库中内容足够时）
- [ ] `新增原子概念` 列出所有今日新增 Atom
- [ ] 所有 [[wikilink]] 指向实际存在的笔记

## 空库处理

如果时间范围内没有新增内容:

```markdown
---
type: brief
period: daily
date: {YYYY-MM-DD}
stats:
  ingested: 0
  new_atoms: 0
  new_links: 0
tags:
  - brief/daily
---

## 今日一句话

今天知识库没有新增内容。

## 建议

试试 `/knowledge-forge ingest <url>` 摄入一些感兴趣的内容，
或者配置 `_config/sources.yaml` 后运行 `/knowledge-forge patrol` 自动巡逻。
```
