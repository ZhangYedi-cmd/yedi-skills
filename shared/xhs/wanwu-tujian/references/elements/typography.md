# Typography 文字系统 — v3.3 九级精确层级

## 文字层级（9级 — v3.3 新增 L8 侧文 + L9 底部横幅）

| Level | 名称 | 粗细 | 颜色 | 特征 |
|-------|------|------|------|------|
| **L1** | 主标题 | Ultra-bold **毛笔书法体** | #3A2A1A | 带「」或""装饰符；粗细笔画变化、墨迹边缘；占顶部25-30%宽度 |
| **L2** | 副标题 | Medium 宋体 | #5C3D2E | 说明性短语，L1 下方一行 |
| **L3** | 英文行 | Small italic serif | #8B6914（最淡） | Dot-separated keywords |
| **L4** | 分区标题 | Bold + 边框容器 | #3A2A1A | 知识块标题，带底色块或边线 |
| **L5** | 标注标签 | 手写感细字 + 连线 | #5C3D2E | 博物馆式标注线连接主体各部位 |
| **L6** | 「」关键词标签 | Bold 水平行 | 朱砂红(#C0392B)边框/底色 | 水平排列3-6个标签 |
| **L7** | 引用/幽默框 | 楷体/斜体 + 红框 | #3A2A1A + 红色边框 | 圆角矩形红框，智慧语录或幽默点评 |
| **L8** | 竖排侧文 ★新 | 毛笔行书/楷书竖排 | #5C3D2E 或 淡墨 | 左右边距区竖排智慧金句/对联 |
| **L9** | 底部横幅条 ★新 | 宋体/楷体 + 装饰条 | #3A2A1A | 丝带/卷轴/出版条内的文字 |

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

## 封面底部文字（v3.3 更新 — 三种变体）

封面底部支持三种样式，按主题选择：

### 变体 A：点号分隔属性列表（默认）
```
属性1 · 属性2 · 属性3 · 属性4 · 属性5
```
示例：`传承 · 瑰宝 · 匠心 · 千年 · 国风`

**Prompt 片段**：
```
Bottom area: dot-separated attribute list in small text — "[attr1] · [attr2] · [attr3] · [attr4]"
```

### 变体 B：丝带/卷轴横幅条（v3.3 新增）
装饰性丝带或卷轴条包裹文字，增加仪式感。
```
Decorative ribbon/scroll banner strip across the bottom containing text:
"[系列总称·精华描述]" — e.g., "第①至⑩步全收录·思维升级完整手册"
Vintage ribbon style with folded edges, warm parchment color with darker text.
```
适用：教程/步骤类（"全收录"类总结文案）

### 变体 C：出版社横幅条（v3.3 新增）
模拟实体出版物的版权条，增加"正式出版物"质感。
```
Bottom publication bar in decorative frame: "[系列名]·典藏版"
Small text below: "[编号] | [出版社名]" — e.g., "301015 | 中南丰出版社"
```
适用：正式文化/收藏类主题

### 变体 D：地支/符号横条（v3.3 新增）
横排展示特殊符号序列，配合印章装饰。
```
Bottom horizontal bar with evenly spaced characters in decorative frame:
"[字1] [字2] [字3] [字4]..." — e.g., "子 丑 寅 卯 辰 巳 午 未 申 酉 戌 亥"
Red square stamps flanking the bar at left and right ends.
```
适用：生肖/天干地支/分类编目类

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

## L8：竖排侧文（v3.3 新增）

画面左右边距区的竖排智慧金句或对联，增加文化仪式感。仅在 focal-radial 封面可选使用。

| 位置 | 内容类型 | 示例 |
|------|---------|------|
| 左侧竖排 | 经典名句/对联上联 | "道可道，非常道" "无为而治" |
| 右侧竖排 | 经典名句/对联下联 | "上善若水，厚德载物" "道法自然" |

**规则**：
- 字体：毛笔行书或楷书，竖排从上到下
- 颜色：#5C3D2E（棕墨）或淡墨色，不抢主画面
- 位置：紧贴外框线内侧，或在外框线与画布边缘之间
- 两侧可只用一侧，或左右各一

**Prompt 片段**：
```
SIDE VERTICAL TEXT (optional):
Left margin: vertical brush calligraphy reading top-to-bottom — "[左侧金句]"
Right margin: vertical brush calligraphy reading top-to-bottom — "[右侧金句]"
In sepia brown (#5C3D2E), subtle — NOT competing with the main illustration.
```

---

## L9：底部横幅条（v3.3 新增）

见"封面底部文字"部分的变体 B/C/D。

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
