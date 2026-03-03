# 九宫格/拼贴式（Grid Collage）

合集并列、文化大全、民俗习俗。

> **源自博文**：民俗习俗大全、十大国粹、中国传统节日
> **核心视觉**：3×3 或 2×3 知识卡片网格，每格独立成章

## 核心视觉描述
- 画面分为 3×3（9格）或 2×3（6格）等均匀网格
- 每格是一个独立的知识卡片，包含：图标/插画 + 标题 + 简介
- 网格之间有统一的分隔线或边框
- 每个卡片风格统一（同色系、同版式），但内容各异
- 封面可用全画面展示所有卡片概览
- 内容页可放大单个卡片深入解析
- 整体像一张精美的知识海报/博物馆展板

## Elements 配置
```yaml
layout: grid-surround
annotations: classification-labels, card-titles
decorations: [red-square-stamps, grid-borders, category-ribbons, uniform-cards]
illustration_style: Chinese traditional mini-illustrations per grid cell
info_density: very-high
```

## Prompt 片段（封面）
```
Chinese traditional encyclopedia illustration on aged xuan paper. A 3×3 grid
of knowledge cards, each cell containing a small Chinese illustration and
Chinese title for one [subject category]. Uniform card design with thin
border lines. Large bold title「[标题]」at top spanning full width. Red square
corner stamps. Each card: [小插画] + 「[名称]」+ brief Chinese description.
Warm muted paper background. English subtitle below main title.
```

## Prompt 片段（内容页）
```
Chinese traditional encyclopedia illustration: knowledge grid page.
[N] knowledge cards arranged in [rows × cols] grid on aged xuan paper.
Each card contains:
  Card [n]: small illustration of [内容] + title「[名称]」+ 1-2 line description
All cards share uniform border style and card dimensions.
Red square stamps at corners. Page title "[类别]" at top.
Bottom: category summary or golden rule box.
Credit "作者：@知渡" at very bottom.
```

## 适用主题
文化大全、民俗合集、并列知识、分类展示、国粹/非遗

## 内容信号词
合集、国粹、民俗、习俗、文化、大全、传统、非遗

## Style Variant Adaptations（风格适配）

| 风格变体 | 适配调整 |
|---------|---------|
| **realistic-portrait** | 每格→写实主体特写+品种名称；卡片边框简洁；自然光照统一渲染 |
| **traditional-encyclopedia** | 默认风格，无需调整。使用原始 Prompt 片段 |

## 示例
「中国十大国粹」「传统节日大全」「各地民俗习俗」「中华老字号合集」「非遗技艺图鉴」
