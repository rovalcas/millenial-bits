---
name: skills-sync
description: Sync skill folders between a repo and environment-aware global targets, including repo-to-repo copies.
---

# SKILL.md: Skills Sync

**Skill Name**: Skills Sync
**Purpose**: Copy skill folders between a repo and smart global folders
**Invocation**: `scripts/sync-skills.sh`

---

## Description

Use this skill when you need to move skills between the repository copy and global skill folders.

Supported directions:

- `repo-to-global`: copy from the repo into the active global target(s)
- `global-to-repo`: copy from the active global target(s) back into the repo
- `repo-to-repo`: copy skills between two repo roots

## Defaults

- Repo source: `.github/skills`
- Global destination: resolved by the script for the current environment
- Windows mirror: included automatically when the current environment can reach it

## Usage

Sync repo skills to global folders:

```bash
bash .github/skills/skills-sync/scripts/sync-skills.sh repo-to-global
```

Sync a single skill back into the repo:

```bash
bash .github/skills/skills-sync/scripts/sync-skills.sh global-to-repo summarize-video
```

Sync one repo into another:

```bash
bash .github/skills/skills-sync/scripts/sync-skills.sh repo-to-repo /path/from/repo /path/to/repo summarize-video
```

## Behavior

- Copy whole skill directories, not individual files.
- Preserve file mode and timestamps when possible.
- Validate every `SKILL.md` frontmatter block before copying.
- Never delete destination content.
- Default to updating only the requested direction.
- Allow an explicit skill name to narrow the sync to one folder.
- Treat `global` as host-aware and let the script choose the reachable targets.

## Implementation Notes

The sync script should prefer `rsync` and fall back to `cp -a` only if necessary.
Use additive sync semantics only.
