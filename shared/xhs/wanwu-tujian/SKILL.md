---
name: wanwu-tujian
description: >
  生成「万物图鉴」风格的小红书系列组图。将任意主题拆解为高信息密度的复古百科插画系列
  （封面+内容页+结尾页），风格完全对标小红书博主「万物图鉴」(@知渡)。固定视觉DNA
  （做旧暖褐宣纸底、工笔博物画风、毛笔书法标题、2-4角红色方印+散布印章），内置 3 种风格变体 ×
  4 种构图模式 × 5 种版面。当用户提到"万物图鉴"、"复古图鉴"、"图鉴风格"、"百科风插画"、
  "科普图鉴"、"古风知识图"、"encyclopedia illustration"时使用此技能。
  即使用户只说"帮我做一组关于XX的科普图片"，只要主题适合图鉴式展示，也应考虑使用。
---

# 万物图鉴系列生成器 v3.3

将任意主题拆解为高信息密度的复古百科插画系列，输出 Prompt 并调用图片生成工具出图。
风格完全对标小红书博主「万物图鉴」(@知渡)。

## Usage

```bash
/wanwu-tujian 积累福报的六种行为
/wanwu-tujian 中华田园猫品种大全 --style realistic-portrait --composition group-portrait
/wanwu-tujian 十二生肖古代雅称 --style anthropomorphic-portrait
/wanwu-tujian 正确去黑头的五个步骤 --pages 5 --model gemini
```

## Options

| Option | Description | Default |
|--------|-------------|---------|
| `--style <s>` | 风格变体 | 自动推断 |
| `--composition <c>` | 构图模式 | 自动推断 |
| `--orientation <o>` | portrait / landscape | portrait |
| `--pages <n>` | 系列图片数量 (2-8) | 自动推断 |
| `--model <m>` | gemini / gpt / nano-banana | 按可用性选择 |

---

## 核心设计：Style × Composition × Layout（3轴系统 v3.3）

三个可组合维度，根据内容自动推荐最优组合：

| 维度 | 控制内容 | 选项 |
|------|----------|------|
| **Style** | 插画风格+色彩能量+写实度 | 3 种风格变体 |
| **Composition** | 信息组织方式 | 4 种构图模式 |
| **Layout** | 画面空间排列 | 3 竖版模式 + 2 横版 |

---

## Style Gallery（3 种风格变体 — v3.3 新增拟人博物）

| Style Variant | 中文名 | 色彩能量 | 写实度 | 适用 |
|---------------|--------|---------|--------|------|
| `realistic-portrait` | 写实群像 | NATURAL (自然画感) | 80-85% | 犬种/猫种/动植物 |
| `traditional-encyclopedia` | 传统百科 | WARM (暖色对比) | 70-80% | 通用百科/教程（默认） |
| `anthropomorphic-portrait` | 拟人博物 | WARM-VIBRANT (鲜明暖色) | 75-80% | 生肖/神话角色/拟人动物 |

详细定义：`references/elements/illustration-styles.md`

---

## 统一视觉 DNA（v3.3 更新）

所有风格变体共享的固定锚点（对标 @知渡 实际发布风格）：

- **标题**：L1 **毛笔书法体**（粗细笔画变化、墨迹边缘，非印刷黑体）
- **角标印章**：红色方块印章（2-4角），内含2-4字中文
- **散布印章**：额外 2-3 个红色印章分散于画面，朱砂红贯穿全图
- **署名**：作者：@知渡
- **背景**：做旧暖褐宣纸底(#E8D5B0)，微妙纸纹，**无重度做旧**
- **封面**：按构图选择版面（dense-cluster 或 focal-radial）
- **可选装饰**：中式角花（龙纹/云纹/如意纹）、外框线、竖排侧文
- **禁用**：维多利亚西式边框、伪拉丁文、anime 风格、3D CGI

**按风格变体差异**（详见 `elements/illustration-styles.md`）：
- **realistic-portrait**: 写实纹理+自然侧光+品种信息卡（NATURAL 画感）
- **traditional-encyclopedia**: 宣纸底+工笔水彩+知识图解叠层（WARM 暖色对比）
- **anthropomorphic-portrait**: 拟人角色+中式服装+贴身名牌标注（WARM-VIBRANT 鲜明暖色）

详细色彩：`references/elements/color-palettes.md`
详细装饰：`references/elements/decorations.md`

---

## Composition Gallery（4 种构图）

| Composition | 中文名 | 适用场景 | 核心视觉 | 封面版面 |
|-------------|--------|----------|----------|---------|
| `group-portrait` | 群像集合式 | 品种/分类/大全/文化合集 | 中央大主体+周围6-12小主体 | dense-cluster [+可选外框] |
| `center-radial` | 中心辐射式 | 规则/方法/哲理（最高互动） | 中央核心概念+放射子元素 | focal-radial ★ |
| `infographic` | 信息图表式 | 教程/步骤/指南 | 步骤流程+左右分栏 | dense-cluster |
| `anatomy-atlas` | 博物解剖式 | 单品深度解析/结构分析 | 中央主体+标注线+剖面图 | dense-cluster |

> **v3.3 变更**：center-radial 封面改用 focal-radial 版面（背景框S/M/L弹性+深色支持+元素骑框）

详细定义：`references/compositions/<composition>.md`

---

## Layout Gallery（v3.3 更新）

**竖版 Portrait (1792×2400 / 3:4)**：
- `dense-cluster`（封面，密集铺满；可选外框+角花）
- `focal-radial`（center-radial 封面专用，弹性背景框+辉光+放射）★ v3.3 重大更新
- `organic-poster`（内容页，有机自由布局）
- `annotated`（内容页子模式，上图下知识）

**横版 Landscape (16:9 / 4:3)**：`side-by-side` / `panoramic`

详细定义：`references/layouts/`

---

## Auto Selection（3轴自动推荐 — v3.3 含拟人博物+背景框档位）

| 内容信号 | Style | 写实度 | Composition | Cover Layout | 背景框档 |
|----------|-------|--------|-------------|--------------|---------|
| 星座/MBTI/性格/人格类型 | traditional-encyclopedia | 75-80% | center-radial | focal-radial | M |
| 福报/功德/因果/修行/天规/佛道 | traditional-encyclopedia | 70-75% | center-radial | focal-radial | S-M |
| 犬种/猫种/动物品种/花卉鉴赏 | realistic-portrait | 80-85% | group-portrait | dense-cluster | — |
| **生肖/神话角色/拟人动物合集** | **anthropomorphic-portrait** | **75-80%** | **group-portrait** | **dense-cluster [+外框+角花]** | — |
| 品种/种类/分类/大全/图鉴 | traditional-encyclopedia | 75-80% | group-portrait | dense-cluster | — |
| 规则/行为/方法/秘诀/X种/X个 | traditional-encyclopedia | 70-75% | center-radial | focal-radial | M |
| 步骤/教程/怎么做/流程/指南 | traditional-encyclopedia | 70-75% | infographic | dense-cluster | — |
| 人生/哲理/道理/准则/十则 | traditional-encyclopedia | 70-75% | center-radial | focal-radial | M |
| 合集/国粹/民俗/习俗/文化 | traditional-encyclopedia | 75-80% | group-portrait | dense-cluster [+外框] | — |
| 解析/成分/结构/功效/本草 | traditional-encyclopedia | 75-80% | anatomy-atlas | dense-cluster | — |
| **思维/框架/模型/10+元素** | traditional-encyclopedia | 70-75% | center-radial | focal-radial | **L (深色)** |

---

## Outline Strategies

| 策略 | 名称 | 理念 | 适合 | 页数 |
|------|------|------|------|------|
| A | 百科全书型 | 广度优先，系统概览 | 品种图鉴、分类百科 | 4-6 |
| B | 深度洞察型 | 深度优先，多角度深挖 | 单品分析、行为图解 | 4-5 |
| C | 故事启发型 | 叙事驱动，场景智慧 | 行为过程、生活智慧 | 3-5 |

---

## File Structure

```
wanwu-tujian/{topic-slug}/
├── analysis.md
├── outline-strategy-{a,b,c}.md
├── outline.md (最终选定)
├── prompts/01-cover-[slug].md ...
├── 01-cover-[slug].png ...
```

**Slug Generation**: 从内容提取主题（2-4词，拼音 kebab-case）
例: "积累福报的六种行为" → `ji-lei-fu-bao`

---

## Workflow

### Progress Checklist

```
万物图鉴系列 进度：
- [ ] Step 0: 检查偏好 (EXTEND.md) ⛔ BLOCKING
  - [ ] 找到 → 加载偏好 → 继续
  - [ ] 未找到 → 首次设置 → 必须完成后才能进入 Step 1
- [ ] Step 1: 分析主题 → analysis.md
- [ ] Step 2: 确认 1 — 风格/构图/方向/规模 ⚠️ REQUIRED
- [ ] Step 3: 生成 3 套大纲
- [ ] Step 4: 确认 2 — 选择大纲 ⚠️ REQUIRED
- [ ] Step 5: 逐张生成（Prompt → 生图）
- [ ] Step 6: 完成报告
```

### Flow

```
Input → [Step 0: Preferences] ─┬─ Found → Continue
                               │
                               └─ Not found → First-Time Setup ⛔ BLOCKING
                                              │
                                              └─ Complete setup → Save EXTEND.md → Continue
                                                                                      │
        ┌───────────────────────────────────────────────────────────────────────────┘
        ↓
Analyze → [Confirm 1] → 3 Outlines → [Confirm 2: Outline + Adjustments] → Generate → Complete
```

### Step 0: Load Preferences (EXTEND.md) ⛔ BLOCKING

**CRITICAL**: 如未找到 EXTEND.md，必须先完成首次设置。

```bash
test -f .wanwu-tujian/EXTEND.md && echo "project"
test -f "$HOME/.wanwu-tujian/EXTEND.md" && echo "user"
```

详见 `references/config/first-time-setup.md`

### Step 1: Analyze Content → `analysis.md`

遵循 `references/workflows/analysis-framework.md`。
确定：内容类型 / Hook / 受众 / 风格变体 / **写实度** / 构图 / **背景框档位(center-radial)** / 翻页流。

### Step 2: Confirmation 1 ⚠️

AskUserQuestion: 风格变体 / 构图 / 方向 / 规模 / [center-radial: 背景框尺寸+色调]。不可跳过。

### Step 3: Generate 3 Outlines

遵循 `references/workflows/outline-template.md`。

### Step 4: Confirmation 2 ⚠️

选择大纲策略（A/B/C/Combined）。不可跳过。

### Step 5: Generate Images

遵循 `references/workflows/prompt-assembly.md`（9模块）。
- 图1（封面）：按构图选版面（dense-cluster 或 focal-radial），无 --ref
- 图2+：有机海报布局，以图1为 --ref

### Step 6: Completion Report

```
万物图鉴系列完成！

主题: [topic]
策略: [A/B/C/Combined]
风格: [style variant] ([realism_level]% realism)
色彩能量: [NATURAL/WARM/WARM-VIBRANT]
构图: [composition name]
版面: 封面 [dense-cluster/focal-radial] / 内容页 organic-poster
[如 center-radial] 背景框: [shape] [S/M/L] [light/dark]
路径: [directory path]
图片: N 张
```

---

## Composition × Layout Compatibility（v3.3 更新）

|  | dense-cluster (封面) | focal-radial (封面) | organic-poster (内容) | annotated (内容) | side-by-side | panoramic |
|--|:---:|:---:|:---:|:---:|:---:|:---:|
| group-portrait | ✓✓ | — | ✓✓ | ✓ | ✓ | ✓✓ |
| center-radial | — | ✓✓ | ✓✓ | ✓✓ | ✓ | — |
| infographic | ✓✓ | — | ✓✓ | ✓ | — | — |
| anatomy-atlas | ✓✓ | — | ✓✓ | ✓✓ | ✓✓ | — |

---

## Image Modification

| 操作 | 步骤 |
|------|------|
| **修改** | **先更新 prompt 文件** → 同 session 重新生成 |
| **插入** | 指定位置 → 创建 prompt → 生成 → 重编号后续文件(NN+1) → 更新 outline |
| **删除** | 删除文件 → 重编号后续(NN-1) → 更新 outline |

---

## Series Design Principles（v3.3 更新）

每张图追求**高信息密度**：

**封面页 — dense-cluster**（group-portrait/infographic/anatomy-atlas）：
- 锚定人物/主体占画面一侧（全高度）
- 6-10 支撑主体紧密叠压环绕
- 散落元素填充空白
- 背景深度（极淡建筑/自然剪影）
- L1 毛笔书法标题 + 4-7 处红色印章
- [可选] 外框线+中式角花、主体名牌标注

**封面页 — focal-radial**（center-radial 专用）：
- 外框线 [+可选角花]
- 中央背景框（S/M/L 弹性，淡彩/深色可选）
- 中央主体叠压+暖金辉光
- 6-12 放射元素（钟点排列，L档可骑框）
- [可选] 竖排侧文(L8)、底部横幅条(L9)

**内容页**（organic-poster）：
- 主体 + 6-12 个标注点
- 2-4 个知识框（带边框的文字区块）
- L6 关键词标签条（主体下方）
- L7 底部智慧引用框
- 1-3 个场景小图或工具图解

---

## References

**Elements** (视觉元素):
- `elements/illustration-styles.md` — 3种风格变体定义 + realism_level 参数（v3.3）
- `elements/canvas.md` — 画布规格、安全区、按风格信息密度
- `elements/color-palettes.md` — 色彩体系、红色分布系统（v3.1）
- `elements/typography.md` — 9级文字层级（v3.3 新增 L8 侧文 + L9 底部横幅）
- `elements/decorations.md` — 弹性背景框、2-4角印章、中式角花、名牌系统（v3.3）

**Compositions** (构图模式 — 4种):
- `compositions/group-portrait.md` — 群像集合式（含 dense-cluster + grid-panel 子模式）
- `compositions/center-radial.md` — 中心辐射式（v3.3 弹性背景框+深色+骑框）
- `compositions/infographic.md` — 信息图表式
- `compositions/anatomy-atlas.md` — 博物解剖式

**Layouts** (版面):
- `layouts/portrait-layouts.md` — dense-cluster(+外框) + focal-radial(弹性) + organic-poster + annotated
- `layouts/landscape-layouts.md` — side-by-side + panoramic

**Workflows** (工作流):
- `workflows/analysis-framework.md` — 内容分析框架（含写实度推荐）
- `workflows/outline-template.md` — 大纲模板（含封面规划）
- `workflows/prompt-assembly.md` — 提示词组装（9模块，v3.3 含3风格变体+弹性系统）

**Config** (配置):
- `config/preferences-schema.md` — EXTEND.md schema v3
- `config/first-time-setup.md` — 首次设置流程
- `config/watermark-guide.md` — 水印配置

---

## Notes

- 自动重试一次失败的生成 | 敏感人物用卡通替代
- 使用确认的语言偏好 | 保持风格一致性
- **两个确认点必须执行**（Steps 2 & 4）— 不可跳过
- 所有图 Module 2（Style Base Variant）逐字一致
- Module 7/8 必须与选定的 Style Variant 匹配
- **封面版面按构图选择**：group-portrait → dense-cluster；center-radial → focal-radial（v3.3）
- **L1 标题必须指定毛笔书法风格**（v3.1 规定）
- **center-radial 背景框尺寸按元素数弹性调整**（S/M/L 三档，v3.3 规定）

## Extension Support

通过 EXTEND.md 自定义配置。详见 **Step 0** 的路径和选项。
