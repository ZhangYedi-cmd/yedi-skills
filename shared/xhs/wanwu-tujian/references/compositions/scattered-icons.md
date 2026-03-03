# 散点图标式（Scattered Icons）

抽象哲理、品质清单、人生准则。

> **源自博文**：人生十则、家庭十要、做人十不要
> **核心视觉**：概念图标自然散布于画面，无严格网格

## 核心视觉描述
- 多个（8-12个）概念图标以自然、松散的方式散布于画面
- 每个图标代表一个抽象概念，配简短中文标签
- 图标风格：手绘线条感，中国传统意象（如莲花代表品德、书卷代表学识）
- 无严格网格或对齐，有机排布形成呼吸感
- 中央可放置核心主题词或主视觉
- 留白充足，每个图标周围有足够空间
- 底部或角落放置金句/点评框

## Elements 配置
```yaml
layout: center-radial | grid-surround
annotations: concept-labels, hand-drawn-icons
decorations: [red-square-stamps, scattered-icons, gold-frame-quote-box]
illustration_style: Chinese symbolic icons, organic scatter layout
info_density: medium-high
```

## Prompt 片段（封面）
```
Chinese traditional encyclopedia illustration on aged xuan paper. Scattered
arrangement of [N] symbolic hand-drawn icons representing abstract concepts,
organically placed across the page without strict grid alignment. Each icon
with a Chinese label nearby. Central large bold title「[标题]」. Red square
corner stamps. Icons include: [图标列表，如 lotus for virtue, scales for
justice, book for wisdom]. Warm muted background with subtle paper texture.
English subtitle below title.
```

## Prompt 片段（内容页）
```
Chinese traditional encyclopedia illustration: scattered concept page.
[N] hand-drawn Chinese symbolic icons scattered organically across aged
xuan paper. Each icon represents one concept:
  [概念1]: [图标描述] + Chinese label "[标签]"
  [概念2]: [图标描述] + Chinese label "[标签]"
  [概念3]: [图标描述] + Chinese label "[标签]"
Red square stamps at corners. Large title "[核心词]" at top.
Bottom: bordered wisdom quote box "[金句]" in italic calligraphy style.
Credit "作者：@知渡" at very bottom.
```

## 适用主题
人生哲理、品德修养、家风家训、抽象准则

## 内容信号词
人生、哲理、道理、准则、十则、要义、品质、修养

## Style Variant Adaptations（风格适配）

| 风格变体 | 适配调整 |
|---------|---------|
| **realistic-portrait** | 图标→写实物品/自然元素（如真实莲花、真实书卷）；自然光照渲染每个物品；细腻纹理 |
| **traditional-encyclopedia** | 默认风格，无需调整。使用原始 Prompt 片段 |

## 示例
「人生十则」「家庭十要」「做人十不要」「君子九思」「古人的处世智慧」
