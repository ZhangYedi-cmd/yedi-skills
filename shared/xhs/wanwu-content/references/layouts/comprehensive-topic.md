# comprehensive-topic（全景专题式）

### 对标案例
- 武术（中国十大国粹·第二章）

### 核心定位
一个大主题的全方位知识图谱页。像"一张信息海报涵盖某领域的全貌"。

### 空间分区

```
┌──────────────────────────────────────────────────┐
│ [外框 + 角标印章]                                  │
│ ┌──────────────────────────────────────────────┐ │
│ │ [左栏标题]    「主标题」         [右栏标题]    │ │
│ │              副标题 · 英文                    │ │
│ │              系列名 第X章                     │ │
│ │                                               │ │
│ │ ┌─左栏──┐  ┌───中央英雄区───┐  ┌──右栏──┐  │ │
│ │ │时间线  │  │                │  │分类卡片 │  │ │
│ │ │/演化  │  │  2-4个英雄     │  │流派1   │  │ │
│ │ │       │  │  人物群像       │  │流派2   │  │ │
│ │ │时代1  │  │  （动态姿态）   │  │流派3   │  │ │
│ │ │ ↓    │  │                │  │       │  │ │
│ │ │时代2  │  │                │  │子主题A │  │ │
│ │ │ ↓    │  │                │  │子主题B │  │ │
│ │ │时代3  │  │                │  │       │  │ │
│ │ │ ↓    │  │                │  │       │  │ │
│ │ │时代4  │  │ [作者署名]     │  │       │  │ │
│ │ └──────┘  └────────────────┘  └───────┘  │ │
│ │                                               │ │
│ │ ┌──底部深潜区──────────────────────────────┐ │ │
│ │ │ [器物图录/工具展示]                        │ │ │
│ │ │ [哲学图解/阴阳太极]  [实践原则]  [评论框] │ │ │
│ │ └──────────────────────────────────────────┘ │ │
│ │                                               │ │
│ └──────────────────────────────────────────────┘ │
│ [底部印章条]                                       │
└──────────────────────────────────────────────────┘
```

### 模块槽位定义

| 槽位 | 位置 | 宽度 | 内容 |
|------|------|------|------|
| **标题区** | 顶部居中 | 100% | 主标题 + 副标题·英文 + 系列章节 |
| **左栏** | 左侧 | 20-22% | 时间线/演化维度（4-6个时代） |
| **中央英雄区** | 中间 | 40-50% | 2-4个英雄人物群像 |
| **右栏** | 右侧 | 22-25% | 分类/流派（4-6个卡片）+ 子主题 |
| **底部深潜区** | 底部 | 100% | 器物图录 + 哲学图解 + 原则 + 评论 |
| **底部印章条** | 最底部 | 100% | 印章 + 标志 |

### 左栏时间线结构

```
Origin & Evolution

原始社会 ─── [小插图：原始格斗]
    │
    ↓
春秋 ─────── [小插图：剑术]
    │
    ↓
秦汉 ─────── [小插图：角抵]
    │
    ↓
唐宋 ─────── [小插图：武举]
    │
    ↓
明清 ─────── [小插图：百家争鸣]
    │
    ↓
近代 ─────── [小插图：李小龙]
```

- 垂直时间线，用线段+箭头连接
- 每个节点：时代名称 + 小插图 + 简短说明
- 红色圆点标记每个时代节点
- 时间线可以用中英文双语标注

### 右栏分类卡片结构

```
Major Schools × Culture

┌─────────┐  ┌─────────┐
│ [少林]   │  │ [太极]   │
│  武僧图  │  │  太极图  │
│少林·刚猛 │  │太极·柔和 │
└─────────┘  └─────────┘
┌─────────┐  ┌─────────┐
│ [峨眉]   │  │ [形意]   │
│  女侠图  │  │  形意图  │
│峨眉·轻灵 │  │形意·整劲 │
└─────────┘  └─────────┘
```

- 2×2 或 2×3 网格排列
- 每个卡片有淡边框/装饰框（可以是卷轴/画框样式）
- 内含小人物图 + 流派名 + 2-4字特征标签

### 中央英雄区要求

- 2-4 个代表性人物，大尺寸
- 有明确的主次关系（中央最大，两侧稍小）
- 每个人物有标注名称 + 身份/贡献
- 动态动作：出拳、挥剑、施展招式
- 可以有光圈/气场等强调效果
- 人物之间可以有互动关系

### 底部深潜区结构

```
┌──────────────────────────────────────────────────────┐
│ [器物图录]                                             │
│ 刀 枪 剑 戟 斧 钺 钩 叉 镗 镖 架 棍 矛 盾 琴 索      │
│ [每个武器的小插图一字排开]                              │
│                                                        │
│ ┌──哲学图解──┐  ┌──实践原则──┐  ┌──趣味评论───┐      │
│ │ [阴阳太极]  │  │ ✓ 练形    │  │ 武术：中国   │      │
│ │ 刚柔并济    │  │ ✓ 练气    │  │ 唯一让打人   │      │
│ │ 内外兼修    │  │ ✓ 练神    │  │ 还能称为...  │      │
│ │ 动静结合    │  │ ✓ 化境    │  │              │      │
│ └────────────┘  └───────────┘  └──────────────┘      │
└──────────────────────────────────────────────────────┘
```

- 器物图录：一排小插图 + 下方名称标注
- 哲学图解：太极/阴阳图 + 关键概念对
- 实践原则：✓ 列表
- 趣味评论框：仿古告示牌样式的幽默短评

### Prompt 片段

```
A highly detailed retro Chinese encyclopedia comprehensive topic page illustration.
Orientation: portrait. Aspect ratio: 3:4 (1792×2400px).
Style: polished digital illustration, 85-90% realism, silky-smooth rendering.

BACKGROUND:
Aged warm parchment paper base (#E8D5B0 to #F5E6C8), subtle fiber texture.
Light tea-stain patches 15-20% opacity. Gentle vignette.

DOUBLE BORDER FRAME SYSTEM:
Outer frame at ~3%, inner frame at ~7-8%, cloud-scroll corner ornaments.

TITLE BLOCK (top center):
L1: "「{主标题}」" in bold brush calligraphy, #3A2A1A.
L2: "{副标题} · {English Title}" below L1, #5C3D2E.
L3: "{系列名} 第{N}章" small text below L2.
AUTHOR: "作者：知渡" in red #C0392B.

LEFT COLUMN — Timeline/Evolution (20-22% width):
Section header: "{时间线标题}"
Vertical timeline with red dot markers and connecting lines:

ERA 1 — "{时代1}":
Small vignette: {场景描述}
Label: "{说明}"
↓
ERA 2 — "{时代2}":
Small vignette: {场景描述}
Label: "{说明}"
↓
{...4-6 eras}

CENTRAL HERO ZONE (40-50% width, 2-4 figures):

HERO 1 (center, largest, {高度}% canvas):
{人物描述 + 动态动作 + 服饰细节}
Name label: "{人物名}" · "{贡献/身份}"

HERO 2 (left of center):
{人物描述 + 动态}
Name label: "{人物名}"

HERO 3 (right of center):
{人物描述 + 动态}
Name label: "{人物名}"

{可选 HERO 4}

Background elements between heroes: {关联元素 — 建筑/符号/光效}

RIGHT COLUMN — Classification (22-25% width):
Section header: "{分类标题}"

CARD 1: [{流派1名}] — small figure illustration, labeled "{特征标签}"
CARD 2: [{流派2名}] — small figure illustration, labeled "{特征标签}"
CARD 3: [{流派3名}] — small figure illustration, labeled "{特征标签}"
CARD 4: [{流派4名}] — small figure illustration, labeled "{特征标签}"

SUB-TOPIC A: "{子主题标题}"
{小插图 + 说明}

SUB-TOPIC B: "{子主题标题}"
{小插图 + 说明}

BOTTOM DEEP-DIVE ZONE (bottom 25-30%):

CATALOG ROW — "{器物/工具图录标题}":
A horizontal row of {N} small detailed illustrations:
{物品1名}, {物品2名}, {物品3名}... each labeled below.

PHILOSOPHY DIAGRAM:
{太极/阴阳/八卦等图解描述}
Surrounding concept pairs: "{概念A} ↔ {概念B}", "{概念C} ↔ {概念D}"

PRACTICE PRINCIPLES:
✓ {原则1}
✓ {原则2}
✓ {原则3}
✓ {原则4}

HUMOR COMMENTARY BOX (wooden plaque/scroll style):
"{趣味评论文字}"

SEAL STAMPS:
Corner stamps: "{印章内容}"
Scattered stamps: "{印章内容}"
Bottom stamp bar: "{左印}", "{右印}", center symbol.

{style_block}
{micro-detail block}

INFORMATION DENSITY: VERY HIGH — 20+ small illustrations, extensive text annotations,
timeline, classification grid, catalog row, philosophy diagram.

NEGATIVE:
{排除项}
```

---

## 布局选择

> 布局选择的完整决策树和信号匹配矩阵见 SKILL.md 中的自动推荐逻辑。
>
> 简要规则：**广泛主题（武术/医学/书法等），有流派/历史/分类等全景需求，或需要时间线** → 选 comprehensive-topic。
