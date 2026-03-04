# 万物图鉴 提示词组装 — v3.3

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
| anthropomorphic-portrait | Chinese encyclopedia illustration with anthropomorphic characters in traditional clothing | 75-80% |

> **写实度映射**：详见 `elements/illustration-styles.md` 的自动映射表。

---

## Module 2: Style Base — 3 Named Variants ⚠️ CRITICAL

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

### Variant C: anthropomorphic-portrait（拟人博物）— v3.3 新增

```
Visual Style (CRITICAL — WanWuTuJian anthropomorphic-portrait variant):
- Chinese traditional encyclopedia illustration with ANTHROPOMORPHIC characters
- [realism_level]% photorealism with [100-realism_level]% hand-painted warmth
- Characters are [animals/mythical creatures] depicted ANTHROPOMORPHICALLY —
  wearing traditional Chinese clothing (robes, armor, hats, capes), holding
  themed objects (weapons, scrolls, instruments), with expressive faces and
  human-like postures
- SEMI-REALISTIC style — NOT chibi/super-deformed, NOT anime, NOT flat cartoon,
  NOT realistic animals; characters have proportional bodies with human-like builds
- Color energy: WARM-VIBRANT — rich saturated colors on costumes and accessories,
  warm parchment background; bolder than WARM, livelier than NATURAL
- Each character carries a [banner flag / scroll tag / nameplate] with their
  Chinese name written on it
- Natural warm lighting with optional golden light effects on magical/sacred items
- Background: clean warm parchment (#E8D5B0) with faint ink-wash landscape behind
- Corner stamps: red square Chinese character stamps at 2-4 corners
- Additional scattered red seal stamps: 2-3 distributed across image
- Credit: 作者：@知渡
- NOT photorealistic animals; NOT Western fantasy art; NOT anime/manga style;
  NOT 3D CGI; NOT Victorian elements
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

## Module 5: Content（v3.3 更新）

```
Page Content:
- Main subject: [描述]
- Corner stamps: top-left「[系列标签]」, top-right「[主题词]」
  [Optional 4-corner]: bottom-left「[品牌标]」, bottom-right「[收藏标]」
- Scattered stamps: 「[印章1]」near [位置], 「[印章2]」near [位置]
- Annotation points: [标注列表，每个含2-6字简述]
- Knowledge blocks: [知识框内容，如"四层意义：①... ②... ③... ④..."]
- Comparison scenes: [✓正确场景 / ✗错误场景]
- Scene vignettes: [场景小图描述]
- Scattered elements: [散落物品，如 loose go stones, ink drops, petals]
- Background depth: [背景深度，如 faint Forbidden City silhouettes]
- [如有金属物] Metallic glint: bright star-shaped sparkle on [metal object]
- [如 center-radial 封面] Center backdrop: [shape] [size S/M/L] [tone light/dark]
  containing [landscape scene description]
- [如有角花] Corner ornaments: [龙纹/云纹/如意纹/回纹] at four frame corners
- [如 anthropomorphic] Subject name tags: [旗帜/卷轴/铭牌] on each character
```

---

## Module 6: Chinese Text（v3.3 更新）

```
Text (render in image):
- Main title (BRUSH CALLIGRAPHY STYLE, ultra-bold, top center): [主标题]
  → Thick and thin stroke variation, ink bleeding edges, NOT printed font
- Subtitle (medium serif, below title): [说明短语]
- English subtitle (small serif): [English · Keywords]
- Category line (small, below English): [属性1｜属性2｜属性3]
- Corner label top-left (red square): [系列标签]
- Corner label top-right (red square): [主题词]
- [If 4-corner] Corner label bottom-left (red square): [品牌标]
- [If 4-corner] Corner label bottom-right (red square): [收藏标]
- Scattered red stamps: 「[印章1]」at [位置], 「[印章2]」at [位置]
- Knowledge block headers: [各框标题]
- Annotation labels (with lines): [标注1→位置], [标注2→位置]...
- [封面底部 — 选一]:
  A) Dot-separated attribute list: "[attr1] · [attr2] · [attr3]"
  B) Ribbon banner text: "[总结文案]"
  C) Publisher bar: "[系列名]·典藏版" + "[编号｜出版社]"
  D) Symbol bar: "[字1] [字2] [字3]..." (生肖/地支等)
- [If 侧文] Left vertical text (L8): "[左侧金句]" top-to-bottom
- [If 侧文] Right vertical text (L8): "[右侧金句]" top-to-bottom
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
- Red square corner stamps at 2-4 corners with Chinese characters
- 2-3 additional red seal stamps scattered throughout image
- [Optional] Chinese corner ornaments (云纹/龙纹/如意纹) at frame corners
- Thin-bordered knowledge boxes organized in grid or column layout
- Annotation lines with Chinese labels + brief descriptions
- Ink-wash mountain or mist corner decorations (subtle)
- Clean warm parchment background (#E8D5B0), subtle paper grain
  — NO fold marks, NO age spots, NO torn edges
- [如有对比] ✓ checkmark and ✗ cross comparison icons
- [如有工具] Tool/item diagram with labeled parts
- Numbered sections with ①②③ circled numbers
- [如有侧文] Vertical wisdom quotes at left/right margins (L8)
- [内容页] Row of keyword tags: 「[词1]」「[词2]」「[词3]」with red borders (L6)
- [底部] Red-bordered wisdom quote box (L7) OR ribbon banner (L9)
```

### anthropomorphic-portrait 装饰（v3.3 新增）

```
Decorations:
- Red square corner stamps at 2-4 corners with Chinese characters
- 2-3 additional red seal stamps scattered throughout image
- Chinese corner ornaments (龙纹/云纹) at frame corners (recommended)
- Thin outer border frame around entire composition
- Each character carries a banner flag / scroll tag with Chinese name
- Faint ink-wash landscape silhouettes behind characters
- Clean warm parchment background (#E8D5B0), subtle paper grain
- [底部] Symbol horizontal bar (L9 variant D) with relevant characters
- Bottom stamps flanking the symbol bar
- Golden light effects on magical/sacred items
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

## 封面 vs 内容页的组装差异（v3.3 更新）

### 封面页（Cover）— 按构图选择版面

| 构图 | 封面版面 | 核心视觉 |
|------|---------|---------|
| group-portrait | `dense-cluster` [+可选外框+角花] | anchor figure + 密集群像铺满画布 |
| center-radial | `focal-radial` ★ | 外框线(+角花) + 中央景观框(S/M/L弹性) + 主体叠压(辉光) + 放射排列(可骑框) |
| infographic | `dense-cluster` | 步骤流程铺满 |
| anatomy-atlas | `dense-cluster` | 中央主体+标注铺满 |

**center-radial 封面必加要素（v3.3 升级为五要素）**：
1. `Thin rectangular border frame` — 外框线 [+可选角花]
2. `[Circular/rectangular] backdrop [S/M/L size] [light/dark tone]` — 弹性尺寸背景框
3. `Main subject overlapping backdrop with warm golden glow` — 主体叠压+辉光
4. `Radial elements [straddling frame if L-size]` — 放射排列 [大框可骑框]
5. `Stamps at [2-4] corners` — 2-4角印章

- Module 5 按构图：
  - group-portrait: anchor figure + 密集群像 + 散落元素 + 背景深度 + 2-4角印章 [+可选外框+角花+名牌]
  - center-radial: **外框线(+角花) + 弹性背景框 + 主体叠压辉光 + 放射排列(可骑框) + 2-4角印章 [+可选侧文]**
- Module 6：L1 毛笔书法标题，底部选一（点号列表/丝带横幅/出版条/符号条）[+可选 L8 侧文]

### 内容页（Content Pages）— organic-poster / annotated

- Module 3 用该构图的「内容页 prompt 片段」
- Module 4 用 `organic-poster` 或 `annotated`
- Module 5 重点是知识块叠层：每页一个核心规则，4-8个知识区块
- Module 6：L1 毛笔书法，L6 关键词标签条，L7 底部引用框

---

## Prompt 检查清单（v3.3 更新）

生成前确认：
- [ ] 风格变体已确定（realistic-portrait / traditional-encyclopedia / anthropomorphic-portrait）
- [ ] realism_level 已按内容类型确定（70-85%）
- [ ] Module 2 选用正确的 Variant 且与系列其他图完全一致（逐字）
- [ ] **封面版面按构图选择**：group-portrait → dense-cluster [+可选外框]；center-radial → focal-radial
- [ ] **center-radial 封面五要素已包含**：① 外框线(+角花?) ② 弹性背景框(S/M/L+淡/深) ③ 主体叠压辉光 ④ 放射排列(L骑框?) ⑤ 2-4角印章
- [ ] **背景框尺寸档已确定**：≤6元素→S / 7-9→M / ≥10→L；坐姿人物至少M
- [ ] L1 标题使用毛笔书法风格（BRUSH CALLIGRAPHY STYLE），位置在顶部25%以内
- [ ] 角标印章数确定（2角 或 4角），散布印章已设置（2-3个）
- [ ] [如适用] 中式角花类型已选定（龙纹/云纹/如意纹/回纹）
- [ ] [如适用] 侧文(L8)内容已确定
- [ ] [如适用] 底部样式已选定（点号/丝带/出版条/符号条）
- [ ] Module 7 装饰集与 Module 2 风格变体匹配
- [ ] Module 8 排除项与 Module 2 风格变体匹配
- [ ] 构图片段从正确的 composition 文件加载
- [ ] 版面模板匹配大纲规格
- [ ] 内容准确反映大纲条目
- [ ] 中文文字完整（标题、角标、散布印章、标注、署名）
- [ ] 署名为"作者：@知渡"
- [ ] **纸张色使用 #E8D5B0（做旧暖褐）而非纯白**
- [ ] 水印已包含（如偏好中启用）
- [ ] 图2+ 已设置 --ref 指向图1
