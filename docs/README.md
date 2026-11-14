# TimeMem 文件索引（15 份正式文件；另列本索引）

| 文件 | 用途／狀態 |
|---|---|
| [DECISIONS.md](./DECISIONS.md) | Repo 正式決策紀錄；Vault `02-決策-ADR` 只保存草稿。 |
| [ERROR_LOG.md](./ERROR_LOG.md) | 錯誤、原因、修正及避免重犯方法；M0-M6 出錯時即時記錄。 |
| [TODO.md](./TODO.md) | 尚未完成的工作及待決事項；每個 M-step 開始前先查看。 |
| [REQUIREMENTS.md](./REQUIREMENTS.md) | Draft 範圍、排除項目、M0 成功準則及 assumptions；反映已批准的 CR-002 / D-023。 |
| [ARCHITECTURE.md](./ARCHITECTURE.md) | D-024 的 React / Node Gateway / Python AI-RAG / PostgreSQL + pgvector 本機目標架構；M0 範圍不變，未決細節及未實作項目標為 TBD。 |
| [TEST-PLAN.md](./TEST-PLAN.md) | 對應需求的 unit、integration 及 manual UAT 計劃；未聲稱已測。 |
| [RISKS.md](./RISKS.md) | M0 風險、影響、緩解方法、負責人及狀態。 |
| [M0-READY.md](./M0-READY.md) | 六份 gate 文件狀態、review findings、驗收證據及 Joe 批核記錄；目前 Draft。 |
| [TimeMem-PRD-V10-1.md](./TimeMem-PRD-V10-1.md) | 產品需求來源；M0 scope 依 PRD 及已批准的 CR-002 / D-023。 |
| [PROGRESS.md](./PROGRESS.md) | 工作現況、已決定事項、待決定事項及下一步。 |
| [TimeMem-Home-Hub-Packaging.md](./TimeMem-Home-Hub-Packaging.md) | 面向家人的 Home Hub 說明與包裝用語。 |
| [TimeMem-Home-Hub-Physical-Setup.md](./TimeMem-Home-Hub-Physical-Setup.md) | JOE-SERVER 的實體擺位及接線參考。 |
| [TimeMem-Install-SOP-Lock-Version.md](./TimeMem-Install-SOP-Lock-Version.md) | V10.1 Lock 版安裝 SOP；取代舊 WOL 流程。 |
| [TimeMem-Sprint-1-Wake-Test.md](./TimeMem-Sprint-1-Wake-Test.md) | 舊 Standby/WOL 喚醒測試草稿；僅供歷史參考，與 Lock 版不一致時以現行 PRD/SOP 為準。 |
| [原構思 IDEA.txt](./原構思%20IDEA.txt) | 最初構想及早期技術方向；歷史參考，不覆蓋現行 PRD。 |
| [README.md](./README.md) | 本索引。 |

## Archive

- [archive/IMPLEMENTATION_PLAN.md](./archive/IMPLEMENTATION_PLAN.md) — obsolete Phase 1 proposal; retained for history only, not an implementation authority.

## 報告 Reports

- 2026-11-10 M0 準備報告 — `docs\reports\2026-11-10-m0-ready.html` — historical report only; its PASS wording is not current review evidence or M0 approval.
- [LUNA-REVIEW-2026-11-14.md](./LUNA-REVIEW-2026-11-14.md) — Luna review handoff/repair record; explicitly pending actual Luna review and not a completed review.
- [INDEPENDENT-REVIEW-2026-11-14.md](./INDEPENDENT-REVIEW-2026-11-14.md) — historical independent document review; not Luna Review evidence or device UAT.

## Root 檔案

- `C:\Project\TimeMem\README.md`（約 1 KB）— 成個項目的入口，介紹點入門及去邊度睇文件；開始工作時由此進入，再按連結閱讀相關文件。
- `C:\Project\TimeMem\docs\TODO.md` — 記錄未做及做緊的工作，並標明優先級。每個 M-step 開始前先查看；完成後將事項搬到 `docs\PROGRESS.md` 作已完成記錄，同時從 TODO 剔走。TODO 只列未做，PROGRESS 只列已做，兩者不可重疊。
- `C:\Project\TimeMem\docs\ERROR_LOG.md` — 記錄錯誤、原因、修正及避免重犯的方法。M0-M6 每次出 bug 都要即時記錄，格式為：日期 / 邊個 M-step / 錯咩 / 原因 / 點 fix / 點避免再犯。DECISIONS 記決定；ERROR_LOG 記錯誤，兩者不可混用。
- `C:\Project\TimeMem\skills-lock.json`（約 8 KB）— Skills metadata 檔，記錄 Skill、版本及 hash；不再用於同步。只使用 `.agents/skills/`（及 `.agents/skills-cold/`）；Luna 為主要工具。`.github` 嗰套 Skills 已刪走，Sync 已於 2026-11-15 停用。
