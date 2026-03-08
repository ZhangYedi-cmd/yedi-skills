---
name: wanwu-series
description: >
  批量生成「万物图鉴」风格的完整图文系列（封面+内容页）。
  统筹 wanwu-cover（封面）和 wanwu-content（内容页）两个子技能，
  自动规划系列大纲、批量组装 Prompt、批量生成图片。
  当用户提到"做一套图鉴"、"批量生成"、"完整系列"、"封面+内容页"、
  "十二生肖全套"、"国粹系列"时使用此技能。
---

# 万物图鉴系列生成器 v1.0

将任意主题规划为完整的图文系列（1 封面 + N 内容页），批量生成。

统筹两个子技能：
- `wanwu-cover` → 封面
- `wanwu-content` → 内容页

---

## Usage

```
/wanwu-series 十二生肖古代雅称 --pages 12
/wanwu-series 中国十大国粹 --pages 10
/wanwu-series 东北五大仙 --pages 5
/wanwu-series 二十四节气 --pages 6 --layout anatomy-spread
```

## Options

| Option | Values | Default |
|--------|--------|---------|
| `--pages <n>` | 内容页数量 (1-20) | 自动推断 |
| `--layout <l>` | 统一内容页布局 / mixed | mixed（自动推断每页） |
| `--style <s>` | 统一风格 / auto | auto |
| `--cover-comp <c>` | 封面构图 | 自动推断 |
| `--start <n>` | 从第 n 页开始（跳过已完成的） | 1 |
| `--cover-only` | 只生成封面 | false |
| `--content-only` | 只生成内容页（跳过封面） | false |
| `--quick` | 跳过每页确认，只确认大纲 | false |

---

## Workflow（6 步）

```
万物图鉴系列 进度：
- [ ] Step 1: 系列规划 — 主题分析 + 总页数 + 每页概要
- [ ] Step 2: 确认大纲 ⚠️ REQUIRED
- [ ] Step 3: 生成封面
- [ ] Step 4: 批量生成内容页（逐页）
- [ ] Step 5: 质量检查
- [ ] Step 6: 完成报告
```

### Step 1: 系列规划

**输入**：用户给定的主题

**输出**：系列大纲（Series Outline），包含：

```yaml
series:
  title: "十二生肖古代雅称"           # 系列标题
  english: "Ancient Elegant Names of Chinese Zodiac"
  total_pages: 13                      # 1封面 + 12内容页
  output_dir: "wanwu-tujian/{slug}"    # 输出目录

cover:
  title: "十二生肖古代雅称与祝福"
  composition: group-portrait           # wanwu-cover 构图
  style: anthropomorphic
  key_elements:                         # 封面主要元素
    - 12个拟人化生肖动物群像
    - 古代服饰
    - 各持代表性道具

pages:
  - page: 1
    title: "子鼠：瑞兽"
    subtitle: "十二生肖古代雅称·第一章"
    layout: narrative-chapter            # wanwu-content 布局
    style: anthropomorphic
    central_subject: "拟人化老鼠穿古装"
    knowledge_modules:
      left_sidebar: [事实1, 事实2, ...]
      right_cards: [渊源, 寓意, 文学]
      bottom_text: "解说文段"

  - page: 2
    title: "丑牛：开犁"
    ...

  - page: 3
    title: "寅虎：山君"
    ...
```

**规划原则**（详见 `references/series-planning.md`）：
1. 每页标题保持系列统一格式
2. 布局可混合（mixed），也可统一
3. 知识模块按主题拆解，确保每页有独特内容
4. 信息密度均匀分配

### Step 2: 确认大纲

使用 AskUserQuestion 展示大纲摘要，确认：
- 总页数
- 每页标题 + 布局
- 封面构图
- 是否需要调整

**大纲确认后**，将完整大纲保存至 `{output-dir}/series-outline.md`。

### Step 3: 生成封面

按 `wanwu-cover` 的视觉规范和 prompt 组装逻辑：
1. 根据大纲中的 cover 配置组装封面 prompt
2. 保存 prompt 至 `{output-dir}/cover/prompt.md`
3. 调用图片生成技能
4. 输出至 `{output-dir}/cover/cover.png`

**封面 Prompt 组装**：引用 `wanwu-cover/references/prompt-assembly.md` 的 9 模块结构。

### Step 4: 并行 Agent 批量生成内容页

**⚡ 默认使用并行 Agent 模式**：为每张内容页各启动一个独立后台 Agent，同时处理，大幅缩短总耗时。

#### 4a. 创建所有输出目录

一次性创建全部 `page-{NN}-{slug}/` 目录。

#### 4b. 为每张内容页启动一个后台 Agent

在**同一条消息**中，用多个 Agent tool call 并行启动，每个 Agent 负责**一张**内容页：

```
Agent 任务模板（每页一个）：
你的任务是为「{系列名}」的第 {N} 页「{标题}」生成万物图鉴内容页。

1. 根据以下大纲信息，按 wanwu-content 规范组装完整 prompt：
   {该页的 YAML 配置：layout / style / central_subject / knowledge_modules 等}

2. Prompt 规范：
   - 引用 wanwu-content/references/prompt-assembly.md 的 10 模块结构
   - 开头加防泄露声明（CRITICAL RENDERING INSTRUCTION...）
   - 不得出现英文占位符，全部替换为实际内容
   - 饱和度 70-85%，polished digital illustration，silky-smooth

3. 保存 prompt 到：{output-dir}/page-{NN}-{slug}/prompt.md

4. 运行生成命令：
   npx -y bun ~/.claude/skills/baoyu-image-gen/scripts/main.ts \
     --promptfiles "{output-dir}/page-{NN}-{slug}/prompt.md" \
     --image "{output-dir}/page-{NN}-{slug}/content.png" \
     --ar 3:4 --quality 2k --provider google

5. 用 Read 工具查看生成的 PNG，确认质量。失败则重试一次。

6. 返回：成功/失败 + 图片路径
```

所有 Agent 设置 `run_in_background: true`，主流程继续处理封面（Step 3）或等待通知。

#### 4c. 等待所有 Agent 完成

收到所有 Agent 完成通知后，进入 Step 5 质量检查。

**内容页 Prompt 组装**：引用 `wanwu-content/references/prompt-assembly.md` 的 10 模块结构。

**重要**：
- Prompt 中不要出现英文占位符（MODULE L1、SECTION B1 等），全部替换为实际内容
- 英文布局标记（TITLE BLOCK、LEFT COLUMN 等）仅作为 prompt 的结构分隔符，
  需要在指令中明确声明 "These English section headers are structural directives for the AI,
  do NOT render them as visible text in the image"
- 每页 Agent 各自重试，主流程无需干预

### Step 5: 质量检查

全部生成完毕后，列出所有输出文件：

```
{output-dir}/
├── series-outline.md
├── cover/
│   ├── prompt.md
│   └── cover.png
├── page-01-zi-shu/
│   ├── prompt.md
│   └── content.png
├── page-02-chou-niu/
│   ├── prompt.md
│   └── content.png
└── ...
```

### Step 6: 完成报告

```
万物图鉴系列完成！

系列: {series_title}
总页数: 1 封面 + {N} 内容页
输出目录: {output_dir}

封面: ✓ cover/cover.png ({composition} × {style})

内容页:
✓ page-01: {title} ({layout})
✓ page-02: {title} ({layout})
✓ page-03: {title} ({layout})
...

全部文件: {total} 张图片 + {total} 个 prompt
```

---

## Prompt 防泄露规则（重要）

每个生成 prompt 的最前面必须加上这段声明：

```
CRITICAL RENDERING INSTRUCTION:
All English section headers in this prompt (like "TITLE BLOCK", "LEFT COLUMN",
"MODULE R1", "SECTION B2", "BOTTOM STAMP BAR", etc.) are STRUCTURAL DIRECTIVES
for the AI image generator. They must NOT appear as visible text in the final image.
Only render text that is explicitly quoted in Chinese or marked as label/title content.
Do NOT render any English layout instructions, variable names, or structural markers.
```

---

## 子技能引用

本技能不重复定义视觉规范，而是引用子技能的 references：

| 需求 | 引用 |
|------|------|
| 封面视觉 DNA | `wanwu-cover/references/visual-dna.md` |
| 封面构图模板 | `wanwu-cover/references/compositions.md` |
| 封面 Prompt 结构 | `wanwu-cover/references/prompt-assembly.md` |
| 内容页视觉 DNA | `wanwu-content/references/visual-dna.md` |
| 内容页布局模板 | `wanwu-content/references/content-layouts.md` |
| 内容页 Prompt 结构 | `wanwu-content/references/prompt-assembly.md` |
| 系列规划模板 | 本技能 `references/series-planning.md` |
| Prompt 路由规则 | 本技能 `references/prompt-router.md` |

---

## 断点续传

如果生成中断（API 超时/手动停止），使用 `--start` 参数从中断处继续：

```
/wanwu-series 十二生肖古代雅称 --start 5   # 从第5页继续
/wanwu-series 十二生肖古代雅称 --content-only --start 8  # 跳过封面，从第8页继续
```

系统会检查 `{output-dir}/page-{N}/content.png` 是否已存在，已存在的跳过。

---

## Changelog

### v1.0 (初版)
- 统筹 wanwu-cover + wanwu-content
- 6 步工作流：规划 → 确认 → 封面 → 内容页 → 检查 → 报告
- 支持 mixed 布局（每页自动推断）
- 支持断点续传（--start）
- Prompt 防泄露规则
