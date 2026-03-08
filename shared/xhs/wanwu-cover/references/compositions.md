# 万物图鉴封面 — 5 种构图模板详细定义 v2.0

> 每种构图模板包含：核心视觉公式、元素配置、Prompt 片段模板。
> v2.0 更新：人物+动态优先、双边框+内容聚拢+选择性破框、微观细节。

---

## 1. group-portrait（群像集合式）

### 对标案例
- 中国十大国粹科普图鉴（人物+物品混合）
- 十二生肖古代雅称与祝福（拟人动物群像）

### 核心视觉公式

```
双边框（外框+内框+呼吸带）
  + 2-3 个人物角色作为视觉锚点（各有动态动作）
  + 6-10 个物品紧密铺满（各有微观光影细节）
  + 90% 内容聚拢在内框内
  + 少量元素选择性破框（人物侧入+物品边缘裁切+棋子/花瓣溢出）
  + 散落元素有微小投影
  + 极淡背景建筑剪影（15-20%）
```

### 元素配置

| 元素 | 数量 | 大小 | 位置 |
|------|------|------|------|
| 人物角色 | 2-3 | 25-35% 画面高度 | 内框内，1个从侧边入场 |
| 物品主体 | 6-10 | 8-15% each | 内框内环绕人物 |
| 散落元素 | 4-8 | 1-3% each | 空白缝隙，部分跨越内框 |
| 背景剪影 | 1-2 | 极淡 15-20% | 远景层 |
| 角标印章 | 2-4 | 5-8% | 贴外框线 |
| 散布印章 | 2-3 | 3-6% | 内框内空白处 |

### Prompt 片段

```
A highly detailed retro Chinese encyclopedia cover illustration,
portrait orientation (3:4 ratio, 1792×2400px).
Style: polished digital illustration, 85-90% realism, silky-smooth rendering.

BACKGROUND:
Aged warm parchment paper (#E8D5B0) with subtle fiber texture,
light tea-stain patches at 15-20% opacity. Gentle vignette at edges.
Faint silhouette of {传统建筑} at 15-20% opacity in upper background.

DOUBLE BORDER FRAME:
Outer frame: thin sepia line at ~3% from edges, cloud-scroll corner ornaments.
Inner frame: thin sepia line at ~7-8% from edges — PRIMARY CONTENT BOUNDARY.
Breathing zone between frames: mostly empty parchment.

MAIN COMPOSITION — Dynamic Group Portrait:
All main content tightly packed WITHIN the inner frame boundary.

FIGURE 1 (anchor, {位置}, {高度}% canvas height):
{人物描述 + 动态动作}. Rendered with smooth semi-realistic style,
silky fabric textures, warm skin tones, volumetric shading.
BREAKOUT: This figure enters from the {left/right} edge — {裁切描述}.

FIGURE 2 ({位置}, {高度}% canvas height):
{人物描述 + 动态动作}.

FIGURE 3 ({位置}, {高度}% canvas height):
{人物描述 + 动态动作}.

OBJECT 1 — {物品名}:
{物品描述 + 动态 + 微观细节（质感/光泽/高光）}

OBJECT 2 — {物品名}:
{物品描述 + 动态 + 微观细节}
{...列出所有物品}

BREAKOUT ELEMENTS (crossing inner frame):
- {物品X} extends past inner frame on {side}, cropped by canvas edge
- {N} scattered {棋子/花瓣} cross the inner frame into breathing zone with tiny shadows

SCATTERED DYNAMIC ELEMENTS:
{花瓣/茶叶/棋子/铜钱/墨滴等} in gentle motion with tiny cast shadows.

{style_block}

MICRO-DETAIL:
{Module 8 微观细节段落}

TEXT: {Module 5}
STAMPS: {Module 6}
DECORATIONS: {Module 7}
NEGATIVE: {Module 9}
```

---

## 2. center-radial（中心辐射式）

### 对标案例
- 人生十则（概念物件放射排列）

### 核心视觉公式

```
双边框（外框+内框+呼吸带）
  + 中央背景框（圆形/矩形，淡彩或深色）+ 暖金辉光
  + 中央核心物件/概念
  + 6-12 个子概念放射排列（钟点位置）
  + 每个子概念配标注文字
  + 可混合人物局部（手部/半身）
```

### Prompt 片段

```
{Module 1 规格}

{Module 2 背景}

{Module 3 双边框}

CENTER BACKDROP:
A {circular / rectangular} backdrop frame at canvas center,
{S 25-35% / M 35-50% / L 50-65%} of canvas height.
Fill: {light ink-wash beige / dark indigo / dark forest green}.
Soft warm golden glow radiating from center (#F5C842, feathered edges).

CENTER SUBJECT:
{中央核心物件描述 + 微观细节}, overlapping backdrop frame, with warm ambient glow.

RADIAL ELEMENTS (clockwise from 12 o'clock):
Position 12:00 — {子元素描述 + 微观细节}, labeled "{序号}{名称}"
Position 1:30 — {子元素描述}, labeled "{序号}{名称}"
{...按需增减}

Each radial element rendered as a detailed polished illustration vignette
with handwritten-style Chinese label nearby.

{style_block}
{Module 8 微观细节}
{Modules 5-7, 9}
```

---

## 3. scatter-concept（散点概念式）

### Prompt 片段

```
{Module 1 规格}
{Module 2 背景}
{Module 3 双边框}

COMPOSITION — Scattered Concept Display:
{N} concept objects evenly distributed within the inner frame,
creating a "curiosity cabinet" display effect.
No single dominant center — items roughly equal in visual weight.

Objects (each with polished rendering + micro-details):
1. {物件描述 + 微观细节} — labeled "{标注}"
2. {物件描述 + 微观细节} — labeled "{标注}"
{...}

Objects maintain visual rhythm through varied sizes, diagonal arrangement,
and connecting color repetition. All with tiny shadows.

{style_block}
{Module 8 微观细节}
{Modules 5-7, 9}
```

---

## 4. pyramid（金字塔层次式）

### Prompt 片段

```
{Module 1 规格}
{Module 2 背景}
{Module 3 双边框}

COMPOSITION — Pyramid Hierarchy (within inner frame):
Triangular arrangement, nearly left-right symmetrical.

APEX (top center, largest, 20-25% canvas height):
{顶部核心角色描述 + 动态}, elevated on clouds or platform.

MIDDLE TIER (3-5 figures, 12-18% each):
Left: {角色描述 + 动态}
Right: {角色描述 + 动态}

BASE TIER (5-8 figures, 8-12% each):
{底层角色，从左到右}

Eye flow from apex downward, each tier slightly overlapping below.

{style_block}
{Module 8 微观细节}
{Modules 5-7, 9}
```

---

## 5. c-surround（C型环绕式）

### 特殊色彩
红色比例最高 — 大面积红色元素 + 金色元素增加。

### Prompt 片段

```
{Module 1 规格}
{Module 2 背景}
{Module 3 双边框}

COMPOSITION — C-Surround (within inner frame):
Central focal object: {焦点物件描述 + 微观细节}, 20-30% canvas.

Surrounding in C-shape (clockwise):
Top-left: {物件} — labeled "{标签}"
Top-right: {物件} — labeled "{标签}"
Right: {物件} — labeled "{标签}"
{...}

EMPHASIS — Rich Red & Gold:
Dominant warm reds: {红色元素列表}
Gold accents: {金色元素}
Highest red-to-canvas ratio of all templates.

{style_block}
{Module 8 微观细节}
{Modules 5-7, 9}
```

---

## 风格片段（style_block）

### anthropomorphic

```
ILLUSTRATION STYLE:
Polished digital illustration of anthropomorphic animals in traditional Chinese garments.
Smooth, refined rendering — silky fabric textures with visible brocade and silk sheen.
Animal features rendered with rich detail while bodies are humanized.
Soft volumetric shading, warm directional light from upper-left.
Saturation: 75-85%. Realism: 85-90%.
NO flat ink outlines — soft integrated edges.
```

### traditional

```
ILLUSTRATION STYLE:
Polished digital illustration with traditional Chinese encyclopedia aesthetic.
Smooth rendering — each object and figure has volumetric form with soft shading.
Rich color depth, warm tonal range, museum-specimen clarity with premium digital polish.
Soft directional light from upper-left.
Saturation: 70-85%. Realism: 85-90%.
NO flat ink outlines. NOT sketchy watercolor.
```

### realistic

```
ILLUSTRATION STYLE:
High-quality naturalist illustration with polished digital rendering.
Detailed textures: fur strands, leaf veins, feather barbs, metallic sheen.
Natural warm side-lighting, soft directional shadows.
Silky-smooth surface rendering, accurate proportions.
Saturation: 70-80%. Realism: 85-95%.
```
