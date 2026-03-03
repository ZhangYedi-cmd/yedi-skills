# Illustration Style Variants 插画风格变体

## Overview

博主 @知渡 根据内容类型使用不同的视觉风格。每种风格变体定义：画技、角色渲染、色彩能量、光效、背景处理。

**核心规则**：同系列所有图使用同一风格变体（Module 2 逐字一致），不同系列可使用不同变体。

## 2 种风格变体

### 1. realistic-portrait（写实群像）

> **来源**：护主狗系列、动植物写实肖像

| 维度 | 描述 |
|------|------|
| **画技** | 细腻半写实绘画，丰富纹理和自然光影 |
| **角色风格** | 写实比例，细腻毛发/羽毛/花瓣纹理，照片级主体细节 |
| **角色占比** | 45-55% 画面 |
| **色彩能量** | VIBRANT（丰富自然色，细腻色彩过渡） |
| **光效** | 自然光线 — 温暖侧光、柔和阴影、环境反射；无超自然光效 |
| **背景** | 温暖中性色+微妙纸质感，焦点完全在主体写实度和细节上 |
| **信息密度** | MEDIUM-HIGH（8-12元素） — 主体之美为优先 |
| **信息模块** | 标注线、品种/物种信息卡、对比表、详细标签系统 |
| **适用** | 犬种/猫种图鉴、植物鉴赏、食材/药材深度解析、任何以主体写实为核心吸引力的主题 |

**Prompt 片段**：
```
Detailed semi-realistic painting with rich texturing and natural lighting.
Photographic-level detail: fine fur/feather/petal textures, realistic
proportions, detailed color gradations. Subject occupies 45-55% of canvas.
Natural warm side-lighting with soft shadows and environmental reflections.
Background: warm neutral with subtle paper texture, focus on subject realism.
Color energy: VIBRANT — rich natural colors with full saturation on subjects.
```

---

### 2. traditional-encyclopedia（传统百科）— 升级版默认

> **来源**：当前默认风格，v2.0 升级色彩活力

| 维度 | 描述 |
|------|------|
| **画技** | 细线勾勒+水彩填色，中国历史百科插画风格（历史图鉴） |
| **角色风格** | 传统中国古代人物，着汉服/布衣，半写实叙事风格 |
| **角色占比** | 35-45% 画面 |
| **色彩能量** | WARM（升级自 v1.0 MUTED — 自然主体色彩**更饱和**，与暖色底纸形成刻意对比） |
| **光效** | 关键元素微妙暖光；边缘水墨氛围效果；无戏剧性光线 |
| **背景** | 经典仿古宣纸（#F0E0C0~#E8D5B0），折痕污渍，暖色哑光 |
| **信息密度** | HIGH（10-15元素） |
| **信息模块** | 知识框、标注线、✓/✗对比、编号步骤、工具图解、智慧金句框 |
| **适用** | 通用知识百科、教程/步骤、历史文化、分类大全 — 万能默认风格 |

**Prompt 片段**：
```
Chinese traditional encyclopedia illustration (历史图鉴风格).
Fine-line ink contour + watercolor fill. Traditional Chinese figures in
historical robes with narrative quality. Aged xuan paper background
(#F0E0C0~#E8D5B0) with fold marks and age spots.
Color energy: WARM — muted warm background BUT natural subjects use RICHER,
MORE SATURATED colors as deliberate contrast; cinnabar red and amber gold
accents are BOLD, not faded. Knowledge infographic overlay with structured
text blocks, boxed panels, ✓/✗ comparison icons, numbered ①②③.
```

---

## Style Selection Matrix（自动推荐）

| 内容信号词 | 推荐风格 | 色彩能量 | 备选风格 |
|-----------|---------|---------|---------|
| 星座/MBTI/性格/人格类型/XX座 | traditional-encyclopedia | WARM | traditional-encyclopedia |
| 福报/功德/因果/修行/天规/佛道 | traditional-encyclopedia | WARM | traditional-encyclopedia |
| 犬种/猫种/动物品种/花卉鉴赏 | realistic-portrait | VIBRANT | group-portrait (traditional) |
| 品种/种类/分类/大全/图鉴 | traditional-encyclopedia | WARM | realistic-portrait |
| 规则/行为/方法/秘诀/X种/X个 | traditional-encyclopedia | WARM | realistic-portrait |
| 步骤/教程/怎么做/流程/指南 | traditional-encyclopedia | WARM | — |
| 人生/哲理/道理/准则/十则 | traditional-encyclopedia | WARM | realistic-portrait |
| 合集/国粹/民俗/习俗/文化 | traditional-encyclopedia | WARM | — |
| 解析/成分/结构/功效/本草 | traditional-encyclopedia | WARM | realistic-portrait |

## Color Energy Levels（色彩能量级别）

| 级别 | 描述 | 饱和度范围 | 光效 | 适用风格 |
|------|------|----------|------|---------|
| ~~MUTED~~ | ~~（v1.0 默认，已废弃）~~ | ~~20-40%~~ | 无 | ~~废弃~~ |
| **WARM** | 暖色强调+哑光底色，新默认 | 40-65% | 微妙暖光 | traditional-encyclopedia |
| **VIBRANT** | 全面丰富饱和色 | 60-85% | 自然光/金光 | realistic-portrait |

## Theme Color Palette（主题色板）

主题色为可选项，在需要为特定主题/角色分配专属色调时使用：

| 名称 | Hex | 适用主题 |
|------|-----|---------|
| fire-red | #FF4500 | 火象星座、热血、战斗 |
| ocean-blue | #1E90FF | 水象星座、温柔、智慧 |
| forest-green | #228B22 | 自然、稳重、财富 |
| royal-gold | #FFD700 | 王者、权威、神圣 |
| ice-crystal | #87CEEB | 冷静、高冷、理性 |
| mystic-purple | #7B68EE | 神秘、灵性、创意 |
| earth-brown | #8B4513 | 踏实、传统、自然 |
| sakura-pink | #FFB7C5 | 浪漫、温馨、女性 |
| sunset-amber | #FF8C00 | 热情、活力、冒险 |
| jade-green | #00A86B | 翠绿、东方、清新 |
| crimson-warrior | #DC143C | 勇气、激情、果断 |
| midnight-indigo | #4B0082 | 深邃、孤独、出尘 |

## Light Effect Descriptions（光效描述库）

| 光效类型 | Prompt 片段 | 适用场景 |
|---------|------------|---------|
| natural-warm | `warm natural side-lighting, soft golden hour quality, gentle highlights on key features` | 写实/自然光 |
| ink-atmospheric | `subtle ink-wash mist effects at edges, atmospheric depth, faint cloud wisps` | 传统百科 |
