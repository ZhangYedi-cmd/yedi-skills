---
name: koubo-script-writer
description: >
  口播稿写作与自动配图引擎。输入一个主题（+可选素材/大纲/源文档），产出一篇可直接对着念的
  短视频口播稿（钩子/主体/收尾，标注每段时长、字数、砍词优先级），并自动规划配图需求、
  写出图片 prompt 文件、调用 baoyu-image-gen 实际出图。触发词：写口播稿、生成口播稿、
  口播文案、短视频文案、配音稿、给视频写稿、自动配图、topic to script、spoken script、
  voiceover script。
---

# 口播稿写作与自动配图

把一个主题变成两样东西：一份能直接对着念的口播稿，一套配好的图。别只写文字不管图，也别只画图没有可念的稿子——两者必须同一次产出、风格互相咬合。

**Iron Law：口播稿是念的，不是读的。** 禁止 bullet list、禁止书面语（"首先/其次/综上所述"）、禁止无法验证的数据。每段落必须是能一口气念下去的连贯口语段落，第一人称，带真实案例或具体数字（没有就别编，写"具体数字以实测为准"这类留白）。

## 输入

- **主题**（必需）：一句话说清这期讲什么，没有就先问用户，别自己瞎猜方向。
- **素材**（可选，有多少收多少）：大纲、源码、聊天记录、参考文章、已有的"讲义"/长文版本。
- **目标时长**（可选，默认 3 分钟左右，约 800-900 字，语速基准 4.5 字/秒）。
- **配图需求**（可选）：默认"封面 + 每个主体段落一张示意图"；用户可以说"只要文案不要图"跳过 Step 4-5。
- **输出目录**（可选，没指定就问一句，或用当前工作目录下 `assets/` 惯例）。

## 工作流

### Step 1 · 素材内化

读完用户给的所有素材，提炼：这期的核心论点是什么、能撑起论点的 1-2 个具体案例/数字、读者此刻的认知缺口在哪。缺口决定钩子怎么开场——钩子要么戳一个反常识的事实，要么戳一个读者正在经历的痛点，不要用"今天来聊聊 XXX"这种平铺式开场。

### Step 2 · 拆大纲（先给用户确认）

按 `references/script-format.md` 的结构拆段落，每段标：段名、目标秒数、这段要讲的一句话核心。默认结构（可按素材增减）：

| 段落 | 时长 | 作用 |
|---|---|---|
| 钩子 | 约 15s | 反常识事实/痛点，抛出本期要讲的核心概念 |
| 概念/为什么 | 约 45-55s | 讲清问题本质，用一个具体案例代替抽象定义 |
| 怎么做/案例 | 约 50-60s（可拆 2 段） | 具体机制或流程，越具体越好，能复现的给复现路径 |
| 坑/边界 | 约 30-40s | 真实翻车案例 + 现行规则，没有真实坑就砍这段，不编 |
| 收尾 | 约 25-30s | 一句话总结边界/原则 + 一个抛给观众的开放问题 |

大纲发给用户确认（除非用户明确说"直接写"或是自动化调用），确认后再写正文。

### Step 3 · 写正文

逐段写，遵守 `references/script-format.md` 的措辞规范。写完做字数/时长核对：字数 ÷ 4.5 = 预估秒数，超时长 15% 以上要精简，不是删内容删水词。

文件头部按 `references/script-format.md` 的格式写清：对应讲义/源文档（如果有）、全稿字数、预估时长、压缩时优先砍哪几段（越靠后写的段落越先砍，坑/边界段通常第一个砍）。

输出文件名：`{日期或主题短语}-koubo.md`，写到用户指定目录。

### Step 4 · 配图需求规划

从口播稿的段落结构反推图片清单，默认规则：

1. 封面 1 张（横版 16:9，如果明确要发抖音/短视频平台再加竖版 9:16）。
2. 每个"主体/案例"类段落 1 张示意图（钩子段和收尾段一般不需要单独配图，除非用户要求）。
3. 图不超过正文段落数——宁缺毋滥，不是每句话都要一张图。

先看输出目录（或用户指定目录）下有没有已存在的图片 prompt（常见路径 `assets/prompts/*.md`）。**有就复用其角色/配色描述**，保证系列视觉统一，不要另起一套风格。没有就用 `references/image-style-guide.md` 的默认模板起草一套角色设定，写清楚后**先问用户是否满意这套角色/配色**再往下走（出图有实际成本，方向错了返工代价高）。

### Step 5 · 写 prompt 文件 + 出图

按 `references/image-style-guide.md` 的格式，每张图写一个独立 `.md` prompt 文件，编号规则：`00-cover.md`（横版封面）、`00-cover-vertical.md`（竖版封面，如需要）、`01-xxx.md`、`02-xxx.md`...（按正文段落顺序）。

调用本机 `baoyu-image-gen` skill 实际出图（不要自己另写图片生成逻辑）：

```bash
# 定位 baoyu-image-gen（通常在全局 skills 目录）
BAOYU_DIR="$HOME/.claude/skills/baoyu-image-gen"
[ -d "$BAOYU_DIR" ] || BAOYU_DIR=$(find "$HOME" -maxdepth 4 -iname "baoyu-image-gen" -print -quit 2>/dev/null)

# 单张出图（示例：横版封面）
BUN_X=bun; command -v bun >/dev/null || BUN_X="npx -y bun"
$BUN_X "$BAOYU_DIR/scripts/main.ts" --promptfiles assets/prompts/00-cover.md --image assets/00-cover.png --ar 16:9

# 竖版封面
$BUN_X "$BAOYU_DIR/scripts/main.ts" --promptfiles assets/prompts/00-cover-vertical.md --image assets/00-cover-vertical.png --ar 9:16

# 批量出图：先用 baoyu-image-gen 的 build-batch.ts 把 prompts/ 目录打成 batch.json，再并发出图
$BUN_X "$BAOYU_DIR/scripts/build-batch.ts" --outline <大纲文件或prompts目录> --prompts assets/prompts --output assets/batch.json --images-dir assets
$BUN_X "$BAOYU_DIR/scripts/main.ts" --batchfile assets/batch.json --jobs 4
```

若 `baoyu-image-gen` 首次使用需要 `EXTEND.md` 配置（provider/model/画质），照它自己的 Step 0 走一遍，不要在本 skill 里重复实现配置逻辑。

若同一系列已经出过图（角色/配色已在其他 prompt 文件里定型），新的 prompt 必须原样复用那段角色描述文字，不要意译或简化，避免同系列角色跑偏。

### Step 6 · 收尾自查

- [ ] 正文全是能念的连贯口语段落，没有 bullet、没有书面语过渡词
- [ ] 没有编造的数据/benchmark；不确定的地方写了留白而不是瞎编
- [ ] 头部时长/字数标注和实际字数对得上
- [ ] 图片数量 = 封面 + 主体段落数，没有为了凑数硬加图
- [ ] 每张图的角色/配色描述与系列内其他图一致（复用同一套措辞）
- [ ] 汇总输出：口播稿路径、prompt 文件路径、出图结果（成功/失败各几张）给用户

## 边界

- 只产口播稿 + 配图，不负责发布、不负责剪辑/合成视频（发布走各平台自己的发布 skill）。
- 不判断内容是否符合具体平台审核规则（导流、敏感词等）——那是调用方项目自己的红线，这个 skill 不重复实现，如果调用方项目有 `CLAUDE.md`/`brain/` 之类的红线文档，写稿前应该先读一遍。
- 不做人物写实肖像生成；配图默认走插画风格（参考 `references/image-style-guide.md`）。
