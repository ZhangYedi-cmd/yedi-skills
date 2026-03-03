# Illustration Style Variants 插画风格变体 — v3.1

## Overview

博主 @知渡 根据内容类型使用不同的视觉风格。每种风格变体定义：画技、角色渲染、色彩能量、光效、背景处理。

**核心规则**：同系列所有图使用同一风格变体（Module 2 逐字一致），不同系列可使用不同变体。

---

## 写实度参数 realism_level（v3.1 新增）

动态控制插画的写实程度（70-85%），避免过于卡通或过于照片化。

**Prompt 写法**：
```
[X]% photorealism with [100-X]% hand-painted artistic warmth.
Visible brushstrokes and painterly quality — NOT photographic, NOT CGI, NOT 3D render.
```

**按内容类型自动映射**：

| 内容信号词 | 写实度 |
|-----------|--------|
| 犬种/猫种/动物品种/花卉鉴赏 | 80-85% |
| 品种/种类/分类/图鉴/食材/药材 | 80-85% |
| 合集/国粹/民俗/习俗/文化 | 75-80% |
| 星座/MBTI/性格/人格类型 | 75-80% |
| 解析/成分/结构/功效/本草 | 75-80% |
| 规则/行为/方法/秘诀/X种/X个 | 70-75% |
| 福报/功德/因果/修行/天规/佛道 | 70-75% |
| 步骤/教程/怎么做/流程/指南 | 70-75% |
| 人生/哲理/道理/准则/十则 | 70-75% |

---

## 2 种风格变体

### 1. realistic-portrait（写实群像）

> **来源**：护主狗系列、动植物写实肖像

| 维度 | 描述 |
|------|------|
| **画技** | 高品质博物插画，田野图鉴级别，可见笔触画感 |
| **角色风格** | 精准博物插画，可见笔触，略带表情神韵，**非照片级**，有画家手感 |
| **角色占比** | 45-55% 画面 |
| **色彩能量** | NATURAL（丰富自然色，精细色彩过渡，50-75%饱和度） |
| **光效** | 自然光线 — 温暖侧光、柔和阴影、环境反射；无超自然光效 |
| **背景** | 干净暖色底(#F5EED8~#FAF5EC)，极少纸质纹理，焦点在主体 |
| **信息密度** | MEDIUM-HIGH（8-12元素）— 主体之美为优先 |
| **信息模块** | 标注线、品种/物种信息卡、对比表、详细标签系统 |
| **适用** | 犬种/猫种图鉴、植物鉴赏、食材/药材深度解析 |

**Prompt 片段**：
```
High-quality naturalist illustration, field-guide quality with visible brushwork.
[realism_level]% photorealism with [100-realism_level]% hand-painted artistic warmth.
Fine fur/feather/petal textures, accurate proportions, detailed color gradations,
painterly quality — NOT photographic, NOT CGI, NOT 3D render.
Subject occupies 45-55% of canvas.
Natural warm side-lighting with soft shadows and environmental reflections.
Background: clean warm cream (#F5EED8~#FAF5EC), minimal paper texture.
Color energy: NATURAL — rich natural colors with refined saturation on subjects.
```

---

### 2. traditional-encyclopedia（传统百科）— 升级版默认

> **来源**：当前默认风格，v3.0 升级背景+色彩

| 维度 | 描述 |
|------|------|
| **画技** | 细线勾勒+水彩填色，中国历史百科插画风格（历史图鉴） |
| **角色风格** | 传统中国古代人物，着汉服/布衣，半写实叙事风格 |
| **角色占比** | 35-45% 画面 |
| **色彩能量** | WARM（自然主体色彩**更饱和**，与暖色底纸形成刻意对比） |
| **光效** | 关键元素微妙暖光；边缘水墨氛围效果；无戏剧性光线 |
| **背景** | **干净暖色宣纸** (#F5EED8~#FAF5EC)，微妙纸质纹理，**无重度做旧** |
| **信息密度** | HIGH（10-15元素） |
| **信息模块** | 知识框、标注线、✓/✗对比、编号步骤、工具图解、智慧金句框 |
| **适用** | 通用知识百科、教程/步骤、历史文化、分类大全 — 万能默认风格 |

**Prompt 片段**：
```
Chinese traditional encyclopedia illustration (历史图鉴风格).
[realism_level]% photorealism with [100-realism_level]% hand-painted artistic warmth.
Fine-line ink contour + watercolor fill. Traditional Chinese figures in
historical robes with narrative quality.
Background: clean warm cream paper (#F5EED8~#FAF5EC) with subtle paper grain only.
NO heavy aging, NO dark stains, NO fold marks, NO torn edges.
Color energy: WARM — muted warm background BUT natural subjects use RICHER,
MORE SATURATED colors as deliberate contrast; cinnabar red (#C0392B) and amber
gold (#FFBF00) accents are BOLD, not faded. Knowledge infographic overlay with
structured text blocks, boxed panels, ✓/✗ comparison icons, numbered ①②③.
```

---

## Style Selection Matrix（自动推荐）

| 内容信号词 | 推荐风格 | 色彩能量 | 写实度 |
|-----------|---------|---------|--------|
| 星座/MBTI/性格/人格类型/XX座 | traditional-encyclopedia | WARM | 75-80% |
| 福报/功德/因果/修行/天规/佛道 | traditional-encyclopedia | WARM | 70-75% |
| 犬种/猫种/动物品种/花卉鉴赏 | realistic-portrait | NATURAL | 80-85% |
| 品种/种类/分类/大全/图鉴 | traditional-encyclopedia | WARM | 75-80% |
| 规则/行为/方法/秘诀/X种/X个 | traditional-encyclopedia | WARM | 70-75% |
| 步骤/教程/怎么做/流程/指南 | traditional-encyclopedia | WARM | 70-75% |
| 人生/哲理/道理/准则/十则 | traditional-encyclopedia | WARM | 70-75% |
| 合集/国粹/民俗/习俗/文化 | traditional-encyclopedia | WARM | 75-80% |
| 解析/成分/结构/功效/本草 | traditional-encyclopedia | WARM | 75-80% |

---

## Color Energy Levels（色彩能量级别）

| 级别 | 描述 | 饱和度范围 | 光效 | 适用风格 |
|------|------|----------|------|---------|
| ~~MUTED~~ | ~~（v1.0 默认，已废弃）~~ | ~~20-40%~~ | 无 | ~~废弃~~ |
| **WARM** | 暖色强调+哑光底色，新默认 | 40-65% | 微妙暖光 | traditional-encyclopedia |
| **NATURAL** | 丰富自然色，精细过渡，有画感 | 50-75% | 自然光 | realistic-portrait |

> **说明**：v3.1 将 realistic-portrait 的 VIBRANT 更名为 NATURAL，强调"自然画感"而非"全面高饱和"，避免过于卡通化的高彩倾向。

---

## Theme Color Palette（主题色板）— 可选

主题色仅在需要为特定主题/角色分配专属色调时使用：

| 名称 | Hex | 适用主题 |
|------|-----|---------|
| fire-red | #FF4500 | 火象星座、热血、战斗 |
| ocean-blue | #1E90FF | 水象星座、温柔、智慧 |
| forest-green | #228B22 | 自然、稳重、财富 |
| royal-gold | #FFD700 | 王者、权威、神圣 |
| earth-brown | #8B4513 | 踏实、传统、自然 |
| jade-green | #00A86B | 翠绿、东方、清新 |

---

## Light Effect Descriptions（光效描述库）

| 光效类型 | Prompt 片段 | 适用场景 |
|---------|------------|---------|
| natural-warm | `warm natural side-lighting, soft golden hour quality, gentle highlights on key features` | 写实/自然光 |
| ink-atmospheric | `subtle ink-wash mist effects at edges, atmospheric depth, faint cloud wisps` | 传统百科 |
