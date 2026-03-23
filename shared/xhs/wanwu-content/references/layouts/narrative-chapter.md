# narrative-chapter（叙事章节式）

### 对标案例
- 虎：山君（十二生肖古代雅称·第三章）
- 马：追风（十二生肖古代雅称·第七章）

### 核心定位
系列章节的故事叙述页。像"翻到古籍中某一章的精美插图页"。

### 空间分区

```
┌──────────────────────────────────────────────┐
│ [外框 + 角标印章]                              │
│ ┌──────────────────────────────────────────┐ │
│ │ [印章]  「主标题」        [印章]          │ │
│ │         副标题                            │ │
│ │         系列名·第X章                      │ │
│ │                                           │ │
│ │  ┌左竖栏┐  ┌───中央大场景───┐  ┌右侧栏┐ │ │
│ │  │      │  │                │  │      │ │ │
│ │  │竖排  │  │   戏剧性       │  │【卡片1】│ │
│ │  │关键  │  │   大场景       │  │ 小图  │ │ │
│ │  │事实  │  │   插画         │  │ 说明  │ │ │
│ │  │列表  │  │                │  │      │ │ │
│ │  │      │  │                │  │【卡片2】│ │
│ │  │图标  │  │ [作者署名]     │  │ 小图  │ │ │
│ │  │+     │  │                │  │ 说明  │ │ │
│ │  │关键词│  │                │  │      │ │ │
│ │  │      │  │                │  │【卡片3】│ │
│ │  └──────┘  └────────────────┘  └──────┘ │ │
│ │                                           │ │
│ │  ┌──底部解说文段──────────────────────┐   │ │
│ │  │ 一段完整的解说文字（3-5行）         │   │ │
│ │  └────────────────────────────────────┘   │ │
│ │                                           │ │
│ └──────────────────────────────────────────┘ │
│ [博物志]    ⊙{地支}    [古今图鉴]            │
└──────────────────────────────────────────────┘
```

### 模块槽位定义

| 槽位 | 位置 | 宽度 | 内容 |
|------|------|------|------|
| **标题区** | 顶部居中 | 100% | 主标题(书法) + 副标题 + 系列·章节 |
| **左竖栏** | 左侧 | 12-15% | 4-6个关键事实（图标+竖排关键词） |
| **中央大场景** | 中间 | 55-65% | 戏剧性场景插画 + 署名 |
| **右侧栏** | 右侧 | 20-25% | 3-4个知识卡片【】标题 |
| **底部文段** | 底部 | 100% | 3-5行解说文字 |
| **底部印章条** | 最底部 | 100% | 博物志 + 地支符号 + 古今图鉴 |

### 左竖栏结构

```
寅虎居三      ← 关键事实1（可加小图标）

十二生肖第三   ← 补充说明

👑             ← 图标
百兽之王       ← 关键事实2

📖
说文有载       ← 关键事实3

大虫·李耳     ← 关键事实4
避讳雅称
```

- 竖排紧凑排列
- 每个事实：可选小图标/emoji + 关键词（2-4字）+ 可选补充行
- 文字深褐色，部分加粗
- 整体占画面宽度 12-15%

### 右侧知识卡片结构

```
【渊源】
┌──────────┐
│ [竹简/    │
│  古籍插图] │
└──────────┘
典出《说文解字》
山兽之君之名

【避讳】
┌──────────┐
│ [古人     │
│  避讳场景] │
└──────────┘
古人讳称"大虫"
敬畏之心深重
```

- 每个卡片：【标题】+ 小插图 + 1-3行说明
- 插图风格可以是：卷轴、竹简、古籍页面、场景小图
- 3-4个卡片纵向排列

### 中央大场景要求

- 占画面 55-65%（比 anatomy-spread 的主体更大）
- 戏剧性构图：人物/动物有强烈动态
- 场景化：有背景环境（山林/草原/建筑）
- 氛围感：云雾、光效、动感线条
- 有内框线包围场景，部分元素破框
- 署名在场景下方

### Prompt 片段

```
A highly detailed retro Chinese encyclopedia narrative chapter page illustration.
Orientation: portrait. Aspect ratio: 3:4 (1792×2400px).
Style: polished digital illustration, 85-90% realism, silky-smooth rendering.

BACKGROUND:
Aged warm parchment paper base (#E8D5B0 to #F5E6C8) with subtle fiber texture.
Light tea-stain patches at 15-20% opacity. Gentle vignette.

DOUBLE BORDER FRAME SYSTEM:
Outer frame at ~3%, inner frame at ~7-8%, cloud-scroll corner ornaments.

TITLE BLOCK (top center):
Red seal stamp at top-left of title: "{印章内容}"
L1: "「{生肖/主体}：{雅称/主题}」" in bold brush calligraphy, #3A2A1A.
Red seal stamp at top-right: "{印章内容}"
L2: "{系列名}·第{N}章" below L1, #5C3D2E.

LEFT VERTICAL SIDEBAR (12-15% width, left side):
Compact vertical list of key facts, reading top-to-bottom:
- "{关键事实1}" with optional small icon
  "{补充说明1}"
- "{关键事实2}" with optional icon
{...4-6 items}
All text in deep brown #3A2A1A, selective bold emphasis.

CENTRAL DRAMATIC SCENE (55-65% of visual area, framed by inner border):
{场景详细描述 — 人物/动物 + 动态动作 + 环境 + 氛围}
The scene is dramatic and alive: {动态细节}.
{主角} is {动作描述}, with {服饰/装备/特征细节}.
Background: {环境描述 — 山林/草原/建筑/云雾}.
Selective breakout: {1-2个元素突破内框描述}.

AUTHOR CREDIT: "作者：知渡" in cinnabar red, below the scene.

RIGHT SIDEBAR (20-25% width, 3-4 knowledge cards):

CARD 1 — "【{标题1}】":
Small illustration: {卷轴/竹简/场景描述}
Text: "{说明文字}"

CARD 2 — "【{标题2}】":
Small illustration: {描述}
Text: "{说明文字}"

CARD 3 — "【{标题3}】":
Small illustration: {描述}
Text: "{说明文字}"

BOTTOM EXPLANATORY TEXT BLOCK (bottom 10-12%, with thin border):
A paragraph of explanatory text in Song typeface:
"{解说文段内容}"
Deep brown #3A2A1A on parchment background.

BOTTOM STAMP BAR (outer frame zone):
Left: red seal "博物志", Right: red seal "古今图鉴".
Center: circular red symbol containing "{地支字}".
Small decorative elements: zodiac animal silhouettes in a row.

{style_block}
{micro-detail block}

NEGATIVE:
{排除项}
```

---

## 布局选择

> 布局选择的完整决策树和信号匹配矩阵见 SKILL.md 中的自动推荐逻辑。
>
> 简要规则：**系列中的一章，有章节编号，带叙事性（典故/雅称/故事）** → 选 narrative-chapter。
