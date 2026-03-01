# CHANGELOG

## 0.3.0 - 2026-03-01
### 封面多样化 + 一页一主题策略
基于 xiaohongshu-mcp 二次分析博主 7 组不同主题笔记（饺子馅、兰花、选狗、化妆步骤、
四大系列等），对比 4 组已生成图片的问题后更新。

**问题诊断：**
- 4组图的封面全部使用 center-radial 对称圆环 → 同质化严重
- 龙生九子等列表内容将3个条目合并一页 → 每个条目展示不足

**核心变更：**
- `layouts/portrait-layouts.md`：新增 **6 种封面原型** (cover-A~F)，分离封面/内容页版型体系
  - cover-A 物品环绕型（饺子馅·蒸笼居中）
  - cover-B 多人群像型（八大天规·8人物错落）
  - cover-C 标本解剖型（君子兰·大标本+标注）
  - cover-D 流程变换型（化妆步骤·左右变换）
  - cover-E 分区分类型（选狗·按人群分区）
  - cover-F 场景多格型（四大系列·多格预览）
- `layouts/portrait-layouts.md`：新增 **single-subject-plate** 内容页版型（一页一主题 ⭐）
- `workflows/analysis-framework.md`：新增「内容结构类型」分析维度 + 封面版型自动选择表
- `workflows/outline-template.md`：策略 A 改为「一页一主题」（列表型必选）；禁止合并条目
- `SKILL.md`：更新 Layout Gallery、Outline Strategies、Series Design Principles、Workflow

## 0.2.0 - 2026-03-01
### 风格对标重构：万物图鉴（小红书真实博主风格）
通过 xiaohongshu-mcp 实际抓取博主「万物图鉴」(646228ea000000001203607f) 的
热门笔记图片（八大天规、古籍植物图鉴、老祖宗九大风水宝地等），对比原 SKILL 定义后进行系统性更新。

**核心变更：**
- `elements/canvas.md`：新增 1792×2400（3:4）为首选画布，对标博主实际上传尺寸
- `elements/color-palettes.md`：底色从西方羊皮纸（#F5E6D3）→ 中国宣纸米黄（#F0E0C0），调整饱和度策略
- `elements/typography.md`：废弃伪拉丁学名，引入中式角标印章体系（红色方块+2-4字汉字）
- `elements/decorations.md`：新增「知识图解叠层」系统（知识框、✓✗对比、①②③编号、中式人物插画说明）；废弃 Victorian ornamental border → 水墨山水边角
- `workflows/prompt-assembly.md`：Module 2 Style Base 从"19世纪西方博物馆水彩"→"中国历史百科图鉴+知识信息图叠层"
- `layouts/portrait-layouts.md`：新增 knowledge-split 版型；移除 Faux-Latin 引用；更新通用尾部
- `variants/anatomy.md`：定位为博主最高互动量变体，补充知识图解叠层 prompt 片段
- `variants/natural-history.md`：补充植物类高饱和度特别说明，调整为中国本草/博物风

## 0.1.0 - 2026-02-27
- 初始化版本记录。
