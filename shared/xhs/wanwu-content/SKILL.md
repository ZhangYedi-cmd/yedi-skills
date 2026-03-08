---
name: wanwu-content
description: >
  生成「万物图鉴」风格的内容页（非封面）。基于对 @万物图鉴 实际内容页的逆向视觉分析，
  将任意主题拆解为高信息密度的复古百科插画内容页。
  3 种内容页布局：anatomy-spread（解剖图鉴）、narrative-chapter（叙事章节）、
  comprehensive-topic（全景专题）。
  视觉 DNA 继承自 wanwu-cover v2.0，在此基础上增加：知识模块系统、标注箭头、
  微缩场景插图、标签系统、微观放大圈、底部知识条。
  当用户提到"万物图鉴内容页"、"图鉴内容"、"做图鉴"、"百科内容页"时使用。
---

# 万物图鉴内容页生成器 v1.0

将任意主题拆解为高信息密度的复古百科插画内容页。

与 `wanwu-cover` 共享视觉 DNA（宣纸底、双边框、印章、丝滑数字插画渲染），
但拥有独立的布局系统、知识模块拆解逻辑和 Prompt 组装结构。

---

## Usage

```
/wanwu-content 子鼠 --layout anatomy-spread
/wanwu-content 虎：山君 --layout narrative-chapter --series "十二生肖古代雅称" --chapter 3
/wanwu-content 武术 --layout comprehensive-topic --series "中国十大国粹" --chapter 2
/wanwu-content 丑牛 --layout anatomy-spread --style realistic
```

## Options

| Option | Values | Default |
|--------|--------|---------|
| `--layout <l>` | anatomy-spread, narrative-chapter, comprehensive-topic | 自动推断 |
| `--style <s>` | anthropomorphic, traditional, realistic | 自动推断 |
| `--series <name>` | 系列名称（用于章节编号） | 无 |
| `--chapter <n>` | 章节编号 | 无 |
| `--orientation` | portrait / landscape | portrait |
| `--title <t>` | 自定义标题 | 从主题提取 |
| `--quick` | 跳过确认 | false |

---

## Workflow（6 步）

```
万物图鉴内容页 进度：
- [ ] Step 1: 分析主题 — 确定标题/布局/风格/知识模块拆解
- [ ] Step 2: 知识模块设计 — 拆解信息架构
- [ ] Step 3: 确认方案 ⚠️ REQUIRED（除非 --quick）
- [ ] Step 4: 组装 Prompt（按 references/prompt-assembly.md 的模块拼接）
- [ ] Step 5: 调用图片生成技能出图
- [ ] Step 6: 完成报告
```

### Step 1: 分析主题

确定以下关键信息：

1. **主标题**（中文）：用户指定 或 从内容提取
2. **副标题**：补充说明 + 英文/拉丁学名（如适用）
3. **系列信息**：系列名 + 第X章（如适用）
4. **布局模板**：按自动推荐矩阵 或 用户指定
5. **风格变体**：按自动推荐矩阵 或 用户指定
6. **中央主体**：主视觉焦点描述

**自动推荐矩阵**：

| 内容信号 | Layout | Style |
|----------|--------|-------|
| 动物/植物/生物单体 | anatomy-spread | realistic |
| 生肖单体+文化解读 | anatomy-spread | anthropomorphic |
| 雅称/典故/人物故事 | narrative-chapter | traditional |
| 文化/国粹/武术/技艺 | comprehensive-topic | traditional |
| 品种/分类单体深潜 | anatomy-spread | realistic |
| 历史事件/人物传记 | narrative-chapter | traditional |

### Step 2: 知识模块设计

根据布局模板，拆解主题信息为知识模块。详见 `references/content-layouts.md`。

**核心原则**：
- 每个布局有固定的模块槽位（slot）
- 每个模块 = 标题 + 1-4个知识点 + 配图描述
- 知识点 = 编号 + 名称 + 简短说明 + 小插图
- 信息密度要高，但有层次（主次分明）

### Step 3: 确认方案

使用 AskUserQuestion 确认：
- 布局模板
- 知识模块清单
- 中央主体描述
- 标题 / 副标题

### Step 4: 组装 Prompt

严格按照 `references/prompt-assembly.md` 的模块顺序拼接。
Prompt 保存至 `{output-dir}/prompt.md`。

### Step 5: 生成图片

调用可用的图片生成技能，输出至 `{output-dir}/content.png`。
失败自动重试一次。

### Step 6: 完成报告

```
万物图鉴内容页完成！

主题: [topic]
标题: [title]
系列: [series] 第[n]章
布局: [layout]
风格: [style]
路径: [output path]

文件:
✓ prompt.md
✓ content.png
```

---

## 3 种内容页布局

详见 `references/content-layouts.md`，以下为摘要：

### 1. anatomy-spread（解剖图鉴式）

对标：子鼠、丑牛
- **中央**：大主体插图（占 40-50%），带解剖标注箭头
- **左栏**：文化/历史知识维度（3-4个编号模块）
- **右栏**：习性/特征知识维度（3-4个编号模块）
- **底部**：属性条 + 结构图 + 补充知识块
- **特色元素**：微观放大圈、标签标注、特征列表（✓）、趣味引言框

### 2. narrative-chapter（叙事章节式）

对标：虎：山君、马：追风
- **中央**：大场景插图（占 55-65%），戏剧性构图
- **左竖栏**：关键事实纵列（图标+关键词，紧凑排列）
- **右侧栏**：3-4个知识卡片，【】括号标题
- **底部**：解说文段 + 印章条
- **特色元素**：竖排文字、卷轴/竹简插图、古籍引用框

### 3. comprehensive-topic（全景专题式）

对标：武术
- **中央**：2-4个英雄人物群像
- **左栏**：时间线/演化维度（从古到今）
- **右栏**：分类/流派维度（卡片式展示）
- **底部**：深潜区（器物图录 + 哲学图解 + 实践原则 + 趣味评论框）
- **特色元素**：时间线、阴阳/太极图、器物图录、人物对比

---

## 内容页专属视觉元素（封面没有的）

详见 `references/visual-dna.md`，以下为摘要：

### 知识模块系统
- **模块标题框**：带边框的标题条（「生肖文化象征」「生活习性图解」）
- **编号标题**：①②③④ 或 (1)(2)(3) 编号 + 粗体标题
- **知识卡片**：【渊源】【避讳】【文学】等黑方括号标题

### 标注系统
- **解剖标注**：细线 + 箭头 → 主体各部位名称
- **标签**：小圆角矩形标签（草食、群居、农耕）
- **特征列表**：✓ 嗅觉灵敏 / ✓ 繁殖能力强

### 微缩插图系统
- **场景插图**：小型矩形场景图（30-50px 概念），每个知识点配一个
- **微观放大圈**：圆形放大镜效果（毛发放大图、蹄结构）
- **结构简图**：简化的解剖/结构示意图

### 趣味元素
- **角色引言框**：主角的第一人称趣味发言
- **趣味评论框**：仿古书页/告示牌中的幽默短评
- **寓意列表**：鼠入粮仓 → 富足 / 鼠入厨房 → 粮丰

---

## References

- `references/visual-dna.md` — 内容页完整视觉规范（继承封面 + 内容页专属）
- `references/content-layouts.md` — 3 种布局模板详细定义 + Prompt 片段
- `references/prompt-assembly.md` — Prompt 模块组装规范

---

## Changelog

### v1.0 (初版)

- 从 wanwu-cover v2.0 继承视觉 DNA
- 3 种内容页布局：anatomy-spread / narrative-chapter / comprehensive-topic
- 内容页专属元素：知识模块系统、标注箭头、微缩插图、标签、微观放大圈
- 6 步工作流：分析 → 知识模块设计 → 确认 → 组装 → 出图 → 报告
