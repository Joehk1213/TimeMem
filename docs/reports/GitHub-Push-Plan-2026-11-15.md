> 歷史文件：本文撰寫時現行版為 V10.1；現行版已為 V10.2。

# GitHub 選擇性推送計劃

檢查範圍：`C:\Project\TimeMem`  
計劃日期：2026-11-15

本文件是選擇性推送計劃，不代表已推送或批准 M0。M0 仍為 **Draft / NOT APPROVED**；批准權只在 Joe 手上。

> 更新（2026-11-15）：已刪走 `.github` 嗰套 Skills，Sync 已停用，只用 `.agents/skills/`，Luna 為主要工具。本文件的推送計劃是歷史記錄；本次只作本機 Commit，未 Push。

## 1. Git 現狀同 386 項變更分析

- 專案分支為 `main`，追蹤 `origin/main`；有 2 筆提交及 465 個已追蹤檔案，並已配置 GitHub remote `origin`。
- 本地 Git 無法判斷 GitHub 儲存庫目前是 Private 還是 Public。未由 Joe 在 GitHub 網站確認為 Private 前，不應推送。
- 一般 `git status --porcelain` 有 386 個狀態項目：346 個含刪除狀態、8 個修改及 32 個未追蹤項目。未追蹤目錄可能合併顯示，因此下表是狀態項目數，並非每個目錄內的檔案總數。
- 346 個含刪除狀態由 344 個 `D` 及 2 個 `AD` 組成；`AD` 表示 index 曾標記新增、工作目錄目前為刪除。8 個 `M` 為修改；32 個 `??` 為未追蹤項目。

| 類別 | D | AD | M | ?? | 影響摘要 |
|---|---:|---:|---:|---:|---|
| Skills／GitHub 設定（`.agents`、`.github`） | 336 | 0 | 6 | 11 | 大量 Skills 刪除，另有修改及未追蹤內容 |
| `docs` | 5 | 2 | 1 | 12 | 包含一般文件及報告；不能把整個目錄視為已審核 |
| `reference` | 0 | 0 | 0 | 4 | 未追蹤參考資料 |
| `scripts` | 0 | 0 | 0 | 3 | 未追蹤腳本，推送前仍須逐份覆核 |
| 根目錄設定（`.gitignore`、`.env.example`） | 0 | 0 | 0 | 2 | 兩者目前均未追蹤；本次只更新 `.gitignore` |
| 其他根目錄項目（包括 `README.md`） | 3 | 0 | 1 | 0 | `README.md` 有修改；另有 3 個根目錄檔案處於刪除狀態 |
| **合計** | **344** | **2** | **8** | **32** | **386 個狀態項目** |

`skills-lock.json` 為已追蹤且目前沒有狀態變更。上述分類按 Git 狀態路徑的頂層類別統計。

若把全部工作目錄變更以 `git add -A` 整理、提交並推送，遠端將反映 346 個含刪除狀態（包括 336 個 Skills／GitHub 設定項目、5 個 docs 項目、3 個其他根目錄項目及 2 個 `AD` 項目）的刪除，並發布 8 個修改及加入 32 個未追蹤狀態項目。兩個 `AD` 項目會依當時工作目錄狀態重新整理；若以 `git add -A` 同步，可能成為刪除。單獨執行 `git push` 不會傳送尚未提交的工作目錄變更；以上是整批 stage、commit 後推送的風險推演。本次不會執行任何 Git 寫入或推送命令。

不應整批推送：此舉可能移除大量 Skills，並同時納入未審核的 docs、參考資料、腳本、設定及刪除狀態。現有 README 有修改，`.gitignore` 與 `.env.example` 亦未追蹤；須逐項選取及確認。

## 2. `.gitignore` 新舊對比

現有 `.gitignore` 已包含 Python／Node 暫存檔、`.env` 及 `.env.*`（保留 `.env.example`、`.env.docker.example`）、部分日誌及備份規則。本次保留全部既有規則，不重寫或移除任何例外。

| 現有規則 | 核准後新增規則 |
|---|---|
| `__pycache__/`、`*.pyc`、`node_modules/` | `*.pem`、`*.key`、`*.p12`、`*.pfx` |
| `.env`、`.env.*`、`!.env.example`、`!.env.docker.example` | `id_rsa*`、`id_ed25519*` |
| `npm-debug.log*`、`docs/obsidian/dt.log`、`dt.log`、`public/*.acl-backup`、`run-backup.bat` | `/docs/evidence/**` |
| 保留既有所有其他規則 | `**/personal-data/**`、`**/private-data/**`、`**/*-personal-data.*` |

新規則用於排除原始 evidence、常見私鑰／金鑰檔及明確標記的個人資料路徑。`.gitignore` 不會自動停止追蹤已追蹤檔案；本次不會使用任何取消追蹤或 staging 命令。`.gitignore` 在檢查前已是未追蹤檔案，本次只按批准更新其內容。

## 3. 建議推／唔推清單

以下「建議推」均須先完成內容覆核、確認沒有敏感資料，並由 Joe 選取及確認；不代表本次會 stage 或推送。

### 建議推（逐項確認後）

| 檔案／範圍 | 推送條件 |
|---|---|
| `README.md` | 目前有修改；先檢視差異並由 Joe 確認內容 |
| 一般 `docs` 文件及報告（不包括 `docs/evidence/**`） | 只選已清理項目；先覆核本計劃及清理檢查報告列出的敏感類型／行號 |
| `scripts` 中的必要腳本 | 清理掃描未發現疑似憑證、序號或網絡位址；仍須人工檢查執行目標及環境設定 |
| `skills-lock.json` | 目前乾淨且掃描未發現敏感模式；由 Joe 確認是預期要推送的依賴鎖定檔 |
| `.env.example` | 僅確認全為範例值、不含真實憑證後才可選取 |

### 建議唔推

| 檔案／範圍 | 原因 |
|---|---|
| `docs/evidence/**` 原圖 | 可能包含路由器、Tailnet、裝置或個人識別資訊；本次不檢視圖片 |
| `reference/photo/**` | 未檢視圖片內容，無法排除個人影像或其他權利／隱私風險 |
| `.env`、真實憑證、私鑰及金鑰檔 | 不得推送；目前只發現 `.env.example`，不代表日後可推送真實設定 |
| `.agents/**`、`.github/**` 中的 Skills | 本次一律不列入建議推送；即使狀態中有大量刪除，也不得整批同步 |
| 尚未確認的電郵格式字串行 | 先確認是否為示例資料；以下僅列路徑、類型及行號，不列內容 |
| 本計劃或清理檢查報告列出的其他敏感類型行 | 在完成判定及 Joe 確認前不推送 |
| 未篩選的 386 項變更 | 包含大量 Skills 刪除及未審核新增、修改；不得批次推送 |

未確認電郵格式字串行：

| 檔案路徑 | 類型 | 行號 |
|---|---|---|
| `.agents/skills/pr-review-expert/SKILL.md` | 電郵格式字串，是否為示例未確定 | 258、273 |
| `.agents/skills-cold/database-designer/references/database-design-reference.md` | 示例／測試電郵格式字串 | 175、385 |
| `.agents/skills-cold/database-designer/references/index_strategy_patterns.md` | 示例／測試電郵格式字串 | 306 |
| `.agents/skills-cold/database-schema-designer/SKILL.md` | 電郵格式字串，是否為示例未確定 | 144 |
| `.agents/skills-cold/migration-architect/expected_outputs/rollback_runbook.json` | 電郵格式字串，是否為示例未確定 | 545–546、552–553、559–560、566–567、573–574 |
| `.agents/skills-cold/migration-architect/expected_outputs/rollback_runbook.txt` | 電郵格式字串，是否為示例未確定 | 11–12、16–17、21–22、26–27、31–32 |
| `.agents/skills-cold/sql-database-assistant/references/optimization_guide.md` | 示例／測試電郵格式字串 | 158 |
| `.agents/skills-cold/sql-database-assistant/references/orm_patterns.md` | 示例／測試電郵格式字串 | 228 |
| `.github/skills/pr-review-expert/SKILL.md` | 電郵格式字串，是否為示例未確定 | 258、273 |
| `.github/skills-cold/database-designer/references/database-design-reference.md` | 示例／測試電郵格式字串 | 175、385 |
| `.github/skills-cold/database-designer/references/index_strategy_patterns.md` | 示例／測試電郵格式字串 | 306 |
| `.github/skills-cold/database-schema-designer/SKILL.md` | 電郵格式字串，是否為示例未確定 | 144 |
| `.github/skills-cold/migration-architect/expected_outputs/rollback_runbook.json` | 電郵格式字串，是否為示例未確定 | 545–546、552–553、559–560、566–567、573–574 |
| `.github/skills-cold/migration-architect/expected_outputs/rollback_runbook.txt` | 電郵格式字串，是否為示例未確定 | 11–12、16–17、21–22、26–27、31–32 |
| `.github/skills-cold/sql-database-assistant/references/optimization_guide.md` | 示例／測試電郵格式字串 | 158 |
| `.github/skills-cold/sql-database-assistant/references/orm_patterns.md` | 示例／測試電郵格式字串 | 228 |

其他應先覆核的類型與行號，以 `GitHub-Cleanup-Check-2026-11-15.md` 第 2 節為準；該節沒有記錄敏感原文。

## 4. 推送前 Joe 要做嘅檢查

1. 到 GitHub 網站開啟 `origin` 對應的倉庫，查看倉庫設定／頁面所示的可見度。
2. 在 Joe 明確確認該倉庫為 **Private** 前，不要推送。若倉庫顯示 Public 或無法確認，停止推送並先決定是否改為 Private。
3. 逐項檢查欲推送檔案及其差異；排除本計劃所列的 Skills、evidence 原圖、相片、真實憑證及未確認行。
4. 確認 `.env.example` 不含真實值；不要把 `.env` 或金鑰檔加入推送選擇。
5. 確認只選取 Joe 已清理及批准的檔案，不選取整個 386 項變更。

本地 `git remote -v` 只能確認 remote 設定，不能讀取 GitHub 儲存庫的 Private／Public 可見度。

## 5. 驗證未改動

以下為變更前基線 SHA-256；核准變更完成後逐一重算，六份 Gate 文件及四份 v1/v2 文件均與基線一致。所有受保護檔案均未修改。

六份 Gate 文件（變更後雜湊全數一致）：

| 檔案 | 變更前 SHA-256 |
|---|---|
| `docs/ARCHITECTURE.md` | `14C9D07DBDC677E1F40D973E3577F5AFE5BE2B90ACE9FFFBDA10CAB7BFEB6224` |
| `docs/DECISIONS.md` | `3F9DD3A8EAAA206FB4E1B20AE8E06F0E3990B6A5E37831230836333115642055` |
| `docs/M0-READY.md` | `0A458EF0306F96B9BA4DD00770C9E3A0BCD42E575701134CC2C951698C7EBEED` |
| `docs/REQUIREMENTS.md` | `FF4011CD22B83E8E84E414DEEE3E8F2FA0DCE3D52190130E3DBC0D6BB54195B8` |
| `docs/RISKS.md` | `12E47E093CFBEF033E436274CB18ABEE965DAFFD17A4933F5AA9D8A4B30676A9` |
| `docs/TEST-PLAN.md` | `BD00363CE7E71C37B5B54E047F93CA700221EF1CC19921C83B5A88DF80EBDBCB` |

v1/v2 版本核對（涵蓋 PRD 及 Sir 摘要兩組版本；變更後雜湊全數一致）：

| 檔案 | 變更前 SHA-256 |
|---|---|
| `docs/archive/TimeMem-PRD-V10-1.md` | `09FDDE9E2B06CEAB12ABE7C5CB4B69F5B4163FBD179D050139126A6747DA92C5` |
| `docs/prd/TimeMem-PRD-V10-2.md` | `E27A7D4540C61FE01C8B4EDAB6B986E8C31C9A25D13B240A0FCBB5E02D3AA190` |
| `docs/reports/TimeMem-Summary-For-Sir.md` | `F9B92FF33C18577C3F91772A2C97006A5BAEDCCE6F914AEA4E8AB16A61C1CF75` |
| `docs/reports/TimeMem-Summary-for-Sir-v2.md` | `4AB6042FC3C88214CB7357FEFD9A9A61F082A4958126B13700A4799E713438C5` |

`docs/evidence` 變更前有 12 個檔案；變更後數量、相對路徑清單 SHA-256（`85DC9719D1A1F816ACBF0A4245093B52A832D56C2E451CDD572B78B935FCCE23`）及按路徑與檔案 SHA-256 組成的位元組摘要（`98A969AE5B21398F5570C89ED712312E9FD9994F4D6DD7B06A9023A421BEEBE9`）均相同。這 12 個檔案均未追蹤，現在因已批准的 `.gitignore` 規則而被忽略；沒有開啟圖片或修改 evidence 檔案。

變更前 `git status --porcelain --untracked-files=all` 共 749 個狀態列，摘要為 `D286B07EDDA40546E49CCA341677B85E75789277C6B54E3E5E6B8ECD55EC8427`；一般 porcelain 為 386 項。變更後完整清單為 738 項：其中 12 項 evidence 因新 ignore 規則不再列作未追蹤，並新增本報告一項。移除本報告狀態列並還原 12 項 evidence 原有的未追蹤狀態後，正規化清單共 749 項且 SHA-256 與基線完全一致。除核准更新的 `.gitignore`、本報告及上述預期 ignore 顯示差異外，狀態沒有其他變更。新規則未匹配到現有金鑰副檔名或明確標記的個人資料路徑。沒有執行 add、stage、commit 或 push。

## 6. 俾 Joe 決定嘅三個問題

1. `origin` 對應的 GitHub 倉庫目前是 **Private** 還是 **Public**？請以 GitHub 網站確認。
2. 是否確認完全不推送 `docs/evidence/**` 原圖？
3. 是否確認本次已批准的 `.gitignore` 更新內容？

**M0 仍為 Draft / NOT APPROVED。本文件是推送計劃，不等於 M0 已批准，批准權只在 Joe 手上。**
