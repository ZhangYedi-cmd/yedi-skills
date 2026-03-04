# 中心辐射式（Center Radial） — v3.3

规则拆解、行为分析、哲理智慧、方法论、抽象概念清单。

> **源自博文**：积累福报的六种行为、人有九不争、八大天规、道家处事之道、处理问题的10个思维
> **核心视觉**：中央主体 + 圆形/方形景观背景衬托 + 外围元素放射排列
> **互动数据**：博主所有构图中**互动量最高**的类型
> **v3.3 重大更新**：背景框三档尺寸弹性系统；深色背景框支持；元素骑框规则；四角印章+中式角花

---

## ★ 核心视觉公式（v3.3 四层深度结构）

万物图鉴 center-radial 封面的**固定四层结构**：

```
第1层（画布底）: 做旧宣纸底 (#E8D5B0) + 外框线 + [可选]中式角花装饰
第2层（中央背景框）: 圆形/方形景观框，尺寸按元素数弹性调整
第3层（中央主体）: 核心人物/器物叠压在背景框之前，有暖光/辉光效果
第4层（放射元素）: 6-12个器物/图标放射排列，可骑框（跨越背景框边界）
```

**中央背景框形状选择**：
- 圆形（circular vignette）：道家/哲理/自然主题（道家处事之道、积累福报）
- 方形/矩形框（rectangular frame）：历史人物/规则主题（曾国藩戒律、天规、人生十则）
- 大圆形（full circular backdrop）：10个以上元素的复杂主题（处理问题的10个思维）

## ★ 背景框尺寸弹性系统（v3.3 新增 — 关键更新）

背景框尺寸不再固定，按**放射元素数量和主体类型**动态调整：

| 档位 | 画面占比 | 适用场景 | 示例 |
|------|---------|---------|------|
| **S 小框** | 25-35% | ≤6个元素，主体小（器物/符号/莲花） | 积累福报（莲花+6器物） |
| **M 中框** | 35-50% | 7-9个元素，主体中（坐姿人物/动物） | 道家处事之道（道士+11器物） |
| **L 大框** | 50-65% | ≥10个元素，主体大（全身人物/场景） | 处理问题的10个思维（容器+10器物） |

**自动选档规则**：
- 放射元素 ≤6 → S，需要辐射留出足够外圈空间
- 放射元素 7-9 → M，背景框与外圈平衡
- 放射元素 ≥10 → L，大框容纳密集元素，部分元素可骑框
- **主体是坐姿/全身人物** → 至少 M，人物需要足够空间
- **主体是小器物（莲花/容器/符号）** → 可用 S

**Prompt 尺寸指令**：
```
# S 小框
A [circular/rectangular] backdrop frame (25-35% of canvas height) at center...

# M 中框
A [circular/rectangular] backdrop frame (35-50% of canvas height) at center,
large enough to frame the seated figure with landscape behind...

# L 大框
A LARGE [circular/rectangular] backdrop (50-65% of canvas height) dominating
the center, some radial elements overlap the frame boundary...
```

---

## 元素骑框规则（v3.3 新增）

放射元素与背景框的位置关系不再是严格"框外排列"：

| 关系 | 说明 | 适用 |
|------|------|------|
| **框外** | 所有元素在背景框外围排列 | S/M 小中框，元素≤8 |
| **骑框** | 部分元素横跨背景框边界（一半在内一半在外） | L 大框，元素≥10 |
| **框内+框外** | 主体在框内，近景元素也在框内，远景元素在框外 | 大场景主题 |

**Prompt 骑框指令**：
```
Several radial elements STRADDLE the backdrop frame boundary — partially inside,
partially outside — creating depth and breaking the rigid circle/frame edge.
```

---

## ★ 深色背景框（v3.3 新增 — Dark Vignette）

官方图中部分主题使用**深色背景圆盘/框**（非水墨淡彩），产生强对比：

| 类型 | 色调 | 框内场景 | 适用 |
|------|------|---------|------|
| **淡彩水墨**（默认） | 浅色调，与宣纸底融合 | 山水/竹林/宫殿，中等可见度 | 大部分主题 |
| **深色星空** | 深靛蓝 #1B2838~#2C3E50 | 星空/银河/灯塔+金光 | 思维/智慧/宇宙感主题 |
| **深色森林** | 深墨绿 #1A3C2A~#2D4A3E | 密林/竹海/山谷 | 自然哲理/隐士主题 |

**深色背景框 Prompt 片段**：
```
CENTER BACKDROP: A [circular/rectangular] frame with DARK background
(deep indigo #1B2838 / dark forest green #1A3C2A) containing [starry sky
with distant galaxy / dense misty forest with golden lighthouse light].
HIGH CONTRAST against the warm parchment surrounding it — the dark backdrop
makes the central subject and golden glow POP dramatically.
```

---

## 核心视觉描述（v3.3 更新）

- **整图外框**：细线矩形装饰外边框，略内缩于画布边缘；可选中式角花（云纹/龙纹）装饰四角
- **中央背景框**：圆形或方形，尺寸 S/M/L 按内容弹性；内含中国景观场景，淡彩或深色
- **中央主体**：人物/器物叠压在背景框之上，体积占画面 30-50%，有暖光/辉光
- **放射排列**：6-12个代表子主题的器物/图标，围绕中心呈轮辐状有序排布，可骑框
- **标注系统**：每个外围元素配中文标注线 + 编号 ①②③④ + 2-6字简述
- **角标印章**：2-4角红色方块印章（至少左上+右上，可选左下+右下）
- **可选竖排侧文**：左右边距区可放竖排智慧金句/对联
- 底部：点号属性列表 或 丝带横幅条 或 出版社横幅

---

## 子模式

### 子模式 A: focal-radial（封面专用 v3.3 — 默认）

**四层结构**：外框(+角花) → 中央景观圆/方框(弹性尺寸) → 主体叠压 → 外围放射元素(可骑框)。

```
OUTER FRAME: Thin decorative rectangular border frame around the entire
composition, slightly inset from canvas edges. [Optional] Chinese-style corner
ornaments (cloud scrolls 云纹 / dragon motifs 龙纹 / ruyi patterns 如意纹)
at four corners of the frame.

CENTER BACKDROP: A [circular vignette / rectangular frame] backdrop at the
image center. SIZE: [S: 25-35% / M: 35-50% / L: 50-65%] of canvas height
— choose based on element count and subject size.
TONE: [light ink-wash (default) / dark indigo #1B2838 / dark forest #1A3C2A]
— choose based on theme mood.
Contains atmospheric Chinese [mountain landscape / bamboo forest / starry sky
with galaxy / palace courtyard / forest with golden lighthouse] scene.

Overlapping the center frame: the MAIN SUBJECT — [figure/object] placed IN FRONT
of the backdrop, creating depth. The main subject has warm golden light/glow
emanating from it (soft radiant warmth, NOT supernatural neon).

SURROUNDING the center in an ORGANIZED RADIAL WHEEL pattern:
[N] symbolic objects/figures arranged like clock positions (12, 2, 4, 6, 8, 10
o'clock). [If L-size backdrop]: some elements STRADDLE the frame boundary.
[If S/M-size]: elements outside the frame with clear spacing.
Each element labeled with Chinese name + brief description (2-6 chars) +
annotation line + circled number ①②③.

[OPTIONAL] SIDE VERTICAL TEXT: wisdom quotes or couplets in vertical calligraphy
along left and/or right margins (e.g., "道可道，非常道" on left, "上善若水，厚德载物" on right).
```

### 子模式 B: scattered-concept（抽象哲理/品质清单）
无严格中心，概念图标自然散布：
```
Multiple concept illustrations scattered organically across the canvas.
Each concept has: small iconic illustration + bold Chinese character label +
brief annotation. Connected by subtle flowing lines.
```
适用：抽象品质清单、星座特质、无具体人物场景。
写实度：70-75%

---

## Elements 配置（v3.3 更新）

```yaml
layout: organic-poster + outer-border-frame (封面必加)
outer_frame: thin-border + [optional] corner-ornaments (云纹/龙纹/如意纹)
center_backdrop:
  shape: circular / rectangular / large-circular
  size: S(25-35%) / M(35-50%) / L(50-65%) — auto by element count
  tone: light-inkwash (default) / dark-indigo / dark-forest
  scene: landscape / starry-sky / bamboo / palace / forest-lighthouse
center_subject: main figure/object overlapping backdrop, warm glow effect
radial_elements: 6-12 objects at clock positions, ordered; can straddle frame (L-size)
annotations: numbered ①②③ + 2-6 char description, thin annotation lines per element
stamps: 2-4 corner stamps + 2-3 scattered stamps (total 4-7 red accents)
corner_ornaments: [optional] 云纹 / 龙纹 / 如意纹 at frame corners
side_text: [optional] vertical wisdom quotes at left/right margins
bottom_zone: dot-list / ribbon-banner / publisher-bar
paper: aged parchment (#E8D5B0), subtle warm yellowing at edges
realism_level: 70-75%
info_density: very-high
```

---

## Prompt 片段（封面 — focal-radial 子模式 A）v3.3

```
Chinese traditional encyclopedia illustration on aged warm parchment (#E8D5B0).
[realism_level]% photorealism with [100-realism_level]% hand-painted warmth.

OUTER FRAME: Thin rectangular decorative border line around the entire composition,
slightly inset (1-2% margin from canvas edges). Sepia brown (#5C3D2E) line.
[If cultural/zodiac theme]: Chinese-style corner ornaments — [cloud scrolls 云纹
/ dragon motifs 龙纹 / ruyi 如意纹] at four corners of the border frame.
NOT Victorian, NOT ornate Western.

CENTER BACKDROP: A [circular vignette / rectangular frame] at the center of the
image, [SIZE: see below] of canvas height.
  - [If ≤6 elements, small subject]: 25-35% canvas height (S)
  - [If 7-9 elements OR seated figure]: 35-50% canvas height (M)
  - [If ≥10 elements OR large scene]: 50-65% canvas height (L)
TONE: [default: atmospheric ink-wash, medium visibility] OR [dark theme:
deep indigo #1B2838 background with starry sky/galaxy/golden lighthouse light,
HIGH CONTRAST against surrounding warm parchment].
Contains atmospheric Chinese [mountain landscape / bamboo grove / starry sky /
palace courtyard / misty forest] scene. Frame border: thin decorative line.

CENTER SUBJECT (overlapping the backdrop frame): [描述主体 — 人物/器物/符号],
placed in front of the backdrop, creating depth layering. Warm golden radiant
glow (#F5C842) emanating softly from the main subject — creates visual hierarchy.
Fine-line ink contour with watercolor fills.

RADIAL ARRANGEMENT: [N] symbolic objects arranged at regular clock positions
around the center (12 o'clock, 2 o'clock, 4 o'clock... etc.).
[If L-size]: some elements STRADDLE the backdrop frame boundary — partially
inside, partially outside — breaking the rigid edge for depth.
[If S/M-size]: elements outside the frame with clear visual breathing room.
Each object is a detailed illustration with Chinese label + brief description
(2-6 chars) + numbered annotation ①②③④⑤⑥...

Loose scattered elements (ink drops, petals, coins) filling any remaining gaps.

Title in BOLD BRUSH CALLIGRAPHY STYLE (毛笔书法字体) at top: "[标题]".
Red square stamps: top-left「[左标]」, top-right「[右标]」.
[Optional] bottom-left「[左下标]」, bottom-right「[右下标]」(use for 文化/图鉴 themes).
Additional red seals: 「[印章1]」near [位置], 「[印章2]」near [位置].
[Optional] SIDE VERTICAL TEXT: "[左侧竖排金句]" along left margin,
"[右侧竖排金句]" along right margin — in brush calligraphy, reading top to bottom.
Bottom: [dot-separated attribute list / ribbon banner with text / publisher bar].
Credit: 作者：@知渡.

Paper: aged warm parchment (#E8D5B0), subtle paper grain, slight warm yellowing
at edges — NOT pure white, NOT heavy stains.
```

---

## Prompt 片段（内容页）

```
Chinese traditional encyclopedia illustration: knowledge infographic layout on
aged warm parchment (#E8D5B0).
Upper 45%: [specific scene] — historical Chinese figures illustrating [principle],
with [N] annotation lines to Chinese labels. Red square stamps at corners.
Brush calligraphy title "[核心词]" at top. Subtitle "[说明]" below.
Lower 50%: structured knowledge panels — [M] bordered boxes with:
  Left section: [知识块1] with ① ② ③ ④ numbered items
  Center: ✗ wrong example illustration (left) vs ✓ correct example (right)
  Right section: [工具/要素] diagram with labeled parts
Bottom: red-bordered summary box "[智慧点评文字]" in italic style (L7).
Credit: 作者：@知渡.
```

---

## 适用主题

人生哲理、传统规则、行为准则、方法论、秘诀/要诀、抽象品质清单

## 内容信号词

规则、行为、方法、秘诀、X种、X个、天规、不争、福报、处世、戒律、思维、之道

---

## Style Variant Adaptations（风格适配）

| 风格变体 | 中央背景框 | 主体光效 | 适配调整 |
|---------|-----------|---------|---------|
| **traditional-encyclopedia** | 圆形/方形景观框（山水/竹林） | 暖金色辉光 | 默认，使用上方 Prompt 片段 |
| **realistic-portrait** | 圆形自然场景框（写实风格） | 自然光 | 中央→写实主体；辐射→标注线+特征信息卡 |
| **anthropomorphic-portrait** | 圆形/方形（配合主题） | 暖光/自然光 | 拟人化角色穿衣持器，贴身名牌/旗帜标注 |

---

## 真实案例参考（v3.3 含尺寸档位）

| 封面 | 中央背景框 | 尺寸档 | 色调 | 主体 | 放射元素数 | 骑框 |
|------|-----------|-------|------|------|-----------|------|
| 道家处事之道（官方1） | 圆形（山水星空） | S-M | 淡彩水墨 | 莲花+双手 | ~10 | 否 |
| 道家处世之道（官方5） | 方形（山水画） | M | 淡彩水墨 | 道士坐像 | ~11 | 否 |
| 处理问题的10个思维 | 大圆形（森林灯塔） | L (55%+) | **深靛蓝** | 发光容器 | 10 | **是** |
| 曾国藩十一条戒律 | 方形（宫廷景观） | M | 淡彩水墨 | 曾国藩坐像 | ~11 | 否 |
| 人生十则 | 方形（山水窗景） | M | 淡彩水墨 | 毛笔书法"名" | 10 | 否 |
