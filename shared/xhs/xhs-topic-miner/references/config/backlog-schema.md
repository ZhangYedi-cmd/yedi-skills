# backlog.yaml 字段规范

`topic-miner/backlog.yaml` 的目标是可持续管理，不是一次性结果导出。

## 顶层结构

```yaml
version: "1.1"
generated: "YYYY-MM-DD"
source_account: "可选"
topics:
  - ...
```

## Topic 字段约束

### 必填字段（所有 topic 都必须有）

| 字段 | 类型 | 约束 |
|------|------|------|
| `id` | string | 批次内唯一（推荐 `001` / `research-001`） |
| `title` | string | 主标题 |
| `alt_titles` | array[string] | 至少 1 个备选标题 |
| `pillar` | string | `P1_`~`P5_` 前缀 |
| `bucket` | string | `B1_`~`B6_` 前缀 |
| `variant` | string | `retro-enc` 支持值 |
| `layout` | string | `retro-enc` 支持值 |
| `source` | string | `matrix_fill` / `competitor_extend` / `search_hot` / `cross_domain` / `gap_driven` |
| `score` | number | 0.0-5.0 |
| `tier` | string | `Hero` / `Hub` / `Help` |
| `status` | string | `idea` / `planned` / `producing` / `published` |
| `created` | string | `YYYY-MM-DD` |

### 推荐字段（强烈建议）

| 字段 | 类型 | 说明 |
|------|------|------|
| `stepps` | object | 六维评分明细（`S/T/E/P_pub/P_prac/S_story`） |
| `reasoning` | string | 1 句话解释为何值得做 |
| `deadline` | string | 具时效主题建议填写 |

### 条件必填字段

| 条件 | 必填字段 |
|------|----------|
| `source == gap_driven` | `gap_evidence.search_demand`, `gap_evidence.supply_density`, `gap_evidence.top_competitor_likes`, `gap_evidence.gap_type` |
| `status == planned` | `plan_date` |
| `status == producing` | `production_note` |
| `status == published` | `published_at`, `metrics.likes`, `metrics.collects` |

## 最小合规示例

```yaml
- id: "research-001"
  title: "二十四节气花卉对照图鉴"
  alt_titles:
    - "每个节气该看什么花？"
  pillar: P2_自然博物
  bucket: B6_搭配
  variant: catalog
  layout: panoramic
  source: gap_driven
  gap_evidence:
    search_demand: high
    supply_density: low
    top_competitor_likes: 260
    gap_type: 蓝海
  stepps: {S: 4, T: 5, E: 4, P_pub: 4, P_prac: 5, S_story: 3}
  score: 4.10
  tier: Hero
  status: idea
  reasoning: "全年可触发，收藏价值高。"
  created: "2026-03-01"
```

## 状态流转规则

`idea -> planned -> producing -> published`

- `idea -> planned`: 必须补 `plan_date`
- `planned -> producing`: 必须补 `production_note`
- `producing -> published`: 必须补 `published_at` 与 `metrics`

## 兼容策略

- 旧数据允许缺少推荐字段。
- 新增或更新的 topic 应遵守本规范（尤其是条件必填）。
