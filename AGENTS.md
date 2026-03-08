# AGENTS

## Repository Purpose

`yedi-skills` is the source-of-truth repository for reusable skills shared across multiple AI agents.

This repository is used to:
- maintain skill source files
- organize skills by scope and namespace
- sync skills into each agent's global skills directory

Do not treat the global skills directories as the source of truth. This repository is the source of truth; synced copies are mirrors.

## Directory Convention

Every skill must live at:

`<scope>/<namespace>/<skill>/`

Each skill root must contain `SKILL.md`.

Scopes:
- `shared`: sync to all supported agents
- `codex`: sync to Codex only
- `claude-code`: sync to Claude Code only
- `openclaw`: sync to OpenClaw only

## Working Rules

When working in this repository:
- prefer updating skill source here instead of editing any global installed copy
- do not hand-edit `SKILLS_INDEX.md` unless explicitly asked; it is generated
- keep namespace grouping capability-based and coherent
- if you add, remove, move, or edit a skill, treat sync as part of the task, not an optional follow-up

## Required After Skill Changes

If any skill content changes, including:
- `SKILL.md`
- `VERSION`
- `CHANGELOG.md`
- files under a skill's `scripts/`, `references/`, `examples/`, `assets/`, or similar subdirectories
- skill moves, renames, additions, or deletions

then before finishing:

1. Regenerate the index when needed:

```bash
python3 scripts/skill-maintenance.py index
```

2. Sync all managed skills to global agent skill directories:

```bash
skillsync sync all
```

3. In the final response, explicitly state whether sync was run and whether it succeeded.

## Sync Notes

- `skillsync` is the standard sync command in this repo.
- If hooks are not installed yet, install them with:

```bash
/Users/yedi/yedi-study/yedi-skills/scripts/install-hooks.sh
```

- After hook installation, `git commit` will also trigger:

```bash
skillsync sync all --commit HEAD
```

## Default Global Skill Directories

- Codex: `~/.codex/skills`
- Claude Code: `~/.claude/skills`
- OpenClaw: `~/.openclaw/skills`

## Maintenance Reminder

For this repository, "task complete" means:
- source changes are done
- generated index is up to date when applicable
- global skill sync has been executed or an explicit reason is given why it was not run
