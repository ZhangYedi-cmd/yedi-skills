# group-portrait（群像集合式）

## 对标案例
- 中国十大国粹科普图鉴（人物+物品混合）
- 十二生肖古代雅称与祝福（拟人动物群像）

## 核心视觉公式

```
双边框（外框+内框+呼吸带）
  + 2-3 个人物角色作为视觉锚点（各有动态动作）
  + 6-10 个物品紧密铺满（各有微观光影细节）
  + 90% 内容聚拢在内框内
  + 少量元素选择性破框（人物侧入+物品边缘裁切+棋子/花瓣溢出）
  + 散落元素有微小投影
  + 极淡背景建筑剪影（15-20%）
```

## 元素配置

| 元素 | 数量 | 大小 | 位置 |
|------|------|------|------|
| 人物角色 | 2-3 | 25-35% 画面高度 | 内框内，1个从侧边入场 |
| 物品主体 | 6-10 | 8-15% each | 内框内环绕人物 |
| 散落元素 | 4-8 | 1-3% each | 空白缝隙，部分跨越内框 |
| 背景剪影 | 1-2 | 极淡 15-20% | 远景层 |
| 角标印章 | 2-4 | 5-8% | 贴外框线 |
| 散布印章 | 2-3 | 3-6% | 内框内空白处 |

## Prompt 片段

```
A highly detailed retro Chinese encyclopedia cover illustration,
portrait orientation (3:4 ratio, 1792×2400px).
Style: polished digital illustration, 85-90% realism, silky-smooth rendering.

BACKGROUND:
Aged warm parchment paper (#E8D5B0) with subtle fiber texture,
light tea-stain patches at 15-20% opacity. Gentle vignette at edges.
Faint silhouette of {传统建筑} at 15-20% opacity in upper background.

DOUBLE BORDER FRAME:
Outer frame: thin sepia line at ~3% from edges, cloud-scroll corner ornaments.
Inner frame: thin sepia line at ~7-8% from edges — PRIMARY CONTENT BOUNDARY.
Breathing zone between frames: mostly empty parchment.

MAIN COMPOSITION — Dynamic Group Portrait:
All main content tightly packed WITHIN the inner frame boundary.

FIGURE 1 (anchor, {位置}, {高度}% canvas height):
{人物描述 + 动态动作}. Rendered with smooth semi-realistic style,
silky fabric textures, warm skin tones, volumetric shading.
BREAKOUT: This figure enters from the {left/right} edge — {裁切描述}.

FIGURE 2 ({位置}, {高度}% canvas height):
{人物描述 + 动态动作}.

FIGURE 3 ({位置}, {高度}% canvas height):
{人物描述 + 动态动作}.

OBJECT 1 — {物品名}:
{物品描述 + 动态 + 微观细节（质感/光泽/高光）}

OBJECT 2 — {物品名}:
{物品描述 + 动态 + 微观细节}
{...列出所有物品}

BREAKOUT ELEMENTS (crossing inner frame):
- {物品X} extends past inner frame on {side}, cropped by canvas edge
- {N} scattered {棋子/花瓣} cross the inner frame into breathing zone with tiny shadows

SCATTERED DYNAMIC ELEMENTS:
{花瓣/茶叶/棋子/铜钱/墨滴等} in gentle motion with tiny cast shadows.

{style_block}

MICRO-DETAIL:
{Module 8 微观细节段落}

TEXT: {Module 5}
STAMPS: {Module 6}
DECORATIONS: {Module 7}
NEGATIVE: {Module 9}
```
