# anatomy-spread（解剖图鉴式）

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
- 署名 "作者：知渡" 位于主体中下部，红色

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

AUTHOR CREDIT: "作者：知渡" in cinnabar red (#C0392B), small handwritten style, below center subject.

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

## 布局选择

> 布局选择的完整决策树和信号匹配矩阵见 SKILL.md 中的自动推荐逻辑。
>
> 简要规则：**单一具体对象（动物/植物/物品）的百科深潜** → 选 anatomy-spread。
