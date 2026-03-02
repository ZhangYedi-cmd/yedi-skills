# Changelog

## 0.3.0 (2026-03-01)

### Added
- 新增 `references/config/backlog-schema.md`，定义 `backlog.yaml` 的必填/推荐/条件必填字段与状态流转约束。
- 新增 `references/workflows/e2e-runbook.md`，提供从选题到发布回填的端到端演练模板。

### Changed
- `SKILL.md` 新增「前置条件速查」，明确 `init/analyze/research/generate` 的硬前置与降级行为。
- `topic-generation.md` 补充前置条件与降级规则，并统一输出字段到 `backlog-schema` 约束。
- `auto-research.md` 调整依赖说明，增加 `get_feed_detail` 不可用时的降级路径说明。
- `competitor-analysis.md` 补充「可独立运行，不强制先 init」的前置条件说明。

## 0.2.0 (2026-03-01)

### Added
- **research 自动调研模式**：无需指定博主，自动横向扫描整个图鉴内容市场
  - Phase 1：三层关键词矩阵（形式词 / 内容域词 / 爆款信号词），8-10 次搜索，候选池 ~50 条
  - Phase 2：2/3 规则质量过滤（量化 + 结构 + 语义），精选池 25-30 条
  - Phase 3：TOP 10 详情采样（`get_feed_detail`），提取评论传播触发证据
  - Phase 4：模式提炼（What 主题聚类 / Why STEPPS 机制诊断 / Gap 需求-供给缺口矩阵）
  - Phase 5：对 🔴 蓝海话题生成选题，写入 backlog.yaml（`source: gap_driven`）
- **gap_driven 第5条选题路径**：选题池新增 `gap_evidence` 字段记录蓝海证据
- **研究报告产出**：`research-{YYYY-MM-DD}.md` 含 What/Why/Gap 三章节
- **依赖扩展**：正式依赖 `get_feed_detail` 工具（research Phase 3）

### Changed
- SKILL.md 更新 Usage、两种模式对比表、核心工作流（Step 1a/1b）、依赖表
- 文件结构图新增 `research-*.md` 产出文件说明
- 关键设计决策新增「为什么要问 Why 而不只是 What」

## 0.1.0 (2026-03-01)

### Added
- 初始版本
- STEPPS 六维传播力评分模型（基于 Berger 沃顿商学院研究）
- Content Pillar × Bucket 选题矩阵（含 Hero-Hub-Help 分层）
- GAPS 竞品分析框架（含 Content Shock 警示）
- 爆款标题公式库（5 种公式 + 优化检查清单）
- 竞品分析工作流（六步法 + 多竞品交叉分析）
- 选题生成工作流（四路径并行：矩阵填充/竞品延伸/搜索热点/跨域迁移）
- 选题池管理（backlog.yaml 持久化）
- 与 retro-enc / xiaohongshu-mcp 的衔接设计
