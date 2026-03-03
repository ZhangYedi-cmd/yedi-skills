# Color Palettes 色彩体系

## 核心色板（共享）— 对标万物图鉴实测色调

| 角色 | 色值 | 用途 |
|------|------|------|
| 纸张主色 | #F0E0C0 仿宣纸米黄, #E8D5B0 暖褐底, #EDE0C8 淡褐 | 背景（比纯羊皮纸更暖、更接近中国宣纸） |
| 墨色主调 | #3A2A1A 深棕墨, #5C3D2E 棕褐, #8B6914 暖褐 | 文字、线条、边框 |
| 结构色 | #C0392B 朱砂红, #922B21 深朱红 | 角标印章、重点标题、✓✗ 图标 |
| 知识框色 | #D4A853 琥珀黄, #FFBF00 亮琥珀 | 知识框边线、编号底色 |
| 自然插画 | #4A7C59 深翠绿, #2E6B3E 墨绿, #8B1A1A 深红 | 植物/山水插画点缀（高于整体饱和度） |
| 笔记框底 | #FAF3E8 极淡米白 | 知识块内部填色，与底纸区分 |
| 禁用 | 霓虹, 荧光, 纯黑大面积, 冷蓝, 冷白 | — |

> **关键区别**：博主用的不是西方博物馆羊皮纸调，而是**中国宣纸/旧书纸调**——底色偏米白偏暖，文字用深棕墨（非纯黑），植物/自然图画局部饱和度高（翠绿、深红），但整体背景保持低饱和。

## Theme Color System（主题色系统）v2.0（可选，需要为主体分配特定色彩时使用）

每个主题/角色分配一个主色调：

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

## Color Energy Levels（色彩能量级别）

| 级别 | 饱和度 | 背景处理 | 主体色彩 | 光效 | 适用风格 |
|------|--------|---------|---------|------|---------|
| ~~MUTED~~ | ~~20-40%~~ | ~~（v1.0 默认，已废弃）~~ | — | 无 | ~~废弃~~ |
| **WARM** | 40-65% | 经典宣纸底，暖色哑光 | 自然主体用**更饱和**色彩做刻意对比 | 微妙暖光 | traditional-encyclopedia |
| **VIBRANT** | 60-85% | 淡化纸质感，偏向氛围渲染 | 全面丰富饱和 | 自然光/金光 | realistic-portrait |

## Light Effect Descriptions（光效描述库）

| 光效类型 | Prompt 片段 |
|---------|------------|
| natural-warm | `warm natural side-lighting, soft golden hour quality, gentle highlights on key features` |
| ink-atmospheric | `subtle ink-wash mist effects at edges, atmospheric depth, faint cloud wisps` |

## Per-Style Color Templates（按风格的色彩模板）

### realistic-portrait
```
Color energy: VIBRANT. Rich natural colors with detailed gradations and realistic
color temperature. Subjects rendered at full saturation with fine texture details.
Warm neutral background with subtle paper texture. Natural warm side-lighting creates
soft shadows and depth. Environmental color reflections on subject surfaces.
```

### traditional-encyclopedia（升级版）
```
Color energy: WARM. Background: aged xuan paper (#F0E0C0 to #E8D5B0), warm matte.
Ink: deep sepia brown (#3A2A1A). Accents: BOLD cinnabar red (#C0392B) for stamps,
BRIGHT amber gold (#FFBF00) for knowledge frames. Natural subjects (plants, animals,
costumes) use RICHER, MORE SATURATED colors as deliberate contrast — not faded, not
muted. Overall warmer and more alive than v1.0.
AVOID: neon, fluorescent, pure black fills, cold blue/white.
```

## 构图色调偏向（次于风格变体的色彩能量级别）
- group-portrait: 暖米底 + 翠绿/深红自然色（植物饱和度高）
- center-radial: 暖米底 + 朱砂标注线 + 琥珀知识框
- infographic: 琥珀编号色 + 朱红箭头
- scattered-icons: 暖色底 + 朱砂红点缀 + 自然色系图标
- grid-collage: 旧金边框 + 深棕分类标签
- anatomy-atlas: 暖米底 + 高饱和自然插画 + 朱砂标注线

## 角标印章色
朱砂红方形印章 `#C0392B`，填色文字用白或极淡米（非纯白）。
印章字体：黑体或仿宋，2-4个汉字（如「图鉴」「天规」「宝地」「百科」）。
