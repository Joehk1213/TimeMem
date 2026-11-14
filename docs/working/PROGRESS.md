# PROGRESS — 已完成事項

## TimeMem 文件與規劃

- 2026-11-05 首次建立本進度文件。
- PROMPT 1：README Review 完成，結果 PASS，檢查 11 項。
- 舊 Phase 1 Implementation Plan 僅完成規劃，現已封存為 obsolete 歷史文件；不得視為已批准範圍或已實作功能。
- STEP 4：建立 `.github/copilot-instructions.md`。
- 四份基礎文件細執完成。
- GitHub 第一次 Push 次序已決定：先 Review 四份基礎文件，再 Push；不一開波就 Sync。
- 開工前 scaffold 文件整理完成：Root README 作為入口、`docs/README.md` 保留九份文件索引、正式決策位置記錄於 `docs/DECISIONS.md`。
- 建立 `.env.example`，只列變數名稱及用途註解，沒有真密碼或 API key。
- 確認 `.gitignore` 有 `__pycache__/` 及 `*.pyc` 規則；清除過往的 Python cache 資料夾，保留 `.py` 原始碼。

## 既有 Family Calendar System MVP + AI Co-Pilot 完成紀錄

以下保留原 TODO 已標記完成的事項；仍未完成的驗證及後續工作已移至 `docs\TODO.md`。

### 階段一：地基與數據鏈路

- 已設定專案規範 `.github/copilot-instructions.md` 與 Supabase Key。
- Task 1.1：已測試 Supabase DB 連線與 Schema 讀取（`source/DB_SCHEMA_DRAFT.sql`）。

### 階段二：輸入層與 RAG 記憶庫

- Task 2.1：已串接 Chat-First 本機規則解析及 Supabase records/RLS 寫入；parser 與請求路徑已檢查。
- Task 2.2：已建立 development-only Telegram Bot Webhook 虛構資料預覽與確認流程，只接受固定測試句、不寫 Supabase。
- Task 2.3：已加入 Family Memory/RAG、家庭提醒及引用；新增獨立 migrations、同家庭 active-member RLS、`/chat` 及 `/today` 總覽。模型載入只在本機嘗試；無權重或維度不符時記錄 `using placeholder`，並回退至 384D normalized feature-hash，不能視為真實權重已載入。
  - 已完成 Reminder API、同家庭資料隔離、source memory 家庭範圍檢查及 cosine/L2/inner-product 搜尋。
  - `family-file-ingestion-bge-housekeeper`：已支援本機 `.txt`／`.md` 以 1,000 字元、200 overlap 分段後經登入 API 入庫；未安裝權重時保留 placeholder 並明確記錄；加入每 15 分鐘、只記 log 的提醒 scheduler。
  - `family-pdf-local-and-today-citations`：已使用本機 vendored PDF.js 擷取 PDF 內嵌文字（不做 OCR、不上載原檔），沿用 1,000/200 分段；`/today` 顯示近期記憶來源及日期、管家提醒排序／剩餘時間／來源引用與完成切換。
  - `family-bge-real-try`：已實作只在本機模型目錄有 `config.json` 時載入 Transformers.js，使用 `local_files_only` 並停用遠端模型；缺少目錄／設定、載入或推論失敗時明確記錄 placeholder。
  - 已完成私人 record body 加密：pgcrypto 加密 `visibility='private'` 記錄的 `content`；DB trigger 拒絕 authenticated plaintext 寫入，API 經原用戶 JWT/RLS 讀取後才解密。標題及其他 metadata 仍是明文；已用虛構資料驗證 round-trip，未使用真實資料。
- Task 2.4：已加入本機多代理記憶查詢流程，包括安全檢查及 `security_logs`、同家庭 RAG librarian、無外網 analyst、引用 editor 及 orchestrator；`/api/memories/search` 要求登入並回傳安全狀態、引用及 metadata；`/chat` 顯示安全 badge、回答及 MEMORY 引用。`source/DB_SCHEMA_DRAFT.sql` 未修改。
  - `family-4agent-loop`：已按 Security → Librarian → Analyst → Editor 次序落地 Node 防幻覺流程；以 `family_members.profile_id/status='active'` 驗證同家庭權限，強制 cosine 門檻、引用檢查及安全事件記錄。
  - Local disposable 驗證：RLS 15/15、approval 3/3、family memories 10/10、reminders 5/5、agents 3/3；未登入搜尋 401，injection log 寫入後已清理。
  - Cloud Supabase Auth health endpoint 回 200；只送 anon key，沒有送出用戶資料。

### 階段三：時間軸與前端呈現

- Task 3.1：已實作 FR005 未來 7 天 Calendar View，active plan 按本地日期分組並依 event_start 排序，沿用 RLS 可見記錄；加入日曆、提醒及最近 5 條家庭記憶總覽。
- Task 3.2：已整合 Chat-First 輸入匣 UI 與互動，包括本機解析、預覽確認、JWT 寫入及成功後刷新記錄檢視。

### 自託管 Supabase 部署

- 已建立 JOE-SERVER Docker Compose stack 配置，原定持久化資料路徑為 `D:\docker-data\family-system`。
- 已在本機 disposable Docker stack 套用現有 migrations（包括 Stage 3 RLS/Storage policies）。
- 本機 `@family-calendar.test` seed、15/15 RLS、3 項 approval 測試已通過。
- 已新增 JOE-SERVER 離線部署指南及支援 C:/D: `FAMILY_DATA_ROOT` 的 image exporter。

### Markdown 文件治理（2026-11-01）

- 已以 `.github/copilot-instructions.md` 作為 LLM 指引主入口，以 `docs/obsidian/FamilySystem-Story.md` 作為人讀故事入口；沿用既有文件，未另建重複主題檔。
- 已在 `docs/obsidian/README.md` 加入故事入口，保留原有 Obsidian 同步說明。
- 已核對本輪指定的歷史報告；只為有日期／後續證據的狀態快照加入範圍清楚的歷史提示，並保留原文。

### TimeMem 正式決策與 M0 Gate（2026-11-11）

- Joe accepted 三項正式決策：M0 approval + CI Gate；PWA modular monolith 與唯一 DB 存取模組；JOE-SERVER Primary、Tailscale tailnet、順暢版及三級信心輸入層。完整內容以 `docs/DECISIONS.md` 為準。
- 已更新 `docs/ARCHITECTURE.md`、`docs/M0-READY.md`，並加入 `scripts/check-m0-gate.ps1` 及 `.github/workflows/Check-M0-Gate.yml`。
- Repo skills source/mirror 檢查、Repo 文件檢查及 diff whitespace 檢查 PASS；GitHub branch protection 的 required check 仍待 Repo 管理者設定，產品／設備 M0 驗收未宣稱完成。
