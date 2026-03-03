# Portrait Layouts 竖版 (1792×2400 / 3:4) — v3.0

v3.0 将 7 种版面精简为 **1 种主版面 + 2 种子模式**，有机海报取代刚性三栏。

---

## organic-poster 有机海报（唯一主版面）

```
Portrait (3:4). Subject(s) expand freely in organic composition, NOT confined
to rigid panels. Illustration breathes naturally — subjects can cross zones,
overlap each other, extend to canvas edges.

Title zone (top 15%): brush calligraphy main title at top, subtitle below,
English line below subtitle. Red square stamps top-left and top-right.

Illustration zone (mid 75%): main subject(s) placed organically — portrait
figure can dominate one full side vertically. Supporting elements scattered
naturally around primary subject. Knowledge annotation lines extend from
subjects. Scattered red seal stamps and background depth elements within this zone.

Bottom zone (10%): dot-separated attribute list OR wisdom quote in red-bordered box.
Credit: 作者：@知渡 at very bottom.
```

**适用**：所有主题的内容页；封面使用 dense-cluster 子模式（见下）

**知识区块位置（内容页）**：
- 分栏知识块：左右各一列，在插画两侧或插画下方
- 单列知识框：插画下方 35-45% 区域
- 底部总结框：朱砂红边框，楷体斜体

---

## dense-cluster 密集簇拥（封面专用子模式）v3.1

> 封面生成时强制使用此模式。内容页不使用。

```
DENSELY PACKED composition filling the entire canvas edge to edge.
Minimal white space. Elements tightly clustered, overlapping at edges —
creating tapestry-like richness, NOT isolated specimens on blank paper.

Anchor figure: ONE dominant subject occupying the ENTIRE LEFT SIDE (or RIGHT SIDE)
vertically — this is the LARGEST element, significantly bigger than others.

Supporting cast: 6-10 secondary subjects clustered TIGHTLY around the anchor,
overlapping each other and the anchor figure. Loose scattered elements (stones,
drops, petals, leaves) fill any remaining gaps.

Background depth: faint architectural or landscape silhouettes in atmospheric
ink wash behind all subjects — Forbidden City outlines, mountain ridges,
pavilion silhouettes etc. VERY FAINT, purely atmospheric.

NO empty zones. NO isolated floating subjects. NO grid-like regular spacing.
Fill every quadrant with subjects, decorations, or background depth elements.
```

**封面 Prompt 必加语言**：
```
DENSELY PACKED filling the entire canvas edge to edge. Minimal white space.
Tightly clustered, overlapping subjects creating tapestry-like richness.
[Anchor figure] occupying the ENTIRE [LEFT/RIGHT] SIDE vertically — the LARGEST
figure in the composition. Loose [scattered elements] filling gaps.
Faint [background architecture] silhouettes in atmospheric ink wash behind subjects.
```

---

## annotated 解剖标注（内容页子模式）

```
Upper half: subject illustration with [N] thin annotation lines to Chinese labels.
Red square stamps at corners. Large brush calligraphy title at top.
Lower half: structured knowledge panels — [M] boxed sections with ① ② ③ ④
numbered items. [If applicable] ✓ correct scene (right) vs ✗ incorrect scene (left).
Bottom: summary quote box in bordered italic style.
Credit: 作者：@知渡.
```

插画占40-55%，知识块占35-45%，标注4-10条

---

## 通用尾部（附加到所有竖版 prompt）

```
Chinese historical encyclopedia illustration on clean warm cream paper (#F5EED8).
Subtle paper grain only — NO heavy aging, NO fold marks, NO dark stains.
Deep sepia ink (#3A2A1A) for lines and text, cinnabar red (#C0392B) for stamps
and keyword tags, amber gold (#FFBF00) for knowledge frames.
NOT Western Victorian border, NOT faux-Latin, NOT anime, NOT photorealistic CGI.
```
