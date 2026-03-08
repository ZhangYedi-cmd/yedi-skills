# 万物图鉴封面 — Prompt 组装规范 v2.0

> 本文档定义封面 Prompt 的 9 模块结构和组装流程。
> v2.0 新增 Module 3（双边框）、Module 8（微观细节）、Module 9（破框指令）。

---

## 模块总览

```
Module 1: 画面规格 + 渲染风格声明
Module 2: 背景层
Module 3: 双边框系统（v2.0 新增）
Module 4: 构图主体（人物+物品+动态）
Module 5: 文字系统
Module 6: 印章系统
Module 7: 装饰层
Module 8: 微观细节（v2.0 新增）
Module 9: Negative（排除项）
```

---

## Module 1: 画面规格 + 渲染风格

```
A highly detailed retro Chinese encyclopedia cover illustration.
Orientation: {portrait / landscape}.
Aspect ratio: {3:4 / 16:9 / 4:3}.
Resolution: {1792×2400 / 1920×1080 / 1660×1242} px.
Style: polished digital illustration with traditional Chinese encyclopedia aesthetic, 85-90% realism.
Rendering: Smooth, refined digital painting with rich color depth, soft volumetric shading, silky-smooth surfaces, and seamless color gradation. Premium coffee-table book quality.
```

**⚠️ v2.0 关键**：必须包含 "polished digital illustration"、"smooth"、"silky-smooth"。
绝不能使用 "ink contour"、"watercolor wash"、"line art" 等平面化描述词。

---

## Module 2: 背景层

```
BACKGROUND:
Aged warm parchment paper base (#E8D5B0 to #F5E6C8) with subtle paper fiber texture.
Very light, irregular tea-stain patches at 15-20% opacity — NOT heavy aging.
Gentle vignette effect: edges 5-10% darker than center.
Overall warmth: color temperature 4800-5500K.
Faint silhouette of {传统建筑类型 — 故宫/山水/塔楼} visible in upper background at 15-20% opacity, providing cultural atmosphere.
No pure white areas, no stark black areas — everything in warm brown tonal range.
```

---

## Module 3: 双边框系统（v2.0 新增）

```
DOUBLE BORDER FRAME SYSTEM:

OUTER FRAME: A thin sepia-brown line (#8B6914) at ~3% margin from canvas edges.
Small Chinese cloud-scroll (云卷) corner ornaments at all four frame corners in faded gold/dark brown, each about 3-4% of canvas width.

INNER FRAME: A second thin sepia-brown line at ~7-8% margin from canvas edges.
This is the PRIMARY CONTENT BOUNDARY — 90% of all illustration content must be contained WITHIN this inner frame.

BREATHING ZONE: The 4-5% gap between outer and inner frame is mostly EMPTY parchment — only corner seal stamps and a few breakout elements occupy this zone.
```

---

## Module 4: 构图主体（人物+物品+动态）

从 `compositions.md` 加载对应构图 Prompt 片段，替换所有 `{变量}`。

**v2.0 核心原则**：
1. **人物优先** — 2-3 个人物角色作为视觉锚点，每个有动态动作
2. **物品动态** — 物品也有进行中的动作（倒茶、写字、落子）
3. **内容聚拢** — 所有主体紧密排布在内框之内
4. **选择性破框** — 仅指定元素突破内框

**变量替换清单**：

| 变量 | 来源 | 示例 |
|------|------|------|
| `{人物角色描述}` | Step 1 分析 | "京剧花旦全装甩袖，武术宗师出拳" |
| `{动态动作}` | Step 1 分析 | "正在倒茶，茶汤半透明琥珀色" |
| `{物品描述}` | Step 1 分析 | "青花瓷瓶，釉面多处弧面高光" |
| `{破框元素}` | Step 1 分析 | "花旦从左侧入场被裁切20%" |
| `{主标题}` | 用户指定 | "「中国十大国粹科普图鉴」" |
| `{English Subtitle}` | 翻译+学术化 | "Ten Great Quintessences..." |
| `{style_block}` | 风格片段 | 见底部 |

---

## Module 5: 文字系统

```
TEXT ELEMENTS:

TITLE BLOCK (top 12-15% of canvas):
L1 MAIN TITLE: "「{主标题}」"
  — Rendered in bold Chinese brush calligraphy (毛笔书法手写体)
  — Thick-thin stroke variation (横细竖粗), with extended pie-na (撇捺) strokes
  — Slight ink bleeding/feathering at stroke edges (NOT crisp digital edges)
  — Deep ink color #3A2A1A
  — Horizontally centered
  — MUST look hand-brushed, NOT a printed typeface

L2 ENGLISH SUBTITLE: "{English Subtitle}"
  — Small serif italic typeface (Garamond/Playfair Display style)
  — Centered directly below L1
  — Color: #5C3D2E

AUTHOR CREDIT (lower-center area):
L3: "作者：知渡"
  — Small handwritten-style script, #5C3D2E at 75% opacity

BOTTOM BAR (bottom 8%, in outer frame zone):
L4: "{底部信息文字}"
  — Medium Song typeface, #5C3D2E, centered
```

---

## Module 6: 印章系统

```
SEAL STAMPS (朱砂红印章系统):

CORNER STAMPS (贴在外框线上):
- Top-left: Square red seal (#C0392B), aged/worn edges, "{左上}" (阴刻/白文印)
- Top-right: Square red seal, "{右上}" (阳刻/朱文印)
{可选:
- Bottom-left: Square red seal, "{左下}"
- Bottom-right: Square red seal, "{右下}"
}

SCATTERED STAMPS (内框内空白处):
- {位置1}: Small red seal containing "{内容1}"
- {位置2}: Small red seal containing "{内容2}"
{可选第3个}

Total: 6-8 red seal stamps. All cinnabar red (#C0392B) with irregular worn edges.
```

---

## Module 7: 装饰层

```
DECORATIVE ELEMENTS:

CLOUDS/MIST:
Wisps of auspicious clouds (祥云) in very light gold-beige (#F5EED8),
scattered in background gaps. Very low opacity (10-20%), decorative only.

SCATTERED OBJECTS:
{根据主题: 棋子/墨滴/花瓣/茶叶/铜钱/梅花/丝带等}
All in gentle motion, with tiny cast shadows on parchment beneath.

METALLIC GLINT:
Star-shaped sparkle effects (✦) on metallic surfaces — needles, bronze,
jewelry, gold objects. Small 4-point stars in warm gold (#FFD700).

BACKGROUND DEPTH:
Faint architectural silhouettes at 15-20% opacity — {故宫/山水/塔楼}.
```

---

## Module 8: 微观细节（v2.0 新增）

```
MICRO-DETAIL EMPHASIS (critical for premium quality):

Every metallic surface: specular highlight line along its length + star sparkle (✦) at tip/edge.
Every glossy surface (porcelain, jade, wet ink): curved reflection highlights following form contour.
Every transparent/translucent material (tea liquid, steam, silk): light passing through with warm glow.
Every scattered small object: tiny soft shadow on parchment beneath it.
Every fabric: weave texture or thread direction catching light differently at different angles.
Every organic material (herbs, petals): fine surface detail — root hairs, leaf veins, waxy sheen.

COLOR & RENDERING:
Saturation: 70-85% — rich, vibrant, luxurious. NOT washed-out or pale.
All surfaces silky-smooth with soft volumetric shading.
Gentle directional light from upper-left creates warm highlights and subtle shadows.
NO flat fills, NO harsh ink outlines. Soft integrated edges throughout.
```

---

## Module 9: Negative（排除项）

```
NEGATIVE PROMPT / MUST AVOID:
- Victorian, Rococo, or Baroque ornamental borders
- Anime, manga, or cartoon rendering style
- 3D CGI or photorealistic photography
- Photorealistic human faces (use semi-realistic stylized illustration)
- Pure white (#FFFFFF) background areas
- Modern sans-serif fonts for the main title
- Gradient color backgrounds
- Hard drop shadows or dramatic spotlight effects
- Stock photography composition
- Pixelated or low-resolution elements
- Neon, fluorescent colors
- Flat ink-line art with watercolor wash (too sketchy — v1.0 已弃用)
- Rough hand-drawn look or visible pencil/ink strokes
- Static museum-catalog feel — the image should feel ALIVE and DYNAMIC
- Pseudo-Latin scientific nomenclature text
```

---

## 组装前检查清单

- [ ] Module 1: 包含 "polished digital illustration" + "silky-smooth"（非 ink-line art）
- [ ] Module 2: 背景层完整 + 建筑剪影 15-20%
- [ ] Module 3: 双边框描述完整（外框+内框+呼吸带）
- [ ] Module 4: 有 2-3 个人物角色 + 动态动作 + 物品动态
- [ ] Module 4: 内容聚拢声明 + 选择性破框指定
- [ ] Module 4: 边缘裁切指定（哪些元素被画布边裁切）
- [ ] Module 5: L1 包含 "brush calligraphy" + "ink bleeding" + "NOT printed" + 「」
- [ ] Module 6: 角标印章贴在外框线上，散布印章在内框内
- [ ] Module 7: 散落元素有投影 + 金属有星芒
- [ ] Module 8: 微观细节段落完整
- [ ] Module 9: 包含禁止 "flat ink-line art" 和 "static museum-catalog"
- [ ] 饱和度 70-85%（非 40-65%）
- [ ] 无占位符残留
- [ ] 总词数 400-700 words

---

## 风格片段（style_block）

### anthropomorphic（拟人博物风）

```
ILLUSTRATION STYLE:
Polished digital illustration of anthropomorphic animals in traditional Chinese garments.
Smooth, refined rendering — silky fabric textures with visible brocade patterns and silk sheen.
Animal features (fur, scales, feathers) rendered with rich detail while bodies are humanized.
Soft volumetric shading with warm directional light from upper-left.
Saturation: 75-85% (WARM-VIBRANT). Realism: 85-90%.
NO flat ink outlines — soft integrated edges throughout.
```

### traditional（传统百科风）

```
ILLUSTRATION STYLE:
Polished digital illustration with traditional Chinese encyclopedia aesthetic.
Smooth, refined rendering — each object and figure has volumetric form with soft shading.
Rich color depth with warm tonal range. Museum-specimen clarity but with premium digital polish.
Soft directional light from upper-left creating gentle highlights and subtle shadows.
Saturation: 70-85% (WARM-RICH). Realism: 85-90%.
NO flat ink outlines — soft integrated edges. NOT sketchy watercolor.
```

### realistic（写实博物风）

```
ILLUSTRATION STYLE:
High-quality naturalist illustration with polished digital rendering.
Detailed textures: individual fur strands, leaf veins, feather barbs, metallic sheen.
Natural warm side-lighting creating soft directional shadows.
Accurate proportions and anatomy with silky-smooth surface rendering.
Saturation: 70-80% (NATURAL-RICH). Realism: 85-95%.
Subtle but present shadow detail on every surface.
```
