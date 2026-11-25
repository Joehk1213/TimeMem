---
name: timemem-workflow
description: "Use for TimeMem Repo and Obsidian Vault work: Repo-first changes, validation, safe synchronization, Bases, and secret handling."
---

# TimeMem Workflow

## When to Use

Use this workflow for changes or synchronization involving the TimeMem repository and its Obsidian Vault.

## Source of Truth

- Repo `C:\Project\TimeMem` is the formal source of truth. It uses Git and has `scripts\check-all.ps1`.
- Vault `C:\Project\Obsidian-Hub\TimeMem` is for notes and records, not the formal source. It has no Git remote.
- Do not resolve conflicts by treating Vault notes as more authoritative than Repo files.

## Required Order: Repo, Validate, Then Vault

1. Make and review the requested changes in Repo first.
2. Run focused checks and `powershell -ExecutionPolicy Bypass -File scripts\check-all.ps1` from Repo. Run `git diff --check` as well when files changed.
3. If any check fails, fix the Repo changes and rerun checks. Do not synchronize to Vault until Repo validation passes.
4. After PASS, synchronize only the relevant notes to Vault. Preserve existing note bodies and add or append information; do not overwrite existing notes.
5. Verify the Vault copy and relevant Bases after synchronization. Do not commit unrelated work.

## Vault Safety

- Never rename, move, or delete these Vault folders: `00-總覽`, `01-時間線-轉接故事`, `02-決策-ADR`, `03-PRD`, `04-SOP`, `05-進度-PROGRESS`, `06-AI意見`, `07-Archive`, `Daily`, `Templates`, and `08-素材-Inbox`.
- Never delete existing note body content. Preserve existing material and frontmatter when appending or syncing.
- New note frontmatter uses this order and these fields: `title`, `date`, `type`, `status`, `tags`, `related`. Do not add an `updated` property or hard-code an updated time.
- Bases use the file-system property `file.mtime` for the last-modified value.
- Never write real passwords or API keys to Vault. `.env.example` may contain variable names and explanatory comments only; keep values blank and never copy real values.

## Bases

- Both TimeMem table Bases use the same underlying order: `file.name`, `type`, `status`, `date`, `file.mtime`.
- Set display names through the Base-level `properties` mapping: `Name`, `Type`, `Status`, `Created`, `Modified`.
- Keep existing filters and views unchanged unless explicitly requested.
- Expected result counts are 4 for `00-總覽/進行中.base` and 1 for `00-總覽/PRD一覽.base`. Recheck both after relevant Vault changes.

## Vault 規則

### 定位與同步

- Vault `C:\Project\Obsidian-Hub\TimeMem` 是個人筆記、草稿和記錄，不是正式文件。Repo 才是正式來源；先在 Repo 完成並驗證 PASS，再 publish，然後才把記錄 copy 回 Vault。
- Repo 有 Git 和 `scripts\check-all.ps1`；Vault 沒有 Git remote。

### Folder 定義

- `00-總覽`：只放 `PRD一覽.base` 和 `進行中.base` 兩個 Base，不放筆記。
- `01-時間線-轉接故事`：每個階段一個 file。
- `02-決策-ADR`：每個決定一個 file；Repo `docs/DECISIONS.md` 是正式版，這裡只放同步副本和草稿。
- `03-PRD`：只放 `TimeMem-PRD-V10-1.md` 這個 Master；不另開 PRD 版本，舊版放 `07-Archive`。
- `04-SOP`：每個 SOP 一個 file。
- `05-進度-PROGRESS`：每次同步開新 file，不覆寫舊 file。
- `06-AI意見`：每個 AI 建議開一個 file，寫明跟或不跟，以及原因。
- `07-Archive`：保存所有舊版；`status` 設為 `archived`，作為證據保留，不刪除。
- `08-素材-Inbox`：保存 Defuddle 收集的 clipping，使用 `type: clipping`、`status: inbox`；整理後按內容移到 `01`、`02` 或 `04`。
- `Daily`：每日一個 `YYYY-MM-DD.md`；只追加，不覆寫。
- `Templates`：只保留英文名 `PRD`、`ADR`、`SOP`、`Clipping` 四份範本，不在範本內寫實際正文。

### File name 規則

- `Daily` 使用 `YYYY-MM-DD.md`。
- `01`、`02`、`04`、`05`、`06` 使用 `YYYY-MM-DD-主題.md`。
- `03` 的 Master 永遠叫 `TimeMem-PRD-V10-1.md`，不改名。
- `Templates` 保持英文檔名 `PRD.md`、`ADR.md`、`SOP.md`、`Clipping.md`。

### Frontmatter 規則

新檔案 frontmatter 欄位按以下次序：

```yaml
---
title:
date: YYYY-MM-DD
type:
status:
tags: []
related: []
---
```

> 唔使手填 updated，Bases 會用 file.mtime 自動顯示最後修改。

- `date` 是建立日期；建立後不要更改。
- `status` 為 `draft`、`in-progress`、`done`、`archived` 或 clipping 使用的 `inbox`。只有 `draft` 和 `in-progress` 會出現在「進行中」；`done`、`archived` 和 `inbox` 不會。

### Update 規則

- 不覆寫舊 file；新狀態另開新 file 記錄。舊 file 設為 `archived` 後移到 `07-Archive`，保留原正文作證據。
- `Daily` 只追加新內容，不刪除或覆寫舊內容。

### Bases 規則

- `PRD一覽` 只看 `03-PRD`，目前預期 1 個結果。
- `進行中` 看全 Vault 中 `status: draft` 或 `status: in-progress` 的 Markdown notes，目前預期 4 個結果。
- 兩個 Base 欄位和顯示名一致：`Name`、`Type`、`Status`、`Created`、`Modified`。
- `Created` 對應 `date`；`Modified` 對應 `file.mtime`。不要新增或手填 `updated` 欄位。

## Repo 檔案規則

- `C:\Project\TimeMem\README.md`（約 1 KB）是整個項目的入口，說明如何入門及去哪裡看文件；由此進入項目並按連結閱讀文件。
- `C:\Project\TimeMem\docs\TODO.md` 記錄未做及做緊的工作並標明優先級。完成後將事項搬到 `docs\PROGRESS.md` 作已完成記錄，並從 TODO 剔走。TODO 只列未做，PROGRESS 只列已做，兩者不可重疊。
- `C:\Project\TimeMem\docs\ERRORLOG.md` 記錄錯誤、原因、修正及避免重犯的方法。M0-M6 每次出 bug 都要即時記錄，格式為：日期 / 邊個 M-step / 錯咩 / 原因 / 點 fix / 點避免再犯。DECISIONS 記決定；ERRORLOG 記錯誤，兩者不可混用。
- `C:\Project\TimeMem\skills-lock.json`（約 8 KB）記錄 Skill、版本及 hash；不是同步機制。只使用 `.agents/skills/` 及 `.agents/skills-cold/`，Luna 為主要工具；同步至 `.github` 已停用，日期為 2026-11-15。
- 每次開工做 M-step，一定要先看 `docs\TODO.md`；做完要更新 `docs\TODO.md`、`docs\PROGRESS.md`，如有出錯亦要更新 `docs\ERRORLOG.md`，不可用舊 Root 路徑。
- `sync-skills.ps1` 已停用；`check-skills-sync.ps1 -RepoOnly` 亦已停用。不可產生或檢查 `.github` Skills；不帶 `-RepoOnly` 的指令仍可比較本機 Vault。
- Root 要保持乾淨，只留 `README.md`、`.gitignore`、`.env.example`、`skills-lock.json`、`.agents`、`.github`、`docs`、`reference`、`scripts`、`.git`。
