# Decorations 装饰元素 — v3.1

## 核心系统：知识图解叠层（Knowledge Infographic Overlay）
这是博主风格的最大特征——在历史插画底图之上，叠加**结构化中文知识图解**。

### 知识块（知识框）
| 元素 | 说明 | Prompt 关键词 |
|------|------|--------------|
| 带框知识区块 | 圆角矩形/直角矩形框，内含标题+内容 | `boxed knowledge panels with thin border lines, organized text blocks` |
| 四层意义框 | "四层有意义"/"四大特征"式编号块 | `four labeled boxes with ① ② ③ ④ numbered items` |
| 左右分栏 | 左侧插画+右侧知识列表，或上图下文 | `split layout: illustration on left, knowledge list on right` |
| 底部总结框 | 页面底部的点评/智慧框，楷体引用风 | `bottom summary box with italic quote style` |

### 对比符号系统
| 元素 | 说明 | Prompt 关键词 |
|------|------|--------------|
| ✓ 正确图标 | 绿色/深色大勾，带说明文字 | `large checkmark ✓ in green/dark color with labeled example` |
| ✗ 错误图标 | 红色大叉，带说明文字 | `large red X mark ✗ with counter-example label` |
| 对比场景图 | 左✗错误场景 + 右✓正确场景，中间分隔线 | `two contrasting vignettes: wrong practice on left, correct on right` |

### 步骤/流程系统
| 元素 | 说明 | Prompt 关键词 |
|------|------|--------------|
| 编号步骤 | ①②③ 带数字圆圈，垂直排列 | `numbered steps with circled numbers ①②③ in vertical list` |
| 箭头流程 | 步骤间连接箭头 | `flow arrows connecting steps` |
| 三顾茅庐式步骤 | "初诊→再诊→三诊" 递进关系 | `progressive numbered stages with brief descriptions` |

## 角标印章系统（v3.3 扩展 — 2-4角标 + 2-3散布）

v3.3 从固定 2 角标升级为 **2-4 角标 + 2-3 散布印章**，支持四角印章布局。

### 角标印章（2-4个）
| 元素 | 位置 | 必选 | 内容 | Prompt 关键词 |
|------|------|------|------|--------------|
| 左上角分类标签 | 左上 | **必选** | 系列序号，如"处世有道" | `red square stamp top-left: series label` |
| 右上角主题词 | 右上 | **必选** | 主题词，如"道法自然" | `red square stamp top-right: theme keyword` |
| 左下角品牌标 | 左下 | 可选 | 品牌/品质词，如"博古通今""智慧图鉴""知行合一" | `red square stamp bottom-left: brand label` |
| 右下角收藏标 | 右下 | 可选 | 收藏/系列词，如"图鉴珍藏""传世珍藏""道法自然" | `red square stamp bottom-right: collection label` |

**四角印章启用条件**：
- 文化/传统/图鉴/生肖类主题 → 推荐四角
- 步骤/教程/日常主题 → 两角即可
- 有底部横幅条时 → 底部两角与横幅配合

### 散布印章（2-3个）
| 元素 | 位置 | 内容 | Prompt 关键词 |
|------|------|------|--------------|
| 主题印章 | 主体附近 | 主题关键词，如「千年传承」「十艺精华」 | `red seal stamp near main subject with Chinese characters` |
| 品质印章 | 画面中部 | 品质词，如「精品」「珍藏」 | `scattered red seal stamp in mid-area` |
| 底部标记 | 底部居中 | 系列品牌词，如"人道规""十思" | `small red seal at bottom center` |

**Prompt 片段**：
```
Red square corner stamps: top-left「[系列标签]」, top-right「[主题词]」.
[If 4-corner]: bottom-left「[品牌标]」, bottom-right「[收藏标]」.
Additional red seal stamps scattered: 「[印章1]」near [位置],
「[印章2]」near [位置]. Total 4-7 red stamps distributed across the image.
```

> **废弃**：Victorian ornamental border（维多利亚装饰边框）→ 改用下方中式边框/角花

## 「」关键词标签条（v3.1 新增）

主体下方水平排列 3-6 个关键词标签，朱砂红边框或底色。

| 元素 | Prompt 关键词 |
|------|--------------|
| 标签条 | `horizontal row of keyword tags in「」brackets below main subject, cinnabar red borders` |
| 单个标签 | `bold Chinese keyword in「」brackets with red border/background` |

**封面底部替代方案**（v3.1 更新）：
封面底部改为 **点号分隔属性列表**，不使用「」标签：
```
Dot-separated attribute list at bottom: "属性1 · 属性2 · 属性3 · 属性4"
```

## ★ 评分系统（v3.1 新增）

| 元素 | Prompt 关键词 |
|------|--------------|
| 五星评分 | `vintage-style five-star rating ★★★★☆` |
| 数值评分 | `numerical score display: [X]/10 in decorative frame` |
| 多维评分 | `multi-dimensional rating bars for different traits` |

## 引用/幽默框（v3.1 新增）

红色边框智慧语录或幽默点评，位于画面底部。

| 元素 | Prompt 关键词 |
|------|--------------|
| 智慧语录框 | `red-bordered (#C0392B) wisdom quote box with italic calligraphy text` |
| 幽默点评框 | `red-bordered humor/commentary box with witty observation` |

## 对比区块（v3.1 新增）

"人类误解 vs 官方翻译" 式左右对比。

| 元素 | Prompt 关键词 |
|------|--------------|
| 左右对比 | `side-by-side comparison block: left "误解/common belief" vs right "真相/reality"` |

## 金属光泽效果（v3.1 新增）

金属物体（针、剑、铜器等）添加星形闪光点。

| 元素 | Prompt 关键词 |
|------|--------------|
| 金属闪光 | `bright metallic star-shaped glint/sparkle reflection on metal surfaces` |
| 宝石光泽 | `gemstone-like sheen with highlight point on precious objects` |

## 散落元素（v3.1 新增）

增加画面深度和细节的松散物品。

| 元素 | Prompt 关键词 |
|------|--------------|
| 散落物品 | `loose [items] scattered on the surface beside [object] for depth and natural feel` |
| 自然碎片 | `scattered petals/leaves/seeds/ink drops around main subjects` |

示例：围棋旁散落的黑白棋子、书法旁的墨滴、茶道旁的茶叶碎片。

## 背景深度（v3.1 新增）

主体背景添加淡化建筑/自然剪影，增加文化氛围。

| 元素 | Prompt 关键词 |
|------|--------------|
| 建筑剪影 | `faint [building] silhouettes in atmospheric ink wash behind subjects` |
| 自然背景 | `subtle landscape/mountain silhouettes in misty background` |

示例：故宫轮廓、长城剪影、远山水墨。

## 标注系统
| 元素 | Prompt 关键词 |
|------|--------------|
| 标注线 | `thin annotation lines with Chinese labels, museum-style` |
| 编号标注 | `circled numbers ①②③ as reference markers` |
| 放大圆 | `magnified detail insets in circular frames with dotted border` |
| 工具图解 | `tool/item labeled diagram: [物品名] with part labels` |

## 数据可视化
| 元素 | Prompt 关键词 |
|------|--------------|
| 评分系统 | `vintage-style rating with ★★★★☆ or numerical scoring` |
| 特征柱状图 | `hand-drawn horizontal bar chart for trait comparison` |
| 规则/要义列表 | `bulleted knowledge list: 不轻进退、不轻许诺... in neat rows` |

## ★ 中央背景框系统（v3.3 重大更新 — 弹性尺寸+深色支持）

万物图鉴封面的**标志性视觉层**：在中央主体背后放置圆形或方形景观框，制造舞台感和层次感。

### 形状选择
| 元素 | 形状 | 适用场景 | Prompt 关键词 |
|------|------|---------|--------------|
| 圆形景观框 | 圆形 vignette | 道家/哲理/自然主题 | `circular vignette frame at center...` |
| 方形景观框 | 矩形 frame | 历史人物/规则/人生主题 | `rectangular decorative frame at center...` |

### ★ 尺寸弹性（v3.3 — 三档系统）
| 档位 | 画面占比 | 条件 | Prompt 尺寸关键词 |
|------|---------|------|------------------|
| **S** | 25-35% | ≤6元素，小主体（莲花/器物/符号） | `(25-35% of canvas height)` |
| **M** | 35-50% | 7-9元素 或 坐姿人物 | `(35-50% of canvas height), large enough to frame the figure` |
| **L** | 50-65% | ≥10元素 或 大场景主体 | `LARGE (50-65% of canvas height), dominating the center` |

### ★ 色调选择（v3.3 — 淡彩+深色）
| 色调 | 色值 | 框内场景 | 适用 | Prompt 关键词 |
|------|------|---------|------|--------------|
| **淡彩水墨**（默认） | 融合宣纸底 | 山水/竹林/宫殿 | 大部分主题 | `atmospheric ink-wash, medium visibility` |
| **深靛蓝** | #1B2838~#2C3E50 | 星空/银河/灯塔金光 | 思维/智慧/宇宙感 | `DARK indigo backdrop (#1B2838), HIGH CONTRAST against warm parchment` |
| **深墨绿** | #1A3C2A~#2D4A3E | 密林/竹海/山谷 | 自然哲理/隐士 | `DARK forest green backdrop (#1A3C2A), mysterious atmosphere` |

**关键规则**：
- 背景框尺寸**按元素数和主体类型弹性调整**，不再固定
- 中央主体叠压在框之前（z-index前置），产生层次感
- 主体带暖金色辉光：`soft warm golden radiant glow (#F5C842) emanating from the main subject`
- L档大框时，放射元素可**骑框**（跨越边界），产生深度
- 深色背景框时，暖光对比更强烈

**Prompt 片段（完整版）**：
```
CENTER BACKDROP: A [circular vignette / rectangular frame] at the image center,
[S: 25-35% / M: 35-50% / L: 50-65%] of canvas height.
[Light tone]: atmospheric Chinese [mountain landscape / bamboo grove / palace
courtyard] in ink-wash style, medium visibility.
[Dark tone]: DARK [indigo #1B2838 / forest green #1A3C2A] background containing
[starry sky with galaxy / dense misty forest / lighthouse with golden light],
HIGH CONTRAST against surrounding warm parchment.

CENTER SUBJECT: [主体描述] overlapping and placed IN FRONT of the backdrop frame,
with soft warm golden radiant glow (#F5C842) emanating from it.
[If L-size]: some radial elements straddle the backdrop boundary.
```

---

## ★ 整图外框线（v3.3 更新 — 适用范围扩大）

**v3.3 变更**：外框线不再仅限 focal-radial，dense-cluster 也可选用。

| 元素 | 说明 | 适用 | Prompt 关键词 |
|------|------|------|--------------|
| 细线外框 | 距画布边缘约1-2%的矩形细线框 | focal-radial（必加）, dense-cluster（可选） | `thin rectangular border line frame around the entire composition, slightly inset from canvas edges, sepia brown (#5C3D2E) line` |
| 圆角外框 | 圆角版本 | 柔和主题可选 | `thin rounded-corner rectangular border frame, slightly inset` |
| 外框+角花 | 外框线+四角中式角花装饰 | 文化/生肖/正式主题 | `thin border frame with Chinese [龙纹/云纹/如意纹] corner ornaments` |

**启用规则**：
- focal-radial 封面 → **必加**外框线
- dense-cluster 封面 → 文化/传统/生肖/正式主题 **可选**加外框线+角花
- 内容页 → 一般不加外框

**Prompt 片段**：
```
Thin rectangular decorative border line around the entire composition,
slightly inset (approximately 1-2% margin) from canvas edges.
Sepia brown (#5C3D2E) line, 2-3px equivalent weight. NOT Victorian ornate.
[Optional]: Chinese-style [dragon 龙纹 / cloud 云纹 / ruyi 如意纹] corner
ornaments at four corners of the border frame.
```

---

## 中式边框与装饰（替代 Victorian border）— v3.3 扩展

### 角花装饰（v3.3 新增 — 四角中式纹样）
| 元素 | 适用主题 | Prompt 关键词 |
|------|---------|--------------|
| 龙纹角花 | 生肖/皇家/正式文化 | `Chinese dragon motif corner ornaments at four corners of the border frame` |
| 云纹角花 | 道家/哲理/仙道 | `Chinese cloud scroll (云纹) corner ornaments at four corners` |
| 如意纹角花 | 福报/吉祥/人生智慧 | `Chinese ruyi (如意) pattern corner ornaments at four corners` |
| 回纹角花 | 严肃/学术/规则 | `Chinese key-fret (回纹) corner ornaments at four corners` |

**角花启用条件**：
- 有外框线时才加角花（角花附着在外框线四角）
- 文化/传统/生肖/正式主题 → 推荐加
- 日常/教程/轻松主题 → 不加，保持简洁

**Prompt 片段**：
```
[With outer border frame]: Chinese-style [dragon 龙纹 / cloud scroll 云纹 /
ruyi 如意纹 / key-fret 回纹] corner ornaments at four corners of the border
frame — traditional Chinese decorative motifs, NOT Western Victorian flourishes.
```

### 边缘装饰
| 元素 | Prompt 关键词 |
|------|--------------|
| 水墨山水边角 | `ink-wash mountain and mist corner decorations` |
| 云纹/回纹边线 | `subtle traditional Chinese cloud or key-fret pattern at edges` |

## 纸张质感（v3.2 更新 — 还原做旧感）

**重要**：v3.2 恢复适度做旧感，还原万物图鉴实测纸张色调。

| 元素 | Prompt 关键词 |
|------|--------------|
| 做旧宣纸色 | `aged warm parchment (#E8D5B0~#D4BE9A)` |
| 边缘暖黄 | `subtle warm yellowing towards edges` |
| 纸纹 | `subtle paper grain texture` |
| **禁止** | ~~heavy fold marks~~, ~~dark stains~~, ~~torn edges~~（避免过度做旧） |

**Prompt 片段**：
```
Aged warm parchment (#E8D5B0) with subtle paper grain and slight warm yellowing
towards edges. NOT pure white, NOT overly pristine. Gives the feel of a genuine
old encyclopedia page without heavy damage.
```

> **v3.2 变更说明**：从 v3.1 的 #F5EED8（偏白）回调至 #E8D5B0（偏暖褐），还原万物图鉴封面的实测纸张色。

## ★ 主体名牌/旗帜系统（v3.3 新增）

角色/生物合集中，每个主体身上可携带小型名牌标注其名称，增加博物馆标本感。

| 元素 | 适用 | Prompt 关键词 |
|------|------|--------------|
| 旗帜名牌 | 动物/将领/角色合集 | `small banner/flag attached to [subject] body with name "[名称]" written on it` |
| 卷轴名牌 | 历史人物/文化合集 | `small scroll tag hanging from [subject] with Chinese name "[名称]"` |
| 铭牌名牌 | 器物/标本合集 | `small brass nameplate below [subject] reading "[名称]"` |

**Prompt 片段**：
```
Each [subject] carries a [small banner flag / hanging scroll tag / brass nameplate]
with their Chinese name written on it — creates museum specimen label effect.
Names: "[名1]" on [主体1], "[名2]" on [主体2], ...
```

---

## 中式人物插画（核心插画风格）
| 元素 | 说明 | Prompt 关键词 |
|------|------|--------------|
| 古代人物 | 着汉服、布衣、文人/工匠/医者服饰，线条饱满 | `traditional Chinese figures in historical robes, semi-realistic illustration` |
| 人物动作场景 | 拜师/行医/制作等具体动作，有叙事感 | `narrative scene vignette showing [action] in historical Chinese setting` |
| 多人群像（封面） | 多个人物环绕主题排布，各持相关物品 | `multiple historical Chinese figures surrounding the central theme` |
| 器物图解 | 工具/器物的详细图解，标注各部件 | `detailed illustration of [tool] with labeled parts in Chinese` |

## 锚定人物（Anchor Figure — v3.1 新增）

封面中的**最大单一主体**，占据画面一侧，建立视觉重心。

| 元素 | Prompt 关键词 |
|------|--------------|
| 锚定人物 | `[figure description] occupying the ENTIRE LEFT/RIGHT SIDE vertically, LARGEST figure in the composition` |

## 构图专属装饰

### 按构图（默认/traditional-encyclopedia）
- group-portrait: 标注线 + 多标本排列 + 角标印章(2+3) + 水墨边角 + 散落元素
- center-radial: 知识块叠层 + ✓✗对比场景 + 步骤框 + 角标印章(2+3) + 引用框
- infographic: 编号步骤 ①②③ + 箭头流程 + 场景小图 + 角标印章(2+3)
- anatomy-atlas: 标注线 + 放大圆 + 剖面图解 + 角标印章(2+3) + 金属闪光

### 按风格变体
- **realistic-portrait**: 标注线 + 品种信息卡 + 对比表 + 详细标签系统 + 自然环境边角 + 金属闪光 + 散落元素
- **traditional-encyclopedia**: 使用上方按构图的默认装饰
