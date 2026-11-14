# TODO — 未完成事項

> 以下只列未完成工作。原有 Family Calendar System MVP + AI Co-Pilot 清單中的已完成項目已移至 [PROGRESS.md](PROGRESS.md)；該清單的雲端／舊架構工作須先對照現行 PRD V10.2（V10.1 已移至 `docs/archive/TimeMem-PRD-V10-1.md`），不能直接視為已批准的 TimeMem 方向。

## TimeMem gate 與後續工作

> CR-002 / D-023 已決定 M0 範圍：五項 PRD setup 加 Tailnet 遠端驗證及 PWA app shell。
- [ ] 完成六份 gate 文件 consistency review、Skill 實測及獨立 review；依 [M0-READY.md](../M0-READY.md) 記錄 findings，Joe 未批准前不寫產品 code／migration／DB。
- [ ] M0 批准後，DEVELOP 第一步啟用 `M0 Gate` required check 及 Owner review；不得列為 M0 批准前置條件。
- [ ] M0 批准後按 [TimeMem-Install-SOP-Lock-Version.md](TimeMem-Install-SOP-Lock-Version.md) 及 [TimeMem-Home-Hub-Physical-Setup.md](TimeMem-Home-Hub-Physical-Setup.md) 設定 JOE-SERVER；設備仍未 SETUP／READY，`D:\docker-data\timemem` 不入 Git。
- [ ] 按已批准的 scope，在 Requirements／reviews 就緒及 M0 批准後，驗收 REQ-001 至 REQ-007；所有結果及證據記入 M0-READY。
- [ ] 決定並記錄支援手機／OS／browser matrix；在 scope approval 前不當成 M0 acceptance。

### 待決定

- [ ] 依 D-015 至 D-022 草案逐項取得 Joe 決定；未批准前不作架構或產品行為依據。
- [ ] 依 D-023 更新六份 gate 文件後，重跑雙重 review；M0 仍須另行批准。

## 原有 Family Calendar System MVP + AI Co-Pilot 待辦

### 階段一：地基與數據鏈路

- [ ] Task 1.2：只用虛構測試資料測試 OpenRouter API 免費模型；Service／測試腳本已建立，live test 待免費供應商恢復（曾回 429／逾時）。不得傳送真實家庭隱私。

### 階段二：輸入層與 RAG 記憶庫

- [ ] Task 2.1：以 authenticated 測試帳戶完成 Supabase 實際寫入驗證；不使用 service role 代替。
- [ ] Task 2.2：自行設定 Telegram 測試 bot、webhook secret 及 test chat ID，完成 live webhook 驗證；不得使用真實家庭內容。
- [ ] Task 2.3：提供並驗證相容的本機 bge-small-zh-v1.5 權重；目前只有 placeholder 可用，搜尋結果只供虛構測試資料原型使用。
- [ ] `family-memory-encryption` 後續工作：補上 key rotation、使用者解鎖及加密 family-memory/RAG 搜尋；部署前安全備份 key。key 遺失會令資料無法解密；真實資料仍禁止使用。
- [ ] Task 2.4：Cloud migration dry-run 尚未執行；此工作區未 link Supabase CLI project，亦未配置 Cloud database password，沒有對 Cloud 套用 migrations。

### 自託管 Supabase 部署

- [ ] 完成 OneDrive 解綁、HTTPS reverse proxy 及備份／還原設定後，才可投入正式使用。
- [ ] 將已建立的 JOE-SERVER 部署配置實際部署到 JOE-SERVER D:。

### Markdown 文件治理

- [ ] 核對 `PRODUCTION-README-FINAL-20261030.md` 與 `FINAL-PROD-AUDIT-20261030.md` 的不同狀態／審計內容是否已整份被後續運維文件取代；如需正式 `Superseded by` 標記，先逐項核對重疊聲明，勿把歷史報告當現況。
- [ ] OAuth 設定只核實到 2026-10-31 的唯讀診斷；後續報告仍記錄缺少 secret，沒有修正證據。不得標記為已修復或推斷目前設定。
- [ ] 修正 `docs/obsidian/SERVER-ONLINE-SUCCESS-20261031.md` 指向 `supabase/CLOUD-MIGRATION-FIX.sql` 的既有錯誤相對連結；該檔不在原本九個目標內，先確認可安全寫入，不可繞過權限。
- [ ] 如需確認 Git refs、Cloud、部署、資料庫或網絡現況，另行安排獲授權的唯讀檢查；本輪歷史記錄沒有執行相關驗證。
