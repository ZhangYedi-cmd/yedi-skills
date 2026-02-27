---
name: xhs-auto-post
description: 小红书图文自动生成项目。OpenClaw 按预定义工作流编排 Claude Code，完成 Brief 生成、图片生成、质量审核、压缩、归档的完整流程。当用户说"做小红书"、"生成小红书内容"、"XHS 图文"、"帮我出一期小红书"时使用。
---

# XHS 小红书图文自动生成

将用户意图转化为可发布的小红书图文，全程按预定义工作流执行，产物统一归档。

## 角色边界

### OpenClaw 负责

- 分析用户意图，填写 Brief（topic / style / layout / count）
- 按工作流编排步骤，决定调用哪个 Claude Code Skill
- 在 Step 3 审核图片质量（通过继续 / 打回重做）
- 每步完成后写入 run.log

### Claude Code 负责

- Step 2：执行 `baoyu-xhs-images`（或其他图片 Skill）生成图片
- Step 4：执行 `baoyu-compress-image` 压缩图片
- 操作文件系统，输出产物到规范路径

## 工作流摘要

```
Step 1  [OpenClaw]                        分析意图 → 创建 run 目录，写 brief.md
Step 2  [ClaudeCode: baoyu-xhs-images]    读 brief.md → 生成 images/
Step 3  [OpenClaw]                        质量审核 → 通过 / 打回重做
Step 4  [ClaudeCode: baoyu-compress-image] 压缩 images/ → images-compressed/
Step 5  [OpenClaw]                        完成 run.log，告知用户产物路径
```

详细定义见 → `references/workflow.md`

## 可用 Claude Code Skills

| Skill | 默认用途 |
|---|---|
| `baoyu-xhs-images` | 主图生成（默认） |
| `retro-enc` | 复古图鉴风格 |
| `baoyu-cover-image` | 单独生成封面 |
| `baoyu-compress-image` | 发布前压缩 |
| `baoyu-comic` | 漫画叙事风格 |

完整说明（触发词 / 输入 / 输出 / 选择条件）见 → `references/cc-skills.md`

## 产物目录

**根路径**: `~/Projects/xhs-auto-post/runs/`

**每次运行**:
```
YYYY-MM-DD-NNN/
├── brief.md              ← Step 1 输出（OpenClaw 填写）
├── images/               ← Step 2 输出（Claude Code 生成）
├── images-compressed/    ← Step 4 输出（Claude Code 压缩）
└── run.log               ← 全程追加写入
```

完整规范见 → `references/artifacts.md`

## 质量检查点

OpenClaw 在以下节点需要主动 review，不得自动跳过：

- **Step 3**（⛔ 阻塞）：查看 `images/` 下生成的图片，判断是否符合 Brief 要求
  - 通过：继续 Step 4
  - 打回：重新执行 Step 2（可修改 brief.md 后重试）

## 参考文件

- `references/workflow.md` — 每个 Step 的详细输入 / 输出 / 完成条件
- `references/cc-skills.md` — 可用 Claude Code Skills 完整目录
- `references/artifacts.md` — 产物目录结构、命名规则、run.log 格式
