# 万物图鉴 提示词组装 — v3.1

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

---

## Module 1: Image Spec

```
Create a [STYLE_NAME] illustration for Xiaohongshu.
Orientation: [Portrait/Landscape]. Aspect Ratio: [3:4 / 1792×2400].
Style: [STYLE_DESCRIPTION]. Quality: Museum-grade detail.
[realism_level]% photorealism with [100-realism_level]% hand-painted artistic warmth.
```

| Style Variant | STYLE_DESCRIPTION | 写实度范围 |
|---------------|-------------------|----------|
| realistic-portrait | High-quality naturalist illustration with visible brushwork | 80-85% |
| traditional-encyclopedia | Chinese traditional encyclopedia illustration with knowledge infographic overlay | 70-80% |

> **写实度映射**：详见 `elements/illustration-styles.md` 的自动映射表。

---

## Module 2: Style Base — 2 Named Variants ⚠️ CRITICAL

> **规则**：同系列选择一个变体，所有图逐字一致。不同系列可使用不同变体。
> **风格对标：小红书账号「万物图鉴」(@知渡) 的实际发布风格**
> **详细参考**：`references/elements/illustration-styles.md`

### Variant A: realistic-portrait（写实群像）

```
Visual Style (CRITICAL — WanWuTuJian realistic-portrait variant):
- High-quality naturalist illustration, field-guide quality with visible brushwork
- [realism_level]% photorealism with [100-realism_level]% hand-painted warmth
- Subjects: fine fur/feather/petal textures, accurate proportions, painterly
  quality — NOT photographic, NOT CGI, NOT 3D render
- Rich color gradations, natural color temperature, refined saturation on
  natural subjects
- Natural warm side-lighting with soft shadows and environmental reflections
- Subject occupies 45-55% of canvas, richly detailed and textured
- Background: clean warm cream (#F5EED8~#FAF5EC), minimal paper grain only
- Color energy: NATURAL — rich natural colors with refined saturation and
  visible painterly quality
- Knowledge panels: species/variety info cards, annotation systems,
  comparison tables with clean layout
- Corner stamps: red square Chinese character stamps at top corners
- Additional scattered red seal stamps: 2-3 distributed across image
- Credit: 作者：@知渡
- NOT supernatural glow; NOT cartoon/chibi; NOT flat illustration;
  NOT Western Victorian elements; NOT faux-Latin; NOT photorealistic CGI
```

### Variant B: traditional-encyclopedia（传统百科）— 升级版默认

```
Visual Style (CRITICAL — WanWuTuJian traditional-encyclopedia variant):
- Chinese traditional encyclopedia illustration aesthetic (历史图鉴风格)
- [realism_level]% photorealism with [100-realism_level]% hand-painted warmth
- Detailed semi-realistic illustration of historical Chinese figures, plants,
  animals and landscapes — NOT Western natural history watercolor plates
- Illustration technique: fine-line ink contour + watercolor fill
- Traditional Chinese figures wear historical robes (汉服/布衣/文人服), depicted
  with narrative and expressive quality
- Background: clean warm cream paper (#F5EED8~#FAF5EC), subtle paper grain only
  — NO fold marks, NO heavy aging, NO dark stains, NO torn edges
- Color energy: WARM — muted warm background BUT natural subjects (plants,
  animals, costumes) use RICHER, MORE SATURATED colors as deliberate contrast;
  cinnabar red (#C0392B) and amber gold (#FFBF00) accents are BOLD, not faded
- Knowledge infographic overlay: structured text blocks, boxed knowledge panels,
  ✓/✗ comparison icons, numbered sections ①②③ are layered OVER the illustration
- Corner stamps: red square Chinese character stamps at top corners
- Additional scattered red seal stamps: 2-3 distributed across image
- Credit: 作者：@知渡
- NOT neon, NOT fluorescent, NOT pure black fills, NOT cold white
- NOT Western Victorian border, NOT faux-Latin scientific names
```

---

## Module 3: Composition

从 `references/compositions/<composition>.md` 加载核心视觉特征和 prompt 片段。

| Composition | 加载文件 | 子模式 |
|-------------|----------|--------|
| group-portrait | `compositions/group-portrait.md` | organic-spread / dense-cluster (封面) / grid-panel |
| center-radial | `compositions/center-radial.md` | radial / scattered-concept |
| infographic | `compositions/infographic.md` | — |
| anatomy-atlas | `compositions/anatomy-atlas.md` | — |

> **废弃**：`scattered-icons.md`（已合并入 center-radial 子模式 B）
> **废弃**：`grid-collage.md`（已合并入 group-portrait 子模式 C）

**封面页**：使用该 composition 的「封面 prompt 片段」+ `dense-cluster` 子模式
**内容页**：使用该 composition 的「内容页 prompt 片段」

> **风格适配**：见各 composition 文件的 `Style Variant Adaptations` 表。

---

## Module 4: Layout

从 `references/layouts/` 加载对应版面的 prompt 模板。

**竖版**：`layouts/portrait-layouts.md`
- **封面** → `dense-cluster`（密集簇拥，铺满画布）
- **内容页** → `organic-poster`（有机海报，自由布局）
- **解剖/知识页** → `annotated`（上图下知识）

**横版**：`layouts/landscape-layouts.md` → `side-by-side` / `panoramic`

---

## Module 5: Content

```
Page Content:
- Main subject: [描述]
- Corner stamp left-top: [系列标签，如"图鉴"/"福报·壹"]
- Corner stamp right-top: [主题词，如"慈悲"/"匠人风骨"]
- Scattered stamps: [印章1词，如"千年传承"] near [位置], [印章2词] near [位置]
- Annotation points: [标注列表]
- Knowledge blocks: [知识框内容，如"四层意义：①... ②... ③... ④..."]
- Comparison scenes: [✓正确场景 / ✗错误场景]
- Scene vignettes: [场景小图描述]
- Scattered elements: [散落物品，如 loose go stones, ink drops, petals]
- Background depth: [背景深度，如 faint Forbidden City silhouettes]
- [如有金属物] Metallic glint: bright star-shaped sparkle on [metal object]
```

---

## Module 6: Chinese Text

```
Text (render in image):
- Main title (BRUSH CALLIGRAPHY STYLE, ultra-bold, top center): [主标题，如"师不顺路"]
  → Thick and thin stroke variation, ink bleeding edges, NOT printed font
- Subtitle (medium serif, below title): [说明短语，如"中国传统八大天规之首"]
- English subtitle (small serif): [English · Keywords]
- Category line (small, below English): [属性1｜属性2｜属性3]
- Corner label top-left (red square): [系列标签]
- Corner label top-right (red square): [主题词]
- Scattered red stamps: 「[印章1]」at [位置], 「[印章2]」at [位置]
- Knowledge block headers: [各框标题]
- Annotation labels (with lines): [标注1→位置], [标注2→位置]...
- [封面底部] Dot-separated attribute list: "[attr1] · [attr2] · [attr3]"
- [内容页底部] Wisdom quote box (L7, red border): "[智慧点评文字]"
- Credit (small, bottom): 作者：@知渡
```

---

## Module 7: Decorations — 按风格变体选择

> 从 `references/elements/decorations.md` 加载装饰元素。

### realistic-portrait 装饰

```
Decorations:
- Red square corner stamps top-left and top-right with Chinese characters
- 2-3 additional red seal stamps scattered: 「[词]」near [位置]
- Species/variety info cards with clean borders
- Detailed annotation lines with Chinese labels (museum-style)
- Comparison tables for trait/feature analysis
- Magnified detail insets in circular frames with dotted border
- Bright metallic star-shaped glint on any metal surfaces
- Loose scattered elements ([items]) around main subjects for depth
- Faint background silhouettes in atmospheric ink wash
- Clean warm cream background (#F5EED8), subtle paper grain only
```

### traditional-encyclopedia 装饰（默认）

```
Decorations:
- Red square corner stamps top-left and top-right with Chinese characters
- 2-3 additional red seal stamps scattered throughout image
- Thin-bordered knowledge boxes organized in grid or column layout
- Annotation lines with Chinese labels
- Ink-wash mountain or mist corner decorations (subtle)
- Clean warm cream background (#F5EED8), subtle paper grain only
  — NO fold marks, NO age spots, NO torn edges
- [如有对比] ✓ checkmark and ✗ cross comparison icons
- [如有工具] Tool/item diagram with labeled parts
- Numbered sections with ①②③ circled numbers
- [内容页] Row of keyword tags: 「[词1]」「[词2]」「[词3]」with red borders (L6)
- [底部] Red-bordered wisdom quote box (L7)
```

---

## Module 8: Negative — 按风格变体调整

### realistic-portrait

```
AVOID: supernatural glow effects, cartoon/chibi style, flat illustration,
Western Victorian ornamental border, faux-Latin scientific names, 3D CGI render,
anime/manga style, neon colors, fluorescent, cold blue/white tones, pure black
fills, modern minimalist design, dark background, isolated specimens on empty paper,
photorealistic photography quality (want painterly field-guide quality instead).
```

### traditional-encyclopedia（默认）

```
AVOID: Western Victorian ornamental border, faux-Latin scientific names,
photorealistic photography, 3D CGI render, anime/manga style, neon colors,
fluorescent, cold blue/white tones, pure black fills, modern minimalist design,
dark background, heavy paper aging/fold marks/dark stains, isolated floating
subjects with too much empty space.
```

---

## Module 9: Watermark

```
Subtle watermark "[内容]" at [位置], legible but not distracting.
```

---

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

---

## Session ID 管理

同系列使用相同 Session ID 保持一致性：
- 格式：`wanwu-{slug}-{timestamp}`
- 示例：`wanwu-fu-bao-20260303-143052`

---

## 模型适配

| 模型 | 注意 |
|------|------|
| Gemini 3 | 长 prompt 理解好，直接用完整结构；对中文文字渲染相对最好 |
| GPT-4o | 不支持 negative prompt，正向描述中写"NOT Victorian, NOT Latin text"；中文渲染一般 |
| Nano Banana | 尾部加 `Please use nano banana pro to generate.` |

---

## 封面 vs 内容页的组装差异

### 封面页（Cover）— dense-cluster 模式

- Module 3 用该构图的「封面 prompt 片段」
- Module 4 用 `dense-cluster`（密集铺满画布）
- Module 5 包含：anchor figure + 密集群像 + 散落元素 + 背景深度 + 散布印章
- Module 6：L1 毛笔书法标题，底部点号分隔属性列表（不用「」标签）

### 内容页（Content Pages）— organic-poster / annotated

- Module 3 用该构图的「内容页 prompt 片段」
- Module 4 用 `organic-poster` 或 `annotated`
- Module 5 重点是知识块叠层：每页一个核心规则，4-8个知识区块
- Module 6：L1 毛笔书法，L6 关键词标签条，L7 底部引用框

---

## Prompt 检查清单

生成前确认：
- [ ] 风格变体已确定（realistic-portrait / traditional-encyclopedia）
- [ ] realism_level 已按内容类型确定（70-85%）
- [ ] Module 2 选用正确的 Variant 且与系列其他图完全一致（逐字）
- [ ] 封面使用 dense-cluster 布局（锚定人物+密集群像+散落元素）
- [ ] L1 标题使用毛笔书法风格（BRUSH CALLIGRAPHY STYLE）
- [ ] 散布印章已设置（2-3个，除固定角标外）
- [ ] Module 7 装饰集与 Module 2 风格变体匹配
- [ ] Module 8 排除项与 Module 2 风格变体匹配
- [ ] 构图片段从正确的 composition 文件加载
- [ ] 版面模板匹配大纲规格
- [ ] 内容准确反映大纲条目
- [ ] 中文文字完整（标题、角标、散布印章、标注、署名）
- [ ] 署名为"作者：@知渡"
- [ ] 水印已包含（如偏好中启用）
- [ ] 图2+ 已设置 --ref 指向图1
