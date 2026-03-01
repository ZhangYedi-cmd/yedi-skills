---
name: retro-encyclopedia
description: >
  生成复古科普图鉴风格的小红书系列组图。将任意主题拆解为高信息密度的复古百科插画系列
  （封面+内容页+结尾页），风格对标"图解万物"、"万物图鉴"等爆款账号。支持竖版和横版，
  内置 6 种图鉴子变体 × 10 种构图模板。当用户提到"复古图鉴"、"万物图鉴"、"科普图鉴"、
  "百科风插画"、"encyclopedia illustration"、"图解万物风格"时使用此技能。
  即使用户只说"帮我做一组关于XX的科普图片"，只要主题适合图鉴式展示，也应考虑使用。
---

# 复古科普图鉴系列生成器

将任意主题拆解为高信息密度的复古百科插画系列，输出 Prompt 并调用图片生成工具出图。

## Usage

```bash
/retro-encyclopedia 橘猫的品种大全
/retro-encyclopedia 白粥的绝配 --variant pairing --orientation portrait
/retro-encyclopedia 猫咪的一天 --pages 5 --model gemini
```

## Options

| Option | Description | Default |
|--------|-------------|---------|
| `--variant <v>` | 图鉴子变体 | 自动推断 |
| `--orientation <o>` | portrait / landscape | portrait |
| `--pages <n>` | 系列图片数量 (2-18) | 列表型=1+N, 其他自动推断 |
| `--model <m>` | gemini / gpt / nano-banana | 按可用性选择 |

## 核心设计：Variant × Layout

视觉风格**锁定复古科普图鉴**（中国宣纸底色 + 历史人物半写实插画 + 知识图解叠层 + 中式角标印章），
在此基础上两个可组合维度：

| 维度 | 控制内容 | 选项 |
|------|----------|------|
| **Variant** | 信息组织方式 | natural-history, anatomy, pairing, fusion, process, catalog |
| **Layout** | 画面空间排列 | 5 竖版 + 5 横版 |

### Variant Gallery

| Variant | 中文名 | 适用场景 | 信息类型 |
|---------|--------|----------|----------|
| `natural-history` | 自然史博物 | 品种/分类/家族 | "大类下有哪些小类" |
| `anatomy` | 解剖标注 | 行为/结构/特征 | "各部分是什么" |
| `pairing` | 搭配指南 | 食物/工具/穿搭 | "配什么好" |
| `fusion` | 融合对比 | 混血/对比/A+B=C | "结合会怎样" |
| `process` | 流程图解 | 步骤/过程/时间线 | "怎么发生的" |
| `catalog` | 器物图录 | 工具/器具/收藏 | "各有什么讲究" |

详细定义：`references/variants/<variant>.md`

### Layout Gallery

**封面 Cover（6种原型，根据内容自动选择 ⚠️ 禁止全用同一种）：**

| 代号 | 名称 | 适用 |
|------|------|------|
| cover-A | 物品环绕型 | N种品种/物品 + 有容器概念（饺子→蒸笼） |
| cover-B | 多人群像型 | N个人物/角色/规则（八大天规） |
| cover-C | 标本解剖型 | 单品深度解析（君子兰、某种食材） |
| cover-D | 流程变换型 | 步骤/变化/对比（化妆步骤、翻新） |
| cover-E | 分区分类型 | 按维度分类的选择指南（选狗） |
| cover-F | 场景多格型 | 多主题合集/系列预览（四大系列） |

**内容页 Content（一页一主题 ⭐ 默认策略）：**
single-subject-plate, annotated, knowledge-split, grid-surround, fusion-plate, sequential

**横版 Landscape (16:9 / 4:3)**：side-by-side, panoramic, timeline-flow, scene-map, dashboard

详细定义：`references/layouts/`

### Auto Selection

| 内容信号 | Variant | 封面 Cover | 内容页 Layout |
|----------|---------|-----------|-------------|
| N种品种/种类/大全 | natural-history | cover-A 物品环绕 | single-subject-plate |
| N个人物/规则/规律 | anatomy | cover-B 多人群像 | single-subject-plate |
| 搭配/配什么/绝配 | pairing | cover-A 物品环绕 | single-subject-plate |
| 混合/融合/对比/VS | fusion | cover-D 流程变换 | fusion-plate |
| 步骤/流程/过程 | process | cover-D 流程变换 | sequential |
| 单品深度解析 | anatomy | cover-C 标本解剖 | annotated |
| 多主题合集预览 | catalog | cover-F 场景多格 | knowledge-split |

## 统一视觉 DNA（对标小红书「万物图鉴」账号实际风格）

所有子变体共享的风格锚点：

- **底色**：仿中国宣纸/旧书纸（#F0E0C0～#E8D5B0），暖米色、哑光、轻微折痕与污渍
- **技法**：细线勾勒+水彩填色，中国历史百科插画风（非西方博物馆水彩版画）
- **人物**：传统中国古代人物，着汉服/布衣，半写实叙事风格
- **主色**：深棕墨 #3A2A1A（线条）、朱砂红 #C0392B（角标、强调）、琥珀 #FFBF00
- **点缀**：翠绿 #4A7C59（植物/自然高饱和）、深棕 #8B6914
- **禁用**：霓虹、荧光、纯黑大面积、维多利亚西式边框、冷蓝冷白
- **文字**：超大黑体主标题 + 英文副标题（·分隔）+ 中文分类说明行，**无伪拉丁学名**
- **角标**：红色方块印章（左上+右上），内含2-4字中文（「图鉴」「天规第X」「宝地」等）
- **装饰**：知识图解叠层（带框知识块、①②③编号、✓✗对比场景）+ 标注线 + 水墨山水边角

详细定义：`references/elements/`

## Outline Strategies

| 策略 | 名称 | 理念 | 适合 | 页数 |
|------|------|------|------|------|
| A | 一页一主题 ⭐ | 列表型首选，每个条目独占一页 | 龙生九子、八大天规、12种饺子馅 | 1+N [+1] |
| B | 多维度深拆 | 深度优先，按维度拆解 | 单品分析、命理体系 | 1+M+1 |
| C | 场景叙事 | 趣味优先，场景推进 | 行为过程、搭配指南 | 1+M+1 |

> ⚠️ **列表型内容（"N种…""N大…"）必须使用策略A**，禁止将多个条目合并到同一页
> （如"上三子/中三子/下三子"会导致每个条目展示空间不足）。

## File Structure

```
retro-encyclopedia/{topic-slug}/
├── analysis.md
├── outline-strategy-{a,b,c}.md
├── outline.md (最终选定)
├── prompts/01-cover-[slug].md ...
├── 01-cover-[slug].png ...
```

## Workflow

```
复古图鉴系列 进度：
- [ ] Step 0: 检查偏好 (EXTEND.md) ⛔ BLOCKING
- [ ] Step 1: 分析主题 → analysis.md
- [ ] Step 2: 确认 1 — 变体/构图/规模 ⚠️ REQUIRED
- [ ] Step 3: 生成 3 套大纲
- [ ] Step 4: 确认 2 — 选择大纲 ⚠️ REQUIRED
- [ ] Step 5: 逐张生成（Prompt → 生图）
- [ ] Step 6: 完成报告
```

### Step 0: Load Preferences
```bash
cat ./EXTEND.md 2>/dev/null || cat ~/EXTEND.md 2>/dev/null
```
未找到则首次设置（语言/方向/水印/署名/模型）。**未完成前不进行任何其他步骤。**
参考：`references/config/preferences-schema.md`

### Step 1: Analyze Content
分析：核心对象、信息类型、**内容结构类型**（列表型/维度型/流程型/对比型）、调性。
⭐ 输出推荐：变体 + **封面版型(cover-A~F)** + 内容页版型 + 页数。
参考：`references/workflows/analysis-framework.md`

### Step 2: Confirmation 1 ⚠️
用 AskUserQuestion 确认：变体 / **封面版型** / 方向(竖/横) / 规模

### Step 3: Generate 3 Outlines
每套含 YAML front matter + 逐页规划。A=广度 B=深度 C=趣味。
参考：`references/workflows/outline-template.md`

### Step 4: Confirmation 2 ⚠️
用户选择/混合策略。确认后写入 outline.md。

### Step 5: Generate Images
逐张：组装 Prompt → 保存 prompts/ → 调用生成工具 → 出图。
Prompt 结构：`[风格基底] + [变体特征] + [构图模板] + [内容] + [中文文字] + [装饰]`
同系列使用相同 session ID 保持一致性。
参考：`references/workflows/prompt-assembly.md`

### Step 6: Completion Report
输出：主题、策略、变体、文件列表。

## Series Design Principles

每张图追求**高信息密度**：
- 一个主体 + 4-12 个标注点
- 2-4 个知识框（带边框的文字区块）
- 1-3 个场景小图或工具图解
- 底部金句框/总结框

| 位置 | 密度 | 要求 |
|------|------|------|
| 封面 | 最高 | 大标题+角标印章+多元素自然排布+英文副标题 |
| 内容页 | 高 | ⭐ 每页聚焦一个主题/条目，深度展开所有知识块 |
| 结尾页 | 中高 | 数据面板/金句/总览/速查表 |

## Variant × Layout Compatibility

| | center-radial | annotated | grid-surround | fusion-plate | sequential | side-by-side | panoramic | timeline-flow | scene-map | dashboard |
|---|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
| natural-history | ✓✓ | ✓ | ✓ | — | — | ✓ | ✓✓ | — | — | ✓ |
| anatomy | ✓ | ✓✓ | — | ✓ | ✓ | ✓ | — | — | — | ✓✓ |
| pairing | ✓ | — | ✓✓ | — | — | ✓ | ✓ | — | ✓ | — |
| fusion | — | ✓ | — | ✓✓ | — | ✓✓ | — | — | — | ✓ |
| process | — | ✓ | — | — | ✓✓ | — | — | ✓✓ | ✓ | — |
| catalog | ✓✓ | ✓ | ✓ | — | — | — | ✓✓ | — | — | ✓ |

## Image Modification

| 操作 | 步骤 |
|------|------|
| 修改 | 更新 prompt → 同 session 重新生成 |
| 插入 | 指定位置 → 创建 prompt → 生成 → 重编号 |
| 删除 | 删除文件 → 重编号 → 更新 outline |

## References

- `elements/`: canvas, typography, decorations, color-palettes
- `variants/`: natural-history, anatomy, pairing, fusion, process, catalog
- `layouts/`: portrait-layouts, landscape-layouts
- `workflows/`: analysis-framework, outline-template, prompt-assembly
- `config/`: preferences-schema
