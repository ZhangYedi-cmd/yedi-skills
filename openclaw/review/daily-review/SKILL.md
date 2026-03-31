---
name: daily-review
description: >-
  当用户说"复盘"、"日复盘"、"周复盘"、"review"、"回顾一下"、
  "今天做了什么"、"这周总结"时使用此技能。
  读取 Notion 日记，生成结构化复盘报告并写回 Notion。
---

# Daily Review（日复盘 + 周复盘）

读取 Notion 上的工作日报和生活学习日记，生成结构化复盘报告，写回 Notion 复盘页面。

## Inputs

- `type`（可选）：`daily` 或 `weekly`，默认自动判断
  - 用户说"周复盘"/"weekly" → `weekly`
  - 用户说"日复盘" → `daily`
  - 未明确 → 周日或周一默认 `weekly`，其他默认 `daily`
- `date`（可选）：指定日期，默认今天

## Process

### 0. Notion MCP 检查
如果 Notion MCP 工具不可用，提示用户先连接 Notion MCP，然后停止。

### 1. 判断复盘类型
根据用户触发词 + 当前星期判断 `daily` 或 `weekly`。

### 2. 读取 Notion 日记内容
使用 Notion fetch 工具读取两个日记页面（页面 ID 见 `references/workflows/notion-ops.md`）：
- 工作日报
- 生活学习日记

从页面内容中，按日期提取对应时间范围的条目：
- `daily`：当天条目
- `weekly`：本周一至今天的所有条目

**如果对应日期没有内容**，告知用户"今天/本周暂无日记记录"，停止。

### 3. 生成复盘报告
按对应模板生成报告：
- `daily` → `references/templates/daily-template.md`
- `weekly` → `references/templates/weekly-template.md`

生成要求：
- **提炼而非复制**：用自己的语言总结，不要照搬日记原文
- **有洞察力**：KPT 和模式识别要基于内容深度分析，不是泛泛而谈
- **反思提问要有针对性**：基于当天/本周的具体内容生成，不要问通用问题
- **日复盘无需「我的回应」**，周复盘保留「我的回应」留白

### 3.5 信息补给（按需）
当 Step 3 中识别到用户有技术困惑或方向模糊时：
1. 先用 `/knowledge-forge query` 查询知识库中是否已有相关知识
2. 如果知识库无相关内容，用 `/knowledge-forge ingest` 抓取最新的社区文章、推特讨论
3. 将调研结果整理为「信息补给」板块，附在复盘末尾
4. 抓取的内容会自动入库到知识锻造炉，持续积累

**不是每次都需要信息补给**——只在识别到明确困惑点时才触发。

### 4. 写入 Notion
复盘目标页面的定位和写入方式见 `references/workflows/notion-ops.md`。
- 首次使用：创建「复盘日记」顶级页面
- 后续使用：在页面末尾追加新条目

**写入前**先 fetch 目标页面，确认当天/当周的复盘不存在（避免重复生成）。
如果已存在，询问用户是否覆盖。

### 5. 通知用户
- 告知复盘报告已生成
- 周复盘：提醒用户打开 Notion 填写「我的回应」
- 附上页面链接

## Output

- Notion 复盘日记页面中新增一条复盘记录
- 返回：生成状态 + 页面链接
- 如有信息补给：附上调研到的关键信息摘要

## 依赖

| 依赖 | 用途 | 必须？ |
|------|------|--------|
| Notion MCP | 读写 Notion 页面 | 是 |
| knowledge-forge | 困惑点调研，抓取最新信息 | 否（按需触发） |
