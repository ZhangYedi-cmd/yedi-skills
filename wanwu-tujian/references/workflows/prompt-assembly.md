# 万物图鉴 提示词组装

## 9 模块结构

```
[1. Image Spec]     — 方向/比例/风格声明
[2. Style Base]     — 统一风格基底（所有图一致，逐字保持）⚠️ CRITICAL
[3. Composition]    — 构图特征（从 compositions/*.md 加载）
[4. Layout]         — 版面模板（从 layouts/*.md 加载）
[5. Content]        — 本页具体内容
[6. Chinese Text]   — 中文文字（直接写入尝试渲染）
[7. Decorations]    — 装饰细节
[8. Negative]       — 排除项
[9. Watermark]      — 水印（如启用）
```

## Module 1: Image Spec
```
Create a [STYLE_NAME] illustration for Xiaohongshu.
Orientation: [Portrait/Landscape]. Aspect Ratio: [3:4 / 1792×2400].
Style: [STYLE_DESCRIPTION]. Quality: Museum-grade detail.
```

| Style Variant | STYLE_DESCRIPTION |
|---------------|-------------------|
| cartoon-infographic | Vibrant cartoon-infographic with chibi characters and extreme information density |
| celestial-narrative | Dramatic celestial/xianxia painting with divine golden light effects |
| realistic-portrait | Detailed semi-realistic portrait with rich textures and natural lighting |
| traditional-encyclopedia | Chinese traditional encyclopedia illustration with knowledge infographic overlay |

## Module 2: Style Base — 4 Named Variants ⚠️ CRITICAL

> **规则**：同系列选择一个变体，所有图逐字一致。不同系列可使用不同变体。
> **风格对标：小红书账号「万物图鉴」(@知渡) 的实际发布风格**
> **详细参考**：`references/elements/illustration-styles.md`

### Variant A: cartoon-infographic（卡通信息图）— 互动量最高
```
Visual Style (CRITICAL — WanWuTuJian cartoon-infographic variant):
- Modern cartoon/chibi illustration blended with traditional Chinese elements
- Characters: semi-chibi style with expressive cartoon faces, large eyes,
  exaggerated charming proportions — NOT stiff realistic historical figures
- Each character has a unique THEME COLOR: [THEME_COLOR] saturating their
  costume, accessories, and surrounding energy aura at maximum vibrancy
- Character occupies 35-40% of canvas, vibrant and eye-catching, dynamic pose
- Light effects: glowing [LIGHT_TYPE] aura around character, particle effects,
  energy wisps in theme color — the character RADIATES color and energy
- Background: aged paper texture but BRIGHTER and more LUMINOUS than traditional;
  paper is secondary to the vibrant character art and colorful info modules
- Color energy: RADIANT — maximum saturation on characters and info panels,
  background stays warm but luminous, every element pops with vivid color
- Information modules: achievement badge columns (LEFT), behavior comic strips
  (RIGHT), radar charts, tag clouds, growth comics, humor quote boxes —
  EXTREMELY high information density (15-20 distinct elements per page)
- Corner stamps: red square Chinese character stamps at top corners
- Credit: 作者：@知渡
- NO muted/flat/plain illustration; NO stiff historical realism;
  NO Western Victorian elements; NO faux-Latin
```

### Variant B: celestial-narrative（仙侠叙事）
```
Visual Style (CRITICAL — WanWuTuJian celestial-narrative variant):
- Xianxia/celestial-style fine painting with dramatic divine atmosphere
- Characters: full-body divine/immortal figures in flowing colorful robes,
  sacred postures, graceful movement — spiritual and majestic quality
- Robes in rich saturated hues: deep crimson, royal purple, celestial blue,
  emerald green — flowing and dynamic, NOT flat or stiff
- Divine golden light: warm amber rays emanating from figures, sacred glow
  halos, floating golden particles, heavenly atmospheric effects
- Multiple figures possible, each in distinct colorful flowing robes
- Background: deep celestial backdrop with golden-amber gradients, layered
  clouds, heavenly atmosphere — minimal paper texture, DRAMATIC atmosphere
- Color energy: VIBRANT — rich saturated robes against warm golden atmospheric
  background; the scene GLOWS with divine warmth
- Knowledge overlay with traditional boxed panels, but subordinate to the
  dramatic visual narrative
- Corner stamps: red square Chinese character stamps at top corners
- Credit: 作者：@知渡
- NO flat/muted illustration; NO cartoon/chibi; NO cold tones;
  NO Western Victorian elements; NO faux-Latin
```

### Variant C: realistic-portrait（写实群像）
```
Visual Style (CRITICAL — WanWuTuJian realistic-portrait variant):
- Detailed semi-realistic painting with rich texturing and natural lighting
- Subjects: photographic-level detail in animal/plant/object rendering,
  detailed fur/feather/petal textures, realistic proportions
- Rich color gradations, realistic color temperature, full saturation on
  natural subjects — fur has multiple color tones, eyes are detailed
- Natural warm side-lighting with soft shadows and environmental reflections
- Subject occupies 45-55% of canvas, richly detailed and textured
- Background: warm neutral with subtle paper texture, focus entirely on
  subject realism; environmental context where appropriate
- Color energy: VIBRANT — rich natural colors at full saturation; the subject
  is the visual star with maximum detail and color richness
- Knowledge panels: species/variety info cards, annotation systems,
  comparison tables with clean layout
- Corner stamps: red square Chinese character stamps at top corners
- Credit: 作者：@知渡
- NO supernatural glow; NO cartoon/chibi; NO flat illustration;
  NO Western Victorian elements; NO faux-Latin
```

### Variant D: traditional-encyclopedia（传统百科）— 升级版默认
```
Visual Style (CRITICAL — WanWuTuJian traditional-encyclopedia variant):
- Chinese traditional encyclopedia illustration aesthetic (历史图鉴风格)
- Detailed semi-realistic illustration of historical Chinese figures, plants,
  animals and landscapes — NOT Western natural history watercolor plates
- Illustration technique: fine-line ink contour + watercolor fill
- Traditional Chinese figures wear historical robes (汉服/布衣/文人服), depicted
  with narrative and expressive quality
- Background: aged Chinese xuan paper / old book page (#F0E0C0 to #E8D5B0),
  warm matte yellowed surface, subtle fold marks and age spots
- Color energy: WARM — muted warm background BUT natural subjects (plants,
  animals, costumes) use RICHER, MORE SATURATED colors as deliberate contrast;
  cinnabar red (#C0392B) and amber gold (#FFBF00) accents are BOLD, not faded
- Knowledge infographic overlay: structured text blocks, boxed knowledge panels,
  ✓/✗ comparison icons, numbered sections ①②③ are layered OVER the illustration
- Corner stamps: red square Chinese character stamps at top corners
- Credit: 作者：@知渡
- NO neon, fluorescent, pure black fills, cold white, Western Victorian border
- NO faux-Latin scientific names
```

## Module 3: Composition
从 `references/compositions/<composition>.md` 加载核心视觉特征和 prompt 片段。

| Composition | 加载文件 |
|-------------|----------|
| group-portrait | `compositions/group-portrait.md` |
| center-radial | `compositions/center-radial.md` |
| infographic | `compositions/infographic.md` |
| scattered-icons | `compositions/scattered-icons.md` |
| grid-collage | `compositions/grid-collage.md` |
| anatomy-atlas | `compositions/anatomy-atlas.md` |

**封面页**：使用该 composition 的「Prompt 片段（封面）」
**内容页**：使用该 composition 的「Prompt 片段（内容页）」

> **风格适配**：Composition prompt 片段中如描述"人物"相关特征，需根据当前 Style Variant 调整：
> - **cartoon-infographic**: 人物→Q版角色，增加信息模块密度描述
> - **celestial-narrative**: 人物→仙人/神圣形象，增加光效/氛围描述
> - **realistic-portrait**: 人物→写实主体，增加纹理/细节描述
> - **traditional-encyclopedia**: 保持原始 composition 描述不变

## Module 4: Layout
从 `references/layouts/` 加载对应版面的 prompt 模板。

**竖版**：`layouts/portrait-layouts.md` → center-radial / annotated / grid-surround / fusion-plate / sequential / knowledge-split
**横版**：`layouts/landscape-layouts.md` → side-by-side / panoramic / timeline-flow / scene-map / dashboard

## Module 5: Content
```
Page Content:
- Main subject: [描述]
- Corner stamp left-top: [系列标签，如"图鉴"/"福报·壹"]
- Corner stamp right-top: [主题词，如"慈悲"/"匠人风骨"]
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
- Credit (small, bottom): 作者：@知渡
```

## Module 7: Decorations — 按风格变体选择

> 从 `references/elements/decorations.md` 加载装饰元素。根据 Style Variant 选择对应装饰集。

### cartoon-infographic 装饰（高互动信息模块）
```
Decorations:
- Red square corner stamps at top-left and top-right with Chinese characters
- Achievement badge column on LEFT side (4 badges with medal icons, chibi illustrations, speech bubbles)
- Behavior pattern comic strip on RIGHT side (4-6 panels with sequential scenes, chibi reactions)
- Hexagonal personality radar chart (6 axes, filled in theme color, hand-drawn style)
- Surface vs Inner Self contrast panel (split: composed expression vs contrasting emotion)
- Growth 4-panel comic sequence (character evolution through labeled stages)
- Personality trait tag cloud (varying text sizes, theme color gradient, 「」brackets)
- Humor quote box with decorative border and small chibi reaction illustration
- Highlight moments list (3-5 items with arrow → markers)
- Background: bright aged paper, secondary to vibrant info modules
```

### celestial-narrative 装饰
```
Decorations:
- Red square corner stamps at top-left and top-right with Chinese characters
- Thin-bordered knowledge boxes with warm golden border lines
- Annotation lines with Chinese labels
- Wisdom quote box with ornate golden frame
- Narrative scene vignettes showing key moments
- Divine golden light particle effects throughout
- Layered cloud sea decorations at edges and corners
- Sacred halo glow effects around key elements
- Floating golden particles as ambient decoration
```

### realistic-portrait 装饰
```
Decorations:
- Red square corner stamps at top-left and top-right with Chinese characters
- Species/variety info cards with clean borders
- Detailed annotation lines with Chinese labels (museum-style)
- Comparison tables for trait/feature analysis
- Magnified detail insets in circular frames with dotted border
- Natural environment corner decorations (subtle foliage, texture)
- Warm neutral background with subtle paper texture
```

### traditional-encyclopedia 装饰（默认）
```
Decorations:
- Red square corner stamps at top-left and top-right with Chinese characters
- Thin-bordered knowledge boxes organized in grid or column layout
- Annotation lines with Chinese labels
- Ink-wash mountain or mist corner decorations (subtle)
- Aged paper texture: fold marks, age spots, worn edges
- [如有对比]✓ checkmark (green/dark) and ✗ cross (red) comparison icons
- [如有工具]Tool/item diagram with labeled parts
- Numbered sections with ①②③ circled numbers
```

## Module 8: Negative — 按风格变体调整

### cartoon-infographic
```
AVOID: muted/flat/plain illustration, stiff historical realism, Western Victorian
ornamental border, faux-Latin scientific names, photorealistic photography,
3D CGI render, cold blue/white tones, pure black fills, dark background,
low information density, boring static layout.
```

### celestial-narrative
```
AVOID: flat/muted illustration, cartoon/chibi style, cold tones, Western Victorian
ornamental border, faux-Latin scientific names, photorealistic photography,
3D CGI render, anime/manga style, neon colors, fluorescent, modern minimalist
design, dark background without golden warmth.
```

### realistic-portrait
```
AVOID: supernatural glow effects, cartoon/chibi style, flat illustration,
Western Victorian ornamental border, faux-Latin scientific names, 3D CGI render,
anime/manga style, neon colors, fluorescent, cold blue/white tones, pure black
fills, modern minimalist design, dark background.
```

### traditional-encyclopedia（默认）
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

## 参考图链机制（Visual Consistency — Reference Image Chain）

确保系列内人物/风格一致性：
1. **图1（封面）优先生成** — 不使用 `--ref`
2. **图2+ 全部以图1为 `--ref`** — 锚定人物设计、色彩渲染、插画风格
   ```bash
   # 生成图1（无 ref）
   [generate image 01-cover-xxx.png]

   # 生成图2+（以图1为 ref）
   [generate image 02-content-xxx.png --ref path/to/01-cover-xxx.png]
   ```
   这对于包含重复人物、标志性角色或统一插画元素的系列至关重要。

## Session ID 管理

同系列使用相同 Session ID 保持一致性：
- 格式：`wanwu-{slug}-{timestamp}`
- 示例：`wanwu-fu-bao-20260303-143052`
- 如图片生成工具支持 `--sessionId`，将此 ID 传入所有图片生成调用

## 模型适配
| 模型 | 注意 |
|------|------|
| Gemini 3 | 长 prompt 理解好，直接用完整结构；对中文文字渲染相对最好 |
| GPT-4o | 不支持 negative prompt，正向描述中写"NOT Victorian, NOT Latin text"；中文渲染一般 |
| Nano Banana | 尾部加 `Please use nano banana pro to generate.` |

## Session 一致性
同系列所有图保持相同的 **Module 2 Style Variant（逐字一致）**、色彩能量级别、角标印章风格、署名。
- Module 2 选定一个 Variant（A/B/C/D），系列内所有图逐字复制，不可修改
- Module 7/8 使用与 Module 2 匹配的风格变体装饰/排除项
- 每张图的 Module 6 中角标内容可按页面主题变化（如 福报·壹/福报·贰/福报·叁...）

## 封面 vs 内容页的组装差异

### 封面页（Cover）
- Module 3 用该构图的「封面 prompt 片段」
- Module 4 用 `center-radial` 或 `grid-surround`
- Module 5 主体是多个人物/物品的全景汇总，展示所有核心元素
- Module 6 标题最大，英文副标题完整，两个角标都放系列标签

### 内容页（Content Pages）
- Module 3 用该构图的「内容页 prompt 片段」
- Module 4 用 `annotated` 或 `knowledge-split`（上图下知识/左图右知识）
- Module 5 重点是知识块叠层：每页一个核心规则，4-8个知识区块
- Module 6 左上角标为序号标签（如"福报·壹"），右上角标为该页主题词

## Prompt 检查清单

生成前确认：
- [ ] 风格变体已确定（cartoon-infographic / celestial-narrative / realistic-portrait / traditional-encyclopedia）
- [ ] Module 2 选用正确的 Variant 且与系列其他图完全一致（逐字）
- [ ] Module 2 中 [THEME_COLOR]、[LIGHT_TYPE] 占位符已替换（如使用 cartoon-infographic）
- [ ] Module 7 装饰集与 Module 2 风格变体匹配
- [ ] Module 8 排除项与 Module 2 风格变体匹配
- [ ] 构图片段从正确的 composition 文件加载
- [ ] 版面模板匹配大纲规格
- [ ] 内容准确反映大纲条目
- [ ] 中文文字完整（标题、角标、标注、署名）
- [ ] 署名为"作者：@知渡"
- [ ] 水印已包含（如偏好中启用）
- [ ] 无冲突指令（如 Variant A 的"NOT stiff realism"不与内容描述冲突）
- [ ] 图2+ 已设置 --ref 指向图1
