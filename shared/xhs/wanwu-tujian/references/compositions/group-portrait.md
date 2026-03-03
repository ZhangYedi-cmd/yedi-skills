# 群像集合式（Group Portrait） — v3.0

品种展示、分类图鉴、大全合集、文化国粹合集。

> **源自博文**：猫鉴百种、犬种大全、十二星座图鉴、中国十大国粹
> **核心视觉**：中央大主体 + 周围 6-12 个小主体环绕排列
> **v3.0 新增**：吸收 grid-collage 网格拼贴作为子模式；新增 dense-cluster 封面模式

## 核心视觉描述

- 中央放置最具代表性的主体（最大尺寸，占画面 35-45%）
- 周围环绕 6-12 个次要主体，由内到外逐渐缩小
- 每个主体独立完整，配中文名称标签 + 标注线
- 封面用于全景汇总展示，内容页聚焦单一主体深度解析
- 排列风格：有机布局（非死板网格），类似博物馆标本板

## 子模式

### 子模式 A: organic-spread（默认，内容页）
有机散布，主体自然排列，中心最大，向外渐小。

### 子模式 B: dense-cluster（封面专用，v3.1）
密集簇拥，主体叠压，铺满画布，锚定人物/主体占据一侧。
详见 `layouts/portrait-layouts.md` dense-cluster 模式。

### 子模式 C: grid-panel（吸收自 grid-collage，适合并列等大主体）
网格式排列，3×N 格子，每格等大，适合"十大"/"九大"等并列主题。
```
Grid of [N] equal panels, each containing one [subject] with title and brief
description. Clean borders between panels. Overall title at top.
Red stamp decorations at corners and between panels.
```

## Elements 配置

```yaml
layout: organic-poster (内容页) | dense-cluster (封面)
annotations: classification-labels, hand-written name-tags, annotation-lines
decorations: [red-corner-stamps×2, scattered-stamps×2-3, ink-wash-corner, scattered-elements]
illustration_style: Chinese botanical/zoological illustration (中国本草/博物风)
realism_level: 75-80% (文化合集) | 80-85% (动植物品种)
info_density: high
```

## Prompt 片段（封面 — dense-cluster 模式）

```
Chinese traditional encyclopedia illustration.
[realism_level]% photorealism with [100-realism_level]% hand-painted artistic warmth.
DENSELY PACKED filling the entire canvas edge to edge. Minimal white space.
Tightly clustered, overlapping subjects creating tapestry-like richness.

[Anchor figure/subject] occupying the ENTIRE LEFT SIDE vertically — the LARGEST
element in the composition.

Surrounding: [N] additional [subjects] tightly clustered around the anchor,
overlapping each other. Each labeled with Chinese name.

Loose [scattered elements appropriate to theme] filling remaining gaps.
Faint [background silhouettes] in atmospheric ink wash behind subjects.

Title in BOLD BRUSH CALLIGRAPHY STYLE (毛笔书法字体) at top: "[标题]".
Red square stamps: top-left「[系列标签]」, top-right「[主题词]」.
Additional red seal stamps scattered: 「[印章1]」near [位置], 「[印章2]」near [位置].
Bottom: dot-separated list "[attr1] · [attr2] · [attr3]".
Credit: 作者：@知渡.

Clean warm cream paper (#F5EED8). NOT anime, NOT cartoon, NOT isolated museum
specimens, NOT grid layout, NOT photorealistic CGI.
```

## Prompt 片段（内容页）

```
Chinese traditional encyclopedia illustration on clean warm cream paper (#F5EED8).
[realism_level]% photorealism with [100-realism_level]% hand-painted artistic warmth.
Single [subject] specimen page — large detailed [specimen] illustration with [N]
annotation lines to Chinese labels.
Red square stamps at corners. Brush calligraphy title "[核心词]" at top.
Subtitle "[说明]" below. Knowledge panels lower half — [M] bordered boxes with
① ② ③ numbered items.
Bottom: summary box with key characteristics.
Credit: 作者：@知渡.
```

## 植物类特别说明

植物类（毒花、兰花、草药等）插画要**提高饱和度**：
```
Botanical illustration: rich saturated colors for plants (vivid greens #4A7C59,
deep purples, bright reds) contrasting against the clean cream paper background.
Fine detailed botanical linework with watercolor fills.
```

## 动物类特别说明

动物类与人物结合，常有人与动物的互动场景小图。

## 适用主题

品种图鉴、分类百科、动植物大全、星座/生肖合集、家族谱系、文化国粹合集

## Style Variant Adaptations（风格适配）

| 风格变体 | 适配调整 |
|---------|---------|
| **realistic-portrait** | 主体→高写实博物插画，精细纹理毛发；自然侧光+柔和阴影；标注线+品种信息卡；散落元素；金属闪光 |
| **traditional-encyclopedia** | 默认风格，使用上方 Prompt 片段。封面使用 dense-cluster 子模式。 |

## 示例

「古籍植物图鉴·毒花大全」「中华田园猫鉴百种」「家犬品种大全」「中国名花图鉴」
「十二星座性格图鉴」「中国十大国粹」「非遗技艺大全」「传统节日大全」
