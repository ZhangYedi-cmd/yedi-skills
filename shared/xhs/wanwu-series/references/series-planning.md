# 万物图鉴系列 — 系列规划规范

> 如何将一个大主题拆解为"1封面 + N内容页"的完整系列。

---

## 系列类型与拆解策略

### Type A: 枚举型（最常见）

**特征**：主题本身是一个集合，每个子项是一页。

| 系列 | 子项 | 页数 | 内容页布局 |
|------|------|------|-----------|
| 十二生肖古代雅称 | 鼠牛虎兔龙蛇马羊猴鸡狗猪 | 12 | narrative-chapter |
| 中国十大国粹 | 书法/武术/中医/京剧/... | 10 | comprehensive-topic |
| 东北五大仙 | 胡仙/黄仙/白仙/柳仙/灰仙 | 5 | narrative-chapter |
| 二十四节气 | 立春/雨水/.../大寒 | 6-24 | anatomy-spread |
| 中国四大发明 | 造纸/印刷/火药/指南针 | 4 | comprehensive-topic |

**拆解规则**：
- 1 封面 = 全部子项的群像/概览
- N 内容页 = 每个子项一页深潜
- 封面构图推荐：group-portrait 或 pyramid

### Type B: 维度型

**特征**：主题是单一对象，按不同维度展开。

| 系列 | 维度拆解 | 页数 | 内容页布局 |
|------|---------|------|-----------|
| 茶文化图鉴 | 历史/品种/工艺/器具/礼仪/诗词 | 6 | mixed |
| 故宫建筑 | 总览/太和殿/中和殿/保和殿/... | 5-8 | mixed |
| 中医养生 | 总论/五脏/经络/食疗/四季/... | 6 | mixed |

**拆解规则**：
- 1 封面 = 主题全景概览
- N 内容页 = 每个维度/方面一页
- 第1页通常是"总论/概述"（comprehensive-topic）
- 后续页按维度展开（anatomy-spread 或 narrative-chapter）

### Type C: 故事型

**特征**：主题是一个叙事，按章节/时间线展开。

| 系列 | 章节 | 页数 | 内容页布局 |
|------|------|------|-----------|
| 曾国藩处世之道 | 修身/齐家/治学/为官/用人 | 5 | narrative-chapter |
| 丝绸之路 | 起点/河西走廊/西域/中亚/罗马 | 5-8 | narrative-chapter |

**拆解规则**：
- 封面 = 核心概念群像
- 内容页 = 按叙事顺序排列
- 统一用 narrative-chapter

---

## 封面规划

封面由 `wanwu-cover` 技能处理，这里只规划关键参数：

```yaml
cover:
  title: "{中文主标题}"
  english: "{English Academic Title}"
  composition: "{group-portrait / center-radial / pyramid / c-surround / scatter-concept}"
  style: "{anthropomorphic / traditional / realistic}"
  key_elements:
    - "{主体元素1 — 如拟人化12生肖群像}"
    - "{主体元素2 — 如每个持代表性道具}"
    - "{背景元素 — 如远景古建筑}"
  stamps:
    - "{角标印章内容}"
  bottom_bar: "{底部信息文字}"
```

**封面构图自动选择**：

| 系列类型 | 推荐构图 |
|---------|---------|
| 枚举型（≤6项） | group-portrait |
| 枚举型（7-12项） | group-portrait 或 pyramid |
| 枚举型（>12项） | group-portrait（选代表性子项） |
| 维度型 | center-radial 或 c-surround |
| 故事型 | group-portrait 或 scatter-concept |

---

## 内容页规划

每页需要规划以下信息：

```yaml
page:
  number: 1
  slug: "zi-shu"                    # 用于目录名
  title: "子鼠：瑞兽"
  subtitle: "十二生肖古代雅称·第一章"
  layout: narrative-chapter
  style: anthropomorphic

  central_subject:
    description: "拟人化老鼠角色穿古代学者服饰"
    pose: "手持书卷，智慧形象"

  knowledge_modules:                 # 根据 layout 不同，模块结构不同
    # narrative-chapter 的模块：
    left_sidebar:
      - "子鼠居首"
      - "十二生肖第一"
      - "瑞兽之名"
      - "说文有载"
    right_cards:
      - title: "渊源"
        content: "典出何处"
      - title: "寓意"
        content: "文化象征"
      - title: "文学"
        content: "诗词典故"
    bottom_text: "一段解说文字..."

  stamps: ["鼠瑞", "博物志"]
```

---

## 布局自动推断矩阵

当 `--layout mixed` 时，每页布局按以下规则自动选择：

| 页面内容特征 | 推荐 Layout |
|------------|-------------|
| 单一动物/植物/物品，需要解剖级深潜 | anatomy-spread |
| 故事/典故/雅称，叙事性强 | narrative-chapter |
| 广泛主题（武术/书法/中医），需要分类+时间线 | comprehensive-topic |
| 规则/方法/准则，概念为主 | anatomy-spread（center-radial 变体） |

**枚举型系列的统一布局**：
- 生肖雅称 → 全部 narrative-chapter
- 国粹大全 → 全部 comprehensive-topic
- 动物品种 → 全部 anatomy-spread
- 一般优先统一布局，视觉连贯性更好

---

## 标题格式规范

### 系列标题一致性

同一系列的每页标题应保持统一格式：

```
# 枚举型 — 格式：{子项}：{雅称/别名}
虎：山君
马：追风
鼠：瑞兽

# 国粹型 — 格式：{国粹名}
武术
书法
中医

# 维度型 — 格式：{维度名}
品种大全
制作工艺
鉴赏品鉴
```

### 副标题格式

```
{系列名}·第{N}章

例：
十二生肖古代雅称·第一章
中国十大国粹·第三章
东北五大仙·第二章
```

---

## 输出目录结构

```
wanwu-tujian/{series-slug}/
├── series-outline.md           # 系列大纲
├── cover/
│   ├── prompt.md
│   └── cover.png
├── page-01-{slug}/
│   ├── prompt.md
│   └── content.png
├── page-02-{slug}/
│   ├── prompt.md
│   └── content.png
└── ...
```

**slug 命名规则**：拼音，用短横线连接，如 `zi-shu`、`chou-niu`、`wu-shu`。

---

## 页数推荐

| 系列子项数 | 推荐页数 | 说明 |
|-----------|---------|------|
| 4-6 | 全部 | 每个子项一页 |
| 7-12 | 全部 或 精选6 | 小红书建议9张以内最佳 |
| 13-24 | 精选6-10 | 合并/分组相似子项 |
| >24 | 分多个系列 | 如24节气 → 4季×6节气 |

**小红书最优发布数量**：1封面 + 4-8内容页 = 总计5-9张。
