#!/usr/bin/env python3
from __future__ import annotations

import argparse
import hashlib
import os
import re
import subprocess
from dataclasses import dataclass
from pathlib import Path
from typing import Dict, Iterable, List, Tuple

ROOT = Path(__file__).resolve().parents[1]
IGNORED_TOP = {".git", ".claude"}
SCOPES = {"shared", "codex", "claude-code", "openclaw"}
DEFAULT_VERSION = "0.1.0"


@dataclass(frozen=True)
class Skill:
    scope: str
    namespace: str
    name: str
    path: Path
    description: str


def tracked_skill_files() -> List[Path]:
    try:
        out = subprocess.check_output(
            ["git", "-C", str(ROOT), "ls-files"], text=True
        )
    except Exception:
        return []

    files: List[Path] = []
    for line in out.splitlines():
        if not line.endswith("/SKILL.md"):
            continue
        p = ROOT / line
        if p.exists():
            files.append(p)
    return files


def iter_skills() -> List[Skill]:
    skills: List[Skill] = []

    candidates = tracked_skill_files()
    if not candidates:
        candidates = list(ROOT.rglob("SKILL.md"))

    for skill_md in candidates:
        rel = skill_md.relative_to(ROOT)
        parts = rel.parts
        if not parts:
            continue
        if parts[0] in IGNORED_TOP:
            continue
        if len(parts) < 4:
            continue
        scope, namespace, name = parts[0], parts[1], parts[2]
        if scope not in SCOPES:
            continue

        description = parse_description(skill_md)
        skills.append(
            Skill(
                scope=scope,
                namespace=namespace,
                name=name,
                path=skill_md.parent,
                description=description,
            )
        )
    return sorted(skills, key=lambda s: (s.scope, s.namespace, s.name))


def parse_description(skill_md: Path) -> str:
    text = skill_md.read_text(encoding="utf-8", errors="ignore")
    m = re.search(r"(?m)^description:\s*(.+)$", text)
    if not m:
        return ""
    raw = m.group(1).strip()
    return raw.strip('"\'')


def read_version(skill: Skill) -> str:
    vf = skill.path / "VERSION"
    if not vf.exists():
        return DEFAULT_VERSION
    value = vf.read_text(encoding="utf-8", errors="ignore").strip()
    return value or DEFAULT_VERSION


def ensure_metadata(skills: Iterable[Skill], dry_run: bool = False) -> Tuple[int, int]:
    created_version = 0
    created_changelog = 0

    for s in skills:
        vfile = s.path / "VERSION"
        if not vfile.exists():
            created_version += 1
            if not dry_run:
                vfile.write_text(f"{DEFAULT_VERSION}\n", encoding="utf-8")

        cfile = s.path / "CHANGELOG.md"
        if not cfile.exists():
            created_changelog += 1
            if not dry_run:
                cfile.write_text(
                    "# CHANGELOG\n\n"
                    f"## {DEFAULT_VERSION} - {today()}\n"
                    "- 初始化版本记录。\n",
                    encoding="utf-8",
                )

    return created_version, created_changelog


def today() -> str:
    from datetime import datetime

    return datetime.now().strftime("%Y-%m-%d")


def generate_index(skills: Iterable[Skill], output: Path) -> None:
    lines: List[str] = []
    lines.append("# SKILLS_INDEX")
    lines.append("")
    lines.append(
        "集中技能索引（自动生成）。修改 skill 后请重新运行：`python3 scripts/skill-maintenance.py all`。"
    )
    lines.append("")
    lines.append("| Scope | Namespace | Skill | Version | Status | Path |")
    lines.append("|---|---|---|---|---|---|")

    for s in skills:
        version = read_version(s)
        rel = s.path.relative_to(ROOT).as_posix()
        lines.append(
            f"| {s.scope} | {s.namespace} | `{s.name}` | {version} | active | `{rel}` |"
        )

    lines.append("")
    lines.append("## Trigger Summary")
    lines.append("")
    for s in skills:
        rel = s.path.relative_to(ROOT).as_posix()
        desc = s.description if s.description else "(no description)"
        lines.append(f"- `{rel}`: {desc}")

    output.write_text("\n".join(lines) + "\n", encoding="utf-8")


def file_digest(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as f:
        for chunk in iter(lambda: f.read(1024 * 1024), b""):
            h.update(chunk)
    return h.hexdigest()


def walk_files(base: Path) -> Dict[str, str]:
    out: Dict[str, str] = {}
    for p in base.rglob("*"):
        if not p.is_file():
            continue
        rel = p.relative_to(base).as_posix()
        if rel.endswith(".DS_Store"):
            continue
        out[rel] = file_digest(p)
    return out


def expected_targets(skills: Iterable[Skill]) -> Dict[str, Dict[str, Skill]]:
    mapping: Dict[str, Dict[str, Skill]] = {
        "codex": {},
        "claude-code": {},
        "openclaw": {},
    }

    for s in skills:
        if s.scope == "shared":
            for t in mapping:
                mapping[t][s.name] = s
        elif s.scope in mapping:
            mapping[s.scope][s.name] = s

    return mapping


def target_dir(target: str) -> Path:
    env_map = {
        "codex": "CODEX_SKILLS_DIR",
        "claude-code": "CLAUDE_CODE_SKILLS_DIR",
        "openclaw": "OPENCLAW_SKILLS_DIR",
    }
    default_map = {
        "codex": Path.home() / ".codex/skills",
        "claude-code": Path.home() / ".claude/skills",
        "openclaw": Path.home() / ".openclaw/skills",
    }
    env_name = env_map[target]
    return Path(os.environ.get(env_name, str(default_map[target]))).expanduser()


def drift_check(skills: Iterable[Skill]) -> int:
    expected = expected_targets(skills)
    has_drift = False

    print("# Drift Check")

    for target, skill_map in expected.items():
        tdir = target_dir(target)
        print(f"\n## Target: {target} ({tdir})")
        if not tdir.exists():
            print("- target dir missing (skipped)")
            continue

        # missing + content mismatch
        for skill_name, src_skill in sorted(skill_map.items()):
            dst_skill_dir = tdir / skill_name
            if not dst_skill_dir.exists():
                has_drift = True
                print(f"- MISSING: {skill_name}")
                continue

            src_files = walk_files(src_skill.path)
            dst_files = walk_files(dst_skill_dir)

            missing_files = sorted(set(src_files.keys()) - set(dst_files.keys()))
            extra_files = sorted(set(dst_files.keys()) - set(src_files.keys()))
            changed_files = sorted(
                [
                    k
                    for k in (set(src_files.keys()) & set(dst_files.keys()))
                    if src_files[k] != dst_files[k]
                ]
            )

            if missing_files or extra_files or changed_files:
                has_drift = True
                print(f"- DRIFT: {skill_name}")
                if missing_files:
                    print(f"  - missing files: {', '.join(missing_files[:8])}")
                if extra_files:
                    print(f"  - extra files: {', '.join(extra_files[:8])}")
                if changed_files:
                    print(f"  - changed files: {', '.join(changed_files[:8])}")

        expected_names = set(skill_map.keys())
        actual_names = set()
        for p in tdir.iterdir():
            if p.is_dir() and (p / "SKILL.md").exists():
                actual_names.add(p.name)

        unmanaged = sorted(actual_names - expected_names)
        if unmanaged:
            print(f"- unmanaged skills in target: {', '.join(unmanaged)}")

    if has_drift:
        print("\nResult: DRIFT DETECTED")
        return 1
    print("\nResult: OK (no managed-skill drift)")
    return 0


def main() -> int:
    parser = argparse.ArgumentParser(description="Skill maintenance helpers")
    parser.add_argument(
        "command",
        choices=["index", "meta", "drift", "all"],
        help="index: generate SKILLS_INDEX.md; meta: ensure VERSION/CHANGELOG; drift: check target drift; all: run index+meta+drift",
    )
    parser.add_argument("--dry-run", action="store_true")
    args = parser.parse_args()

    skills = iter_skills()

    if args.command in {"meta", "all"}:
        c_v, c_c = ensure_metadata(skills, dry_run=args.dry_run)
        print(f"meta: created VERSION={c_v}, CHANGELOG={c_c}")

    if args.command in {"index", "all"}:
        if not args.dry_run:
            generate_index(skills, ROOT / "SKILLS_INDEX.md")
        print("index: generated SKILLS_INDEX.md")

    if args.command in {"drift", "all"}:
        return drift_check(skills)

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
