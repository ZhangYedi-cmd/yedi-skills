---
name: wanwu-content
description: >-
  生成「万物图鉴」风格的内容页（非封面）。将任意主题拆解为高信息密度的
  复古百科插画内容页。当用户提到"万物图鉴内容页"、"图鉴内容"、"做图鉴"、
  "百科内容页"、"内容页"、"知识页"时使用此技能。
---

# 万物图鉴内容页生成器

将任意主题拆解为高信息密度的复古百科插画内容页。
与 `wanwu-cover` 共享视觉 DNA，但拥有独立的布局系统和知识模块拆解逻辑。

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
- [ ] Step 4: 组装 Prompt
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

根据布局模板，拆解主题信息为知识模块。

**核心原则**：
- 每个布局有固定的模块槽位（slot），详见 `references/layouts/{chosen}.md`
- 每个模块 = 标题 + 1-4个知识点 + 配图描述
- 知识点 = 编号 + 名称 + 简短说明 + 小插图
- 信息密度要高，但有层次（主次分明）
- 知识模块视觉规范见 `references/elements/knowledge-modules.md`

### Step 3: 确认方案

使用 AskUserQuestion 确认：
- 布局模板
- 知识模块清单
- 中央主体描述
- 标题 / 副标题

### Step 4: 组装 Prompt

1. 加载 `references/workflows/prompt-assembly.md` 了解 10 模块框架。
2. 加载 `references/layouts/{chosen}.md` 获取布局专属 Prompt 片段。
3. 加载 `references/styles/{chosen}.md` 获取风格片段。
4. 如需查阅视觉细节，按需加载 `references/elements/` 下对应文件。
5. 按 10 模块顺序拼接完整 Prompt，保存至 `{output-dir}/prompt.md`。

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

## 视觉规范

所有视觉规范按职责拆分在 references/ 下，Step 4 组装 Prompt 时按需加载：

- `elements/` — 共享视觉基因（渲染色彩、布局系统、微观细节、文字、印章、装饰）+ 内容页专属元素（知识模块、标注系统、微缩插图、趣味元素）
- `layouts/` — 3 种布局模板（Step 1 选定后只加载对应文件）
- `styles/` — 3 种风格变体（Step 1 选定后只加载对应文件）
- `workflows/prompt-assembly.md` — 10 模块 Prompt 组装框架 + 检查清单
