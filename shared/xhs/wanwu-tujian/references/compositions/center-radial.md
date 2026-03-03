# 中心辐射式（Center Radial） — v3.0

规则拆解、行为分析、哲理智慧、方法论、抽象概念清单。

> **源自博文**：积累福报的六种行为、人有九不争、八大天规
> **核心视觉**：中央核心概念 + 放射状排列的子元素
> **互动数据**：博主所有构图中**互动量最高**的类型
> **v3.0 新增**：吸收 scattered-icons 散点图标式作为子模式

## 核心视觉描述

- 中央放置核心主题情景插画（中国古代人物场景），占画面 40-50%
- 围绕中心向外辐射 4-8 个子概念/规则
- 每个子概念配独立知识框 + 编号（①②③④）
- 上半部：主题情景插画 + 标注线
- 下半部：**结构化知识图解叠层**（知识框、对比场景、步骤图）
- 左上/右上角：红色方块角标（系列标签 + 主题词）
- 底部：总结/点评框，楷体引用风（L7）

## 子模式

### 子模式 A: radial（默认，规则/方法/哲理）
中央核心人物/概念，周围辐射散布知识块。

### 子模式 B: scattered-concept（吸收自 scattered-icons，抽象哲理/品质清单）
无严格中心，概念图标自然散布于画面：
```
Multiple concept illustrations scattered organically across the canvas.
Each concept has: small iconic illustration + bold Chinese character label +
brief annotation. No rigid center — composition feels like a wisdom constellation.
Connected by subtle flowing lines or left as floating islands.
```
适用：抽象哲理概念、品质清单、星座特质、无具体人物场景的主题。
写实度：70-75%（figurative, expressive rather than photorealistic）

## Elements 配置

```yaml
layout: organic-poster
annotations: thin-line-labels (4-8), comparison-scenes (✓✗)
knowledge_blocks: [四层意义, 步骤框, 工具图解, 智慧点评]
decorations: [red-corner-stamps×2, scattered-stamps×2-3, knowledge-boxes, numbered-①②③, checkmarks, L7-quote-box]
figures: traditional-chinese-figures, historical-narrative-scenes
realism_level: 70-75%
info_density: very-high
```

## Prompt 片段（封面）

```
Chinese traditional encyclopedia illustration on clean warm cream paper (#F5EED8).
[realism_level]% photorealism with [100-realism_level]% hand-painted artistic warmth.
Central scene: multiple historical Chinese figures in robes, each associated with
one of the [N] principles — arranged in circular or grouped composition.
Fine-line ink contour with watercolor fills. Chinese name labels beside each
figure with thin annotation lines.
Title in BOLD BRUSH CALLIGRAPHY STYLE at top: "[标题]".
Red square stamps top-left「[左标]」and top-right「[右标]」.
Additional red seal stamps scattered: 「[印章1]」near figures.
Ink-wash mountain corner decorations.
```

## Prompt 片段（内容页）

```
Chinese traditional encyclopedia illustration: knowledge infographic layout on
clean warm cream paper (#F5EED8).
Upper 45%: [specific scene] — historical Chinese figures illustrating [principle],
with [N] annotation lines to Chinese labels. Red square stamps at corners.
Brush calligraphy title "[核心词]" at top. Subtitle "[说明]" below.
Lower 50%: structured knowledge panels — [M] bordered boxes with:
  Left section: [知识块1] with ① ② ③ ④ numbered items
  Center: ✗ wrong example illustration (left) vs ✓ correct example (right)
  Right section: [工具/要素] diagram with labeled parts
Bottom: red-bordered summary box "[智慧点评文字]" in italic style (L7).
Credit: 作者：@知渡.
```

## 适用主题

人生哲理、传统规则、行为准则、方法论、秘诀/要诀、抽象品质清单

## 内容信号词

规则、行为、方法、秘诀、X种、X个、天规、不争、福报、处世

## Style Variant Adaptations（风格适配）

| 风格变体 | 适配调整 |
|---------|---------|
| **realistic-portrait** | 中央→写实主体特写；辐射→标注线+品种/特征信息卡；底部→对比表+特征总结 |
| **traditional-encyclopedia** | 默认风格，无需调整。使用原始 Prompt 片段 |

## 示例

「积累福报的六种行为」「中国人的八大天规」「人有九不争」「修身九要」
「处理问题的10个思维」「道家处事之道」「人生铁律」
