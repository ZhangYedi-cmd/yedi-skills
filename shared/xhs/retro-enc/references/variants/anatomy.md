# 解剖标注（Anatomy）
行为分析、规则拆解、知识图解、传统智慧解读。

> **博主风格核心变体**：「八大天规」「修身九要」「人有九不争」系列均属此变体，
> 是博主最高互动量内容的主力风格。

## 核心视觉（对标万物图鉴内容页）
- 上半部：主题情景插画（中国古代人物场景）+ 标注线
- 下半部：**结构化知识图解叠层**（知识框、对比场景、步骤图）
- 左上/右上角：红色方块角标（系列标签 + 主题词）
- 顶部大标题：核心规则名称（超大黑体，2-4字）
- 底部：总结/点评框，楷体引用风

## Elements
```yaml
layout: annotated | knowledge-split
annotations: thin-line-labels (4-8), comparison-scenes (✓✗)
knowledge_blocks: [四层意义, 步骤框, 工具图解, 智慧点评]
decorations: [red-square-stamps, knowledge-boxes, numbered-①②③, checkmarks]
figures: traditional-chinese-figures, historical-narrative-scenes
```

## Prompt 片段（封面页）
```
Chinese traditional encyclopedia illustration on aged xuan paper. Central scene:
multiple historical Chinese figures in robes, each associated with one of the
[N] principles — arranged in circular or grouped composition. Fine-line ink
contour with watercolor fills. Chinese name labels beside each figure with
thin annotation lines. Large bold Chinese title at top: "[标题]". Red square
stamps top-left "[左标]" and top-right "[右标]". English subtitle in serif font.
Ink-wash mountain corner decorations. Warm muted background.
```

## Prompt 片段（内容页）
```
Chinese traditional encyclopedia illustration: knowledge infographic layout.
Upper 45%: [specific scene] — historical Chinese figures illustrating [principle],
with [N] annotation lines to Chinese labels. Red square stamps at corners.
Very large bold title "[核心词]" at top. Subtitle "[说明]" below. English line.
Lower 50%: structured knowledge panels — [M] bordered boxes with:
  Left section: [知识块1] with ① ② ③ ④ numbered items
  Center: ✗ wrong example illustration (left) vs ✓ correct example (right)
  Right section: [工具/要素] diagram with labeled parts
Bottom: bordered summary box "[智慧点评文字]" in italic style.
Credit "作者：@[署名]" at very bottom.
```

## 示例
「中国人的八大天规·师不顺路」「修身九要」「人有九不争」「处理问题的10个思维」
「人生铁律」「道家处事之道」「老祖宗九大风水宝地」
