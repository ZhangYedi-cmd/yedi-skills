---
name: wanwu-tujian
description: >
  生成「万物图鉴」风格的小红书系列组图。将任意主题拆解为高信息密度的复古百科插画系列
  （封面+内容页+结尾页），风格完全对标小红书博主「万物图鉴」(@知渡)。固定视觉DNA
  （仿古宣纸底色、工笔博物画风、红色方印角标、「」标题系统），内置 2 种风格变体 ×
  6 种构图模式 × 12 种版面。当用户提到"万物图鉴"、"复古图鉴"、"图鉴风格"、"百科风插画"、
  "科普图鉴"、"古风知识图"、"encyclopedia illustration"时使用此技能。
  即使用户只说"帮我做一组关于XX的科普图片"，只要主题适合图鉴式展示，也应考虑使用。
---

# 万物图鉴系列生成器

将任意主题拆解为高信息密度的复古百科插画系列，输出 Prompt 并调用图片生成工具出图。
风格完全对标小红书博主「万物图鉴」(@知渡)。

## Usage

```bash
/wanwu-tujian 积累福报的六种行为
/wanwu-tujian 中华田园猫品种大全 --style realistic-portrait --composition group-portrait
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

## 核心设计：Style × Composition × Layout（3轴系统 v2.0）

三个可组合维度，根据内容自动推荐最优组合：

| 维度 | 控制内容 | 选项 |
|------|----------|------|
| **Style** | 插画风格+色彩能量+光效 | 2 种风格变体 |
| **Composition** | 信息组织方式 | 6 种构图模式 |
| **Layout** | 画面空间排列 | 7 竖版 + 5 横版 |

## Style Gallery（2 种风格变体）

| Style Variant | 中文名 | 色彩能量 | 互动量 | 适用 |
|---------------|--------|---------|--------|------|
| `realistic-portrait` | 写实群像 | VIBRANT (高饱和) | ⭐⭐⭐⭐ | 犬种/猫种/动植物 |
| `traditional-encyclopedia` | 传统百科 | WARM (暖色对比) | ⭐⭐⭐⭐ | 通用百科/教程（默认） |

详细定义：`references/elements/illustration-styles.md`

## 统一视觉 DNA

所有风格变体共享的固定锚点（对标 @知渡 实际发布风格）：

- **文字**：超大黑体主标题 + 英文副标题（·分隔）+ 中文分类说明行
- **角标**：红色方块印章（左上+右上），内含2-4字中文（「图鉴」「天规」「百科」等）
- **署名**：作者：@知渡
- **禁用**：维多利亚西式边框、伪拉丁文
- **Module 2 一致性**：同系列选定一个 Style Variant，所有图逐字一致

**按风格变体差异**（详见 `elements/illustration-styles.md`）：
- **realistic-portrait**: 写实纹理+自然侧光+品种信息卡（VIBRANT 高饱和）
- **traditional-encyclopedia**: 宣纸底+工笔水彩+知识图解叠层（WARM 暖色对比）

详细色彩：`references/elements/color-palettes.md`
详细装饰：`references/elements/decorations.md`

## Composition Gallery

| Composition | 中文名 | 适用场景 | 核心视觉 |
|-------------|--------|----------|----------|
| `group-portrait` | 群像集合式 | 品种/分类/大全 | 中央大主体+周围6-12小主体 |
| `center-radial` | 中心辐射式 | 规则/方法/哲理（最高互动） | 中央核心概念+放射子元素 |
| `infographic` | 信息图表式 | 教程/步骤/指南 | 步骤流程+左右分栏 |
| `scattered-icons` | 散点图标式 | 抽象哲理/品质清单 | 概念图标自然散布 |
| `grid-collage` | 九宫格/拼贴式 | 合集/并列知识/文化大全 | 3×3知识卡片网格 |
| `anatomy-atlas` | 博物解剖式 | 单品深度解析/结构分析 | 中央主体+标注线+剖面图 |

详细定义：`references/compositions/<composition>.md`

## Layout Gallery

**竖版 Portrait (1792×2400 / 3:4)**：center-radial, annotated, grid-surround, fusion-plate, sequential, knowledge-split, tri-panel

**横版 Landscape (16:9 / 4:3)**：side-by-side, panoramic, timeline-flow, scene-map, dashboard

详细定义：`references/layouts/`

## Auto Selection（3轴自动推荐）

| 内容信号 | Style | Composition | Layout |
|----------|-------|-------------|--------|
| 星座/MBTI/性格/人格类型 | traditional-encyclopedia | group-portrait / center-radial | center-radial / annotated |
| 福报/功德/因果/修行/天规/佛道 | traditional-encyclopedia | center-radial / scattered-icons | annotated / knowledge-split |
| 犬种/猫种/动物品种/花卉鉴赏 | realistic-portrait | group-portrait / anatomy-atlas | center-radial / tri-panel |
| 品种/种类/分类/大全/图鉴 | traditional-encyclopedia | group-portrait | center-radial / panoramic |
| 规则/行为/方法/秘诀/X种/X个 | traditional-encyclopedia | center-radial | annotated / knowledge-split |
| 步骤/教程/怎么做/流程/指南 | traditional-encyclopedia | infographic | sequential / timeline-flow |
| 人生/哲理/道理/准则/十则 | traditional-encyclopedia | scattered-icons | center-radial / annotated |
| 合集/国粹/民俗/习俗/文化 | traditional-encyclopedia | grid-collage | grid-surround / panoramic |
| 解析/成分/结构/功效/本草 | traditional-encyclopedia | anatomy-atlas | tri-panel / annotated |

## Outline Strategies

| 策略 | 名称 | 理念 | 适合 | 页数 |
|------|------|------|------|------|
| A | 百科全书型 | 广度优先，系统概览 | 品种图鉴、分类百科 | 4-6 |
| B | 深度洞察型 | 深度优先，多角度深挖 | 单品分析、行为图解 | 4-5 |
| C | 故事启发型 | 叙事驱动，场景智慧 | 行为过程、生活智慧 | 3-5 |

## File Structure

```
wanwu-tujian/{topic-slug}/
├── analysis.md
├── outline-strategy-{a,b,c}.md
├── outline.md (最终选定)
├── prompts/01-cover-[slug].md ...
├── 01-cover-[slug].png ...
```

**Slug Generation**:
1. 从内容提取主题（2-4词，拼音 kebab-case）
2. 示例: "积累福报的六种行为" → `ji-lei-fu-bao`

**Conflict Resolution**:
如 `wanwu-tujian/{topic-slug}/` 已存在：
- 追加时间戳: `{topic-slug}-YYYYMMDD-HHMMSS`

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

**Purpose**: 加载用户偏好或执行首次设置。

**CRITICAL**: 如未找到 EXTEND.md，必须先完成首次设置再执行任何其他步骤。不要跳到内容分析，不要询问构图——仅完成偏好设置。

使用 Bash 检查 EXTEND.md 是否存在（优先级顺序）：

```bash
# 先检查项目级
test -f .wanwu-tujian/EXTEND.md && echo "project"

# 再检查用户级
test -f "$HOME/.wanwu-tujian/EXTEND.md" && echo "user"
```

| 路径 | 位置 |
|------|------|
| `.wanwu-tujian/EXTEND.md` | 项目目录 |
| `$HOME/.wanwu-tujian/EXTEND.md` | 用户主目录 |

| 结果 | 操作 |
|------|------|
| 找到 | 读取、解析、显示摘要 → 继续 Step 1 |
| 未找到 | ⛔ BLOCKING: 仅执行首次设置 → 完成并保存 EXTEND.md → 然后 Step 1 |

**首次设置**（EXTEND.md 未找到时）：

**语言**: 使用用户的输入语言。

使用 AskUserQuestion 一次性提出所有问题。详见 `references/config/first-time-setup.md`。

Schema: `references/config/preferences-schema.md`

### Step 1: Analyze Content → `analysis.md`

分析主题内容并进行深度分析。

**操作**:
1. 读取源内容（如用户提供文件则直接使用，如粘贴则保存为 `source.md`）
2. **深度分析**（遵循 `references/workflows/analysis-framework.md`）：
   - 内容类型分类（人生哲理/知识科普/生活实用/趋势商业/传统文化）
   - Hook 分析（爆款标题潜力，含万物图鉴专属钩子）
   - 受众画像识别
   - 互动潜力评估（收藏/分享/评论/互动）
   - **风格变体推荐**（内容信号→风格自动匹配，参考 `illustration-styles.md`）
   - 内容信号→构图自动推荐
   - 翻页流设计
3. 确定推荐图片数量（2-8）
4. **保存到 `analysis.md`**

### Step 2: Confirmation 1 — 风格/构图/方向/规模 ⚠️

**Purpose**: 验证理解 + 收集补充信息。**不可跳过。**

**展示分析摘要**:
- 内容类型 + 主题
- 核心要点
- 推荐风格 + 色彩能量 + 理由
- 推荐构图 + 理由

**使用 AskUserQuestion**:
1. **风格变体**（展示推荐 + 备选）：realistic-portrait / traditional-encyclopedia
2. 构图模式（展示推荐 + 备选）
3. 方向：竖版(Recommended) / 横版
4. 规模：3张精简 / 4-5张标准(Recommended) / 6-8张完整

**回复后**: 更新 `analysis.md` → Step 3

### Step 3: Generate 3 Outlines

基于分析+用户确认，生成3套差异化大纲。每套包含构图 + 大纲结构。

**每套策略**:

| 策略 | 文件 | 大纲 | 推荐构图 |
|------|------|------|----------|
| A | `outline-strategy-a.md` | 百科全书型：广度，系统展示 | 匹配内容 |
| B | `outline-strategy-b.md` | 深度洞察型：深度，多维拆解 | 匹配内容 |
| C | `outline-strategy-c.md` | 故事启发型：叙事，场景智慧 | 匹配内容 |

**大纲格式** (YAML front matter + content):
```yaml
---
strategy: a
name: 百科全书型
style: traditional-encyclopedia
style_reason: "规则类内容适合传统百科风格"
color_energy: WARM
theme_color: ""
light_effect: ink-atmospheric
composition: center-radial
composition_reason: "规则类内容，中心辐射式互动量最高"
default_layout: annotated
orientation: portrait
image_count: 5
---

## P1 封面
**Type**: cover | **Layout**: center-radial
**标题**: 「积累福报的六种行为」
**副标题**: 中国传统智慧·处世之道
**左上角标**: 「图鉴」| **右上角标**: 「福报」
**主体**: [描述] | **标注**: [列表] | **装饰**: [列表]
**信息密度**: 高
```

**差异化要求**:
- 每套策略大纲结构不同 + 可能推荐不同构图
- 页数适配: A 通常 4-6, B 通常 4-5, C 通常 3-5
- 包含 `composition_reason` 说明理由

Reference: `references/workflows/outline-template.md`

### Step 4: Confirmation 2 — 选择大纲 ⚠️

**Purpose**: 用户选择大纲策略并可微调。**不可跳过。**

**展示每套策略**:
- 策略名 + 页数 + 推荐构图
- 逐页摘要（P1 → P2 → P3...）

**使用 AskUserQuestion**:

**问题 1: 选择策略**
- Strategy A (百科全书型)
- Strategy B (深度洞察型)
- Strategy C (故事启发型)
- 组合：指定各策略中的具体页面

**问题 2: 调整（可选）**
- 使用默认设置 (Recommended)
- 调整页面数量
- 调整特定页面内容

**回复后**:
- 单一策略 → 复制到 `outline.md`
- 组合 → 合并指定页面
- 自定义 → 基于反馈重新生成

### Step 5: Generate Images

有了确认的大纲后：

**参考图链（Visual Consistency）**:
1. **生成图1（封面）** — 不使用 `--ref`
2. **图2+ 以图1为 `--ref`** — 锚定风格一致性

**逐张操作**:
1. 保存 prompt 到 `prompts/NN-{type}-[slug].md`
2. 生成图片：
   - **图1**: 无 `--ref`（建立视觉锚点）
   - **图2+**: 加 `--ref <image-01-path>` 保持一致性
3. 每张生成后报告进度

**水印**（如偏好中启用）：
```
Include a subtle watermark "[content]" positioned at [position].
The watermark should be legible but not distracting from the main content.
```
Reference: `references/config/watermark-guide.md`

**Session 管理**:
- Session ID 格式: `wanwu-{topic-slug}-{timestamp}`
- 同系列所有图使用相同 Session ID

### Step 6: Completion Report

```
万物图鉴系列完成！

主题: [topic]
策略: [A/B/C/Combined]
风格: [style variant name]
色彩能量: [VIBRANT/WARM]
构图: [composition name]
版面: [layout name or "varies"]
路径: [directory path]
图片: N 张

✓ analysis.md
✓ outline-strategy-a.md
✓ outline-strategy-b.md
✓ outline-strategy-c.md
✓ outline.md (选定: [strategy])

文件:
- 01-cover-[slug].png ✓ 封面
- 02-content-[slug].png ✓ 内容页
- 03-content-[slug].png ✓ 内容页
- 04-ending-[slug].png ✓ 结尾页
```

## Composition × Layout Compatibility

| | center-radial | annotated | grid-surround | fusion-plate | sequential | knowledge-split | tri-panel | side-by-side | panoramic | timeline-flow | scene-map | dashboard |
|---|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
| group-portrait | ✓✓ | ✓ | ✓✓ | — | — | ✓ | ✓ | ✓ | ✓✓ | — | — | ✓ |
| center-radial | ✓✓ | ✓✓ | — | — | ✓ | ✓✓ | — | ✓ | — | — | — | ✓✓ |
| infographic | — | ✓ | — | — | ✓✓ | ✓ | — | — | — | ✓✓ | — | — |
| scattered-icons | ✓✓ | ✓ | ✓ | — | — | — | — | — | — | — | ✓✓ | — |
| grid-collage | ✓ | — | ✓✓ | — | — | — | — | — | ✓✓ | — | ✓ | — |
| anatomy-atlas | ✓ | ✓✓ | — | ✓ | — | ✓✓ | ✓✓ | ✓✓ | — | — | — | ✓✓ |

## Image Modification

| 操作 | 步骤 |
|------|------|
| **修改** | **先更新 prompt 文件** → 同 session 重新生成 |
| **插入** | 指定位置 → 创建 prompt → 生成 → 重编号后续文件(NN+1) → 更新 outline |
| **删除** | 删除文件 → 重编号后续(NN-1) → 更新 outline |

## Series Design Principles

每张图追求**高信息密度**：
- 一个主体 + 6-12 个标注点
- 2-4 个知识框（带边框的文字区块）
- 1-3 个场景小图或工具图解
- 底部总结框/金句框

| 位置 | 密度 | 要求 |
|------|------|------|
| 封面 | 最高 | 大标题+角标印章+主体+多标注 |
| 内容页 | 高 | 每页一维度，深度展开细节 |
| 结尾页 | 中高 | 数据面板/金句/总览 |

## References

**Elements** (视觉元素):
- `elements/illustration-styles.md` — 2种风格变体定义（v2.0核心）
- `elements/canvas.md` — 画布规格、安全区、按风格信息密度
- `elements/color-palettes.md` — 主题色系统、色彩能量、光效、按风格色彩模板
- `elements/typography.md` — 印章+双语标题系统
- `elements/decorations.md` — 知识图解叠层+高互动信息模块+按风格装饰

**Compositions** (构图模式):
- `compositions/group-portrait.md` — 群像集合式
- `compositions/center-radial.md` — 中心辐射式
- `compositions/infographic.md` — 信息图表式
- `compositions/scattered-icons.md` — 散点图标式
- `compositions/grid-collage.md` — 九宫格/拼贴式
- `compositions/anatomy-atlas.md` — 博物解剖式

**Layouts** (版面):
- `layouts/portrait-layouts.md` — 7种竖版
- `layouts/landscape-layouts.md` — 5种横版

**Workflows** (工作流):
- `workflows/analysis-framework.md` — 内容分析框架
- `workflows/outline-template.md` — 大纲模板
- `workflows/prompt-assembly.md` — 提示词组装（9模块+参考图链）

**Config** (配置):
- `config/preferences-schema.md` — EXTEND.md schema
- `config/first-time-setup.md` — 首次设置流程
- `config/watermark-guide.md` — 水印配置

## Notes

- 自动重试一次失败的生成 | 敏感人物用卡通替代
- 使用确认的语言偏好 | 保持风格一致性
- **两个确认点必须执行**（Steps 2 & 4）— 不可跳过
- 所有图 Module 2（Style Base Variant）逐字一致
- Module 7/8 必须与选定的 Style Variant 匹配

## Extension Support

通过 EXTEND.md 自定义配置。详见 **Step 0** 的路径和选项。
