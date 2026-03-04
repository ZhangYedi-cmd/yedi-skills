# Color Palettes 色彩体系 — v3.1

## 核心色板（共享）— 对标万物图鉴实测色调（v3.2 校准）

| 角色 | 色值 | 用途 |
|------|------|------|
| 纸张主色 | **#E8D5B0** 做旧暖褐, #D4BE9A 深暖褐 | 背景（v3.2 还原：偏暖褐做旧感） |
| 纸张浅色 | #F5EED8 暖米白 | 知识块内部填色区域 |
| 墨色主调 | #3A2A1A 深棕墨, #5C3D2E 棕褐, #8B6914 暖褐 | 文字、线条、外框边线 |
| 结构色 | **#C0392B 朱砂红**, #922B21 深朱红 | 角标印章、散布印章、标题强调、✓✗图标 |
| 知识框色 | #D4A853 琥珀黄, #FFBF00 亮琥珀 | 知识框边线、编号底色 |
| 中央辉光 | #F5C842 暖金, #FFF3AA 浅金 | 中央主体发光效果（center-radial 专用） |
| 自然插画 | #4A7C59 深翠绿, #2E6B3E 墨绿, #8B1A1A 深红 | 植物/山水插画（高于整体饱和度） |
| 笔记框底 | #FAF3E8 极淡米白 | 知识块内部填色，与底纸区分 |
| 禁用 | 霓虹, 荧光, 纯黑大面积, 冷蓝, 冷白 | — |

> **v3.2 关键更新**：纸张底色从 v3.1 的 #F5EED8（偏白）回调为 #E8D5B0（偏暖褐），还原万物图鉴封面实测做旧宣纸感。新增中央辉光色。
> **做旧标准**：边缘轻微暖黄晕染，无折痕、无大污渍、无撕边。

---

## 红色分布系统（v3.1 新增 — 朱砂红贯穿全画）

v3.1 从"2 角标"升级为"全画面红色分布"，参照 @知渡 参考图的密集用印风格：

| 红色元素 | 数量 | 位置 |
|---------|------|------|
| 固定角标印章 | 2 | 左上 + 右上 |
| 散布主题印章 | 2-3 | 主体附近、画面中部 |
| L6 「」关键词标签 | 3-6 | 主体下方水平一行 |
| 标注线强调色 | 部分 | 重要标注线用朱砂红 |
| L7 引用框边线 | 1 | 底部智慧框 |

**总计**：全画面分布 6-12 处朱砂红元素，视觉贯穿全图。

**Prompt 片段**：
```
Cinnabar red (#C0392B) distributed throughout: corner stamps top-left and top-right,
[N] additional red seal stamps scattered at [positions], horizontal row of keyword
tags with red borders below main subject, red-bordered wisdom quote at bottom.
Total 6-12 red accents across entire image.
```

---

## Color Energy Levels（色彩能量级别）

| 级别 | 饱和度 | 背景处理 | 主体色彩 | 光效 | 适用风格 |
|------|--------|---------|---------|------|---------|
| ~~MUTED~~ | ~~20-40%~~ | ~~（v1.0 废弃）~~ | — | 无 | ~~废弃~~ |
| **WARM** | 40-65% | 干净暖米底(#F5EED8)，微妙纸纹 | 自然主体用**更饱和**色彩对比 | 微妙暖光 | traditional-encyclopedia |
| **NATURAL** | 50-75% | 干净暖底，极少纸纹 | 全面丰富自然色，有画感 | 自然光 | realistic-portrait |

> **v3.1 更名**：`VIBRANT` → `NATURAL`，强调"自然画感"而非"全面高饱和"，避免过卡通化。

---

## Light Effect Descriptions（光效描述库）

| 光效类型 | Prompt 片段 |
|---------|------------|
| natural-warm | `warm natural side-lighting, soft golden hour quality, gentle highlights on key features` |
| ink-atmospheric | `subtle ink-wash mist effects at edges, atmospheric depth, faint cloud wisps` |

---

## Per-Style Color Templates（按风格的色彩模板）

### realistic-portrait（v3.0 更新）
```
Color energy: NATURAL. Rich natural colors with detailed gradations and
painterly quality — fine texture details, visible brushwork, not photographic.
Background: clean warm cream (#F5EED8~#FAF5EC), minimal paper grain only.
Natural warm side-lighting creates soft shadows and depth.
Environmental color reflections on subject surfaces.
```

### traditional-encyclopedia（v3.2 校准）
```
Color energy: WARM. Background: aged warm parchment (#E8D5B0), subtle paper grain,
slight warm yellowing towards edges — NOT pure white, gives authentic encyclopedia feel.
Ink: deep sepia brown (#3A2A1A). Accents: BOLD cinnabar red (#C0392B) for stamps
and keyword tags, BRIGHT amber gold (#FFBF00) for knowledge frames.
Center subject (center-radial): soft warm golden glow (#F5C842) emanating from
main subject — radiant warmth, NOT supernatural neon, NOT cold blue light.
Natural subjects (plants, animals, costumes) use RICHER, MORE SATURATED colors as
deliberate contrast — not faded, not muted.
AVOID: neon, fluorescent, pure black fills, cold blue/white, pure white background.
```

---

## 构图色调偏向

- group-portrait: 暖米底 + 翠绿/深红自然色（植物饱和度高）+ 散布朱砂印章
- center-radial: 暖米底 + 朱砂标注线 + 琥珀知识框 + 散布印章
- infographic: 琥珀编号色 + 朱红箭头 + 步骤框
- anatomy-atlas: 暖米底 + 高饱和自然插画 + 朱砂标注线 + 金属闪光

---

## 角标印章色

朱砂红方形印章 `#C0392B`，填色文字用白或极淡米（非纯白）。
印章字体：黑体或仿宋，2-4个汉字（如「图鉴」「天规」「宝地」「百科」）。
散布印章同色系，可略小于角标印章。
