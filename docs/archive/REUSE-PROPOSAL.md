> 已被 `docs/DECISIONS.md` 2026-11-11 取代，入面嘅 TBD 已於 2026-11-11 拍板，唔好當最新規格。呢份只係歷史審核提案。

# FamilySystem 舊 Repo 重用審核提案

> 日期：2026-11-11
> 狀態：審核提案，未批准實作
> 舊 Repo：`C:\Project\old\Family\FamilySystem`（只讀）
> 現行依據：[DECISIONS.md](../DECISIONS.md)、[ARCHITECTURE.md](../ARCHITECTURE.md)、[M0-READY.md](../M0-READY.md)

## 1. 範圍、決策及結論

此審核按 TimeMem 現行正式文件和 Joe 已拍板決定進行，不重新決定：

- **M0 Gate：** approval 流程及 CI Gate；M0 未批核前不實作產品程式碼。
- **modular monolith：** PWA、API、資料存取、Ollama AI、備份、認證；只有資料存取模組可連本機 PostgreSQL。
- **唯一 Primary 及使用方式：** JOE-SERVER 是唯一可寫 Primary，走 Tailscale tailnet，不開 router port、不提供公網入口；PWA 順暢版和首頁輸入層的三級信心處理按已決策內容執行。

**總結：舊 Repo 沒有一個可原封不動移入 TimeMem 的產品模組、資料庫 migration 或部署 stack。** 舊實作以 Supabase Auth/Postgres/Storage、舊雙機配置及舊模型為中心，與本地 PostgreSQL、Ollama、資料存取模組唯一連 DB、單一可寫 Primary 等決定不相容。可保留的是經 Joe 確認仍適用的資料領域概念、安全測試思路和運維檢查清單；程式碼及 migration 均須重寫／重新驗證，不得直接複製。

下文分類說明：

- **可直接重用：** 原內容不需改造即可作為 TimeMem 規格／程序；不代表批准複製程式碼。
- **要改先用得：** 僅可作參考，必須按 TimeMem 的本機架構、安全邊界或需求改寫。
- **唔用得：** 舊依賴、實作、資料或部署做法與已拍板決定衝突，或舊證據不足以支撐新用途。

## 2. 審核邊界與可信度

- 開始前只作檔名檢查，舊 Repo 沒有發現真實秘密設定檔；不曾開啟或搜尋真實秘密設定檔，不列任何憑證／變數名稱或值。
- 沒有讀取 Git history、Vault 或任何秘密備份；沒有跑資料庫、Docker、migration、seed 或舊 Repo 測試。
- `docs/obsidian/` 是舊 Repo 內的歷史文件目錄；沒有修改 Vault。其部署、DB、模型和測試結果均只視為有日期的文件聲明，未獨立重驗，不當作 TimeMem 現況。
- `README.md` 將初始 schema 稱為未驗證草稿；其他較後的部署／驗證報告記錄了不同環境、版本、模型維度及加密狀態。這些差異證明不能把歷史報告的 PASS 或「已部署」直接當成可移植證據。
- `Architecture.jfif`、`Structure.jfif` 只屬舊圖，不作現行架構或目錄結構依據。

## 3. 舊 Repo 盤點

### 3.1 Root 檔案

| 路徑 | 舊用途 | 對 TimeMem 的意義 |
|---|---|---|
| `README.md` | 舊 Family Calendar 的閱讀次序、假資料規則、Supabase 初始化／RLS／記憶功能操作說明。明確指出初始 schema 未驗證。 | 可作舊系統總覽；其中 Supabase 操作步驟、測試憑證流程和外部服務設定不移植。 |
| `PROGRESS-FAMILY.md` | 舊專案階段進度、未完成測試、模型 placeholder、部署與文件治理狀態。 | 歷史狀態；不可當 TimeMem 功能已完成或現況驗收證據。 |
| `TODO.md` | 舊 Family Calendar／RAG 的工作清單；包含仍未驗證的模型、資料庫及部署事項。 | 只供審核舊未竟項目；不併入 TimeMem TODO。 |
| `ERROR_LOG.md` | 記錄舊模型上游不穩、解析容錯與修正測試。 | 可參考「錯誤要可見、用假資料驗證」原則；外部模型故障處理不可作新架構。 |
| `package.json`、`package-lock.json` | 舊 Node/Express/Supabase/Transformers.js/PDF.js 依賴及舊測試命令。 | 不沿用依賴鎖檔；只供辨認舊 runtime 和測試範圍。 |
| `requirements.txt` | Python embedding worker 的套件需求。 | 不直接帶入；TimeMem 的 AI 邊界已決定使用本機 Ollama。 |
| `docker-compose.prod.yml` | 舊 Supabase Postgres、Auth、PostgREST、Storage、Caddy gateway 等容器及 bind mount。 | 不重用 stack；服務拆分、資料路徑及 port 綁定都屬舊系統。 |
| `.env.example`、`.env.docker.example` | 舊系統的空白設定範本。 | 本輪不列其中任何設定名稱；其內容不能決定 TimeMem 設定方案。 |

### 3.2 `docs/` 文件

根目錄九份文件：

| 路徑 | 主要內容 |
|---|---|
| `docs/CLOUD-FIX-STEPS.md` | 舊雲端資料庫欄位修復程序；不作 TimeMem migration。 |
| `docs/DUAL_NB_SETUP.md` | 舊雙 Notebook 的 Primary／Recovery 操作、tailnet、加密備份及空庫還原；其 Primary 角色和 OneDrive 備份拓撲不同於 TimeMem。 |
| `docs/FAMILY_USER_GUIDE.md` | 舊登入角色、頁面、私人記錄、附件限制和行程修改流程。 |
| `docs/GOVERNANCE-CONSOLIDATED-20261101.md` | 舊文件重複、歷史狀態衝突及治理範圍；特別提醒不要把歷史報告當現況。 |
| `docs/JOE-SERVER-DEPLOY-FINAL.md` | 舊 server 部署狀態快照；文件本身明言未在該工作站獨立重跑。 |
| `docs/JOE-SERVER-DEPLOY.md` | 舊 Docker image 離線匯出／匯入、假資料驗證和 server 部署程序。 |
| `docs/JOE-SERVER-REAL-RAG.md` | 舊本機 BGE 權重、384／512 維向量、資料路徑和部署驗證報告。 |
| `docs/SUPABASE-SELFHOST.md` | 舊自託管 Supabase、migration、RLS、備份和維護操作。 |
| `docs/WIFI_AUTORECONNECT.md` | 舊 Windows Wi‑Fi、排程器及服務啟動維護程序；非 TimeMem 產品功能。 |

`docs/obsidian/` 有 33 份歷史／運維文件，按用途盤點如下（每個列出的文件均在掃描範圍內）：

- **API／schema／來源：** `API-MAP-20261030.md` 描述舊 HTTP 路由；`ER-DIAGRAM-20261030.md` 是舊資料庫 catalog 圖；`SOURCE-AUTOPSY-20261030.md` 是舊程式碼盤點。
- **備份／復原／故障：** `BACKUP-FORENSICS-20261030.md`、`DISASTER-RECOVERY-20261030.md`、`CHAOS-ENGINEERING-20261030.md`、`WAKEUP-CHECKLIST-20261030.md` 分別記錄舊備份、災難復原、情境演練及開機檢查；均不能證明目前可還原。
- **部署／生產狀態快照：** `PROD-MAP-20261030.md`、`PRODUCTION-README.md`、`PRODUCTION-README-FINAL-20261030.md`、`FINAL-PROD-AUDIT-20261030.md`、`NIGHT-SHIFT-SUMMARY-20261030.md`、`PJ2-CHECK-20261101.md` 記錄不同時點的舊環境／稽核狀態，彼此不能合併成現況。
- **登入／gateway／網絡修正：** `GOOGLE-OAUTH-FIX-20261031.md`、`OAUTH-8000-DIAG-20261031.md`、`GATEWAY-8000-FIX-20261031.md`、`CORS-FIX-20261031.md` 記錄舊 OAuth、gateway port 及 CORS 修正；不構成 TimeMem Passkey 或 tailnet proxy 規格。
- **資料同步／上線／更新紀錄：** `SERVER-DT-SYNC-FIX-20261031.md`、`SERVER-GIT-FORENSICS-20261031.md`、`SERVER-GIT-SYNC-20261031.md`、`SERVER-ONLINE-PREFLIGHT-20261031.md`、`SERVER-ONLINE-SUCCESS-20261031.md`、`SERVER-PUSH-20261031.md`、`SERVER-SYNC-FRONTEND-20261031.md`、`STASH-REVIEW-SERVER-20261031.md` 是舊工作站同步、部署及更新時點記錄，不是產品升級政策。
- **模型／路線圖／安全：** `ROADMAP-v1.1-20261030.md` 是舊提案；`SECURITY-HARDENING-20261030.md`、`RED-TEAM-REPORT-20261030.md` 記錄舊安全議題；只可作待檢查風險清單。
- **故障診斷：** `CLOUD-MIGRATION-SUCCESS-20261031.md`、`LOADING-LOOP-DIAG-20261031.md` 記錄雲端遷移與載入問題；只代表文件當時聲明。
- **文件／工作方式／背景：** `FamilySystem-Story.md` 是舊產品故事；`README.md` 說明 Obsidian 同步；`WORKFLOW-DT-LIVING-WALL.md` 是舊工作流。以上不是 TimeMem 正式規格。

### 3.3 `server/`

| 路徑 | 舊用途 | 新模組對照／限制 |
|---|---|---|
| `server/index.js` | Express 啟動、CORS、路由註冊、靜態頁面及提醒 scheduler 啟動。 | API 模組參考；內含舊 Supabase/CORS 與 scheduler 初始化，不可直接搬用。 |
| `server/routes/records.js` | 記錄 CRUD、身份／角色檢查、附件上下載與刪除。 | API 行為參考；目前由路由直接使用 Supabase client，違反 TimeMem「DB 只經資料存取模組」。 |
| `server/routes/memories.js` | 記憶匯入、搜尋及查詢 API。 | AI/API 流程參考，不沿用舊資料或儲存模型。 |
| `server/routes/reminders.js` | 提醒列表、新增、完成狀態 API。 | 可作提醒功能行為參考；改由 DAO 存取本機 DB。 |
| `server/routes/health.js`、`config.js` | 舊健康檢查及前端設定回應。 | 健康檢查概念可參考；舊前端設定服務與 TimeMem 不同。 |
| `server/routes/telegram.js`、`server/services/telegramScheduleParser.js` | development-only Telegram 固定測試句預覽及排程解析。 | 不納入 M0；與已決定的 PWA 首頁輸入層不同。 |
| `server/middleware/requireSupabaseUser.js` | 以舊認證服務驗證登入 token，建立帶使用者身份的 DB API client。 | 認證模組只能借鑑「每請求驗證身份」原則；舊協定不可用於 Passkey/PIN。 |
| `server/middleware/apiErrorHandler.js` | 舊 API 共用錯誤回應。 | 可參考集中錯誤處理；新的 API contract 尚未決定。 |
| `server/jobs/reminderScheduler.js` | 定時找近期提醒，只記錄本機 log。 | 不等於手機通知；舊 scheduler 使用管理權限直連舊 DB，須重寫並經 DAO。 |
| `server/services/openrouterService.js` | 呼叫舊外部模型服務。 | **唔用得**；違反 Ollama 本機推理及不使用外部 LLM 的決定。 |

### 3.4 `source/`

| 路徑 | 舊用途 | 新模組對照／限制 |
|---|---|---|
| `source/PRD_MVP.md` | 舊家庭日曆需求、角色、計劃／經歷和七日視圖。 | 只可抽取仍符合 TimeMem 的 domain invariants；不可用舊家庭角色取代 TimeMem 權限。 |
| `source/DB_DESIGN.md` | 舊 ERD、角色授權、RLS、版本控制和附件設計；明列待決／測試。 | 資料存取模組的需求檢查表，不是 TimeMem schema。 |
| `source/DB_SCHEMA_DRAFT.sql` | 舊 Supabase schema DDL，明確標為未驗證草稿，包含 Supabase Auth、Storage 等依賴。 | **不可作 migration 起點**；須按本機 PostgreSQL 及 DAO 邊界重新設計。 |
| `source/BUILD_PLAN.md` | 舊分階段建造順序。 | 可參考「每階段設驗收」方式，不照搬產品步驟。 |
| `source/CONVENTIONS.md` | 舊 Express/Supabase/API 格式和前端慣例。 | 只有錯誤處理、輸入檢查等通用原則可參考；舊技術及直接 DB client 用法不適用。 |
| `source/REFERENCES.md` | 舊 tutorial 的多服務、雲端及外部模型模式。 | **不得採用其 Cloud、Supabase、OpenRouter 或外部 AI 架構。** |
| `source/REPLANNING-MVP1.md` | 舊 DB、登入、部署和 RLS 再規劃。 | 舊決定與 TimeMem 不同，不當作新規格。 |
| `source/agents/{analystAgent,editorAgent,librarianAgent,orchestrator,securityAgent}.js` | 舊記憶檢索／回答的多代理流程。 | AI 模組可參考責任分工；須改成 Ollama、本機資料流程，AI 不得直寫 DB。 |
| `source/rag/embed.js`、`source/rag/search.js` | 本機 Transformers.js BGE 與 placeholder 向量搜尋。 | **不直接重用**；模型、維度、依賴及搜尋介面不等於 Ollama/bge-m3。舊相似度不是信心值。 |
| `source/security/encryption.js` | 舊記錄內容加密 helper。 | 不視為已批准的 TimeMem 金鑰、解鎖或備份設計。 |

### 3.5 `public/`

- `public/index.html` 是靜態前台入口；`public/app.js` 是大型前端主程式；`public/mvp-pages.js`、`public/recurring-schedule.mjs` 實作舊頁面、日曆及週課表解析；`public/styles.css`、`public/mvp-pages.css`、`public/styles/home.css` 是舊 UI 樣式。
- 主 app 沒有找到 PWA manifest／app service worker／Web Push 設定；搜尋到的 PDF worker 屬 PDF.js，不是 PWA worker。舊登入流程是舊系統帳戶登入，沒有找到 Passkey／PIN 實作。
- `public/vendor/pdfjs/` 是 vendored PDF.js、字型、CMap、WASM 及授權檔；舊用途是本機擷取 PDF 文字、不做 OCR、不上載 PDF 原件。不得複製 vendor 檔案；若 TimeMem 有需要，另行核對授權、大小及離線需求。
- `public/*.acl-backup` 是備份副本，不是現行來源；不要當作可移植的版本。
- 相片附件 API 以原始 request bytes 上載至舊私有 Storage，另存檔名／類型／大小 metadata；路徑用隨機物件 ID。未發現內容 hash／相片去重／原檔版本保存功能。刪除記錄會先刪附件物件，故舊行為不是不可變原檔保留方案。

### 3.6 `docker/`、Compose、`supabase/`、`scripts/`

| 位置／關鍵檔案 | 舊用途 | 審核結論 |
|---|---|---|
| `docker/Caddyfile` | Caddy 將舊 gateway 路徑轉送至舊 Auth/REST/Storage 服務；HTTP 配置不是 TimeMem tailnet HTTPS site proxy。 | 可參考 reverse-proxy 的 path routing 思路；須重新寫成綁定 Tailscale IP 的 tailnet-only proxy。舊設定不直接用。未找到 Nginx 設定。 |
| `docker-compose.prod.yml` | 舊 Supabase stack 與 gateway 的容器、健康檢查和資料掛載；含 loopback 及舊 LAN 綁定。 | **唔用得**；不是 TimeMem 本機 Postgres + Ollama modular monolith 的 deployment spec。 |
| `supabase/config.toml`、`supabase/CLOUD-MIGRATION-FIX.sql` | 舊 Supabase CLI 設定及特定遷移修正。 | 不複製、不連外、不執行。 |
| `supabase/migrations/`（19 份） | 初始 schema/RLS、權限修正、附件限制、提醒、Family Memory/vector、placeholder/BGE、加密等累積變更。 | Supabase Auth/RLS/Storage/extension 耦合且歷史上有修補；不可搬用或執行。只作了解舊資料欄位／風險的參考。 |
| `scripts/backup-encrypted.ps1` | 舊 Postgres dump／Storage 搬存的加密備份及僅空庫還原流程。 | 舊雙機／同步目錄流程不符合唯一 Primary；檔案與 DB 不是原子快照，亦不能決定 TimeMem 的格式、留存或 Keep 語義。 |
| `scripts/export-images.ps1` | 匯出舊容器 images 的部署工具，不是相片匯出工具。 | 不帶入產品備份模組。 |
| `scripts/init-family.sql` | 從舊 migration 組合的初始化 SQL。 | 不可手改、不可作 TimeMem schema；本輪沒有執行。 |
| `scripts/seed.js`、`scripts/set-docker-role-passwords.sql`、`scripts/generate-supabase-keys.js` | 舊假帳戶種子、舊 DB role 初始化及舊 Supabase 設定工具。 | 不移植到 TimeMem。 |
| `scripts/check-status.ps1`、`server-sync.ps1`、`dt-sync.ps1`、`clean-dt-log.ps1`、`fallback.ps1`、`fallback-clean.ps1` | 舊設備狀態、Git 同步、log 清理及回退工具。 | 僅屬舊機器運維，不是 TimeMem 更新政策；不可直接執行或移植。 |
| `scripts/rag/embed_worker.py` | 舊 Python embedding worker。 | 不帶入；取代為決定中的本機 Ollama AI 模組。 |

## 4. Remaining TBD 逐項對照

下表涵蓋 [ARCHITECTURE.md](../ARCHITECTURE.md) 的每類 Remaining TBD。**沒有一項完整 TBD 可單靠舊 Repo 直接清除**；舊資料最多提供候選做法或負面證據。信心門檻、唯一 Primary、PWA 方向和 AI/DB 模組界線是已決定事項，不應在此重新表決。

| Remaining TBD | 分類 | 舊證據及改造方式 | 衝突／Joe 尚要決定 |
|---|---|---|---|
| DB schema、migration | **要改先用得** | `source/DB_DESIGN.md` 的家庭／成員／記錄／關聯／附件概念可作領域清單；`DB_SCHEMA_DRAFT.sql` 和 Supabase migrations 不可用。重新以 TimeMem domain 設計本機 PostgreSQL schema、約束、交易、migration 規則；所有連線和 SQL 集中於資料存取模組。 | Joe 要拍板正式 entity/欄位、關聯與權限規則；不可把舊 Supabase RLS 或 Auth schema 當定案。 |
| D: 正式資料目錄／相片檔案配置 | **要改先用得** | 舊 `FAMILY_DATA_ROOT`、舊 `family-system` 目錄及容器 bind mount 只可顯示「DB 與檔案分開持久化」需求；新目錄必須重列 TimeMem DB、原檔、衍生圖及備份位置。 | JOE-SERVER／D: 的 TimeMem 根目錄方向已定；子目錄、ACL、容量及檔案命名規則仍要 Joe 決定。 |
| Ollama 權重來源、版本/digest、設定、資源及驗證 | **唔用得** | 舊 BGE/Transformers.js 本機 loader、384/512 維 column、placeholder 向量及其模型路徑都不是 Ollama 部署；重新按已拍板的 bge-m3、qwen3:8b 與 Ollama 制定本機拉取/匯入、固定版本、RAM/CPU、啟動和無網絡驗證。 | 本機 Ollama 方向及模型家族已定；具體 tag/digest、權重來源、磁碟與資源上限及模型缺失的行為仍由 Joe 決定。 |
| Embedding 接線及信心值校準 | **唔用得** | 舊 cosine 相似度／門檻是檢索排序，不是「能否自動寫 DB」的信心值；不得轉換或沿用。按已決定 >0.9 自動更新可 Undo、0.7–0.9 確認、<0.7 澄清，建立虛構測例、錯誤率和邊界測試；AI 只回候選，寫入仍經 DAO。 | 三級策略和數值已拍板，不再問；Joe 仍要決定校準資料集、可接受錯誤率、重新校準方式及驗收證據。 |
| Passkey/PIN credential、session 儲存／復原及家庭成員／兒童／私人記錄授權 | **唔用得** | 舊 Auth 是 Email/Google 帳戶加舊角色/RLS；沒有找到 Passkey/WebAuthn/PIN。按已決定的 Passkey/Face ID 主登入、PIN 後備、30 日記住裝置、遺失手機撤銷 session/Tailscale 裝置重建 TimeMem 認證模組。 | 主登入／後備、session 使用體驗已定；credential 儲存、撤銷／復原、兒童及私人記錄授權政策細節要 Joe 決定。 |
| MCP 是否啟用、transport、授權 | **唔用得** | 舊 REST API 和查詢 endpoint 不等於 MCP；沒有舊 MCP 模組可搬。若採用，須限定 read-only、經 API/DAO 授權，禁止直接連 DB。 | 是否啟用、transport、客戶端身份與每個工具的資料授權都要 Joe 新決定；可先選不納入 M0，但須在正式 TBD 明確處理。 |
| Caddy 或 Nginx、PWA 設備支援矩陣 | **要改先用得** | 舊 Caddyfile 是 Supabase gateway 路由；舊 Compose 有 loopback/LAN 綁定，並無 tailnet-only HTTPS website。需按 TimeMem app endpoint 重寫，綁定 Tailscale IP，驗證 HTTPS/MagicDNS、非 tailnet 無法連入及 LAN 離線情境；舊 Caddy 不能直接用。 | 不開 router port、tailnet-only、JOE-SERVER 唯一可寫均已定。Caddy/Nginx 最終選擇、手機/瀏覽器版本及 PWA capability matrix 仍要 Joe 決定。 |
| PWA framework、API contract、產品 source tree | **要改先用得** | 舊 `public/` 是靜態 HTML/JS/CSS；沒有 app manifest/service worker，不能直接視為 PWA。舊 Express routes 直接操作 Supabase，須重劃成 UI→API→DAO；可參考錯誤回應完整性，但不要把舊 stack 或 route code 當新 contract。 | PWA 已定；framework、API schema/versioning、模組目錄、生成/測試方式仍要 Joe 決定。 |
| 使用量拆分門檻／量化指標 | **唔用得** | 舊 Repo 沒有可套用到 TimeMem 的 modular-monolith 拆分數據。可把 CPU/RAM、延遲、queue、可用性及獨立 GPU 負載列為候選觀測值。 | 現階段不拆微服務已定；觸發重評的可測量門檻和觀察窗口要 Joe 決定。 |
| 相片去重、原檔保留／遷移 | **唔用得** | 舊附件每次產生新物件路徑，未發現 hash 去重、原檔版本或保留策略；刪除 record 會刪附件。PDF 原檔只在瀏覽器抽文字，不等同照片原檔保存。TimeMem 須另定原檔不可變存放、重複判斷（byte hash/感知 hash）、刪除/Undo、檔案 metadata、縮圖與資料遷移驗證。 | 上述每項產品語義都需要 Joe 新決定；不得默認舊附件做法為保留政策。任何舊資料搬遷另須授權和資料盤點。 |
| `memory.member_ids` UUID array 或關聯表、相片牆動態、觸控／鍵盤互動 | **要改先用得** | 舊 `record_participants` 是多對多 relation table，可作 array/關聯表比較材料；不是對 TimeMem `memory` 的直接答案。舊相片牆 CSS/JS 不是無障礙或互動規格。 | Joe 要決定 member 關聯形式、相片牆動態幅度及觸控／鍵盤的明確驗收準則。 |
| 手機提醒（本機通知、PWA、外部推播） | **要改先用得** | 舊 reminders 表/API 可供列出欄位和完成狀態的參考；scheduler 每 15 分鐘只記 log，沒有手機推播。重寫時經 DAO，PWA 通知需先評估平台權限及 App 關閉時可靠度。 | 本地優先、不用 Cloud/外部 LLM 已定；通知類型、何時觸發、重複/時區、App 關閉時承諾及外部推播是否完全排除仍要 Joe 決定。 |
| Vault 金鑰復原／加密備份、Backup restore「Keep」語義及保留規則 | **要改先用得** | 舊 CMS/OneDrive、雙機都可備份、非原子 DB/Storage 搬存、`RestoreIfEmpty` 是不同拓撲，不符合唯一 Primary。可沿用「備份需校驗、先隔離還原、不覆蓋非空資料」的安全檢查思路；需設計 TimeMem 的一致性、加密、金鑰獨立保管、還原演練及 Keep 含義。 | 唯一 Primary 已定；備份介質／位置、頻率、保留、加密金鑰復原及 Keep 的精確操作後果都要 Joe 新決定。不可默認 OneDrive/雲端或舊 CMS 格式。 |
| 付費功能、授權、支援和更新政策 | **唔用得** | 舊 package 標示為私人專案，未找到可當 TimeMem 商業／授權承諾的文件。舊 Git 同步、Docker image 更新是特定機器的操作紀錄，不是終端使用者更新、回退或支援政策。 | 商業模式、授權、收費、支援範圍、更新來源/批准/維護窗口/回退及安全修補期限全部要 Joe 新決定。 |
| Repo-first Skill／Copilot 操作及實測；M0 approval record | **要改先用得** | 舊 README／build plan 的閱讀順序和假資料測試可作文件流程參考；舊 repo 的 instruction/approval 不會替代 TimeMem gate。 | TimeMem 的 M0 Gate 已拍板，仍要按 [M0-READY.md](../M0-READY.md) 完成實際 GPT-LUNA review、第三方方案覆核、Joe 最終批准及 CI/branch protection 證據；舊 repo 無法清除此 TBD。 |

## 5. 舊組件 → TimeMem modular monolith 模組

以下是「用途對照」，不是檔案搬移清單。TimeMem 模組邊界以 [ARCHITECTURE.md](../ARCHITECTURE.md) 為準；舊程式碼不直接複製。

| 舊組件／檔案 | 對應新模組 | 可重用內容／必要改造 |
|---|---|---|
| `public/index.html`、`public/app.js`、`public/mvp-pages.js`、`public/*.css` | **UI / PWA** | 可參考舊 Calendar/Today 互動；重做為正式 PWA、首頁輸入層及 TimeMem 視圖。禁止直連 DB； framework/目錄待 Joe 決定。 |
| `server/index.js`、`server/routes/{records,memories,reminders,health,config}.js`、`server/middleware/apiErrorHandler.js` | **API** | 可提取 request validation、路由責任和錯誤回應經驗；重新定 API contract，DB 操作一律委派 DAO。 |
| `server/middleware/requireSupabaseUser.js` | **認證** | 只借鑑每個受保護請求驗證身份的責任；以 TimeMem Passkey/PIN/session 設計重寫。 |
| `source/DB_DESIGN.md`、`source/DB_SCHEMA_DRAFT.sql`、`supabase/migrations/*`、`scripts/init-family.sql` | **資料存取／PostgreSQL** | 只作領域欄位及風險盤點；全數重新建模，任何未來 migration 需另行批准及驗證，本輪未執行。 |
| `source/rag/{embed,search}.js`、`source/agents/*.js`、`scripts/rag/embed_worker.py` | **AI（Ollama）** | 可參考檢索／候選／引用責任分工；模型改成本地 Ollama，AI 不連 DB、不寫 DB、不呼叫外部 LLM。 |
| `server/routes/reminders.js`、`server/jobs/reminderScheduler.js`、`supabase/migrations/*reminders*` | **API + 資料存取 + UI/PWA 提醒** | 舊表/API只供需求核對；資料操作重寫經 DAO，scheduler/log 不代表 PWA 通知。 |
| `server/routes/records.js`、附件表／舊 private Storage、`public` upload code | **API + 資料存取 + 檔案存放** | 原始 bytes/metadata/私有物件權限可作檢查項；須另定原檔保留、去重與刪除/Undo，不採用舊 Storage。 |
| `scripts/backup-encrypted.ps1`、舊備份／DR 文件 | **備份** | 可參考校驗、空資料保護、演練與 recovery checklist；重新設計 DB/檔案一致性、金鑰復原、Keep 和保留規則。 |
| `docker/Caddyfile`、`docker-compose.prod.yml`、舊部署文件 | **部署邊界（非 App 模組）** | 重新為本機 Postgres/Ollama/App 和 tailnet-only proxy 寫部署文件；不沿用舊服務、端口或資料掛載。 |
| `server/services/openrouterService.js`、舊 Telegram webhook | **沒有新模組對應** | 不採用；外部 LLM 與舊訊息入口不屬已批准 M0。 |
| Root README、`PROGRESS-FAMILY.md`、`TODO.md`、`ERROR_LOG.md`、舊 `docs/` | **文件治理／審核證據** | 只用作歷史參考，TimeMem 現況以本 Repo 正式文件及實際驗證為準。 |

## 6. Joe 建議拍板次序

1. **資料與檔案基礎：** PostgreSQL schema/migration 原則、DAO API、TimeMem D: 子目錄、相片原檔／去重／縮圖與刪除／Undo 語義。
2. **資料保護：** DB + 原檔一致性備份、加密及金鑰復原、保留週期、還原測試，以及 Backup「Keep」具體含義。
3. **認證與授權：** Passkey/PIN credential 和 session 保存／撤銷／復原、家庭成員／兒童／私人內容的細則。維持已定的 Passkey 主登入、PIN 後備與 30 日記住裝置。
4. **PWA/API：** framework、API contract、產品原始碼樹、瀏覽器／手機支援矩陣及 PWA 離線邊界；確保 UI/API 不直連 DB。
5. **本機 AI：** 已定模型家族的精確權重版本/digest、Ollama 佈署及硬件資源驗證；為已定三級信心門檻訂校準資料、錯誤率和回歸驗收。
6. **入口與提醒：** 選 Caddy 或 Nginx，列明 Tailscale IP bind、HTTPS/MagicDNS 和失敗測試；決定 PWA 提醒行為及 App 關閉時的可靠性承諾。
7. **可選能力／運營政策：** MCP 啟用與否及 read-only 權限；授權、商業／支援及更新、回退、修補政策；記憶成員關聯方式及相片牆互動驗收。
8. **清 gate：** 將每項決定更新至正式文件，清除所有 Remaining TBD，再依 M0 Gate 完成必要覆核與 Joe 最終批准；文件檢查 PASS 不等同產品或 JOE-SERVER 驗收。

### 可從舊 Repo 清除 vs 仍需新決定

- **可直接清除的完整 TBD：無。** 舊 Repo 沒有 Passkey/PIN、完整 PWA、相片去重／原檔保留、手機通知、TimeMem MCP、TimeMem 商業/更新政策或相容的 PostgreSQL migration。
- **舊證據可直接縮小的問題：** 舊 reminders 只記 log；舊 attachment 沒有去重與原檔版本政策；舊前台沒有 PWA worker；舊 BGE/cosine 相似度不可作 Ollama 信心值；舊 Caddy 不是 tailnet-only TimeMem proxy。這些是排除項，不是替 Joe 選方案。
- **仍要 Joe 新決定：** Architecture Remaining TBD 表中的 schema、檔案／備份、模型版本及校準、認證細節、MCP、Caddy/Nginx、PWA/API/tree/裝置支援、拆分量化門檻、相片／成員關聯／互動、通知方式、Vault/加密/Keep、商業／更新政策，以及 Skill 流程實測與 M0 approval 證據。

## 7. 本提案未做事項

本文件只是一份重用審核；沒有複製舊程式碼或相片、沒有改舊 Repo／Vault、沒有使用外部 AI/Cloud、沒有安裝 DB、沒有執行 migration，亦沒有作 commit。實作前仍須按上述次序清 TBD 並通過 TimeMem M0 Gate。
