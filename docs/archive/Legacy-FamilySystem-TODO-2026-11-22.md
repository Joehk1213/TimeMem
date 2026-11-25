# Legacy FamilySystem backlog — archived 2026-11-22

此檔只保存從 `docs/TODO.md` 移出嘅舊 FamilySystem／Cloud／Supabase backlog，避免污染現行 TimeMem TODO。內容不得自動視為 TimeMem 已批准工作。

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

- [ ] 核對 `PRODUCTION-README-FINAL-20261030.md` 與 `FINAL-PROD-AUDIT-20261030.md` 的不同狀態／審計內容是否已整份被後續運維文件取代；如需正式 `Superseded by` 標記，先逐項核對重疊聲明。
- [ ] OAuth 設定只核實到 2026-10-31 的唯讀診斷；後續報告仍記錄缺少 secret，沒有修正證據。
- [ ] 修正舊 Obsidian server report 的 broken relative link；先確認可安全寫入，不可繞過權限。
- [ ] 如需確認舊 Git refs、Cloud、部署、資料庫或網絡現況，另行安排獲授權的唯讀檢查。
