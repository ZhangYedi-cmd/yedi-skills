# 群像集合式（Group Portrait）

品种展示、分类图鉴、大全合集。

> **源自博文**：猫鉴百种、犬种大全、十二星座图鉴
> **核心视觉**：中央大主体 + 周围 6-12 个小主体环绕排列

## 核心视觉描述
- 中央放置最具代表性的主体（最大尺寸，占画面 35-45%）
- 周围环绕 6-12 个次要主体，由内到外逐渐缩小
- 每个主体独立完整，配中文名称标签 + 标注线
- 封面用于全景汇总展示，内容页聚焦单一主体深度解析
- 排列风格：有机布局（非死板网格），类似博物馆标本板

## Elements 配置
```yaml
layout: center-radial (封面) | annotated / knowledge-split (内容页)
annotations: classification-labels, hand-written name-tags, annotation-lines
decorations: [red-square-stamps, ink-wash-corner, age-spots]
illustration_style: Chinese botanical/zoological illustration (中国本草/博物风)
info_density: high
```

## Prompt 片段（封面）
```
A vintage Chinese natural history plate depicting [N] distinct [subject] varieties
on aged xuan paper. Chinese encyclopedic illustration style (类《本草纲目》图鉴风格).
Each specimen drawn with fine-line ink contour and watercolor fill. Chinese name
labels with annotation lines. Central specimen largest and most detailed.
Red square corner stamps. Warm muted paper background with ink-wash corner decoration.
Large bold Chinese title「[标题]」at top center. English subtitle below.
```

## Prompt 片段（内容页）
```
Chinese traditional encyclopedia illustration: single [subject] specimen page.
Upper half: large detailed [specimen] illustration on aged xuan paper with [N]
annotation lines to Chinese labels. Red square stamps at corners.
Very large bold title "[核心词]" at top. Subtitle "[说明]" below.
Lower half: structured knowledge panels — [M] bordered boxes with ① ② ③
numbered items, each with brief Chinese description.
Bottom: summary box with key characteristics.
Credit "作者：@知渡" at very bottom.
```

## 植物类特别说明
植物类（毒花、兰花、草药等）插画要**提高饱和度**——翠绿、深紫、鲜红——
与底纸低饱和形成对比，这是博主植物系列的标志。
```
Botanical illustration: rich saturated colors for plants (vivid greens #4A7C59,
deep purples, bright reds) contrasting against the muted aged paper background.
Fine detailed botanical linework with watercolor fills.
```

## 动物类特别说明
动物类与人物结合，常有人与动物的互动场景小图。

## 适用主题
品种图鉴、分类百科、动植物大全、星座/生肖合集、家族谱系

## Style Variant Adaptations（风格适配）

| 风格变体 | 适配调整 |
|---------|---------|
| **cartoon-infographic** | 主体→Q版角色，每个有专属主题色；环绕排列加入成就徽章和漫画条；背景更亮更鲜艳；信息密度提升至 EXTREME |
| **celestial-narrative** | 主体→仙人/神圣形象，飘逸彩色长袍；金光粒子环绕；背景为天界渐变色而非宣纸；光效为 divine-golden |
| **realistic-portrait** | 主体→高写实度动植物，细腻纹理毛发；自然侧光+柔和阴影；标注线+品种信息卡；背景保持暖中性色 |
| **traditional-encyclopedia** | 默认风格，无需调整。使用原始 Prompt 片段 |

## 示例
「古籍植物图鉴·毒花大全」「中华田园猫鉴百种」「家犬品种大全」「中国名花图鉴」「十二星座性格图鉴」
