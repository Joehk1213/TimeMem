# TimeMem 文件索引（六份 Gate 文件、現行 PRD 及工作文件）

現行 PRD 為 V10.2（`docs/prd/`）；V10.1 已移至 `docs/archive/`。M0 仍為 Draft / NOT APPROVED，批准權只在 Joe 手上。

| 文件 | 用途／狀態 |
|---|---|
| [DECISIONS.md](./DECISIONS.md) | Repo 正式決策紀錄；Vault `02-決策-ADR` 只保存草稿。 |
| [ERROR_LOG.md](./working/ERROR_LOG.md) | 錯誤、原因、修正及避免重犯方法；M0-M6 出錯時即時記錄。 |
| [TODO.md](./working/TODO.md) | 尚未完成的工作及待決事項；每個 M-step 開始前先查看。 |
| [REQUIREMENTS.md](./REQUIREMENTS.md) | Draft 範圍、排除項目、M0 成功準則及 assumptions；CR-002 / D-023 的範圍決定已批准，M0 本身仍未批准。 |
| [ARCHITECTURE.md](./ARCHITECTURE.md) | D-024 的 React / Node Gateway / Python AI-RAG / PostgreSQL + pgvector 本機目標架構；M0 範圍不變，未決細節及未實作項目標為 TBD。 |
| [TEST-PLAN.md](./TEST-PLAN.md) | 對應需求的 unit、integration 及 manual UAT 計劃；未聲稱已測。 |
| [RISKS.md](./RISKS.md) | M0 風險、影響、緩解方法、負責人及狀態。 |
| [M0-READY.md](./M0-READY.md) | 六份 gate 文件狀態、review findings、驗收證據及 Joe 批核記錄；目前 Draft。 |
| [TimeMem-PRD-V10-2.md](./prd/TimeMem-PRD-V10-2.md) | 現行產品需求來源；M0 scope 依 PRD 及已批准的 CR-002 / D-023。V10.1 已歸檔。 |
| [PROGRESS.md](./working/PROGRESS.md) | 工作現況、已決定事項、待決定事項及下一步。 |
| [TimeMem-Home-Hub-Packaging.md](./working/TimeMem-Home-Hub-Packaging.md) | 面向家人的 Home Hub 說明與包裝用語。 |
| [TimeMem-Home-Hub-Physical-Setup.md](./working/TimeMem-Home-Hub-Physical-Setup.md) | JOE-SERVER 的實體擺位及接線參考。 |
| [TimeMem-Install-SOP-Lock-Version.md](./working/TimeMem-Install-SOP-Lock-Version.md) | Lock 版安裝 SOP；SOP 原始版號保留，產品要求以現行 PRD V10.2 為準。 |
| [TimeMem-Sprint-1-Wake-Test.md](./working/TimeMem-Sprint-1-Wake-Test.md) | 舊 Standby/WOL 喚醒測試草稿；僅供歷史參考，與 Lock 版不一致時以現行 PRD/SOP 為準。 |
| [原構思 IDEA.txt](./prd/原構思%20IDEA.txt) | 最初構想及早期技術方向；歷史參考，不覆蓋現行 PRD。 |
| [README.md](./README.md) | 本索引。 |

## Archive

- [TimeMem-PRD-V10-1.md](./archive/TimeMem-PRD-V10-1.md) — V10.1 歷史版本；現行版本為 V10.2。
- [IMPLEMENTATION_PLAN.md](./archive/IMPLEMENTATION_PLAN.md) — obsolete Phase 1 proposal; retained for history only, not an implementation authority.
- [REUSE-PROPOSAL.md](./archive/REUSE-PROPOSAL.md) — 歷史提案；不作現行實作依據。

## 報告 Reports

- [2026-11-10 M0 準備報告](./reports/2026-11-10-m0-ready.html) — historical report only; its PASS wording is not current review evidence or M0 approval.
- [LUNA-REVIEW-2026-11-14.md](./reviews/LUNA-REVIEW-2026-11-14.md) — 歷史 Luna review handoff/repair record。
- [INDEPENDENT-REVIEW-2026-11-14.md](./reviews/INDEPENDENT-REVIEW-2026-11-14.md) — 歷史 independent document review；不是 Luna Review 證據或裝置 UAT。

## Root 檔案

- `C:\Project\TimeMem\README.md`（約 1 KB）— 成個項目的入口，介紹點入門及去邊度睇文件；開始工作時由此進入，再按連結閱讀相關文件。
- `C:\Project\TimeMem\docs\working\TODO.md` — 記錄未做及做緊的工作，並標明優先級。每個 M-step 開始前先查看；完成後將事項搬到 `docs\working\PROGRESS.md` 作已完成記錄，同時從 TODO 剔走。TODO 只列未做，PROGRESS 只列已做，兩者不可重疊。
- `C:\Project\TimeMem\docs\working\ERROR_LOG.md` — 記錄錯誤、原因、修正及避免重犯的方法。M0-M6 每次出 bug 都要即時記錄，格式為：日期 / 邊個 M-step / 錯咩 / 原因 / 點 fix / 點避免再犯。DECISIONS 記決定；ERROR_LOG 記錯誤，兩者不可混用。
- `C:\Project\TimeMem\skills-lock.json`（約 8 KB）— Skills metadata 檔，記錄 Skill、版本及 hash；不再用於同步。只使用 `.agents/skills/`（及 `.agents/skills-cold/`）；Luna 為主要工具。`.github` 嗰套 Skills 已刪走，Sync 已於 2026-11-15 停用。
