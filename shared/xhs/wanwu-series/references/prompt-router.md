# 万物图鉴系列 — Prompt 路由与防泄露规范

> 本文档定义如何正确引用子技能的 prompt 结构，以及防止英文占位符泄露到画面。

---

## Prompt 路由

### 封面 → wanwu-cover

读取以下文件组装封面 prompt：
- `~/.claude/skills/wanwu-cover/references/prompt-assembly.md` → 9 模块结构
- `~/.claude/skills/wanwu-cover/references/compositions.md` → 构图模板片段
- `~/.claude/skills/wanwu-cover/references/visual-dna.md` → 视觉规范（查阅用）

### 内容页 → wanwu-content

读取以下文件组装内容页 prompt：
- `~/.claude/skills/wanwu-content/references/prompt-assembly.md` → 10 模块结构
- `~/.claude/skills/wanwu-content/references/content-layouts.md` → 布局模板片段
- `~/.claude/skills/wanwu-content/references/visual-dna.md` → 视觉规范（查阅用）

---

## Prompt 防泄露规范（v1.0 关键修复）

### 问题

在 v0 测试中发现，prompt 中的英文结构标记（如 "MODULE L1"、"SECTION B2"、
"TITLE BLOCK"、"LEFT VERTICAL SIDEBAR"）被 AI 图片生成器当作画面文字渲染出来。

### 解决方案

**每个 prompt 的开头必须加上防泄露声明**：

```
CRITICAL RENDERING INSTRUCTION:
All English section headers and structural labels in this prompt
(such as "TITLE BLOCK", "LEFT COLUMN", "RIGHT COLUMN", "MODULE",
"SECTION", "CARD", "ERA", "HERO", "BOTTOM", "STAMP BAR", etc.)
are structural directives for organizing the image layout.
They must NOT be rendered as visible text in the final illustration.

ONLY render as visible text:
1. Chinese characters explicitly marked as title/label/annotation content
2. Latin/English text explicitly marked as subtitle content
3. Seal stamp text explicitly specified

Do NOT render: section headers, variable placeholders, layout instructions.
```

### Prompt 编写规则

1. **尽量用中文描述**：能用中文的地方不用英文

   ```
   # BAD — 英文标记容易泄露
   MODULE L1 — "①十二生肖排序":

   # GOOD — 用中文描述位置
   左栏第一模块 — 内容标题"①十二生肖排序":
   ```

2. **英文结构词用括号注释**：

   ```
   # GOOD
   标题区域 (this is the title zone, do not render this English text):
   中文书法标题 "「子鼠」"
   ```

3. **避免全大写英文**：AI 倾向于把 ALL-CAPS 当作需要显示的标题

   ```
   # BAD
   CENTRAL SUBJECT
   BOTTOM KNOWLEDGE BAR

   # BETTER
   Central subject area (structural, not visible):
   Bottom knowledge section (structural, not visible):
   ```

4. **标签值用引号明确**：

   ```
   # 需要渲染的文字用中文引号标记
   标注文字：「门齿终生生长」
   印章内容：「鼠瑞」
   标签文字：「草食」「群居」
   ```

---

## 图片生成调用规范

### 调用命令

```bash
npx -y bun ~/.claude/skills/baoyu-image-gen/scripts/main.ts \
  --promptfiles {prompt-file.md} \
  --image {output-path.png} \
  --ar 3:4 \
  --quality 2k \
  --provider google
```

### 参数说明

| 参数 | 封面 | 内容页 |
|------|------|--------|
| `--ar` | 3:4 | 3:4 |
| `--quality` | 2k | 2k |
| `--provider` | google | google |

### 失败重试

如果生成失败（API 错误/超时），自动重试 1 次。
如果连续 2 次失败，报告错误并继续下一页。

---

## 系列一致性检查

批量生成时需要确保系列视觉一致性：

1. **标题格式统一**：同一系列的每页标题遵循相同格式模式
2. **印章内容统一**：角标印章（博物志/古今图鉴等）全系列一致
3. **署名统一**：全系列使用相同的 "作者：知渡" 或自定义署名
4. **色调统一**：全系列使用相同 style（anthropomorphic/traditional/realistic）
5. **底部条统一**：底部印章条格式全系列一致
