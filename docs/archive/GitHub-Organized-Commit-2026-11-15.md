> 歷史文件：本文撰寫時現行版為 V10.1；現行版已為 V10.2。

# GitHub Skills 清理及本機 Commit 報告

日期：2026-11-15

## 範圍及結果

- 已確認 Desktop Backup `TimeMem-BACKUP-2026-11-15` 存在。刪除前逐檔比較 `.github/skills/` 及 `.github/skills-cold/` 的相對路徑與 SHA-256，與 Backup 完全相符；Backup 沒有修改。
- 只刪除 repo 內 `.github/skills/`（57 個檔案）及 `.github/skills-cold/`（168 個檔案），合共 **225 個檔案**。`.github/` 本身及其 workflow、Copilot instructions 均保留；`.agents/skills/` 和 `.agents/skills-cold/` 均保留。
- 已在 `.gitignore` 加入 `.github/skills/**` 及 `.github/skills-cold/**`。
- Sync 已停用（2026-11-15）：`scripts/sync-skills.ps1` 會明確失敗；`.github/workflows/Check-Skills-Sync.yml` 的 job 已停用；`scripts/check-skills-sync.ps1 -RepoOnly` 已停用。本機 Vault 比對模式仍保留。
- 已更新 `.github/copilot-instructions.md`、`docs/README.md`、`docs/reviews/SKILL-FLOW-2026-11-14.md`、`docs/reports/GitHub-Push-Plan-2026-11-15.md`、`docs/reports/GitHub-Deletion-Audit-2026-11-15.md`、`docs/reports/GitHub-Cleanup-Check-2026-11-15.md`，以及 `.agents/skills/timemem-workflow/SKILL.md` 和 `.agents/skills-cold/book-to-skill/references/conversion_workflow.md`。內容指出只用 `.agents/skills/`、Luna 為主要工具，並記錄已停用同步。

## 保護檢查

- 六份 Gate 文件、evidence 清單及 v1/v2 版本檔案的 SHA-256 與既有基線一致。
- `docs/evidence/` 有 12 個檔案，Git 狀態仍為 0 項；沒有開啟 evidence 或 reference/photo 圖片。
- 沒有讀取 `.git` 內部檔案、`.env` 或 Key 檔案內容。M0 仍為 **Draft / NOT APPROVED**；本次整理及 Commit 不代表 M0 獲批。

## 本機 Commit

- Commit message：`M0 organized: remove .github skills, stop skill sync, keep .agents skills for Luna`
- 僅建立本機 Commit，**未 Push**；Commit 後 `git status --porcelain=v1 --untracked-files=all` 為空，Staged 為 0，Working tree 乾淨。
- `git log --oneline -3` 確認新 organized commit 在原有歷史之上，initial commit 未被改寫。

**提醒：GitHub 仍是未 Push 前的舊狀態。請勿直接 Push；等 Sir 睇完先。**