---
name: preferences-schema
description: EXTEND.md YAML schema for wanwu-tujian user preferences (v3)
---

# 偏好设置 Schema — v3

## 完整 Schema

```yaml
---
version: 3

watermark:
  enabled: false
  content: ""
  position: bottom-right  # bottom-right|bottom-left|bottom-center|top-right
  opacity: 0.7

preferred_style: auto     # realistic-portrait|traditional-encyclopedia|auto
color_energy: auto         # NATURAL|WARM|auto (auto=按风格默认)
enable_light_effects: true # true|false — 是否启用光效描述
realism_level: auto        # 70-85 或 auto（按内容类型自动映射）

preferred_composition:
  name: null              # group-portrait|center-radial|infographic|anatomy-atlas|null
  description: ""         # 自定义说明

default_orientation: portrait  # portrait|landscape
default_pages: 5               # 2-8

credit:
  enabled: true
  format: "作者：@知渡"
  position: bottom-right

preferred_model: auto    # gemini|gpt|nano-banana|auto

language: null           # zh|en|auto

style_tweaks:
  paper_aging: light     # light only — NO fold marks, NO age spots
  info_density: high     # medium|high|extreme — 信息密度
---
```

## 字段说明

| 字段 | 类型 | 默认 | 说明 |
|------|------|------|------|
| `version` | int | 3 | Schema 版本 |
| `preferred_style` | enum | auto | 默认风格变体（auto=按内容自动推荐） |
| `color_energy` | enum | auto | 色彩能量级别（auto=按风格默认） |
| `enable_light_effects` | bool | true | 是否启用光效描述 |
| `realism_level` | int/auto | auto | 写实度 70-85%，auto=按内容类型映射 |
| `watermark.enabled` | bool | false | 是否启用水印 |
| `watermark.content` | string | "" | 水印文字（@用户名或自定义） |
| `watermark.position` | enum | bottom-right | 水印位置 |
| `watermark.opacity` | float | 0.7 | 水印透明度 |
| `preferred_composition.name` | string | null | 默认构图名或 null（自动） |
| `preferred_composition.description` | string | "" | 自定义说明 |
| `default_orientation` | enum | portrait | 默认方向 |
| `default_pages` | int | 5 | 默认页数（2-8） |
| `credit.enabled` | bool | true | 是否显示署名 |
| `credit.format` | string | "作者：@知渡" | 署名格式 |
| `credit.position` | enum | bottom-right | 署名位置 |
| `preferred_model` | string | auto | 首选图片生成模型 |
| `language` | string | null | 输出语言（null=自动检测） |
| `style_tweaks.paper_aging` | enum | light | 纸张做旧程度（v3 仅 light） |
| `style_tweaks.info_density` | enum | high | 信息密度 |

## 风格变体选项

| 值 | 说明 | 色彩能量 | 写实度 |
|----|------|---------|--------|
| `auto` | 根据内容信号自动推荐最优风格 | 自动 | auto |
| `realistic-portrait` | 写实群像 — 犬种/猫种/动植物写实 | NATURAL | 80-85% |
| `traditional-encyclopedia` | 传统百科 — 通用知识百科（默认） | WARM | 70-80% |

## 构图选项（v3 — 4种）

| 值 | 说明 |
|----|------|
| `group-portrait` | 群像集合式 — 品种/分类/大全（含 grid-panel 子模式） |
| `center-radial` | 中心辐射式 — 规则/方法/哲理（最高互动，含 scattered-concept 子模式） |
| `infographic` | 信息图表式 — 教程/步骤/指南 |
| `anatomy-atlas` | 博物解剖式 — 单品深度解析/结构分析 |

> **v3 合并**: `scattered-icons` → center-radial; `grid-collage` → group-portrait

## 水印位置

| 值 | 说明 |
|----|------|
| `bottom-right` | 右下角（默认，最常用） |
| `bottom-left` | 左下角 |
| `bottom-center` | 底部居中 |
| `top-right` | 右上角 |

## 版本迁移

| v2 字段 | v3 变化 |
|---------|---------|
| `color_energy: VIBRANT` | → `NATURAL`（realistic-portrait 专用） |
| `style_tweaks.paper_aging: medium/heavy` | → `light`（v3 简化纸质，NO 折痕/斑点） |
| `preferred_composition: scattered-icons` | → `center-radial` |
| `preferred_composition: grid-collage` | → `group-portrait` |
| 无 `realism_level` 字段 | 新增，默认 `auto` |

## 示例：最小配置

```yaml
---
version: 3
preferred_style: auto
watermark:
  enabled: false
preferred_composition:
  name: null
credit:
  enabled: true
  format: "作者：@知渡"
---
```

## 示例：完整配置

```yaml
---
version: 3
watermark:
  enabled: true
  content: "@知渡"
  position: bottom-right
  opacity: 0.7

preferred_style: auto
color_energy: auto
enable_light_effects: true
realism_level: auto

preferred_composition:
  name: center-radial
  description: "偏好哲理类内容，默认中心辐射"

default_orientation: portrait
default_pages: 5

credit:
  enabled: true
  format: "作者：@知渡"
  position: bottom-right

preferred_model: gemini
language: zh

style_tweaks:
  paper_aging: light
  info_density: high
---
```
