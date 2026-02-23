# Prompt Assembly 提示词组装

## 9 模块结构

```
[1. Image Spec]     — 方向/比例/风格声明
[2. Style Base]     — 统一风格基底（所有图一致）
[3. Variant]        — 变体特征
[4. Layout]         — 构图模板
[5. Content]        — 本页具体内容
[6. Chinese Text]   — 中文文字（直接写入尝试渲染）
[7. Decorations]    — 装饰细节
[8. Negative]       — 排除项
[9. Watermark]      — 水印（如启用）
```

## Module 1: Image Spec
```
Create a vintage scientific encyclopedia illustration.
Orientation: [Portrait/Landscape]. Aspect Ratio: [9:16/16:9].
Style: Hand-painted watercolor illustration. Quality: Museum-grade detail.
```

## Module 2: Style Base（所有图完全一致的锚点）
```
Visual Style (CRITICAL):
- 19th-century natural history illustration aesthetic
- Hand-painted watercolor and colored pencil technique
- NOT photorealistic, NOT digital art, NOT anime/cartoon
- Aged parchment background (#F5E6D3), yellowed, subtle stains, worn edges
- Warm palette: browns (#8B6914, #D2691E), amber (#FFBF00), cream, ivory
- Accents: vermillion red (#C55A5A) for stamps, deep blue (#2C3E6B) for Latin
- No neon, no fluorescent, no pure black fills
```

## Module 3: Variant
从 `references/variants/<variant>.md` 加载核心视觉特征和 prompt 片段。

## Module 4: Layout
从 `references/layouts/` 加载对应构图的 prompt 模板。

## Module 5: Content
```
Page Content:
- Main subject: [描述]
- Annotation points: [标注列表]
- Scene vignettes: [场景描述]
- Data charts: [图表描述]
- Humor: [金句/吐槽]
```

## Module 6: Chinese Text
```
Text (render in image):
- Title (large, bold, top): 「[中文标题]」
- Subtitle (below): [英文]
- Faux-Latin (italic, corners): [学名]
- Labels (hand-written, with lines): [标注1→位置], [标注2→位置]...
- Credit (small, bottom): [署名]
```

## Module 7: Decorations
```
Decorations: annotation lines, magnified insets showing [细节],
red seal stamp at [位置], [边框类型] border, aged paper texture.
```

## Module 8: Negative
```
AVOID: photorealistic, 3D render, digital art, neon, fluorescent,
dark background, anime, cartoon, pixel art.
```

## Module 9: Watermark
```
Subtle watermark "[内容]" at [位置], legible but not distracting.
```

## 模型适配
| 模型 | 注意 |
|------|------|
| Gemini 3 | 长 prompt 理解好，直接用完整结构 |
| GPT-4o | 不支持 negative prompt，正向描述中写"NOT photorealistic" |
| Nano Banana | 尾部加 `Please use nano banana pro to generate.` |

## Session 一致性
同系列所有图保持相同的 Module 2（逐字一致）、色彩、纸张、伪学名、署名。
