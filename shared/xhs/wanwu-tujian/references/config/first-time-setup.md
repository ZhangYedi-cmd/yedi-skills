---
name: first-time-setup
description: First-time setup flow for wanwu-tujian preferences (v3)
---

# 首次设置 — v3

## 概述

当未找到 EXTEND.md 时，引导用户完成偏好设置。

**BLOCKING**: 此设置必须在任何其他工作流步骤之前完成。在此之前不得：
- 询问内容/主题
- 询问构图或版面
- 询问受众
- 进入内容分析

仅执行本设置流程中的问题，保存 EXTEND.md，然后继续。

## 设置流程

```
未找到 EXTEND.md
        │
        ▼
┌─────────────────────┐
│ AskUserQuestion     │
│ (all questions)     │
└─────────────────────┘
        │
        ▼
┌─────────────────────┐
│ Create EXTEND.md    │
└─────────────────────┘
        │
        ▼
    Continue to Step 1
```

## 问题

**语言**: 使用用户的输入语言或已保存的语言偏好。

使用单次 AskUserQuestion 调用，包含所有问题：

### 问题 1: 默认风格

```
header: "风格"
question: "默认插画风格偏好？（后续每次生成也会根据内容自动推荐）"
options:
  - label: "Auto (Recommended)"
    description: "根据内容自动选择最佳风格"
  - label: "traditional-encyclopedia"
    description: "传统百科 — 宣纸底+工笔+知识图解（万能默认）"
  - label: "realistic-portrait"
    description: "写实群像 — 高写实纹理+自然光影（适合动植物/品种类）"
```

### 问题 2: 水印

```
header: "水印"
question: "生成图片需要添加水印吗？输入水印内容（如 @handle 或名字）"
options:
  - label: "不需要水印 (Recommended)"
    description: "暂不添加，后续可在 EXTEND.md 中启用"
```

位置默认 bottom-right。

### 问题 3: 默认构图偏好（v3 — 4种）

```
header: "构图"
question: "默认构图模式偏好？"
options:
  - label: "None (Recommended)"
    description: "根据内容自动选择最佳构图"
  - label: "center-radial"
    description: "中心辐射式 — 适合规则/方法/哲理类（互动量最高）"
  - label: "group-portrait"
    description: "群像集合式 — 适合品种/分类/大全类"
  - label: "infographic"
    description: "信息图表式 — 适合教程/步骤/指南类"
```

> v3 已合并：散点图标式 → center-radial；九宫格 → group-portrait

### 问题 4: 保存位置

```
header: "保存"
question: "偏好设置保存到哪里？"
options:
  - label: "Project"
    description: ".wanwu-tujian/ (仅当前项目)"
  - label: "User"
    description: "~/.wanwu-tujian/ (所有项目通用)"
```

## 保存路径

| 选择 | 路径 | 范围 |
|------|------|------|
| Project | `.wanwu-tujian/EXTEND.md` | 当前项目 |
| User | `~/.wanwu-tujian/EXTEND.md` | 所有项目 |

## 设置完成后

1. 如需要则创建目录
2. 写入 EXTEND.md（含 frontmatter）
3. 确认："偏好已保存到 [路径]"
4. 继续 Step 1

## EXTEND.md 模板（v3）

```yaml
---
version: 3
preferred_style: [selected style or auto]
color_energy: auto
enable_light_effects: true
realism_level: auto
watermark:
  enabled: [true/false]
  content: "[user input or empty]"
  position: bottom-right
  opacity: 0.7
preferred_composition:
  name: [selected composition or null]
  description: ""
default_orientation: portrait
default_pages: 5
credit:
  enabled: true
  format: "作者：@知渡"
  position: bottom-right
preferred_model: auto
language: null
style_tweaks:
  paper_aging: light
  info_density: high
---
```

## v2 → v3 迁移说明

如发现已存在 `version: 2` 的 EXTEND.md，自动应用以下映射：
- `color_energy: VIBRANT` → `NATURAL`
- `style_tweaks.paper_aging: medium/heavy` → `light`
- `preferred_composition.name: scattered-icons` → `center-radial`
- `preferred_composition.name: grid-collage` → `group-portrait`
- 新增 `realism_level: auto`
- `version: 2` → `version: 3`

## 后续修改

用户可直接编辑 EXTEND.md 或重新运行设置：
- 删除 EXTEND.md 触发重新设置
- 编辑 YAML frontmatter 快速调整
- 完整 schema：`config/preferences-schema.md`
