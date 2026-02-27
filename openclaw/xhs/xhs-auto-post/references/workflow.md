# XHS Auto Post — 工作流详细定义

完整流程共 5 步。每步明确执行者、输入、输出、完成条件。

---

## Step 1: 创建 Run 目录 + 生成 Brief

- **执行者**: [OpenClaw]
- **输入**: 用户的意图描述（自然语言）
- **输出**: `~/Projects/xhs-auto-post/runs/YYYY-MM-DD-NNN/brief.md`
- **完成条件**: `brief.md` 存在且包含所有必填字段（见下）
- ⛔ **阻塞点**: brief.md 不存在时，Step 2 不得执行

### brief.md 模板

```markdown
---
topic: <主题，1-3 句话>
style: <cute|fresh|warm|bold|minimal|retro|pop|notion|chalkboard|study-notes>
layout: <sparse|balanced|dense|list|comparison|flow|mindmap|quadrant>
count: <图片数量，1-10>
skill: <baoyu-xhs-images|retro-enc|baoyu-comic>
notes: <补充说明，可为空>
---
```

### 选 Skill 的判断逻辑

| 用户意图 | 推荐 Skill |
|---|---|
| 普通知识/种草/日常 | `baoyu-xhs-images`（默认） |
| 复古感、图鉴感、百科感 | `retro-enc` |
| 叙事型、有角色、有剧情 | `baoyu-comic` |

---

## Step 2: 生成图片

- **执行者**: [ClaudeCode: `<brief.skill>`]
- **输入**: `runs/YYYY-MM-DD-NNN/brief.md`
- **输出**: `runs/YYYY-MM-DD-NNN/images/*.png`
- **完成条件**: `images/` 目录存在且图片数量 ≥ `brief.count`
- **调用方式**:

```bash
# 默认（baoyu-xhs-images）
/baoyu-xhs-images --style <style> --layout <layout>
[粘贴 brief.md 的 topic 内容]

# 复古图鉴
/retro-enc
[粘贴 topic]

# 漫画
/baoyu-comic
[粘贴 topic]
```

- **run.log 写入**: `Step: generate-images | Status: ok | Notes: <图片数量>张`

---

## Step 3: 质量审核

- **执行者**: [OpenClaw]
- **输入**: `runs/YYYY-MM-DD-NNN/images/`
- **输出**: 审核结论（通过 / 打回）
- **完成条件**: OpenClaw 明确给出 "通过" 或 "打回"
- ⛔ **阻塞点**: 必须人工 review，不得自动跳过

### 审核标准

- 图片数量是否符合 `brief.count`
- 风格是否符合 `brief.style`
- 内容是否覆盖 `brief.topic` 核心点
- 是否有明显生成错误（文字乱码、内容缺失）

### 打回流程

打回时：
1. 在 `brief.md` 末尾追加 `retry-notes: <问题描述>`
2. 清空 `images/` 目录
3. 重新执行 Step 2

- **run.log 写入**: `Step: review | Status: ok/retry | Notes: <审核说明>`

---

## Step 4: 压缩图片

- **执行者**: [ClaudeCode: `baoyu-compress-image`]
- **输入**: `runs/YYYY-MM-DD-NNN/images/`
- **输出**: `runs/YYYY-MM-DD-NNN/images-compressed/*.webp`
- **完成条件**: `images-compressed/` 下文件数量 = `images/` 下文件数量
- **调用方式**:

```bash
/baoyu-compress-image runs/YYYY-MM-DD-NNN/images/ -o runs/YYYY-MM-DD-NNN/images-compressed/ -r
```

- **run.log 写入**: `Step: compress | Status: ok | Notes: <压缩率>`

---

## Step 5: 归档 + 通知用户

- **执行者**: [OpenClaw]
- **输入**: `run.log` 历史记录
- **输出**: 完成的 `run.log`，向用户报告结果
- **完成条件**: `run.log` 末尾写入完成记录，用户收到产物路径

### 通知用户格式

```
本次运行完成 ✓
Run ID: YYYY-MM-DD-NNN
图片（原始）: ~/Projects/xhs-auto-post/runs/YYYY-MM-DD-NNN/images/
图片（发布用）: ~/Projects/xhs-auto-post/runs/YYYY-MM-DD-NNN/images-compressed/
```

- **run.log 写入**: `Step: done | Status: ok | Notes: 全流程完成`

---

## 完整流程示意

```
用户意图
    │
    ▼
[OpenClaw] Step 1: 生成 brief.md
    │  ⛔ brief.md 必须存在
    ▼
[ClaudeCode] Step 2: 生成 images/
    │
    ▼
[OpenClaw] Step 3: 质量审核
    │  ⛔ 必须 review，通过才继续
    │  ↩ 打回 → 回到 Step 2
    ▼
[ClaudeCode] Step 4: 压缩 → images-compressed/
    │
    ▼
[OpenClaw] Step 5: 归档 + 通知用户
```
