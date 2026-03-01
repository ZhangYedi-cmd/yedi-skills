# Prompt Assembly 提示词组装

## 9 模块结构

```
[1. Image Spec]     — 方向/比例/风格声明
[2. Style Base]     — 统一风格基底（所有图一致，逐字保持）
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
Create a vintage Chinese encyclopedia illustration for Xiaohongshu.
Orientation: [Portrait/Landscape]. Aspect Ratio: [3:4 / 1792×2400].
Style: Detailed semi-realistic Chinese historical illustration with knowledge
infographic overlay. Quality: Museum-grade detail.
```

## Module 2: Style Base（所有图完全一致的锚点）⚠️ 同系列逐字保持

> **风格对标：小红书账号「万物图鉴」的实际发布风格**

```
Visual Style (CRITICAL — match WanWuTuJian XHS aesthetic):
- Chinese traditional encyclopedia illustration aesthetic
- Detailed semi-realistic illustration of historical Chinese figures, plants,
  animals and landscapes — NOT Western natural history watercolor plates
- Illustration technique: fine-line ink contour + watercolor fill, similar to
  Chinese historical painting (历史图鉴风格), NOT 19th-century European plates
- Traditional Chinese figures wear historical robes (汉服/布衣/文人服), depicted
  with narrative and expressive quality
- Background: aged Chinese xuan paper / old book page texture (#F0E0C0 to
  #E8D5B0), warm matte yellowed surface, subtle fold marks and age spots
- Warm muted palette for background; natural subjects (plants, landscapes) use
  richer saturated greens and reds as contrast
- Knowledge infographic overlay: structured text blocks, boxed knowledge panels,
  ✓/✗ comparison icons, numbered sections ①②③ are layered OVER the illustration
- Corner stamps: red square Chinese character stamps (like 「图鉴」「天规」) at
  top corners — NOT Victorian flourishes or Latin text
- NO faux-Latin scientific names (这是中国传统文化内容，无拉丁学名)
- NO neon, fluorescent, pure black fills, cold white, Western Victorian border
```

## Module 3: Variant
从 `references/variants/<variant>.md` 加载核心视觉特征和 prompt 片段。

## Module 4: Layout
从 `references/layouts/` 加载对应构图的 prompt 模板。

## Module 5: Content
```
Page Content:
- Main subject: [描述]
- Corner stamp left-top: [系列标签，如"图鉴"/"天规第一"]
- Corner stamp right-top: [主题词，如"匠人风骨"/"悬壶济世"]
- Annotation points: [标注列表]
- Knowledge blocks: [知识框内容，如"四层意义：①... ②... ③... ④..."]
- Comparison scenes: [✓正确场景 / ✗错误场景]
- Scene vignettes: [场景小图描述]
```

## Module 6: Chinese Text
```
Text (render in image):
- Main title (very large, bold, top center): [主标题，如"师不顺路"]
- Subtitle (medium, below title): [说明短语，如"中国传统八大天规之首"]
- English subtitle (small serif): [English · Keywords]
- Category line (small, below English): [属性1｜属性2｜属性3]
- Corner label top-left (red square): [系列标签]
- Corner label top-right (red square): [主题词]
- Knowledge block headers: [各框标题]
- Annotation labels (with lines): [标注1→位置], [标注2→位置]...
- Credit (small, bottom): 作者：@[署名]
```

## Module 7: Decorations
```
Decorations:
- Red square corner stamps at top-left and top-right with Chinese characters
- Thin-bordered knowledge boxes organized in grid or column layout
- Annotation lines with Chinese labels
- Ink-wash mountain or mist corner decorations (subtle)
- Aged paper texture: fold marks, age spots, worn edges
- [如有对比]✓ checkmark (green/dark) and ✗ cross (red) comparison icons
- [如有工具]Tool/item diagram with labeled parts
```

## Module 8: Negative
```
AVOID: Western Victorian ornamental border, faux-Latin scientific names,
photorealistic photography, 3D CGI render, anime/manga style, neon colors,
fluorescent, cold blue/white tones, pure black fills, modern minimalist design,
dark background.
```

## Module 9: Watermark
```
Subtle watermark "[内容]" at [位置], legible but not distracting.
```

## 模型适配
| 模型 | 注意 |
|------|------|
| Gemini 3 | 长 prompt 理解好，直接用完整结构；对中文文字渲染相对最好 |
| GPT-4o | 不支持 negative prompt，正向描述中写"NOT Victorian, NOT Latin text"；中文渲染一般 |
| Nano Banana | 尾部加 `Please use nano banana pro to generate.` |

## Session 一致性
同系列所有图保持相同的 **Module 2（逐字一致）**、纸张色调、角标印章风格、署名。
每张图的 Module 6 中角标内容可按页面主题变化（如 天规第一/第二/第三...）。

## 封面 vs 内容页的组装差异

### 封面页（Cover）
- Module 4 用 `center-radial` 或 `grid-surround`
- Module 5 主体是多个人物/物品的全景汇总，展示所有核心元素
- Module 6 标题最大，英文副标题完整，两个角标都放系列标签

### 内容页（Content Pages）
- Module 4 用 `annotated` 或 `knowledge-split`（上图下知识/左图右知识）
- Module 5 重点是知识块叠层：每页一个核心规则，4-8个知识区块
- Module 6 左上角标为"天规第X"，右上角标为该页主题词，主标题是核心词
