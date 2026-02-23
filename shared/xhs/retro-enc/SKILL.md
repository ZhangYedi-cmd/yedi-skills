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
| `--pages <n>` | 系列图片数量 (2-8) | 自动推断 |
| `--model <m>` | gemini / gpt / nano-banana | 按可用性选择 |

## 核心设计：Variant × Layout

视觉风格**锁定复古科普图鉴**（aged parchment + 手绘水彩 + 标注线 + 伪学名），
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

**竖版 Portrait (9:16 / 3:4)**：center-radial, annotated, grid-surround, fusion-plate, sequential

**横版 Landscape (16:9 / 4:3)**：side-by-side, panoramic, timeline-flow, scene-map, dashboard

详细定义：`references/layouts/`

### Auto Selection

| 内容信号 | Variant | Layout |
|----------|---------|--------|
| 品种/种类/分类/大全 | natural-history | center-radial / panoramic |
| 结构/原理/分析/拆解/行为 | anatomy | annotated / dashboard |
| 搭配/配什么/绝配/食谱 | pairing | grid-surround |
| 混合/融合/对比/VS | fusion | fusion-plate / side-by-side |
| 步骤/流程/过程/怎么做 | process | sequential / timeline-flow |
| 工具/器具/装备/收藏 | catalog | center-radial / panoramic |

## 统一视觉 DNA

所有子变体共享的风格锚点：

- **底色**：做旧羊皮纸（#F5E6D3），微黄、轻微污渍、边缘老化
- **技法**：手绘水彩+彩铅，类 18-19 世纪自然史博物插画
- **主色**：暖棕 #8B6914、焦糖 #D2691E、琥珀 #FFBF00
- **点缀**：朱红 #C55A5A（印章）、深蓝 #2C3E6B（学名）
- **禁用**：霓虹、高饱和荧光、纯黑大面积
- **文字**：大标题「」+ 英文副标题 + 伪拉丁学名 + 手写标注
- **装饰**：标注线、放大圆、剪影对比、复古图表、朱红印章

详细定义：`references/elements/`

## Outline Strategies

| 策略 | 名称 | 理念 | 适合 |
|------|------|------|------|
| A | 百科全书型 | 广度优先，系统展示 | 品种图鉴、分类百科 |
| B | 深度解剖型 | 深度优先，多维拆解 | 单品分析、行为图解 |
| C | 场景叙事型 | 趣味优先，场景串联 | 行为过程、搭配指南 |

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
分析：核心对象、信息类型、深度、调性、幽默潜力。输出推荐变体+构图+页数。
参考：`references/workflows/analysis-framework.md`

### Step 2: Confirmation 1 ⚠️
用 AskUserQuestion 确认：变体 / 方向(竖/横) / 规模(3/4-5/6-8张)

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
- 一个主体 + 6-12 个标注点
- 3-5 个场景小图
- 1-2 个数据图表（星级/雷达图/柱状图）
- 放大圆 + 对比剪影 + 伪学名

| 位置 | 密度 | 要求 |
|------|------|------|
| 封面 | 最高 | 大标题+副标题+伪学名+主体+多标注 |
| 内容页 | 高 | 每页一维度，塞满细节 |
| 结尾页 | 中高 | 数据面板/金句/总览 |

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
