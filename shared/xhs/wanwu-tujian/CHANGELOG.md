# Changelog

## 3.1.0 (2026-03-03)

### realism_level 参数 + 视觉 DNA 强化

基于实际封面生成迭代，引入动态写实度参数，强化毛笔书法标题和印章系统。

**新增**:
- **`realism_level` 动态参数** (70-85%): 按内容类型自动映射写实度
  - Prompt 模板：`[X]% photorealism with [100-X]% hand-painted artistic warmth`
  - realistic-portrait: 80-85%（写实感更强）
  - traditional-encyclopedia: 70-80%（更多手绘画感）
- **毛笔书法 L1 标题规范**: 所有图片 L1 必须指定 `BOLD BRUSH CALLIGRAPHY STYLE (毛笔书法字体) — thick and thin stroke variation, ink bleeding edges, NOT printed font`
- **扩展印章系统**: 2 固定角标 + 2-3 散布印章（朱砂红贯穿全图，共 6-12 个红色锚点）
- **封面底部点分隔列表**: 封面 L3 位置使用 `[词1] · [词2] · [词3]` 格式（非「」标签）
- **`realism_level` 字段**: analysis.md/outline.md YAML 新增此字段
- **Auto Selection 写实度列**: SKILL.md 自动推荐表新增 realism_level 列

**升级**:
- preferences-schema 版本升级到 v3（新增 `realism_level: auto` 字段）
- first-time-setup EXTEND.md 模板同步 v3 schema
- 所有 composition 文件的 Elements 配置新增 `realism_level` 字段
- prompt-assembly.md Module 1 新增 realism_level 注入
- analysis-framework.md 风格推荐表新增写实度列

---

## 3.0.0 (2026-03-03)

### Style × Composition × Layout 精简重构

基于对 @知渡 10+ 张实际爆款图的深度分析，大幅精简视觉体系，提升 Prompt 质量。

**核心变化**:

#### 视觉系统升级
- **背景色净化**: `#F0E0C0~#E8D5B0` → `#F5EED8~#FAF5EC`（更干净，无重度做旧感）
- **纸张质感简化**: 彻底移除 fold marks、age spots、worn edges、dark stains
- **色彩能量重命名**: `VIBRANT` → `NATURAL`（realistic-portrait 专用，50-75%饱和度）
- **主题色精简**: 12色 → 6色（保留 fire-red, ocean-blue, forest-green, royal-gold, earth-brown, jade-green）

#### 布局重构（竖版）
- **删除 `tri-panel`**（刚性三栏）
- **新增 `organic-poster`**（有机海报式）: 主体自由扩展，不受栏位限制，信息模块有机散布
- **新增 `dense-cluster`**（封面专用）: 密集铺满，锚定主体占整侧，支撑主体紧密叠压，散落元素填充
- **保留 `annotated`**（内容页子模式，上图下知识）
- 横版: 5种 → 2种（保留 side-by-side, panoramic）

#### 构图精简（6→4）
- **合并 `scattered-icons` → `center-radial`**（新增 scattered-concept 子模式）
- **合并 `grid-collage` → `group-portrait`**（新增 grid-panel 子模式）
- 保留：`group-portrait`, `center-radial`, `infographic`, `anatomy-atlas`
- 删除文件：`scattered-icons.md`, `grid-collage.md`

#### 字体层级扩展（7级）
- **L4 分区标题**（新）: Bold + 边框容器，用于区块标题
- **L6 「」关键词标签**（新）: 水平排列标签条，红色边框/底色
- **L7 引用/智慧框**（新）: 红框智慧语录/幽默点评，底部固定位置
- L1 明确要求毛笔书法风格（v3.1 进一步强化）

#### 信息模块新增
- 「」关键词标签条（主体下方 3-6 个标签）
- 红框引用/智慧框（L7，底部）
- 金属器物星形闪光效果
- 封面背景深度（极淡建筑/自然剪影，水墨晕染）
- 散落主题元素（小图标散落在画面空白处）

#### 工作流更新
- `analysis-framework.md`: 内容信号→构图映射更新（4种），新增 realism_level 列
- `outline-template.md`: YAML 新增 cover_layout: dense-cluster 字段，封面规划更新
- `prompt-assembly.md`: Module 1 realism_level，Module 2 变体更新（NATURAL/photorealist→naturalist），Module 7 散布印章+金属闪光+散落元素
- `preferences-schema.md`: v3 schema（4构图，paper_aging 默认 light，新增 realism_level）

**向后兼容**:
- traditional-encyclopedia 作为默认，v2.0 内容调整风格描述后可复用
- 旧 EXTEND.md（v2）自动迁移：VIBRANT→NATURAL, scattered-icons→center-radial, grid-collage→group-portrait

---

## 2.0.0 (2026-03-03)

### Style × Composition × Layout 3轴系统

从单一风格升级为 **4 种风格变体 × 6 种构图 × 11 种版面** 的完整组合系统。
基于对 @知渡 博主实际发布内容的深度分析，识别出其使用的多种视觉风格。

**新增**:
- **4 种插画风格变体** (`illustration-styles.md`):
  - `cartoon-infographic` 卡通信息图 — Q版角色+主题色光环（互动量最高，对标12星座系列）
  - `celestial-narrative` 仙侠叙事 — 仙人长袍+金光粒子+天界氛围（对标积累福报系列）
  - `realistic-portrait` 写实群像 — 写实纹理+自然光影（对标护主狗系列）
  - `traditional-encyclopedia` 传统百科 — 宣纸+工笔+知识叠层（升级版默认）
- **色彩能量系统** (3级): WARM → VIBRANT → RADIANT（废弃 v1.0 MUTED 级别）
- **主题色系统**: 12 种命名主题色（fire-red, ocean-blue, royal-gold 等）
- **光效描述库**: 7 种光效类型（divine-golden, elemental-fire/ice/star/nature, natural-warm, ink-atmospheric）
- **8 种高互动信息模块** (`decorations.md`): 成就徽章栏、行为漫画条、雷达图、矛盾体对比、成长四格、标签云、幽默金句框、高光时刻
- **按风格的 Module 7/8**: 装饰集和排除项根据风格变体自动切换
- **风格自动推荐**: 内容信号→风格映射表（analysis-framework.md）
- **按风格信息密度指引**: canvas.md 按 4 种风格分别定义密度标准
- **构图风格适配**: 6 个 composition 文件各增加 Style Variant Adaptations 表
- `--style` 命令行选项
- 首次设置新增风格偏好问题

**升级**:
- SKILL.md 核心设计从「固定风格 × Composition × Layout」升级为「Style × Composition × Layout」
- Step 2 确认点增加风格变体选择
- 大纲 YAML 新增 style/color_energy/theme_color/light_effect 字段
- prompt-assembly.md Module 2 从单一块升级为 4 个命名变体
- preferences-schema 版本升级到 v2（新增 preferred_style, color_energy, enable_light_effects）
- color-palettes.md 新增主题色、能量级别、光效、按风格色彩模板
- traditional-encyclopedia 色彩能量从 MUTED 升级为 WARM（自然主体更饱和）
- Prompt 检查清单增加风格相关检查项

**向后兼容**:
- traditional-encyclopedia 作为升级版默认，v1.0 内容无需修改
- 现有 EXTEND.md（v1）仍可使用，缺失字段使用默认值

---

## 1.0.0 (2026-03-03)

### Initial Release

从 `retro-enc` (v0.2.0) + `baoyu-xhs-images` 合并而来的全新技能。

**来源**:
- **retro-enc**: 视觉元素系统（宣纸色系、印章角标、知识图解叠层、文字层级）、9模块 Prompt 结构、版面模板
- **baoyu-xhs-images**: 成熟工作流（首次设置引导、深度内容分析、受众识别、2个确认点、参考图链机制）

**新增**:
- 6种全新构图模式（替代 retro-enc 的6种 variant）：
  - `group-portrait` 群像集合式 — 品种/分类/大全
  - `center-radial` 中心辐射式 — 规则/方法/哲理（最高互动）
  - `infographic` 信息图表式 — 教程/步骤/指南
  - `scattered-icons` 散点图标式 — 抽象哲理/品质清单
  - `grid-collage` 九宫格/拼贴式 — 合集/并列知识/文化大全
  - `anatomy-atlas` 博物解剖式 — 单品深度解析/结构分析
- 万物图鉴专属 Hook 模式：权威古典钩、数量钩、秘密钩
- 内容信号→构图自动推荐映射表
- 5类万物图鉴内容分类：人生哲理、知识科普、生活实用、趋势商业、传统文化
- 参考图链机制：图1无--ref → 图2+以图1为--ref
- Session ID 管理：`wanwu-{slug}-{timestamp}`
- 3种百科图鉴大纲策略：百科全书型(A)、深度洞察型(B)、故事启发型(C)
- Composition × Layout 兼容矩阵（6×11）
- 首次设置引导（水印/构图偏好/保存位置）

**固定**:
- 视觉风格锁定为万物图鉴DNA（无多风格选择）
- 默认署名：作者：@知渡

**文件结构**:
- SKILL.md — 主定义
- 4 elements 文件 — 画布/色彩/文字/装饰
- 6 compositions 文件 — 全新构图模式
- 2 layouts 文件 — 竖版6种/横版5种
- 3 workflows 文件 — 分析/大纲/组装
- 3 config 文件 — 首次设置/偏好/水印
- VERSION + CHANGELOG.md
