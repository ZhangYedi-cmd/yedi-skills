# 万物图鉴 大纲模板

## 文件命名

大纲文件使用策略标识：
- `outline-strategy-a.md` — 百科全书型
- `outline-strategy-b.md` — 深度洞察型
- `outline-strategy-c.md` — 故事启发型
- `outline.md` — 最终选定（从所选策略复制）

## 图片文件命名

```
NN-{type}-[slug].png
NN-{type}-[slug].md (in prompts/)
```

| Type | Usage |
|------|-------|
| `cover` | 封面（第一张） |
| `content` | 内容页（中间） |
| `ending` | 结尾页（最后） |

**示例**：
- `01-cover-fu-bao.png`
- `02-content-ci-bei.png`
- `03-content-jie-yuan.png`
- `04-ending-summary.png`

**Slug 规则**：
- 从页面内容提取（拼音 kebab-case）
- 系列内唯一
- 简短但有描述性（2-4词）

## 三种策略（百科图鉴版）

### 策略 A: 百科全书型（广度优先）

| 方面 | 说明 |
|------|------|
| **理念** | 系统概览，广度优先 |
| **特征** | 全面展示所有子类/规则/要素，信息密度高 |
| **适合** | 品种图鉴、分类大全、规则合集 |
| **结构** | 总览封面 → 分类展示(×N) → 数据总结 |
| **页数** | 4-6 |

### 策略 B: 深度洞察型（深度优先）

| 方面 | 说明 |
|------|------|
| **理念** | 多角度深挖，深度优先 |
| **特征** | 选取核心要素深度解析，每页一个维度 |
| **适合** | 单品解析、行为图解、原理拆解 |
| **结构** | 概览 → 维度1 → 维度2 → 维度3 → 总结 |
| **页数** | 4-5 |

### 策略 C: 故事启发型（叙事驱动）

| 方面 | 说明 |
|------|------|
| **理念** | 叙事驱动，场景智慧 |
| **特征** | 以故事/场景串联知识，趣味性优先 |
| **适合** | 行为过程、生活智慧、人物故事 |
| **结构** | 设定 → 场景1 → 场景2 → 场景3 → 金句 |
| **页数** | 3-5 |

## 版面位置建议

| 位置 | 推荐版面 | 原因 |
|------|----------|------|
| 封面 | center-radial / grid-surround | 最强视觉冲击 |
| 铺垫 | annotated / knowledge-split | 铺陈语境 |
| 核心 | annotated / knowledge-split / sequential | 匹配内容密度 |
| 收获 | knowledge-split | 清晰总结 |
| 结尾 | annotated | 简洁金句 |

## 大纲格式

```markdown
# 万物图鉴系列大纲

---
strategy: a  # a, b, or c
name: 百科全书型
style: traditional-encyclopedia  # cartoon-infographic / celestial-narrative / realistic-portrait / traditional-encyclopedia
style_reason: "规则类内容适合传统百科风格"
color_energy: WARM  # RADIANT / VIBRANT / WARM
theme_color: ""  # 仅 cartoon-infographic 需要，如 "#FF4500"
light_effect: ink-atmospheric  # 参考 illustration-styles.md 光效描述库
composition: center-radial  # 推荐构图
composition_reason: "规则/方法类内容最适合中心辐射式，互动量最高"
default_layout: annotated
orientation: portrait
image_count: 5
generated: YYYY-MM-DD HH:mm
---

## P1 封面
**Type**: cover
**Layout**: center-radial
**Composition**: center-radial
**Hook**: "老祖宗总结的六种积累福报的行为"
**Slug**: fu-bao-overview
**Filename**: 01-cover-fu-bao-overview.png

**标题**: 「积累福报的六种行为」
**副标题**: 中国传统智慧·处世之道
**英文**: Six Virtuous Acts · Ancient Chinese Wisdom
**左上角标**: 「图鉴」
**右上角标**: 「福报」

**主体**: 多位古代人物环绕排布，各持代表不同行为的物品
**标注**: [慈悲行善, 结善缘, 持戒修身, ...]
**装饰**: 红色方印章×2, 水墨山水边角, 宣纸质感
**信息密度**: 高

**Swipe Hook**: 第一种最容易做到👇

---

## P2 内容页 - [维度/规则1]
**Type**: content
**Layout**: knowledge-split
**Composition**: center-radial
**Core Message**: [核心规则]
**Slug**: [slug]
**Filename**: 02-content-[slug].png

**标题**: 「[规则名]」
**副标题**: [规则说明]
**左上角标**: 「福报·壹」
**右上角标**: 「[主题词]」

**主体**: [场景描述]
**标注点(6-10)**: [标注列表]
**知识块**: [知识框内容]
**对比场景**: ✓[正确] / ✗[错误]
**信息密度**: 高

**Swipe Hook**: [下一页钩子]

---
```

## Swipe Hook 策略

每张图末尾应有下一页钩子：

| 策略 | 示例 |
|------|------|
| 预告 | "第一种最容易做到👇" |
| 编号 | "接下来是第2种👇" |
| 最高级 | "下一个更重要👇" |
| 悬念 | "最后一种很少人知道👇" |
| 承诺 | "最实用的来了👇" |
| 紧迫 | "最重要的在最后👇" |

## 每页检查清单

- [ ] ≥6 标注/标签
- [ ] ≥1 数据可视化或知识框
- [ ] ≥2 场景小图或放大圆
- [ ] 角标印章（左上+右上）
- [ ] 署名：作者：@知渡
- [ ] 信息密度达标（高/极高）
