# 端到端演练模板（Topic -> Image -> Publish -> 回填）

目标：在 1 次演练中跑通 `xhs-topic-miner -> retro-enc -> 发布 -> 数据回填` 闭环。

## 演练前检查

- `xiaohongshu-mcp` 可用（至少 `search_feeds` / `user_profile`）
- `retro-enc` 可用
- 工作目录可写（将生成 `topic-miner/*`）

## 路径 A：从零开始（推荐）

### Step 1: 初始化支柱

```bash
/topic-miner init
```

输入 1-3 个竞品 URL，确认后生成 `topic-miner/config/pillars.yaml`。

### Step 2: 市场调研找蓝海

```bash
/topic-miner research --category 传统文化 --n 50
```

输出：
- `topic-miner/research-YYYY-MM-DD.md`
- `topic-miner/backlog.yaml`（追加 `source: gap_driven`）

### Step 3: 生成一批可执行选题

```bash
/topic-miner generate --pillar 传统智慧 --hot
```

输出：`topic-miner/batch-YYYY-MM-DD.md` + 更新 `backlog.yaml`。

### Step 4: 选 1 个 Hero 题制作图片

```bash
/topic-miner backlog --tier Hero --pick 1
```

取推荐标题，交给 `retro-enc`：

```bash
/retro-encyclopedia <选题标题> --variant <建议variant>
```

### Step 5: 发布并回填效果

发布后记录互动数据，再回填：

```bash
/topic-miner backlog --published "<选题标题>" likes=500 collects=200
```

可选：补充评论数和发布时间到 `backlog.yaml` 的 `metrics/comments`、`published_at`。

## 路径 B：仅调研快跑（无需 init）

适合先验证赛道，不立刻建立完整支柱。

```bash
/topic-miner research --category 自然博物 --n 50
/topic-miner backlog --tier Hero --pick 3
/topic-miner score "<候选标题>"
```

说明：该路径可快速拿到可做选题，但 `generate` 仍建议在完成 `init` 后执行。

## 演练完成检查清单

- [ ] 有 `research-*.md` 或 `analysis-*.md`
- [ ] `backlog.yaml` 有至少 1 条 `Hero`
- [ ] 已完成 1 条 `published` 回填
- [ ] 能复盘「为什么爆/不爆」（基于 STEPPS + 回填数据）
