# TimeMem Copilot Instructions

## Project source of truth

- `docs/` is the canonical source for TimeMem product and implementation decisions. Use [docs/README.md](../docs/README.md) to find the current documents.
- `docs/TimeMem-PRD-V10-1.md` is the current product requirements document: PRD V10.1. Do not treat older drafts or archived notes as overriding it.
- The Obsidian Vault is at `C:\Project\Obsidian-Hub\TimeMem`. It is for personal notes and daily records; repo docs remain authoritative for project decisions if the two overlap.
- If canonical docs conflict or leave a decision open, stop and ask instead of guessing or silently resolving it.

## Vault safety and frontmatter

- Never rename the Vault's numbered folders `00` through `07`.
- Never delete existing note body content. Preserve existing material; ask before removing or replacing it.
- Preserve existing frontmatter properties. Do not silently rename or remove properties.
- For new notes, use valid YAML frontmatter and only the agreed properties below. Ask before adding any other property.

```yaml
---
title:
date: 2026-11-10
type: note
status: draft
tags: []
related: []
---
```

- `title` may be blank or contain the note title.
- `date` uses `YYYY-MM-DD`.
- `type` is one of `PRD`, `ADR`, `SOP`, `clipping`, or `note`.
- `status` is one of `draft`, `in-progress`, or `done`.
- For `clipping` notes, include `source:` in addition to the properties above.

## Skills

- Use `.agents/skills/` only; GPT-6 Luna is the primary tool. The `.github/skills/` and `.github/skills-cold/` copies were removed. Sync has been disabled since 2026-11-15 and must not be re-enabled without Joe's approval.
- Do not run `scripts\sync-skills.ps1`; it is disabled and fails explicitly. The `-RepoOnly` mode of `scripts\check-skills-sync.ps1` is disabled; running it without that switch still compares repository skills with the local Vault.
- Follow [timemem-workflow](../.agents/skills/timemem-workflow/SKILL.md) for Repo-first validation, safe Vault synchronization, Bases conventions, and secret handling.
- The former GitHub Actions skill-mirror check is disabled; it no longer validates or synchronizes repository Skills.
- Do not treat GitHub as a source of Skills; keep active and cold Skills in `.agents/skills/` and `.agents/skills-cold/`.
