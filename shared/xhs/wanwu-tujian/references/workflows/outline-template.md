# 万物图鉴 大纲模板 — v3.1

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

**Slug 规则**：从页面内容提取（拼音 kebab-case），系列内唯一，2-4词。

---

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

---

## 版面位置建议（v3.0 更新）

| 位置 | 推荐版面 | 原因 |
|------|----------|------|
| 封面 | dense-cluster | 最强视觉冲击，铺满画布 |
| 铺垫 | organic-poster | 铺陈语境 |
| 核心 | organic-poster / annotated | 匹配内容密度 |
| 收获 | annotated | 清晰总结 |
| 结尾 | organic-poster | 简洁金句 |

---

## 大纲格式

```markdown
# 万物图鉴系列大纲

---
strategy: a  # a, b, or c
name: 百科全书型
style: traditional-encyclopedia  # realistic-portrait / traditional-encyclopedia
style_reason: "规则类内容适合传统百科风格"
realism_level: 75  # 70-85，按内容类型映射
color_energy: WARM  # NATURAL / WARM
light_effect: ink-atmospheric  # 参考 illustration-styles.md 光效描述库
composition: center-radial  # 推荐构图
composition_reason: "规则/方法类内容最适合中心辐射式，互动量最高"
default_layout: organic-poster
cover_layout: dense-cluster
orientation: portrait
image_count: 5
generated: YYYY-MM-DD HH:mm
---

## P1 封面
**Type**: cover
**Layout**: dense-cluster（密集簇拥，铺满画布）
**Composition**: [composition]
**Hook**: "老祖宗总结的六种积累福报的行为"
**Slug**: fu-bao-overview
**Filename**: 01-cover-fu-bao-overview.png

**标题（L1 毛笔书法）**: 「积累福报的六种行为」
**副标题（L2）**: 中国传统智慧·处世之道
**英文（L3）**: Six Virtuous Acts · Ancient Chinese Wisdom
**左上角标**: 「图鉴」
**右上角标**: 「福报」
**散布印章**: 「千年传承」near 主体, 「积善成德」near 右侧

**锚定主体**: [最大人物/主体，占画面一侧]
**群像**: [6-10个环绕主体，密集叠压]
**散落元素**: [主题相关散落物品]
**背景深度**: [建筑/自然剪影，极淡水墨]
**底部文字**: 传承 · 瑰宝 · 匠心 · 千年 · 国风
**信息密度**: 最高（dense-cluster）

**Swipe Hook**: 第一种最容易做到👇

---

## P2 内容页 - [维度/规则1]
**Type**: content
**Layout**: organic-poster / annotated
**Composition**: [composition]
**Core Message**: [核心规则]
**Slug**: [slug]
**Filename**: 02-content-[slug].png

**标题（L1 毛笔书法）**: 「[规则名]」
**副标题（L2）**: [规则说明]
**左上角标**: 「福报·壹」
**右上角标**: 「[主题词]」

**主体**: [场景描述]
**标注点(6-10)**: [标注列表]
**知识块**: [知识框内容]
**对比场景**: ✓[正确] / ✗[错误]
**L6 关键词标签**: 「[词1]」「[词2]」「[词3]」
**L7 底部引用框**: "[智慧点评]"
**信息密度**: 高

**Swipe Hook**: [下一页钩子]

---
```

---

## Swipe Hook 策略

| 策略 | 示例 |
|------|------|
| 预告 | "第一种最容易做到👇" |
| 编号 | "接下来是第2种👇" |
| 最高级 | "下一个更重要👇" |
| 悬念 | "最后一种很少人知道👇" |
| 承诺 | "最实用的来了👇" |
| 紧迫 | "最重要的在最后👇" |

---

## 每页检查清单（v3.1 更新）

**封面页**：
- [ ] dense-cluster 布局（密集铺满，无大块空白）
- [ ] 锚定主体（占画面一侧）
- [ ] 锚定主体周围 6-10 个支撑元素
- [ ] 散落元素填充剩余空间
- [ ] 背景深度（极淡建筑/自然剪影）
- [ ] L1 毛笔书法标题
- [ ] 4-5 红色印章（2固定角标 + 2-3散布）
- [ ] 底部点号分隔属性列表（非「」标签）

**内容页**：
- [ ] ≥6 标注/标签
- [ ] ≥1 数据可视化或知识框
- [ ] ≥2 场景小图或放大圆
- [ ] L1 毛笔书法标题
- [ ] 角标印章（左上+右上固定 + 1-2散布）
- [ ] L6 关键词标签条（主体下方）
- [ ] L7 底部引用/智慧框
- [ ] 署名：作者：@知渡
- [ ] 信息密度达标（高/极高）
