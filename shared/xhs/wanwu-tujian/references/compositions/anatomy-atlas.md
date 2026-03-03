# 博物解剖式（Anatomy Atlas）

单品深度解析、结构分析、成分功效。

> **源自博文**：兰花品种鉴赏系列、五果为助、本草养生
> **核心视觉**：中央大主体 + 标注线 + 剖面/细节放大图

## 核心视觉描述
- 中央放置单一主体的精细插画（占画面 40-55%）
- 从主体各部位引出标注线，连接中文标签
- 周围配 2-4 个细节放大圆（虚线边框圆形放大镜效果）
- 可选剖面图/截面图展示内部结构
- 标注点 6-10 个，每个标注包含名称 + 简短说明
- 底部可放功效/特征总结框
- 高饱和自然色系（特别是植物/食材类）

## Elements 配置
```yaml
layout: annotated | knowledge-split | tri-panel
annotations: thin-line-labels (6-10), magnified-detail-insets (2-4)
data_viz: [cross-section-diagram, feature-comparison-table]
decorations: [red-square-stamps, annotation-lines, circular-detail-frames, ink-wash-corner]
illustration_style: Chinese botanical/medical atlas (本草/博物风)
info_density: high
```

## Prompt 片段（封面）
```
Chinese traditional botanical atlas illustration on aged xuan paper. Central
large detailed [subject] drawn in fine-line ink with rich watercolor fills.
[N] thin annotation lines extending from different parts to Chinese labels.
[M] circular magnified detail insets with dotted borders showing close-up
features. Large bold title「[标题]」at top. Red square corner stamps.
Warm background, rich saturated colors for the main subject contrasting
against muted paper. English subtitle below title.
```

## Prompt 片段（内容页）
```
Chinese traditional encyclopedia illustration: anatomy atlas page.
Central [subject] illustration (detailed, high saturation) on aged xuan paper.
Annotation system:
  Line 1 → "[部位1]": [说明]
  Line 2 → "[部位2]": [说明]
  Line 3 → "[部位3]": [说明]
Magnified detail circles: [detail 1 描述], [detail 2 描述]
Optional cross-section diagram showing internal structure.
Red square stamps at corners. Large title "[品名]" at top.
Bottom: efficacy/characteristic summary box with ① ② ③ items.
Credit "作者：@知渡" at very bottom.
```

## 植物/食材特别说明
植物和食材类主体使用**高饱和色彩**——翠绿叶片、鲜红果实、金黄花蕊——
与底纸低饱和形成强烈对比，这是博主此类内容的视觉标志。
```
Rich saturated botanical colors: vivid greens (#4A7C59), deep reds (#8B1A1A),
golden yellows (#D4A853) for the main subject. Detailed fine-line ink contours
with lush watercolor fills. Contrast against warm muted paper background.
```

## 适用主题
单品解析、植物/草药鉴赏、食材功效、器物结构、成分分析

## 内容信号词
解析、成分、结构、功效、本草、鉴赏、品种、养生

## Style Variant Adaptations（风格适配）

| 风格变体 | 适配调整 |
|---------|---------|
| **realistic-portrait** | 强化写实：主体细节极致，皮毛/花瓣纹理精细；放大圆展示微观结构；自然光+环境反射 |
| **traditional-encyclopedia** | 默认风格，无需调整。使用原始 Prompt 片段 |

## 示例
「兰花品种鉴赏」「五果为助·养生图解」「中草药本草图鉴」「茶叶品种解析」「传统器具结构图解」
