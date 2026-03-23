---
name: wanwu-cover
description: >-
  生成「万物图鉴」风格的单张封面图。将任意主题转化为复古百科插画封面。
  当用户提到"万物图鉴封面"、"图鉴封面"、"复古百科封面"、"科普封面"、
  "做一张封面"、"封面图"时使用此技能。
---

# 万物图鉴封面生成器

将任意主题转化为一张高信息密度的复古百科插画封面。

## Usage

```
/wanwu-cover 十二生肖古代雅称与祝福
/wanwu-cover 中国十大国粹 --comp group-portrait
/wanwu-cover 人生十则 --comp center-radial
/wanwu-cover 除夕做这些会提升运气 --comp c-surround
/wanwu-cover --comp pyramid --title "十二生肖性格分析"
```

## Options

| Option | Values | Default |
|--------|--------|---------|
| `--comp <c>` | group-portrait, center-radial, scatter-concept, pyramid, c-surround | 自动推断 |
| `--style <s>` | anthropomorphic, traditional, realistic | 自动推断 |
| `--orientation` | portrait / landscape | portrait |
| `--title <t>` | 自定义标题 | 从主题提取 |
| `--quick` | 跳过确认 | false |

---

## Workflow（5 步）

```
万物图鉴封面 进度：
- [ ] Step 1: 分析主题 — 确定标题/构图/风格/主要元素
- [ ] Step 2: 确认方案 ⚠️ REQUIRED（除非 --quick）
- [ ] Step 3: 组装 Prompt（按 references/prompt-assembly.md 的 9 模块拼接）
- [ ] Step 4: 调用图片生成技能出图
- [ ] Step 5: 完成报告
```

### Step 1: 分析主题

确定以下关键信息：

1. **主标题**（中文）：用户指定 或 从内容提取
2. **英文副标题**：翻译 + 学术化润色
3. **风格变体**：按自动推荐矩阵 或 用户指定
4. **构图模板**：按自动推荐矩阵 或 用户指定
5. **主体元素清单**：**优先使用人物角色（2-3个）作为视觉锚点** + 物品（4-8个）+ 散落元素
6. **动态动作**：每个人物/关键物品需指定动态动作（倒茶、挥毫、舞蹈等）
7. **印章内容**：2-4 个角标印章文字 + 2-3 个散布印章文字
8. **底部信息栏**：属性列表 / 十二地支 / 其他总结文字

**自动推荐矩阵**：

| 内容信号 | Style | Composition |
|----------|-------|-------------|
| 生肖/神话/拟人动物 | anthropomorphic | group-portrait |
| 犬猫/动植物品种 | realistic | group-portrait |
| 分类/大全/国粹/文化 | traditional | group-portrait |
| 规则/方法/X种行为 | traditional | center-radial |
| 人生/哲理/准则 | traditional | center-radial |
| 习俗/节日/仪式 | traditional | c-surround |
| 排名/等级/TOP | traditional | pyramid |

### Step 2: 确认方案

使用 AskUserQuestion 确认：
- 构图模板
- 风格变体
- 主要元素清单（人物 + 物品）
- 标题 / 副标题

### Step 3: 组装 Prompt

1. 加载 `references/workflows/prompt-assembly.md` 了解 9 模块框架。
2. 加载 `references/compositions/{chosen}.md` 获取构图专属 Prompt 片段。
3. 加载 `references/styles/{chosen}.md` 获取风格片段。
4. 如需查阅视觉细节，按需加载 `references/elements/` 下对应文件。
5. 按 9 模块顺序拼接完整 Prompt，保存至 `{output-dir}/prompt.md`。

### Step 4: 生成图片

调用可用的图片生成技能，输出至 `{output-dir}/cover.png`。
失败自动重试一次。

### Step 5: 完成报告

```
万物图鉴封面完成！

主题: [topic]
标题: [title]
风格: [style]
构图: [composition]
路径: [output path]

文件:
✓ prompt.md
✓ cover.png
```

---

## 视觉规范

所有视觉规范按职责拆分在 references/ 下，Step 3 组装 Prompt 时按需加载：

- `elements/` — 渲染色彩、布局系统、微观细节、文字、印章、装饰
- `compositions/` — 5 种构图模板（Step 1 选定后只加载对应文件）
- `styles/` — 3 种风格变体（Step 1 选定后只加载对应文件）
- `workflows/prompt-assembly.md` — 9 模块 Prompt 组装框架 + 检查清单
