# PROGRESS — 已完成事項

## 2026-11-25 — Multi-Agent 交接機制同專案文件重整

- 已新增 `docs/working/AGENT-STATE.md`，作為 Multi-Agent 唯一交接狀態板。
- `.github/copilot-instructions.md` 已加入開工前讀取交接文件、完工後同步更新嘅強制規則。
- 已確認 `docs/PRD.md` 係現行 V10.2，並只修正開頭格式；舊 V10.2 snapshot 仍保留喺 `docs/archive/`。
- 舊架構圖及歷史說明已由 `reference/` 移入 `docs/archive/`；無刪除程式碼。
- PWA 合併候選已列入 `docs/working/AGENT-STATE.md`：`TimeMem-PWA/manifest.json`、`TimeMem-PWA/sw.js`，預定目的地為 `frontend/public/`；暫未搬動或刪除任何程式碼。

## 2026-11-25 — M1 test plan 完成

- Joe 已批准 M1 private test plan，正式編號為 D-052。
- Test plan 固定 5 條合成版行程、2 條問題、2 個 PASS 標準；技術為 `bge-m3 + Postgres + pgvector + qwen3:8b`，1 條行程 = 1 chunk。
- RESULT 使用彈出框，唔加功能落 PWA 原有頁面；PWA 主頁魚仔保持原樣。
- M1 test 資料及完整 plan 已放喺 `docs/owner-private/04-PRIVATE-TEST.md`。
- D-052 已同步到 TODO：下個月先寫 code，呢個月唔寫 code；PASS 後先加 PDF、行程同人。
- 呢輪只更新記錄；冇 commit，亦冇 push。

## 2026-11-23 — M0 正式通過

- Joe 於 2026-11-23 正式批准 M0 PASS，已記入 D-051。
- 三項整體判定全部 PASS：安全、穩定、頂到 M1。
- M0 requirements、review、D-050 Off-host HDD 加密備份／restore 同 `qwen3:8b` 測速證據已齊。
- `GATE.md` 已更新為 M0 PASS 及批准日期 2026-11-23；TODO 已移除 M0 部分，改為 M1 下一階段。
- M1 仍須按 `Text → Embedding → Vector DB → UI` 最小圈逐步執行、驗證及停候下一次批准。
- 呢輪冇 commit，亦冇 push。

## 2026-11-23 — Off-host HDD 備份、restore 同模型測速完成

- Joe 已批准將今晚結果以 D-050 同步入正式記錄。
- HDD：`E:` BUFFALO 2TB 外置 USB HDD，使用 BitLocker XTS-AES 256，FullyEncrypted，Protection On。
- 備份：已寫入 `E:\JOE-SERVER\C-Project-20261123-221322`，合共 1055 個 file、50,429,049 bytes；全部 SHA-256 核對正確。
- Restore：由備份還原 `TimeMem\docs` 40 個 file；全部 SHA-256 核對正確，temp 已清除。
- `qwen3:8b`：實測 9.02 tok/s；200 字約 22.17 秒，符合 D-046 所定性能基準。
- D-042 同 D-048 要求嘅今晚 HDD／restore／測速證據已齊；原兩項未完成工作已由 TODO 移除。
- 呢輪只記錄證據；冇改 `GATE.md`、approval，亦冇 commit 或 push。M0 整體仍等 Joe 最後決定 PASS 或 NOT PASS。

## 2026-11-23 — Meta AI 決定已入 repo

- Joe 已批准並記錄 D-043 至 D-049。
- D-043：移除 `owner-public`，`owner-private` 成為唯一正本；唔再維護 public POC、公開 Cloud 或 Supabase 雲端路線。
- D-044：M1 先做 `Text → Embedding → Vector DB → UI` 小圈，PDF 遲啲先加，唔一次過做晒完整 pipeline。
- D-045：採用阿SIR Reading App Logic；約 1000 字切段、Embedding、存本地 PostgreSQL Vector DB、Top 5 retrieval、`qwen3:8b` 回答、UI 顯示；Embedding 用本地 Ollama `bge-m3`。
- D-046：`qwen3:8b` 維持首選；16GB RAM／冇 GPU 以 5–10 tok/s 為正常，200 字答覆 30 秒內完成先合格，唔合格先落 `qwen3:4b` 後備。
- D-047：M1 test data 固定用公開、唔敏感嘅 `docs/README.md`，唔用假資料或私人資料。
- D-048：今晚直接插 USB 嘅 Off-host HDD；500GB 以上先得、1TB 最好，順便做 `qwen3:8b` 速度測試。
- D-049：AI 要一步一步，一次只做一樣，短回覆；Joe 講停就即停。
- 呢輪只更新決策及記錄；冇改 `GATE.md`、approval、code，亦冇 commit 或 push。

## 2026-11-23 — M0 當前狀態

| 要求 | 狀態 | 已記錄證據／說明 |
|---|---|---|
| REQ-001 | PASS | D-034；Joe 確認 2026 年 8 月已清機，現狀 evidence 已收錄。 |
| REQ-002 | PASS | D-035；installer exit code 0，三個 endpoint HTTP 200，Docker container healthy，模型可用。 |
| REQ-003 | PASS | D-036；接受穩定 WiFi、Power 及長時間運行 evidence、`unless-stopped`。 |
| REQ-004 | PASS | D-037；接受現有 WiFi 同枱面擺位 evidence。另加全景相審計要求已由 Joe REJECT，唔再重拍。 |
| REQ-005 | PASS | D-038；00:24 Logon JSON 逐項 PASS，SHA-256 已對返，舊 FAIL 已移入 `superseded/`。 |
| REQ-006 | PASS | D-042；LINK JSON 顯示 Tailnet HTTP 200、非 Tailnet 連唔到，SHA-256 已對返。 |

- D-033 選 B、D-039、D-042、D-050 同 D-051 已由 Joe 批准；M0 整體已於 2026-11-23 正式 PASS。
- D-050 已記錄唯一 HDD TBD 所需嘅 Off-host 備份及 restore evidence，今晚技術證據已完成。
- M0 已轉入 PASS；下一步只按 D-043 至 D-047 進行 M1 最小圈，唔代表後續 milestone 自動批准。

## 2026-11-23 — M0 Audit 補救準備完成

- 已對 PRD、D-026 至 D-038、GATE、TODO、Hybrid 5 stack、scripts 同 evidence 做一次 post-change consistency review；呢次只係 MAI 單次 review，唔取代 D-014 要求嘅兩位 reviewer，亦唔改 M0 NOT APPROVED。
- D-039 已由 Joe 批准；Hybrid 5 已部署事實正式記作 M0 例外，但唔修改 M0 整體 approval。
- 已加入 `scripts/Backup-TimeMem-Encrypted.ps1` 及 `docs/working/TimeMem-Backup-Restore-Test.md`；script 會要求 off-host path、`age` public recipient 同 label，唔會喺未提供條件時跑。
- REQ-006 最新 LINK JSON 已收錄，D-042 批准以 Tailnet HTTP 200 同非 Tailnet 連唔到作 PASS；唔再要求重做電話測試。
- REQ-005 指定 Logon JSON 已同步、hash 已核對；舊 FAIL 已移入 `superseded/`，冇再用 AUDIT 早前嘅自相矛盾狀態。

## 2026-11-23 — REQ-005 PASS

- Joe 已批准 D-038；REQ-005 按 Joe 親自確認加 2026-11-23 00:24:50 本機 Logon PASS JSON 記為 PASS：3000 / 444 / 11434 全部 HTTP 200，Docker 三個容器 healthy，Ollama API 有 `bge-m3` + `qwen3:8b`；SHA-256 為 `0B2F6319B1E3F70412B92E10AC87679F30AB429FFEEAE3E9C29EF871119B482C`。驗證程式寫入雜湊／共享同步失敗列做工具後續處理，唔影響 TimeMem 驗收；M0 整體仍為 NOT APPROVED。

## 2026-11-22 — REQ-004 PASS

- Joe 已批准 D-037；REQ-004 按新政策記為 PASS：接受 WiFi 代替 LAN，同接受 JOE-SERVER 直接放枱面而唔使鋁架。Joe 已實測 WiFi 一星期穩定；擺位相證明部機同 ROUTER 並排、通風、唔入櫃、唔入袋；證據已收錄於 `docs/evidence/M0-REQ-004/`。M0 整體仍為 NOT APPROVED。

## 2026-11-22 — REQ-003 PASS

- Joe 已批准 D-036；REQ-003 按新政策記為 PASS：Ethernet 接受一星期穩定 WiFi；Lock 8 小時電話 Search 測試 BYPASS；Docker restart policy 接受 `unless-stopped`。M0 整體仍為 NOT APPROVED。

## 2026-11-22 — REQ-002 PASS

- Joe 於 2026-11-22 批准本 REQ；SERVER installer exit code 0，`bge-m3` + `qwen3:8b` 齊全，3000 / 444 / 11434 全部 HTTP 200，三個容器 healthy；完整證據已收錄於 `docs/evidence/M0-REQ-002/`，REQ-002 記為 PASS。M0 整體仍為 NOT APPROVED。

## 2026-11-22 — M0-REQ-001 至 M0-REQ-005 初次 evidence 檢查

- 初次檢查 `docs/evidence/` 時只見 `M0-REQ-006`，因此當時 REQ-001 至 REQ-005 保持 NOT EVIDENCED；後續 REQ PASS 狀態見頂部現況表。

## 2026-11-22 — 記錄語言規則已統一

- 所有 record 嘅新內容一律用廣東話；只保留明確准用嘅英文檔名、路徑、ID、指令、code、文件名、M0、Space、Vault、MCP、人名、Space 名及專有名詞。
- 已將規則記入 `.github/copilot-instructions.md` 及 `C:\Project\REPO\README.md`，之後所有新 repo 都跟同一做法。
- 舊 record 唔一次過重寫；下一次更新嗰份檔時，會順手將受影響嘅英文段落轉返廣東話。

## 2026-11-22 — canonical document rename and product detail review recorded

- 以 `git mv` 將舊 active files normalize 到 `docs/GATE.md`、`docs/TODO.md`、`docs/PROGRESS.md`、`docs/ERRORLOG.md`；`docs/PRD.md` 係 active Version 10.2。
- 舊 `M0-READY.md`、V10.2 PRD snapshot 已保留於 `docs/archive/`；沒有 delete。
- PRD/DECISIONS/ARCHITECTURE 記入 Space、MCP、Vault、reminder 及 compact local model direction；M0 仍 NOT APPROVED。
- 舊 FamilySystem / Supabase backlog 已 archive，現行 TODO 只保留 TimeMem 工作。
- 此次只處理 rename、link normalization 及文件整理；無 product code、schema、deployment 或 approval status change。

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
- 已更新 `docs/ARCHITECTURE.md`、`docs/GATE.md`，並加入 `scripts/check-m0-gate.ps1` 及 `.github/workflows/Check-M0-Gate.yml`。
- Repo skills source/mirror 檢查、Repo 文件檢查及 diff whitespace 檢查 PASS；GitHub branch protection 的 required check 仍待 Repo 管理者設定，產品／設備 M0 驗收未宣稱完成。