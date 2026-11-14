# 文件過期內容審核 — 2026-11-15

## 範圍與計數

- 掃描範圍：`C:\Project\TimeMem` 內全部 `.md`、`.txt`，共 **176 份**；排除 `.git` 及 `Desktop Backup`。沒有開啟 evidence/reference 圖片。
- 分類計數：**A 8 份現行文件、27 個原始行位**；**B 11 份歷史文件**（9 份加註、2 份 v1/v2 摘要依指示不改）；**C 1 份 Gate 文件、7 個行位**待 Joe 決定。按文件／問題組計共 **20 項**（A 8 + B 11 + C 1）。
- 以下 A 行號為修正前掃描行號。B 只加檔首歷史註記，不改正文；C 完全沒有修改。
- 本次只處理文件，不代表 M0 已批准；M0 仍為 Draft / NOT APPROVED，批准權只在 Joe 手上。

## A — 現行文件：已修正

| 檔案及修正前行號 | 過期內容 | 處理 |
|---|---|---|
| `README.md:3,7-8` | 把 PRD V10.1 寫成現行版；PRD 及 TODO/PROGRESS 指向舊路徑。 | 改指 `docs/prd/TimeMem-PRD-V10-2.md`，註明 V10.1 已歸檔；修正工作文件路徑，並標明 M0 狀態。 |
| `docs/README.md:1,6-8,13-19,29-30,35-36` | 索引標題及文件數目過時；多個工作文件、PRD、原構思及 Review 連結指向搬遷前路徑；CR-002 / D-023 範圍決定容易與 M0 批准混淆；SOP 標籤未分清 SOP 版號與 PRD 現行版。 | 按現況更新索引連結：Gate 在 `docs/`、PRD 在 `docs/prd/`、歷史版在 `docs/archive/`、報告在 `docs/reports/`、Review 在 `docs/reviews/`、工作文件在 `docs/working/`；明確 M0 未批准。 |
| `.github/copilot-instructions.md:6` | 指定 V10.1 舊路徑為現行 PRD。 | 改為 V10.2 現行路徑，並列明 V10.1 歸檔及 M0 狀態。Skills 段落原已正確說明只用 `.agents/skills/`、Luna 為主要工具及 Sync 停用，保留不變。 |
| `docs/working/TODO.md:3,7` | 把 V10.1 當現行 PRD；M0-READY 連結錯指 `docs/working/`。 | 更新為 V10.2，指出 V10.1 已移入 Archive，並修正 Gate 文件相對連結。 |
| `docs/working/TimeMem-Install-SOP-Lock-Version.md:3` | SOP 的 V10.1 版號容易被誤讀成現行 PRD 版號。 | 保留 SOP 原始版號，另註明產品要求以 V10.2 為準及 V10.1 PRD 歸檔位置。 |
| `reference/README.md:3,7-8` | 現行 PRD 及原構思連結仍指搬遷前路徑，並把 V10.1 當現行要求。 | 更新至 `docs/prd/` 的正確檔案，並標示 V10.2 現行、V10.1 歸檔。 |
| `reference/README-HOME-HUB-OVERVIEW.md:3` | 現行要求連結仍指舊 PRD 路徑及版本。 | 更新為 V10.2 路徑，註明 V10.1 已歸檔；保留其餘歷史內容。 |
| `scripts/run sync skill.txt:1` | 仍提供已停用的 Skill Sync 執行命令。 | 換成停用說明：`.github` Skills 已刪除、Sync 停用，只用 `.agents/skills/`，Luna 為主要工具。 |

## B — 歷史文件：只加檔首註記

以下 9 份文件只在正文前（保留 YAML frontmatter 完整性）加上「歷史文件：本文撰寫時現行版為 V10.1；現行版已為 V10.2。」；原正文未改。

| 檔案 | 歷史內容／相關原文行號 |
|---|---|
| `docs/reviews/INDEPENDENT-REVIEW-2026-11-14.md` | 11/14 review 快照，不代表現行文件狀態。 |
| `docs/reviews/LUNA-REVIEW-2026-11-14.md` | 原 frontmatter 記錄當時待 Review 的狀態；後續 Review 已另行記錄。 |
| `docs/reviews/SKILL-FLOW-2026-11-14.md` | `10-18` 記錄當時 `.github` Skills／Sync 檢查；該流程現已停用。原文亦有歷史說明。 |
| `docs/reviews/INDEPENDENT-REVIEW-2026-11-15.md` | 當日文件覆核快照；不替代 Joe 的 M0 批准。 |
| `docs/reviews/LUNA-REVIEW-2026-11-15.md` | `19,42` 記錄當時 M0-READY 同步狀態；後續狀態已有更新。 |
| `docs/reports/GitHub-Cleanup-Check-2026-11-15.md` | `40-48` 是清理前檢查記錄中的舊 `.github` 路徑；保留為歷史證據。 |
| `docs/reports/GitHub-Deletion-Audit-2026-11-15.md` | `26,210-377,382,384` 是刪除前後的歷史分類及路徑；檔案原有開首已標示其為較早 Audit。 |
| `docs/reports/GitHub-Organized-Commit-2026-11-15.md` | `7-10,21` 記錄當日 Skills 清理及停用 Sync 的操作，作為歷史紀錄保留。 |
| `docs/reports/GitHub-Push-Plan-2026-11-15.md` | `8,84-91,124` 記錄當時 Push 計劃及舊路徑；檔案原有開首已標明計劃狀態。 |

以下兩份 v1/v2 摘要亦有過時描述，但按明確保護界線不改、不加註：

- `docs/reports/TimeMem-Summary-For-Sir.md:138,197-198` — v1 摘要中的舊 PRD／Skills Sync 說法。
- `docs/reports/TimeMem-Summary-for-Sir-v2.md:86,88` — v2 摘要中的舊 PRD 路徑及 Skills Mirror 說法；保留其既有工作樹修改。

## C — Gate 文件：列出待 Joe 決定，未修改

| 檔案及行號 | 過時內容 | 處理 |
|---|---|---|
| `docs/M0-READY.md:42,61,156,172,175-177` | Skill-flow PASS／Sync 命令及 `.github/skills` 比對結果仍作為 Gate 證據；Sync 已停用、`.github` Skills 已刪除。 | 完全不改。待 Joe 決定是否在 M0 批准前更新 Gate 證據；Gate 內 `M0 approval: NOT APPROVED` 狀態保留。 |

其餘五份 Gate（`ARCHITECTURE.md`、`DECISIONS.md`、`REQUIREMENTS.md`、`RISKS.md`、`TEST-PLAN.md`）未找到需依本次條件修正的 V10.1 現行版、舊 Skills Sync 現行用法、搬遷前 PRD 路徑或「M0 已批准／功能已完成」宣稱。六份 Gate 均未修改。

## 驗證及保護界線

- 本次 A 類更新 **8 份**；B 類加註 **9 份**；C 類 **1 份、7 個行位**留待 Joe 決定。
- 沒有修改六份 Gate、`docs/evidence/`、v1/v2 摘要正文或任何歷史報告正文；沒有 stage、commit 或 push。
- `git status` 和 `git diff --stat` 的最後結果及既有工作樹修改，另於本次工作結束時核對；本報告不記錄任何序號、IMEI、個人裝置名稱、密碼、Key、Token 或完整 IP 原文。
