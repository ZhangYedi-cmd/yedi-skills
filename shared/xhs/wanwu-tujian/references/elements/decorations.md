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

## 角标印章系统（v3.1 扩展 — 2+3 系统）

v3.1 从仅有 2 个角标升级为 **2 角标 + 2-3 散布印章**，红色贯穿全画面。

### 固定角标（2个）
| 元素 | 位置 | 内容 | Prompt 关键词 |
|------|------|------|--------------|
| 左上角分类标签 | 左上 | 系列序号，如"天规第一" | `red square stamp top-left: series label` |
| 右上角主题词 | 右上 | 主题词，如"匠人风骨" | `red square stamp top-right: theme keyword` |

### 散布印章（2-3个，v3.1 新增）
| 元素 | 位置 | 内容 | Prompt 关键词 |
|------|------|------|--------------|
| 主题印章 | 主体附近 | 主题关键词，如「千年传承」「十艺精华」 | `red seal stamp near main subject with Chinese characters` |
| 品质印章 | 画面中部 | 品质词，如「精品」「珍藏」 | `scattered red seal stamp in mid-area` |
| 底部标记 | 底部居中 | 系列品牌词，如"人道规" | `small red seal at bottom center` |

**Prompt 片段**：
```
Red square corner stamps: top-left「[系列标签]」and top-right「[主题词]」.
Additional red seal stamps scattered throughout: 「[印章1]」near [位置],
「[印章2]」near [位置]. Total 4-5 red stamps distributed across the image.
```

> **废弃**：Victorian ornamental border（维多利亚装饰边框）→ 改用下方中式边框

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

## 中式边框与装饰（替代 Victorian border）
| 元素 | Prompt 关键词 |
|------|--------------|
| 水墨山水边角 | `ink-wash mountain and mist corner decorations` |
| 云纹/回纹装饰 | `subtle traditional Chinese cloud or key-fret pattern at edges` |

## 纸张质感（v3.1 简化）

**重要**：v3.1 大幅简化纸张做旧，保持干净清爽。

| 元素 | Prompt 关键词 |
|------|--------------|
| 微妙纸纹 | `subtle paper grain texture only` |
| 暖色底面 | `clean warm cream surface (#F5EED8)` |
| **禁止** | ~~fold marks~~, ~~heavy age spots~~, ~~worn torn edges~~, ~~dark stains~~ |

**Prompt 片段**：
```
Clean warm cream paper (#F5EED8~#FAF5EC) with subtle paper grain only.
NO heavy aging, NO dark stains, NO fold marks, NO torn edges.
```

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
