# 信息图表式（Infographic）

步骤流程、教程指南、操作方法。

> **源自博文**：化妆教程、正确去黑头的五个步骤、手冲咖啡图解
> **核心视觉**：步骤编号流程 + 左右分栏信息排布

## 核心视觉描述
- 步骤以 ①②③④⑤ 编号，垂直或水平排列
- 每个步骤配场景小图 + 简短文字说明
- 箭头/虚线连接各步骤，建立视觉流程感
- 左右分栏可选：左图右文 或 左文右图
- 中心主体可做动态姿态（展示动作过程）
- 材料/工具面板置于角落

## Elements 配置
```yaml
layout: sequential | knowledge-split
annotations: numbered-steps, trajectory-paths
data_viz: [timeline, trigger-conditions, materials-panel]
decorations: [numbered-circles, arrows, stage-vignettes, red-square-stamps]
figures: traditional-chinese-figures-in-action
info_density: high
```

## Prompt 片段（封面）
```
Chinese traditional encyclopedia illustration on aged xuan paper. Central theme:
[subject] shown as a comprehensive visual guide. Multiple step illustrations
arranged around a central figure. Large bold Chinese title「[标题]」at top.
Red square corner stamps. Each step has a circled number ① ② ③ with brief
Chinese description. English subtitle below title. Ink-wash corner decorations.
```

## Prompt 片段（内容页）
```
Chinese traditional encyclopedia illustration: step-by-step infographic layout.
Central [subject] in dynamic action pose with numbered (①②③) dotted-line
trajectory paths showing the process stages. Scene vignettes at each step:
  Step ①: [描述] — illustration + label
  Step ②: [描述] — illustration + label
  Step ③: [描述] — illustration + label
Red square stamps at corners. Large bold title "[核心词]" at top.
Materials/tools panel in bottom corner with labeled items.
Bottom: summary box with key tips.
Credit "作者：@知渡" at very bottom.
```

## 适用主题
制作教程、美妆步骤、烹饪流程、养护指南、操作方法

## 内容信号词
步骤、教程、怎么做、流程、指南、方法、做法、攻略

## Style Variant Adaptations（风格适配）

| 风格变体 | 适配调整 |
|---------|---------|
| **realistic-portrait** | 步骤主体→高写实细节特写；每步配放大圆展示关键细节；自然光照；工具/材料面板写实渲染 |
| **traditional-encyclopedia** | 默认风格，无需调整。使用原始 Prompt 片段 |

## 示例
「正确去黑头的五个步骤」「手冲咖啡的七个步骤」「包饺子的科学」
「化妆新手入门教程」「中草药炮制流程图解」
