# 万物图鉴内容页 — 3 种布局模板详细定义 v1.0

> 每种布局包含：空间分区图、模块槽位定义、元素配置、Prompt 片段模板。
> 所有布局共享 visual-dna.md 中的视觉基因。

---

## 1. anatomy-spread（解剖图鉴式）

### 对标案例
- 子鼠（十二生肖之首）
- 丑牛（十二生肖）

### 核心定位
单一主体的百科全景深潜页。像"翻开百科全书看一个词条"。

### 空间分区

```
┌──────────────────────────────────────────────┐
│ [外框 + 角标印章]                              │
│ ┌──────────────────────────────────────────┐ │
│ │ [区域标题A]   「主标题」     [区域标题B]   │ │
│ │               副标题                      │ │
│ │               拉丁学名                    │ │
│ │                                           │ │
│ │  ┌─左栏─┐   ┌──中央主体──┐  ┌─右栏─┐   │ │
│ │  │①模块 │   │            │  │①模块 │   │ │
│ │  │ 场景图│   │  大主体插图  │  │ 场景图│   │ │
│ │  │      │   │ +标注箭头   │  │      │   │ │
│ │  │②模块 │   │            │  │②模块 │   │ │
│ │  │ 场景图│   │  ↙  ↘  ↗  │  │ 场景图│   │ │
│ │  │      │   │ 标注  标注  │  │      │   │ │
│ │  │③模块 │   │            │  │③模块 │   │ │
│ │  │ 场景图│   │ [作者署名]  │  │ 场景图│   │ │
│ │  │      │   │            │  │      │   │ │
│ │  │④模块 │   │ [引言框]   │  │④模块 │   │ │
│ │  │      │   │            │  │      │   │ │
│ │  └──────┘   └────────────┘  └──────┘   │ │
│ │                                           │ │
│ │  ┌──底部知识条──────────────────────────┐ │ │
│ │  │①属性  ②结构图  ③食物  ④生态  ⑤寓意│ │ │
│ │  │[微观放大圈]   [特征✓列表]  [寓意列表]│ │ │
│ │  └──────────────────────────────────────┘ │ │
│ │                                           │ │
│ └──────────────────────────────────────────┘ │
│ [底部印章条]                                   │
└──────────────────────────────────────────────┘
```

### 模块槽位定义

| 槽位 | 位置 | 宽度 | 内容 |
|------|------|------|------|
| **标题区** | 顶部居中 | 100% | 主标题(书法) + 副标题 + 拉丁学名 |
| **区域标题A** | 左栏顶部 | 25% | 知识维度A名称（如"生肖文化象征"） |
| **区域标题B** | 右栏顶部 | 25% | 知识维度B名称（如"生活习性图解"） |
| **左栏** | 左侧 | 22-25% | 知识维度A：3-4个编号模块 |
| **中央主体** | 中间 | 40-50% | 大主体插图 + 标注箭头 + 署名 + 引言框 |
| **右栏** | 右侧 | 22-25% | 知识维度B：3-4个编号模块 |
| **底部知识条** | 底部 | 100% | 3-5个补充知识块 + 微观放大圈 + 特征列表 |
| **底部印章条** | 最底部 | 100% | 印章 + 标志 |

### 每个编号模块的结构

```
② 民间寓意图解
┌─────┐ ┌─────┐
│鼠咬 │ │鼠守 │
│铜钱 │ │粮仓 │
│招财 │ │富足 │
└─────┘ └─────┘
┌─────┐ ┌─────┐
│鼠抱 │ │双鼠 │
│谷穗 │ │同仓 │
│丰登 │ │富裕 │
└─────┘ └─────┘
```

- 标题：编号 + 名称
- 内容：2-4个小场景插图，每个配 2-4 字说明
- 小插图排列：2×2 或 1×2 或 1×3 网格

### 中央主体要求

- 占画面 40-50% 的视觉面积
- 主体朝向略偏（3/4 视角），不完全正面
- 6-10 条标注线从主体各部位引出
- 标注内容：解剖特征 / 行为特征 / 文化象征
- 主体有微观细节（毛发纹理、眼睛反光等）
- 署名 "作者：万物图鉴" 位于主体中下部，红色

### Prompt 片段

```
A highly detailed retro Chinese encyclopedia content page illustration.
Orientation: portrait. Aspect ratio: 3:4 (1792×2400px).
Style: polished digital illustration with traditional Chinese encyclopedia aesthetic, 85-90% realism.
Rendering: Smooth, refined digital painting with rich color depth, soft volumetric shading, silky-smooth surfaces.

BACKGROUND:
Aged warm parchment paper base (#E8D5B0 to #F5E6C8) with subtle paper fiber texture.
Very light tea-stain patches at 15-20% opacity. Gentle vignette at edges.

DOUBLE BORDER FRAME SYSTEM:
Outer frame: thin sepia-brown line at ~3% margin, cloud-scroll corner ornaments.
Inner frame: thin sepia-brown line at ~7-8% margin — PRIMARY CONTENT BOUNDARY.

TITLE BLOCK (top center, 10-12% height):
L1: "「{主标题}」" in bold Chinese brush calligraphy, deep ink #3A2A1A.
L2: "{副标题}" below L1, medium brown #5C3D2E.
L3: "{拉丁学名/英文}" in small italic serif (Garamond style), #5C3D2E.

SECTION HEADER LEFT: Bordered title box "「{知识维度A名称}」" at top-left area.
SECTION HEADER RIGHT: Bordered title box "「{知识维度B名称}」" at top-right area.

CENTRAL SUBJECT ({主体名称}, occupying 40-50% of visual area, center):
{主体详细描述 — 姿态/朝向/动态/表情/质感}
Rendered with silky-smooth digital illustration, rich detail.
{6-10条标注线描述}: thin sepia annotation lines extending from the subject to labeled text:
- Arrow to {部位1}: "{标注文字1}"
- Arrow to {部位2}: "{标注文字2}"
{...}

AUTHOR CREDIT: "作者：万物图鉴" in cinnabar red (#C0392B), small handwritten style, below center subject.

CHARACTER QUOTE BOX (below subject):
Scroll-style speech box containing first-person humorous quote from the subject:
"{角色引言}"
Title "{角色名}：" in bold red.

LEFT COLUMN (22-25% width, left side, 3-4 knowledge modules):

MODULE L1 — "①{模块标题}":
{2-4 small vignette illustrations in 2×2 grid}:
- Vignette 1: {场景描述}, labeled "{说明}"
- Vignette 2: {场景描述}, labeled "{说明}"
{...}

MODULE L2 — "②{模块标题}":
{vignette描述}

MODULE L3 — "③{模块标题}":
{vignette描述}

MODULE L4 — "④{模块标题}":
{vignette描述}

RIGHT COLUMN (22-25% width, right side, 3-4 knowledge modules):

MODULE R1 — "①{模块标题}":
{vignette描述 + tag labels}

MODULE R2 — "②{模块标题}":
{vignette描述 + tag labels}

MODULE R3 — "③{模块标题}":
{vignette描述 + tag labels}

MODULE R4 — "④{模块标题}":
{vignette描述 + tag labels}

TAG LABELS: Small rounded rectangle tags next to vignettes, light background with sepia border:
{标签1}, {标签2}, {标签3}...

BOTTOM KNOWLEDGE BAR (bottom 18-22% of canvas):

SECTION B1 — "①{底部模块1标题}":
{属性键值对列表}

SECTION B2 — "②{底部模块2标题}":
{结构简图描述 — 简化线稿风格}

SECTION B3 — "③{底部模块3标题}":
{食物/工具图标行描述}

SECTION B4 — "④{底部模块4标题}":
{生态/功能说明}

SECTION B5 — "⑤{底部模块5标题}":
{文化寓意图标行}

MICROSCOPIC DETAIL CIRCLES (1-3 circular magnification views):
- Circle 1: Close-up of {微观对象1}, showing {细节描述}
- Circle 2: Close-up of {微观对象2}, showing {细节描述}
Connected to main subject by thin dotted lines.

FEATURE CHECKLIST:
"{特征标题}"
✓ {特征1}
✓ {特征2}
✓ {特征3}
{...}

SYMBOLISM LIST:
{现象1} → {寓意1}
{现象2} → {寓意2}
{...}

SEAL STAMPS:
Corner stamps on outer frame: top-left "{左上}", top-right "{右上}".
Scattered stamps within composition: "{散布1}", "{散布2}".
{...额外印章}

BOTTOM STAMP BAR:
Left: red seal "{左下印}", Right: red seal "{右下印}", Center: circular zodiac symbol "{符号}".

{style_block}

MICRO-DETAIL EMPHASIS:
{微观细节段落}

COLOR & RENDERING:
Saturation: 70-85%. Rich, vibrant, warm tones.
All surfaces silky-smooth with soft volumetric shading.
Information density: HIGH — approximately 15-20 small illustrations + extensive text labels.

NEGATIVE PROMPT / MUST AVOID:
{排除项}
```

---

## 2. narrative-chapter（叙事章节式）

### 对标案例
- 虎：山君（十二生肖古代雅称·第三章）
- 马：追风（十二生肖古代雅称·第七章）

### 核心定位
系列章节的故事叙述页。像"翻到古籍中某一章的精美插图页"。

### 空间分区

```
┌──────────────────────────────────────────────┐
│ [外框 + 角标印章]                              │
│ ┌──────────────────────────────────────────┐ │
│ │ [印章]  「主标题」        [印章]          │ │
│ │         副标题                            │ │
│ │         系列名·第X章                      │ │
│ │                                           │ │
│ │  ┌左竖栏┐  ┌───中央大场景───┐  ┌右侧栏┐ │ │
│ │  │      │  │                │  │      │ │ │
│ │  │竖排  │  │   戏剧性       │  │【卡片1】│ │
│ │  │关键  │  │   大场景       │  │ 小图  │ │ │
│ │  │事实  │  │   插画         │  │ 说明  │ │ │
│ │  │列表  │  │                │  │      │ │ │
│ │  │      │  │                │  │【卡片2】│ │
│ │  │图标  │  │ [作者署名]     │  │ 小图  │ │ │
│ │  │+     │  │                │  │ 说明  │ │ │
│ │  │关键词│  │                │  │      │ │ │
│ │  │      │  │                │  │【卡片3】│ │
│ │  └──────┘  └────────────────┘  └──────┘ │ │
│ │                                           │ │
│ │  ┌──底部解说文段──────────────────────┐   │ │
│ │  │ 一段完整的解说文字（3-5行）         │   │ │
│ │  └────────────────────────────────────┘   │ │
│ │                                           │ │
│ └──────────────────────────────────────────┘ │
│ [博物志]    ⊙{地支}    [古今图鉴]            │
└──────────────────────────────────────────────┘
```

### 模块槽位定义

| 槽位 | 位置 | 宽度 | 内容 |
|------|------|------|------|
| **标题区** | 顶部居中 | 100% | 主标题(书法) + 副标题 + 系列·章节 |
| **左竖栏** | 左侧 | 12-15% | 4-6个关键事实（图标+竖排关键词） |
| **中央大场景** | 中间 | 55-65% | 戏剧性场景插画 + 署名 |
| **右侧栏** | 右侧 | 20-25% | 3-4个知识卡片【】标题 |
| **底部文段** | 底部 | 100% | 3-5行解说文字 |
| **底部印章条** | 最底部 | 100% | 博物志 + 地支符号 + 古今图鉴 |

### 左竖栏结构

```
寅虎居三      ← 关键事实1（可加小图标）

十二生肖第三   ← 补充说明

👑             ← 图标
百兽之王       ← 关键事实2

📖
说文有载       ← 关键事实3

大虫·李耳     ← 关键事实4
避讳雅称
```

- 竖排紧凑排列
- 每个事实：可选小图标/emoji + 关键词（2-4字）+ 可选补充行
- 文字深褐色，部分加粗
- 整体占画面宽度 12-15%

### 右侧知识卡片结构

```
【渊源】
┌──────────┐
│ [竹简/    │
│  古籍插图] │
└──────────┘
典出《说文解字》
山兽之君之名

【避讳】
┌──────────┐
│ [古人     │
│  避讳场景] │
└──────────┘
古人讳称"大虫"
敬畏之心深重
```

- 每个卡片：【标题】+ 小插图 + 1-3行说明
- 插图风格可以是：卷轴、竹简、古籍页面、场景小图
- 3-4个卡片纵向排列

### 中央大场景要求

- 占画面 55-65%（比 anatomy-spread 的主体更大）
- 戏剧性构图：人物/动物有强烈动态
- 场景化：有背景环境（山林/草原/建筑）
- 氛围感：云雾、光效、动感线条
- 有内框线包围场景，部分元素破框
- 署名在场景下方

### Prompt 片段

```
A highly detailed retro Chinese encyclopedia narrative chapter page illustration.
Orientation: portrait. Aspect ratio: 3:4 (1792×2400px).
Style: polished digital illustration, 85-90% realism, silky-smooth rendering.

BACKGROUND:
Aged warm parchment paper base (#E8D5B0 to #F5E6C8) with subtle fiber texture.
Light tea-stain patches at 15-20% opacity. Gentle vignette.

DOUBLE BORDER FRAME SYSTEM:
Outer frame at ~3%, inner frame at ~7-8%, cloud-scroll corner ornaments.

TITLE BLOCK (top center):
Red seal stamp at top-left of title: "{印章内容}"
L1: "「{生肖/主体}：{雅称/主题}」" in bold brush calligraphy, #3A2A1A.
Red seal stamp at top-right: "{印章内容}"
L2: "{系列名}·第{N}章" below L1, #5C3D2E.

LEFT VERTICAL SIDEBAR (12-15% width, left side):
Compact vertical list of key facts, reading top-to-bottom:
- "{关键事实1}" with optional small icon
  "{补充说明1}"
- "{关键事实2}" with optional icon
{...4-6 items}
All text in deep brown #3A2A1A, selective bold emphasis.

CENTRAL DRAMATIC SCENE (55-65% of visual area, framed by inner border):
{场景详细描述 — 人物/动物 + 动态动作 + 环境 + 氛围}
The scene is dramatic and alive: {动态细节}.
{主角} is {动作描述}, with {服饰/装备/特征细节}.
Background: {环境描述 — 山林/草原/建筑/云雾}.
Selective breakout: {1-2个元素突破内框描述}.

AUTHOR CREDIT: "作者：@万物图鉴" in cinnabar red, below the scene.

RIGHT SIDEBAR (20-25% width, 3-4 knowledge cards):

CARD 1 — "【{标题1}】":
Small illustration: {卷轴/竹简/场景描述}
Text: "{说明文字}"

CARD 2 — "【{标题2}】":
Small illustration: {描述}
Text: "{说明文字}"

CARD 3 — "【{标题3}】":
Small illustration: {描述}
Text: "{说明文字}"

BOTTOM EXPLANATORY TEXT BLOCK (bottom 10-12%, with thin border):
A paragraph of explanatory text in Song typeface:
"{解说文段内容}"
Deep brown #3A2A1A on parchment background.

BOTTOM STAMP BAR (outer frame zone):
Left: red seal "博物志", Right: red seal "古今图鉴".
Center: circular red symbol containing "{地支字}".
Small decorative elements: zodiac animal silhouettes in a row.

{style_block}
{micro-detail block}

NEGATIVE:
{排除项}
```

---

## 3. comprehensive-topic（全景专题式）

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
AUTHOR: "作者：@万物图鉴" in red #C0392B.

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

## 布局选择决策树

```
主题是单一具体对象（动物/植物/物品）?
  ├─ YES → anatomy-spread
  └─ NO
      └─ 主题是某个系列中的一章（有叙事性）?
          ├─ YES → narrative-chapter
          └─ NO → comprehensive-topic
```

更详细的信号匹配：

| 信号 | Layout |
|------|--------|
| 单一动物/植物/物品深潜 | anatomy-spread |
| 有"结构""习性""属性"等解剖类需求 | anatomy-spread |
| 系列中的一章，有章节编号 | narrative-chapter |
| 有"典故""雅称""故事"等叙事需求 | narrative-chapter |
| 广泛主题（武术/医学/书法等） | comprehensive-topic |
| 有"流派""历史""分类"等全景需求 | comprehensive-topic |
| 需要时间线 | comprehensive-topic |
