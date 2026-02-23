# yedi-skills

`yedi-skills` 是你的技能源仓库，用来集中维护可被多个 AI Agent 使用的 skills，并通过 `skillsync` 自动同步到各工具的全局 skills 目录。

## 目录约定

Skill 根目录格式：

`<scope>/<namespace>/<skill>/`

并且每个 skill 根目录必须包含 `SKILL.md`。

当前作用域：

- `shared`：共享 skill，会同步到所有工具
- `codex`：仅同步到 Codex
- `claude-code`：仅同步到 Claude Code
- `openclaw`：仅同步到 OpenClaw

## 快速开始

1. 安装 hooks 和全局 `skillsync` 命令：

```bash
/Users/yedi/yedi-study/yedi-skills/scripts/install-hooks.sh
```

2. 执行同步：

```bash
skillsync sync all
```

## 常用命令

同步到指定工具：

```bash
skillsync sync codex
skillsync sync claude-code
skillsync sync openclaw
```

增量同步（按某次提交）：

```bash
skillsync sync all --commit HEAD
```

预览动作（不落盘）：

```bash
skillsync sync claude-code --dry-run --verbose
```

## 默认目标目录

- Codex：`~/.codex/skills`
- Claude Code：`~/.claude/skills`
- OpenClaw：`~/.openclaw/skills`

可通过环境变量覆盖：

- `CODEX_SKILLS_DIR`
- `CLAUDE_CODE_SKILLS_DIR`
- `OPENCLAW_SKILLS_DIR`

## 自动同步机制

- Git `post-commit` hook 会在提交后执行同步。
- 同步失败不会影响提交成功（只输出报错日志）。

## 详细文档

完整规则、冲突处理、删除策略、安装细节见：

- `/Users/yedi/yedi-study/yedi-skills/docs/skill-sync.md`
