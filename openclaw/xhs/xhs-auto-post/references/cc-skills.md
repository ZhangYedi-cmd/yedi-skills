# XHS Auto Post — Claude Code Skills 目录

本项目中 OpenClaw 可调度的 Claude Code Skills 完整列表。

---

## 快速选择

| Skill | 触发词 | 何时使用 |
|---|---|---|
| `baoyu-xhs-images` | `/baoyu-xhs-images` | **默认**，普通知识/种草/日常内容 |
| `retro-enc` | `/retro-enc` | 复古感、图鉴感、百科感内容 |
| `baoyu-comic` | `/baoyu-comic` | 叙事型、有角色或剧情的内容 |
| `baoyu-cover-image` | `/baoyu-cover-image` | 需要单独生成封面图时 |
| `baoyu-compress-image` | `/baoyu-compress-image` | **Step 4 固定使用**，发布前压缩 |

---

## baoyu-xhs-images

**用途**: 小红书信息图系列生成，支持 10 种视觉风格 × 8 种布局

**输入**:
- `--style <name>` — 视觉风格（见下）
- `--layout <name>` — 布局方式（见下）
- 内容：直接粘贴 topic 文本，或指定文件路径

**输出**: `images/*.png`（1-10 张）

**风格选项**:

| Style | 特点 |
|---|---|
| `cute` | 甜美可爱，经典小红书风格（默认） |
| `fresh` | 清新自然 |
| `warm` | 温馨亲切 |
| `bold` | 高冲击力，抓眼球 |
| `minimal` | 极简高级 |
| `retro` | 复古怀旧 |
| `pop` | 活力鲜艳 |
| `notion` | 知识卡片，学术感 |
| `chalkboard` | 黑板报风格 |
| `study-notes` | 手写笔记风 |

**布局选项**:

| Layout | 特点 |
|---|---|
| `sparse` | 信息少，呼吸感强 |
| `balanced` | 均衡（默认） |
| `dense` | 高信息密度 |
| `list` | 列表型 |
| `comparison` | 对比型 |
| `flow` | 流程型 |
| `mindmap` | 思维导图型 |
| `quadrant` | 四象限型 |

---

## retro-enc

**用途**: 复古百科图鉴风格，对标"图解万物"、"万物图鉴"爆款风格

**输入**: topic 文本（直接粘贴）

**输出**: `images/*.png`（封面 + 内容页 + 结尾页）

**适合场景**: 科普类、知识科普、动植物/历史/文化类主题

---

## baoyu-comic

**用途**: 知识漫画，支持多种画风和叙事基调

**输入**: topic 文本 + 可选风格参数

**输出**: `images/*.png`（多格漫画页）

**适合场景**: 有故事性的内容，人物对话，情感叙事

---

## baoyu-cover-image

**用途**: 单独生成文章封面图，5 维度参数（类型/色板/渲染/文字/情绪）

**输入**: 标题文字 + 可选参数

**输出**: `cover.*`（支持 16:9、2.35:1、1:1）

**何时使用**: brief.md 中明确要求单独封面时，在 Step 2 后额外执行

---

## baoyu-compress-image

**用途**: 图片压缩，自动选择最佳工具（sips → cwebp → ImageMagick → Sharp）

**输入**: 目录路径 + 可选参数

**输出**: `*.webp`（默认）或 `*.png`

**Step 4 标准调用**:

```bash
/baoyu-compress-image <run-dir>/images/ -o <run-dir>/images-compressed/ -r
```

**选项**:

| 选项 | 说明 | 默认 |
|---|---|---|
| `-o` | 输出路径 | 同目录替换后缀 |
| `-f` | 格式（webp/png/jpeg） | webp |
| `-q` | 质量 0-100 | 80 |
| `-r` | 递归处理子目录 | false |
| `-k` | 保留原文件 | false |
