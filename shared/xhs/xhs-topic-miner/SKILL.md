---
name: xhs-topic-miner
description: >
  小红书复古图鉴账号的选题挖掘引擎。基于 STEPPS 传播力模型（Berger, 沃顿商学院）、
  Content Pillar×Bucket 矩阵、GAPS 竞品分析框架，系统化地发现、评估、管理选题。
  支持两种发现模式：analyze（竞品分析）和 research（市场横向扫描，无需指定博主）。
  与 retro-enc（图鉴生成）和 xiaohongshu-mcp（发布）形成完整内容流水线。
  当用户提到"选题"、"找话题"、"内容规划"、"竞品分析"、"爆款分析"、
  "蓝海"、"市场调研"、"自动调研"时使用此技能。
---

# 小红书选题挖掘引擎

将「靠灵感找选题」变成「用系统产选题」。

## Usage

```bash
# 竞品模式（指定博主）
/topic-miner analyze <博主URL>              # 竞品拆解

# 调研模式（无需指定博主，自动横向扫描市场）
/topic-miner research                       # 全品类市场扫描
/topic-miner research --category 传统文化   # 指定品类（影响关键词矩阵）
/topic-miner research --n 50               # 候选池大小（默认50）

# 选题生成与管理
/topic-miner generate                       # 生成选题（基于已有分析）
/topic-miner generate --pillar 传统智慧      # 指定支柱方向
/topic-miner generate --hot                 # 结合当前热点
/topic-miner score "中国十大名茶图鉴"         # 单个选题评分
/topic-miner backlog                        # 查看选题池
/topic-miner init                           # 首次初始化（设置支柱体系）
```

## 前置条件速查（消除歧义）

| 命令 | 硬前置条件（缺一不可） | 缺失时行为 |
|------|--------------------|------------|
| `init` | 1-3 个竞品 URL（建议含 `xsec_token`） | 无 URL 时阻塞并要求补充 |
| `analyze` | 可访问 `xiaohongshu-mcp.user_profile` + 竞品 URL | 条件不足时不执行分析 |
| `research` | 可访问 `search_feeds`；建议可访问 `get_feed_detail` | 缺 `get_feed_detail` 时降级为无评论证据版报告 |
| `generate` | `topic-miner/config/pillars.yaml` 存在 | 无 `pillars.yaml` 时阻塞并引导先 `init` |
| `score` | 无（纯单题评分） | 始终可执行 |
| `backlog` | `topic-miner/backlog.yaml`（首次可自动创建） | 文件不存在时初始化空池 |

补充规则：
- `analyze` 可以独立运行，不强制先 `init`。但如果没有 `pillars.yaml`，只产出分析报告，不做矩阵配置。
- `generate` 默认走四路径；若缺 `analysis-*.md`，则跳过 `competitor_extend` 路径并在结果中标注降级原因。

## 两种发现模式对比

| 维度 | `analyze`（竞品模式） | `research`（调研模式） |
|------|---------------------|----------------------|
| 输入 | 指定博主 URL | 无需输入（或指定品类） |
| 数据范围 | 单博主内容 | 跨账号市场（50篇） |
| 洞察类型 | 该博主做了什么 → 我能延伸什么 | 整个市场做了什么 → 哪里有空白 |
| 选题来源标记 | `competitor_extend` / `matrix_fill` | `gap_driven` |
| 适合场景 | 已知对标账号，深度学习 | 主动发现蓝海，不局限于特定博主 |

**推荐组合**：先 `research` 找方向，再 `analyze` 学做法。

## 方法论基础

本技能不是「拍脑袋」设计，每个模块都有明确的理论依据：

| 模块 | 理论来源 | 文件 |
|------|----------|------|
| 选题评分 | Berger STEPPS 模型（《Contagious》, 被引1300+） | `references/frameworks/stepps-scoring.md` |
| 内容架构 | Content Pillar × Bucket + Hero-Hub-Help | `references/frameworks/content-matrix.md` |
| 竞品分析 | GAPS 框架 + Content Shock 理论 | `references/frameworks/gaps-analysis.md` |
| 标题优化 | BuzzSumo 数据 + 平台实操总结 | `references/frameworks/title-formulas.md` |
| 选题生成 | 四路径并行法 | `references/workflows/topic-generation.md` |
| 竞品工作流 | 六步分析法 | `references/workflows/competitor-analysis.md` |

## 核心工作流

### Step 0: 初始化（首次推荐） ⛔ BLOCKING（仅在缺少 `pillars.yaml` 时）

```
/topic-miner init
```

1. 用户提供 1-3 个竞品博主 URL
2. 自动执行竞品分析（Step 1a，可复用 `analyze` 结果）
3. 基于分析结果，推荐 Content Pillar 体系
4. ⚠️ 用户确认/调整支柱和桶的定义
5. 保存到工作目录 `topic-miner/config/pillars.yaml`

如果工作目录下已有 `pillars.yaml`，`init` 不再阻塞，可直接 `analyze/research/generate`。

### Step 1a: 竞品分析（`analyze`）

参考 `references/workflows/competitor-analysis.md`

```
输入：博主主页 URL（含 xsec_token）
工具：xiaohongshu-mcp 的 user_profile
流程：
  1. 提取 user_id 和 xsec_token
  2. 获取博主信息 + 全部笔记列表
  3. 按点赞排序，识别爆款（TOP 20%）
  4. 题材聚类 + 标题模式提取
  5. 内容空白发现（联想词 vs 已发内容）
  6. 生成 GAPS 分析报告
输出：topic-miner/analysis-{博主}.md
```

可单独执行，不要求先 `init`。

### Step 1b: 市场调研（`research`）⭐ 新增

参考 `references/workflows/auto-research.md`

```
输入：品类关键词（可选，默认图鉴全品类）
工具：xiaohongshu-mcp 的 search_feeds + get_feed_detail
流程（5个Phase）：
  Phase 1 搜索矩阵扫描：三层关键词 × 8-10 次搜索，候选池 ~50 条
  Phase 2 质量过滤：2/3 规则（量化+结构+语义），精选池 25-30 条
  Phase 3 详情采样：TOP 10 调用 get_feed_detail，提取评论传播证据
  Phase 4 模式提炼：
    - What：高赞内容聚类（3-5个主题群）
    - Why：STEPPS 机制诊断（为什么能爆，机制性解释）
    - Gap：需求-供给缺口矩阵（🔴蓝海 / 🟡机会 / 🟢红海）
  Phase 5 选题生成：对 🔴 蓝海话题生成 gap_driven 选题，写入 backlog.yaml
输出：
  topic-miner/research-{YYYY-MM-DD}.md   市场调研报告（含 What/Why/Gap）
  topic-miner/backlog.yaml               追加 gap_driven 类型选题
```

**无需初始化即可运行**。`research` 不依赖支柱配置；`analyze` 只依赖竞品 URL 与 `user_profile`。

### Step 2: 选题生成（`generate`）

参考 `references/workflows/topic-generation.md`

```
前置条件：
  - 必须：`topic-miner/config/pillars.yaml`
  - 推荐：至少 1 份 `analysis-*.md`（用于 `competitor_extend` 路径）
流程：
  1. 四条路径并行：矩阵填充 / 竞品延伸 / 搜索热点 / 跨域迁移
  2. 合并去重，生成 ~20 个候选选题
  3. 每个选题生成 3 个标题变体（参考 title-formulas.md）
  4. STEPPS 六维评分（参考 stepps-scoring.md）
  5. Hero/Hub/Help 分层
  6. ⚠️ 展示结果，用户确认要加入选题池的
输出：topic-miner/batch-{日期}.md + 更新 backlog.yaml
```

### Step 3: 选题评分（`score`）

```
输入：单个选题标题或描述
流程：
  1. STEPPS 六维评分（逐维度说明理由）
  2. 计算加权总分
  3. 标题优化建议（参考 title-formulas.md 的检查清单）
  4. 推荐 retro-enc 的 variant 和 layout
输出：评分卡（终端展示，不保存文件）
```

### Step 4: 选题管理（`backlog`）

```
存储：topic-miner/backlog.yaml
状态：idea → planned → producing → published
Schema：references/config/backlog-schema.md
操作：
  /topic-miner backlog                  # 查看全部
  /topic-miner backlog --tier S         # 只看 S 级
  /topic-miner backlog --pick 3         # 推荐本周 3 个选题
  /topic-miner backlog --done "标题"     # 标记已完成
  /topic-miner backlog --published "标题" likes=500 collects=200  # 回填数据
```

## 与其他技能的衔接

```
xhs-topic-miner                    ← 你在这里
    ↓ 输出选题 + variant + layout 建议
retro-enc                          ← 图鉴生成
    ↓ 输出图片系列
xiaohongshu-mcp                    ← 发布
    ↓ 发布到小红书
xhs-topic-miner backlog --published ← 回填数据，闭环优化
```

## 依赖

| 依赖 | 工具 | 用途 | 必须？ |
|------|------|------|--------|
| xiaohongshu-mcp | `user_profile` | 获取博主数据（analyze 模式） | 是 |
| xiaohongshu-mcp | `search_feeds` | 搜索笔记（research + generate 热点路径） | 是 |
| xiaohongshu-mcp | `get_feed_detail` | 获取笔记详情和评论（research Phase 3） | 否（缺失时降级） |
| agent-reach | `search-xhs` | 辅助搜索 | 否（有 xiaohongshu-mcp 即可） |
| retro-enc | — | 下游对接（variant/layout 建议） | 否（选题独立可用） |

## 文件结构

```
topic-miner/                        # 工作目录（在用户项目中）
├── config/
│   └── pillars.yaml                # Content Pillar 体系配置
├── analysis-万物图鉴.md             # 竞品分析报告（analyze 模式产出）
├── analysis-图解万物.md
├── research-2026-03-01.md          # 市场调研报告（research 模式产出）
├── batch-2026-03-01.md             # 选题生成批次（generate 模式产出）
├── batch-2026-03-15.md
└── backlog.yaml                    # 选题池（所有模式共用）
```

## 端到端演练模板

参考：`references/workflows/e2e-runbook.md`

## 关键设计决策

### 为什么情绪唤醒（E）权重最高？
Berger & Milkman 的研究（2012, 沃顿商学院）通过分析纽约时报 7000 篇文章的
分享数据，证明**高唤醒情绪是内容传播的第一驱动因素**。敬畏感（awe）效果最强。
这解释了为什么「八大天规」（敬畏）比「中华田园猫鉴百种」（平淡）互动差距百倍。

### 为什么用矩阵而不是纯 AI 发散？
纯 AI 发散容易：(1) 重复相似方向 (2) 遗漏某些角度 (3) 无法保证覆盖度。
矩阵确保每个 Pillar×Bucket 组合都被考虑到，AI 只在格子内发散。

### 为什么需要四条路径？
单一路径有盲区。矩阵填充覆盖全面但缺乏热度感知；竞品延伸有验证但缺乏创新；
搜索热点有时效但可能偏离定位；跨域迁移有创新但缺乏验证。四条并行互补。

### 为什么 research 模式要问"为什么"而不只是"是什么"？
大多数竞品工具只告诉你"什么在爆"（现象），但不解释"为什么能爆"（机制）。
没有机制理解，选题者只能照搬表面形式，而无法创造新爆款。
research 模式强制输出 STEPPS 机制诊断，让每个选题决策都有可复用的传播理论支撑：
- 「传统智慧类爆款 = Social Currency × Emotion（敬畏）双轮驱动」→ 可以迁移到其他话题
- 「数字+权威词结构 → 强结构信号」→ 可以作为标题公式推广

这样产出的不只是一批选题，而是一套「为什么你的内容会被分享」的认知模型。
