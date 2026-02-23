# yedi-skills 多 Agent 自动同步说明

## 目标
在本仓库提交后，自动将 skills 同步到各工具全局 skills 目录，并按目录作用域控制同步目标。

## 目录规范与作用域
仅识别以下顶层目录：

- `shared`
- `codex`
- `claude-code`
- `openclaw`

Skill 根目录格式固定为：

`<scope>/<namespace>/<skill>/`

且该目录必须包含 `SKILL.md`。

同步到目标端时，目录会扁平化为：

`<global_skills>/<skill>`

不会保留 namespace 层级。

作用域路由规则：

- `shared/<namespace>/<skill>`: 同步到所有工具
- `codex/<namespace>/<skill>`: 仅同步到 Codex
- `claude-code/<namespace>/<skill>`: 仅同步到 Claude Code
- `openclaw/<namespace>/<skill>`: 仅同步到 OpenClaw

## 默认目标目录

- Codex: `~/.codex/skills`
- Claude Code: `~/.claude/skills`
- OpenClaw: `~/.openclaw/skills`

如果目标目录不存在：打印 warning 并跳过，不会自动创建，也不会让脚本失败。

## CLI 命令
主命令为：

```bash
skillsync
```

子命令：

```bash
skillsync sync [target] [options]
```

`target` 可选值：

- `all`（默认）
- `codex`
- `claude-code`
- `openclaw`

示例：

```bash
skillsync sync codex
skillsync sync all
skillsync sync codex --commit HEAD --dry-run
```

默认行为：

- 若未指定 `--all` 或 `--commit`，默认使用 `--all`（全量同步）。
- `skillsync sync codex` 会同步：
  - `shared/<namespace>/<skill>`（共享技能）
  - `codex/<namespace>/<skill>`（codex 专有技能）
  到 Codex 目标目录，不会触发其他工具同步。

## 一次性安装 Git Hook
在仓库根目录执行：

```bash
/Users/yedi/yedi-study/yedi-skills/scripts/install-hooks.sh
```

安装脚本会：

1. 设置 `git config core.hooksPath .githooks`
2. 确保以下脚本可执行：
   - `.githooks/post-commit`
   - `scripts/skillsync`
   - `scripts/sync-skills.sh`
   - `scripts/install-hooks.sh`
3. 安装全局命令软链：
   - 默认目录：`/Users/yedi/.local/node-v20.20.0/bin`
   - 软链目标：`skillsync -> /Users/yedi/yedi-study/yedi-skills/scripts/skillsync`
   - 可通过环境变量 `SKILLSYNC_BIN_DIR` 覆盖安装目录
4. 若安装目录不在 `PATH`，脚本会提示但不会失败

## 手动执行同步
推荐用 CLI：

```bash
skillsync sync all
```

按目标工具同步：

```bash
skillsync sync codex
```

按提交增量同步：

```bash
skillsync sync all --commit HEAD
```

只看动作不落盘（dry-run）：

```bash
skillsync sync codex --dry-run --verbose
```

兼容旧入口（仍可用）：

```bash
/Users/yedi/yedi-study/yedi-skills/scripts/sync-skills.sh --all
/Users/yedi/yedi-study/yedi-skills/scripts/sync-skills.sh --commit HEAD
```

## 环境变量覆盖目标目录
你可以在执行时覆盖默认目录（CLI 和旧脚本都生效）：

```bash
CODEX_SKILLS_DIR="/custom/codex/skills" \
CLAUDE_CODE_SKILLS_DIR="/custom/claude/skills" \
OPENCLAW_SKILLS_DIR="/custom/openclaw/skills" \
skillsync sync all
```

## 删除策略
删除策略为镜像删除：

- 当源 skill 根目录不存在（或不再包含 `SKILL.md`）时，目标 `<global_skills>/<skill>` 会被删除。
- 同步复制使用 `rsync -a --delete`，会删除目标中源里不存在的文件。

## 冲突策略
若同一次执行中，同一个目标工具出现同名 skill（例如 `shared/.../foo` 和 `codex/.../foo` 都映射到 Codex 的 `foo`），脚本会直接报错并退出非 0，避免静默覆盖。

## Git Hook 行为
`post-commit` 会调用：

```bash
/Users/yedi/yedi-study/yedi-skills/scripts/skillsync sync all --commit HEAD
```

如果同步失败，Hook 只报错并 `exit 0`，不会影响本次 commit 结果。

## 常见问题

### 为什么某些工具没有同步？
目标目录不存在时会被跳过。例如当前机器没有 `~/.claude/skills`，脚本会 warning 后继续其他工具。

### 为什么目标目录不保留 namespace？
当前策略是按 `<skill>` 扁平化，便于兼容大多数 agent 全局 skills 结构。

### 同名冲突如何处理？
脚本会检测目标 `(agent, skill)` 键是否来自多个源 skill 根目录。若冲突，立即退出并给出冲突路径。

### 旧命令还能用吗？
能用。`sync-skills.sh` 保留兼容，`skillsync` 是更推荐的统一入口。
