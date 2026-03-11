# 万物图鉴内容页 — Prompt 组装规范 v1.0

> 本文档定义内容页 Prompt 的模块结构和组装流程。
> 与 wanwu-cover 的 9 模块结构类似，但增加了内容页专属模块。

---

## 模块总览

```
Module 1: 画面规格 + 渲染风格声明
Module 2: 背景层
Module 3: 双边框系统
Module 4: 标题区
Module 5: 构图主体（根据布局类型切换）
Module 6: 知识模块系统（内容页核心）
Module 7: 标注与标签系统
Module 8: 印章系统
Module 9: 装饰与微观细节
Module 10: Negative（排除项）
```

---

## Module 1: 画面规格 + 渲染风格

```
A highly detailed retro Chinese encyclopedia content page illustration.
Orientation: {portrait / landscape}.
Aspect ratio: {3:4 / 16:9}.
Resolution: {1792×2400 / 1920×1080} px.
Style: polished digital illustration with traditional Chinese encyclopedia aesthetic, 85-90% realism.
Rendering: Smooth, refined digital painting with rich color depth, soft volumetric shading,
silky-smooth surfaces, and seamless color gradation. Premium encyclopedia page quality.
Information density: HIGH — this is a knowledge-rich content page with multiple illustration modules,
text annotations, labels, and detail views.
```

**关键词必须包含**：
- "content page"（非 "cover"）
- "polished digital illustration"
- "information density: HIGH"
- "silky-smooth"

---

## Module 2: 背景层

```
BACKGROUND:
Aged warm parchment paper base (#E8D5B0 to #F5E6C8) with subtle paper fiber texture.
Very light, irregular tea-stain patches at 15-20% opacity — NOT heavy aging.
Gentle vignette effect: edges 5-10% darker than center.
Overall warmth: color temperature 4800-5500K.
No pure white areas, no stark black areas — everything in warm brown tonal range.
```

与封面一致，但注意：
- 内容页不需要"极淡建筑剪影"背景（信息已经很密，不需要额外背景深度）
- 背景要更"干净"以衬托大量文字和小插图

---

## Module 3: 双边框系统

```
DOUBLE BORDER FRAME SYSTEM:
Outer frame: thin sepia-brown line (#8B6914) at ~3% margin from canvas edges.
Small Chinese cloud-scroll corner ornaments at four corners.
Inner frame: thin sepia-brown line at ~7-8% margin from canvas edges.
This is the PRIMARY CONTENT BOUNDARY.
Breathing zone between frames: mostly empty parchment, only seal stamps.
```

与封面一致。

---

## Module 4: 标题区

### anatomy-spread 标题

```
TITLE BLOCK (top center, 10-12% of canvas height):
L1 MAIN TITLE: "「{主标题}」" in bold Chinese brush calligraphy.
  Deep ink #3A2A1A, thick-thin stroke variation, slight ink bleeding.
  MUST look hand-brushed, NOT a printed typeface.
L2 SUBTITLE: "{副标题}" centered below L1, #5C3D2E.
L3 LATIN/ENGLISH: "{拉丁学名/英文}" in small italic serif, #5C3D2E.
```

### narrative-chapter 标题

```
TITLE BLOCK (top center, 10-12%):
Small red seal stamps flanking the title area.
L1: "「{主体}：{雅称/主题}」" in bold brush calligraphy, #3A2A1A.
L2: "{系列名}·第{N}章" centered below, #5C3D2E.
```

### comprehensive-topic 标题

```
TITLE BLOCK (top center, 10-12%):
L1: "「{主标题}」" in bold brush calligraphy, #3A2A1A.
L2: "{副标题}" · "{English Title}" below L1, #5C3D2E.
L3: "{系列名} 第{N}章" small text.
L4: "作者：知渡" in red #C0392B.
```

---

## Module 5: 构图主体

根据布局类型选择对应的主体描述。

### anatomy-spread 主体

```
CENTRAL SUBJECT ({主体名}, 40-50% of visual area, center of composition):
{详细描述 — 物种/对象 + 姿态 + 朝向（3/4视角）+ 动态 + 表情}
Rendered with silky-smooth digital illustration, rich detail:
- {质感细节1}
- {质感细节2}
- {微观细节}

ANNOTATION LINES (thin sepia #5C3D2E lines extending from subject):
- Arrow to {部位1}: "{标注文字1}"
- Arrow to {部位2}: "{标注文字2}"
- Arrow to {部位3}: "{标注文字3}"
{...6-10条标注}

AUTHOR CREDIT: "作者：知渡" in red #C0392B, small handwritten style, below subject center.

CHARACTER QUOTE BOX (scroll-style frame near subject):
"{角色名}：{第一人称趣味引言}"
Character name in bold red.
```

### narrative-chapter 主体

```
CENTRAL DRAMATIC SCENE (55-65% of visual area, framed by inner border):
{场景详细描述 — 主角 + 动态 + 环境 + 氛围}
The scene is dramatic and alive: {运动/光影/气势描述}.
{主角} is {动作}, wearing/having {服饰/装备}.
Background environment: {山林/草原/宫殿/战场}.
Selective breakout: {1-2个元素突破内框}.

AUTHOR CREDIT in red, below the scene.
```

### comprehensive-topic 主体

```
CENTRAL HERO ZONE (40-50% width, center):
2-4 representative figures in dynamic poses:
HERO 1 (center, largest): {人物描述 + 动作 + 标注}
HERO 2 (left): {人物描述 + 动作 + 标注}
HERO 3 (right): {人物描述 + 动作 + 标注}
{可选 HERO 4}

Background elements: {符号/建筑/光效}
```

---

## Module 6: 知识模块系统（内容页核心）

### anatomy-spread 知识模块

```
SECTION HEADER LEFT: Bordered title box "「{知识维度A}」" at top-left.
SECTION HEADER RIGHT: Bordered title box "「{知识维度B}」" at top-right.

LEFT COLUMN (22-25% width, 3-4 modules):

MODULE L1 — "①{标题}":
{2-4 small vignette illustrations in grid}:
- Vignette: {场景描述}, labeled "{说明}"
{...}

MODULE L2 — "②{标题}":
{vignette描述}

MODULE L3 — "③{标题}":
{vignette描述}

{可选 MODULE L4}

RIGHT COLUMN (22-25% width, 3-4 modules):
{同上格式}

BOTTOM KNOWLEDGE BAR (bottom 18-22%):
SECTION B1 — "①{标题}": {属性/键值对}
SECTION B2 — "②{标题}": {结构简图}
SECTION B3 — "③{标题}": {图标行}
SECTION B4 — "④{标题}": {说明}
SECTION B5 — "⑤{标题}": {寓意图标行}

MICROSCOPIC CIRCLES (1-3):
- Circle: {微观对象}, showing {细节}, connected by dotted line.

FEATURE CHECKLIST: ✓ {特征1} / ✓ {特征2} / ...
SYMBOLISM LIST: {现象} → {寓意} / ...
```

### narrative-chapter 知识模块

```
LEFT VERTICAL SIDEBAR (12-15% width):
Compact vertical key facts:
- "{关键事实1}" + optional icon
- "{关键事实2}"
{...4-6 items}

RIGHT SIDEBAR (20-25% width, 3-4 cards):
CARD 1 — "【{标题}】": {小插图描述} + "{说明文字}"
CARD 2 — "【{标题}】": {小插图描述} + "{说明文字}"
CARD 3 — "【{标题}】": {小插图描述} + "{说明文字}"

BOTTOM TEXT BLOCK (10-12%, bordered):
"{解说文段 — 3-5行知识性文字}"
```

### comprehensive-topic 知识模块

```
LEFT COLUMN — Timeline (20-22% width):
"{时间线标题}"
ERA 1 — "{时代}": {vignette}, "{说明}"
↓
ERA 2 — "{时代}": {vignette}, "{说明}"
{...4-6 eras}

RIGHT COLUMN — Classification (22-25% width):
"{分类标题}"
CARD grid (2×2 or 2×3):
[{类别1}] — figure + "{标签}"
[{类别2}] — figure + "{标签}"
{...}
SUB-TOPICS: {子主题A/B}

BOTTOM DEEP-DIVE ZONE (25-30%):
CATALOG ROW: horizontal row of {N} items, each labeled.
PHILOSOPHY DIAGRAM: {图解描述} + concept pairs.
PRACTICE PRINCIPLES: ✓ list.
HUMOR BOX: "{趣味评论}" in scroll/plaque style.
```

---

## Module 7: 标注与标签系统

```
ANNOTATION SYSTEM:
Thin sepia lines (#5C3D2E at 70% opacity) with arrows/dots connecting
subject parts to label text. {N} annotation lines total.

TAG LABELS:
Small rounded rectangle tags (light parchment fill + sepia border):
"{标签1}", "{标签2}", "{标签3}"...
Placed adjacent to relevant vignettes or illustrations.

NUMBERED HEADERS:
Circle-enclosed numbers ①②③④ preceding module titles.
Deep brown bold text.
```

---

## Module 8: 印章系统

```
SEAL STAMPS (朱砂红):
CORNER STAMPS (on outer frame):
- Top-left: "{内容}" (白文印/阴刻)
- Top-right: "{内容}" (朱文印/阳刻)
{可选 bottom-left, bottom-right}

SCATTERED STAMPS (within composition):
- {位置}: "{内容}"
- {位置}: "{内容}"

BOTTOM STAMP BAR:
- Left end: red seal "{左印}"
- Right end: red seal "{右印}"
- Center: circular symbol "{符号}"

All stamps: cinnabar red #C0392B, aged worn edges.
```

---

## Module 9: 装饰与微观细节

```
DECORATIVE ELEMENTS:
Wisps of auspicious clouds at 10-20% opacity in background gaps.
{根据主题的散落元素}

MICRO-DETAIL:
Every metallic surface: specular highlight + star sparkle (✦).
Every glossy surface: curved reflection highlights.
Every translucent material: light passing through with warm glow.
Every scattered object: tiny soft shadow on parchment.
Every fabric: weave texture catching light.
Every organic material: fine surface detail.

COLOR & RENDERING:
Saturation: 70-85%. Rich, vibrant, warm.
Silky-smooth surfaces, soft volumetric shading.
Gentle directional light from upper-left.
NO flat fills, NO harsh ink outlines.
```

---

## Module 10: Negative

```
NEGATIVE PROMPT / MUST AVOID:
- Victorian/Rococo/Baroque ornamental borders
- Anime/manga/cartoon rendering
- 3D CGI or photorealistic photography
- Photorealistic human faces
- Pure white backgrounds
- Modern sans-serif title fonts
- Gradient color backgrounds
- Neon/fluorescent colors
- Flat ink-line art with watercolor wash
- Rough hand-drawn look
- Static museum-catalog feel
- Low information density (this is a CONTENT page, must be knowledge-rich)
- Empty space without purpose (fill with knowledge modules)
- Overlapping text that is illegible
- Pseudo-Latin nomenclature
```

---

## 组装前检查清单

### 通用检查
- [ ] Module 1: 包含 "content page" + "polished digital illustration" + "information density: HIGH"
- [ ] Module 2: 背景无建筑剪影（内容页不需要）
- [ ] Module 3: 双边框完整
- [ ] Module 4: 标题格式匹配布局类型
- [ ] Module 8: 印章完整
- [ ] Module 9: 微观细节段落完整
- [ ] Module 10: 包含 "Low information density" 禁止项
- [ ] 饱和度 70-85%
- [ ] 无占位符残留

### anatomy-spread 检查
- [ ] 中央主体占 40-50%
- [ ] 有 6-10 条标注线
- [ ] 左栏 3-4 模块 + 右栏 3-4 模块
- [ ] 底部知识条 3-5 个子模块
- [ ] 有微观放大圈
- [ ] 有角色引言框
- [ ] 有特征 ✓ 列表
- [ ] 小插图总数 ≈ 15-20

### narrative-chapter 检查
- [ ] 中央场景占 55-65%，戏剧性构图
- [ ] 左竖栏 4-6 个关键事实
- [ ] 右侧栏 3-4 个【】知识卡片
- [ ] 底部有完整解说文段
- [ ] 有系列·章节编号
- [ ] 底部印章条有地支符号

### comprehensive-topic 检查
- [ ] 有 2-4 个英雄人物
- [ ] 左栏有时间线（4-6个时代）
- [ ] 右栏有分类卡片（4-6个）
- [ ] 底部深潜区有：器物图录 + 哲学图解 + 实践原则
- [ ] 有趣味评论框
- [ ] 小插图总数 ≈ 20+

### 词数目标
- anatomy-spread: 500-800 words
- narrative-chapter: 400-600 words
- comprehensive-topic: 600-900 words

---

## 风格片段（style_block）

继承自 wanwu-cover，完全一致：

### anthropomorphic
```
Polished digital illustration of anthropomorphic animals in traditional Chinese garments.
Smooth, refined rendering — silky fabric textures with visible brocade and silk sheen.
Animal features rendered with rich detail while bodies are humanized.
Saturation: 75-85%. Realism: 85-90%.
```

### traditional
```
Polished digital illustration with traditional Chinese encyclopedia aesthetic.
Smooth rendering — each object and figure has volumetric form with soft shading.
Rich color depth, warm tonal range, museum-specimen clarity with digital polish.
Saturation: 70-85%. Realism: 85-90%.
```

### realistic
```
High-quality naturalist illustration with polished digital rendering.
Detailed textures: fur strands, leaf veins, feather barbs, metallic sheen.
Natural warm side-lighting, soft directional shadows.
Saturation: 70-80%. Realism: 85-95%.
```
