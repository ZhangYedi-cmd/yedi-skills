# XHS Auto Post — 产物管理规范

---

## 根目录

```
~/Projects/xhs-auto-post/runs/
```

OpenClaw 在 Step 1 执行前确认此目录存在，不存在则创建：

```bash
mkdir -p ~/Projects/xhs-auto-post/runs
```

---

## Run 命名规则

格式：`YYYY-MM-DD-NNN`

- `YYYY-MM-DD`：运行日期
- `NNN`：当天序号，从 `001` 开始，同一天多次运行递增

**示例**:
```
2026-02-26-001/   ← 当天第一次
2026-02-26-002/   ← 当天第二次
```

**确定 NNN 的方法**（OpenClaw 在 Step 1 执行）:

```bash
ls ~/Projects/xhs-auto-post/runs/ | grep $(date +%Y-%m-%d) | wc -l
# 结果 + 1 即为本次 NNN，补零到三位
```

---

## 每次 Run 的目录结构

```
YYYY-MM-DD-NNN/
├── brief.md              ← Step 1 输出（OpenClaw 创建）
├── images/               ← Step 2 输出（Claude Code 生成）
│   ├── 01.png
│   ├── 02.png
│   └── ...
├── images-compressed/    ← Step 4 输出（Claude Code 压缩）
│   ├── 01.webp
│   ├── 02.webp
│   └── ...
└── run.log               ← 全程追加写入
```

---

## brief.md 规范

### 必填字段

```markdown
---
topic: <主题描述，1-3 句话，越具体越好>
style: <cute|fresh|warm|bold|minimal|retro|pop|notion|chalkboard|study-notes>
layout: <sparse|balanced|dense|list|comparison|flow|mindmap|quadrant>
count: <数字，1-10>
skill: <baoyu-xhs-images|retro-enc|baoyu-comic>
notes: <补充说明，可为空字符串>
---
```

### 打回重试时追加字段

```markdown
retry-notes: <上次审核的问题描述>
retry-count: <重试次数>
```

### 示例

```markdown
---
topic: "AI 时代如何保持竞争力：3 个普通人也能做到的策略"
style: notion
layout: list
count: 6
skill: baoyu-xhs-images
notes: "受众是职场 25-35 岁，语气轻松不说教"
---
```

---

## run.log 规范

### 格式

每步完成后 OpenClaw 追加一行：

```
[YYYY-MM-DD HH:MM] Step: <step-name> | Status: <ok|fail|retry> | Notes: <说明>
```

### Step Name 枚举

| step-name | 对应步骤 |
|---|---|
| `create-run` | Step 1：创建目录和 brief.md |
| `generate-images` | Step 2：Claude Code 生成图片 |
| `review` | Step 3：OpenClaw 质量审核 |
| `compress` | Step 4：Claude Code 压缩图片 |
| `done` | Step 5：归档完成 |

### 示例 run.log

```
[2026-02-26 10:03] Step: create-run | Status: ok | Notes: Run ID 2026-02-26-001
[2026-02-26 10:04] Step: generate-images | Status: ok | Notes: 生成 6 张图片
[2026-02-26 10:06] Step: review | Status: retry | Notes: 第 3 张文字排版混乱，打回重做
[2026-02-26 10:09] Step: generate-images | Status: ok | Notes: 重新生成 6 张图片
[2026-02-26 10:10] Step: review | Status: ok | Notes: 审核通过
[2026-02-26 10:11] Step: compress | Status: ok | Notes: 平均压缩率 68%
[2026-02-26 10:11] Step: done | Status: ok | Notes: 全流程完成
```

---

## 清理策略

- **保留原则**：所有 run 目录默认永久保留，不自动删除
- **手动清理**：如需释放空间，删除 `images/`（保留 `images-compressed/` 和 `brief.md`、`run.log`）
- **归档**：可将旧 run 目录移至 `~/Projects/xhs-auto-post/archive/`
