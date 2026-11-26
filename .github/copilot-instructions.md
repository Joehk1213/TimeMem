# TimeMem Copilot Instructions

## 強制 Multi-Agent 交接規則

- 任何 AI Agent 開始工作前必須先讀取 `docs/PROGRESS.md` 與 `docs/working/AGENT-STATE.md`；每次完成任務後，必須同步更新這兩個檔案。

<!--
性質：Repository Copilot 操作指引
用途：規範批准、PROMPT、檔案閱讀同工作模式
邊個叫開：Joe
幾時可刪：Joe 親口要求刪除或呢套操作指引正式停用
-->

## Copilot 操作指引

1. 冇 Joe 親口講 `APPROVED`，唔做嗰兩樣動作。唔答 = 唔批。
2. `PROMPT` 要清晰簡短，唔好為減而減。每次留返 3 個字保險。
3. 揀讀 3 份 `.MD`，唔好人手貼成堆對話。`PROMPT` 要短，再自己去讀 `TODO / DECISIONS / PROGRESS`。
4. 只睇講明嗰幾個 File，唔好掃晒成個 workspace。
5. 熟嘅範疇一次過出晒，唔牙膏；唔熟嘅先一步一步。
6. 傾嘢用 Meta AI 傾好，再出 `PROMPT` 俾 GitHub Copilot 寫 code。

## Project source of truth

- `docs/` is the canonical source for TimeMem product and implementation decisions. Use [docs/README.md](../docs/README.md) to find the current documents.
- `docs/PRD.md` is the current product requirements document: PRD V10.2. V10.1 is archived at `docs/archive/TimeMem-PRD-V10-1.md`; do not treat archived notes as current requirements.
- M0 remains Draft / NOT APPROVED. Joe alone has approval authority.
- The Obsidian Vault is at `C:\Project\Obsidian-Hub\TimeMem`. It is for personal notes and daily records; repo docs remain authoritative for project decisions if the two overlap.
- If canonical docs conflict or leave a decision open, stop and ask instead of guessing or silently resolving it.

## Record 寫作語言

- 所有 record 文件嘅新內容一律用廣東話，包括 `PROGRESS.md`、`DECISIONS.md` 入面嘅新決定、`GATE.md` 說明、`TODO.md` 描述及 `ERRORLOG.md`。
- 只可保留英文於：檔案名、路徑、D-ID、REQ-ID、TASK-ID、指令、code、PRD、DECISIONS、GATE、TODO、PROGRESS、ERRORLOG、M0、Space、Vault、MCP、Space 名、人名及專有名詞。
- 解釋、原因、做法、Blocker 及下一步全部用廣東話；表頭可用中英對照，但表格內容要用廣東話。
- 當更新一份之前含英文嘅 record，順手將受影響段落轉返廣東話；唔好新增一版英文同一版廣東話。

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