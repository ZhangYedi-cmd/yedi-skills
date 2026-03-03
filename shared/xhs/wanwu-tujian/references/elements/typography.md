# Typography 文字系统 — v3.1 七级精确层级

## 文字层级（7级）

| Level | 名称 | 粗细 | 颜色 | 特征 |
|-------|------|------|------|------|
| **L1** | 主标题 | Ultra-bold **毛笔书法体** | #3A2A1A | 带「」或""装饰符；粗细笔画变化、墨迹边缘；占顶部25-30%宽度 |
| **L2** | 副标题 | Medium 宋体 | #5C3D2E | 说明性短语，L1 下方一行 |
| **L3** | 英文行 | Small italic serif | #8B6914（最淡） | Dot-separated keywords |
| **L4** | 分区标题 | Bold + 边框容器 | #3A2A1A | 知识块标题，带底色块或边线 |
| **L5** | 标注标签 | 手写感细字 + 连线 | #5C3D2E | 博物馆式标注线连接主体各部位 |
| **L6** | 「」关键词标签 | Bold 水平行 | 朱砂红(#C0392B)边框/底色 | 水平排列3-6个标签 |
| **L7** | 引用/幽默框 | 楷体/斜体 + 红框 | #3A2A1A + 红色边框 | 圆角矩形红框，智慧语录或幽默点评 |

---

## L1：毛笔书法标题（v3.1 新增）

L1 标题必须使用**毛笔书法字体风格（BRUSH CALLIGRAPHY STYLE）**，不是印刷黑体：

- 粗细笔画变化（thick and thin stroke variation）
- 墨迹边缘效果（ink bleeding edges）
- 飞白效果（dry brush strokes where appropriate）
- 有力的起笔和收笔（strong entry and exit strokes）

**Prompt 片段**：
```
Title in BOLD BRUSH CALLIGRAPHY STYLE (毛笔书法字体) — thick and thin stroke
variation, ink bleeding edges, powerful brush energy. NOT printed font, NOT
computer typeface, NOT sans-serif.
```

---

## 标题模板（封面页）

```
L1 主标题（毛笔书法，超大）：[核心词] 或 「[主题]」
L2 副标题（中等宋体）：[具体说明短语，如"中国传统八大天规之首"]
L3 英文行（小衬线斜体）：[English Theme] · [Type Keywords]
左上角印章（红色方块）：[系列类别，如"图鉴"]
右上角印章（红色方块）：[主题词，如"天规"]
```

---

## 标题模板（内容页）

```
左上角分类标签（红色方块）："天规第一" / "天规第二" ...
右上角主题词（红色方块）："匠人风骨" / "悬壶济世" ...
L1 主标题（毛笔书法，超大，占顶部30%）：核心规则名称（如"师不顺路"）
L2 副标题（中等宋体）：[规则说明，如"中国传统八大天规之首"]
L3 分类说明行：[属性标签]｜[属性标签]｜[属性标签]
```

---

## 封面底部文字（v3.1 更新）

封面底部**不使用「」标签**，改为**点号分隔属性列表**：

```
属性1 · 属性2 · 属性3 · 属性4 · 属性5
```

示例：`传承 · 瑰宝 · 匠心 · 千年 · 国风`

**Prompt 片段**：
```
Bottom area: dot-separated attribute list in small text — "[attr1] · [attr2] · [attr3] · [attr4]"
NOT individual「」tags, NOT boxed keywords.
```

---

## L6：「」关键词标签（v3.1 新增）

内容页主体下方水平排列 3-6 个关键词：

```
「慈悲」「结缘」「持戒」「修身」「传承」
```

**Prompt 片段**：
```
Row of keyword tags below main subject: 「[词1]」「[词2]」「[词3]」in horizontal
line, each with cinnabar red border (#C0392B), bold Chinese characters.
```

---

## L7：智慧/幽默框（v3.1 新增）

页面底部或角落的引用框，楷体斜体风格，朱砂红边框：

**Prompt 片段**：
```
Bottom wisdom quote box: rounded rectangle with cinnabar red border (#C0392B),
italic calligraphy-style Chinese text inside.
```

---

## 已废弃：伪拉丁学名

博主风格中**无任何西方伪拉丁学名**。用以下中式系统替代：
- 右上/左上角：红色方形角标印章（「图鉴」「天规」「宝地」「百科」等）
- 类别小徽章（「匠人风骨」「悬壶济世」等 2-4 字主题词）
- 页眉处可加：主题系列序号（天规 第一 / 天规 第二）

---

## Prompt 文字指令原则

直接在 prompt 中写出完整中文内容和位置。尽量让 AI 渲染关键文字，
尤其是大标题（L1 毛笔书法）和角标印章（这两个位置最容易被正确渲染）。
知识块内的细节文字注明位置即可，具体内容由后期处理补充。
