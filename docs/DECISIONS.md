# 正式決策紀錄

正式決策以本 Repo 的 `docs/DECISIONS.md` 為準；Obsidian Vault 的 `02-決策-ADR` 只作草稿，不是正式決策位置。

每項決策使用唯一 D-ID，並記錄以下欄位：

- Status: Draft / Approved / Superseded / Rejected
- Date、Decision、Rationale、Approver
- Supersedes、Superseded By、Architecture Impact、CR

## 決策

### D-001 — 正式決策位置

- Date: 2026-11-10
- Decision: Repo 的 `docs/DECISIONS.md` 是正式決策紀錄；Vault `02-決策-ADR` 只保存草稿。
- Rationale: 避免正式決定分散在不同位置，造成版本不一致。
- Impact: 正式決策須記錄在本檔；Vault 草稿不覆蓋 Repo 決定。
- Status: Approved
- Approver: Joe
- Supersedes: None
- Superseded By: None
- Architecture Impact: See impact above; [ARCHITECTURE.md](./ARCHITECTURE.md).
- CR: None

### D-002 — M0 Gate 強制方式

- Date: 2026-11-11
- Decision: 採用 approval 流程加 CI Gate。GPT-LUNA 必須使用 Repo 的 `grill-me` Skill 反覆檢視計劃並提出第一階段 approval；再由第三方 AI 對該方案表示同意；最後且只有 Owner Joe 有權作最終批准。前兩階段是必要覆核，不等於開始實作的授權。新增 `scripts/check-m0-gate.ps1` 及 GitHub Actions `M0 Gate` 檢查；產品程式碼 PR 只有在 base branch 已有完整 approval 記錄時才可通過，並須在 branch protection 設定為 required check。此流程只阻止未批准的產品程式碼合併，不能阻止有檔案權限的人在本機直接寫檔。不同意使用 OS ACL，因其可能鎖死 workspace，增加維運風險。
- Rationale: 保留 Owner Joe 的最終決定權，同時用可重複檢查的 CI 降低未批准程式碼合併風險；不以本機權限鎖定妨礙正常開發。
- Impact: M0-READY 記錄每階段覆核狀態、批准人、日期及範圍；CI 只讀取 base branch 的記錄，不能在同一個產品程式碼 PR 內自批自用。`M0 Gate` required status check 的啟用時序依 D-014：Joe 批准 M0 後，於 DEVELOP 第一步設定。第三方 AI 只作計劃覆核，不是 TimeMem runtime；不得向其提供真實家庭資料、密碼或 API key。
- **決定人：** Joe
- Status: Superseded
- Approver: Joe
- Supersedes: None
- Superseded By: D-014
- Architecture Impact: See impact above; [ARCHITECTURE.md](./ARCHITECTURE.md).
- CR: CR-001

### D-003 — App / Service 拆分

- Current interpretation: D-024 replaces the deployment topology; D-025 limits the blanket Cloud exclusion to the household closed-loop track. Other applicable local safeguards remain.
- Date: 2026-11-11
- Decision: 採 modular monolith：PWA App + 本機 PostgreSQL + 本機 Ollama。模組分為 UI、API、資料存取、AI（Ollama）、備份及認證；各模組須明確列出責任及禁止事項。只有資料存取模組可以連接 DB，其他模組必須經由它，不可直接連 DB。現階段不拆微服務；只有出現可驗證的獨立擴縮需求，例如 AI 需要獨立 GPU 主機，或使用量超出本機單體可承受範圍，才評估拆分。
- Rationale: 目前沒有獨立擴縮或獨立部署需求；modular monolith 符合家庭本機部署，降低操作、升級及故障排查成本，同時用明確模組邊界保留未來拆分能力。
- Impact: App 以 PWA 提供介面；API、資料存取、AI、備份及認證在同一部署中保持模組隔離。PostgreSQL 和 Ollama 留在本機，不使用 Supabase、Cloud、OpenRouter 或外部 LLM。模組邊界須在 `docs/ARCHITECTURE.md` 持續維護。
- **決定人：** Joe
- Status: Superseded
- Approver: Joe
- Supersedes: None
- Superseded By: D-024 (deployment topology only)
- Architecture Impact: See impact above; [ARCHITECTURE.md](./ARCHITECTURE.md).
- CR: None

### D-004 — 設備、部署拓撲、順暢版及輸入層

- Current interpretation: the single Primary, Tailnet-only entry and no public router port govern the household closed-loop track; D-025 permits a separate public synthetic-data POC, not public access to JOE-SERVER.
- Date: 2026-11-11
- Decision:
  - **部署與設備：** JOE-SERVER 是唯一可寫 Primary，Windows 11、家中、FUJITSU LIFEBOOK U9311X、i7-1165G7、16 GB RAM、477 GB NVMe，C: + D:，自託管 DB；JOE-DESKTOP 是 Windows 10 隨身開發及 Recovery 機，只有 C:。兩機透過 GitHub 只同步程式碼，不同步 DB。系統須可由外出裝置經 Tailscale tailnet 存取及更新；不開 router port、不提供公網入口。網站使用綁定 Tailscale IP 的 tailnet-only reverse proxy（Caddy 或 Nginx）、Tailscale HTTPS 及 MagicDNS，例如 `joe-server.tailxxx.ts.net`。舊 DUAL_NB 的 Supabase `127.0.0.1` 綁定只適用舊系統：Tailscale ping 通不代表網站可用，TimeMem 必須由 tailnet-only proxy 提供可達的網站入口。JOE-SERVER 現時未 7x24、未 SETUP、未 READY；進入 DEVELOP 階段後才按長開方式運作。
  - **順暢版：** Tailscale 使用 Always-on／On-demand 背景連線，避免每次手動開 App；PWA 記住裝置 30 日，不因關閉 App 就登出。Passkey/Face ID 為主要登入方式，PIN 只作後備，不要求每次同時輸入兩次認證。PWA 直接進入 Calendar／今日版。遺失手機時，撤銷 Tailscale 裝置並 revoke TimeMem session。目標是在收到 `【entity-WhatsApp¦canonical_name=WhatsApp】` 後 10 秒內、全程 3 下完成 DB 更新。
  - **首頁輸入層：** 首頁頂部只有一個自然語言輸入框，例如「取消 黎緊星期六 中文補習 阿sir 請假」；使用者不需先選日期、課堂或按 Edit。所有相關 AI 分類及提議統一使用三級信心門檻：信心值 > 0.9 時只可在該功能政策允許自動執行時更新，並提供 30 秒 Undo；0.7 至 0.9（含邊界）顯示確認卡，例「搵到：星期六 3:30 中文補習班，改做取消，原因阿Sir請假，啱唔啱？」用戶確認後才更新；低於 0.7 時不猜測、不寫入，向用戶列出候選並澄清。完成後以 NLP 回覆實際更新內容，不只顯示 Success。自動更新及 Undo 僅適用於 events/todos，不包括 memories；相片連結等另有明確確認要求的功能仍須先確認。輸入方式屬 M2 或後續；Share Sheet 及語音輸入延後。
- Rationale: 唔開 router port 是安全邊界，不是限制用戶；Tailscale 讓本人外出時仍可安全存取家中 Primary。PWA 順暢版減少操作步驟，輸入層以本機 Embedding/Ollama 提高日常更新效率；推理留在家中，真實資料不送往公開 Cloud 或外部服務，遠端查看只經加密 Tailnet 到授權裝置。
- Impact: JOE-SERVER 是唯一資料寫入來源；GitHub 不承載或同步 DB。應用層有兩層存取控制：Tailscale 裝置層及 TimeMem Passkey/PIN 層；HTTP 入口限於 tailnet，PostgreSQL 不對公網開放。所有 DB 寫入由資料存取模組執行；高信心自動更新必須可 Undo，中信心須確認，低信心不得寫入。M0 驗收須覆蓋 tailnet、順暢版、三級信心及離線 LAN 行為。
- **決定人：** Joe
- Status: Approved
- Approver: Joe
- Supersedes: None
- Superseded By: None
- Architecture Impact: See impact above; [ARCHITECTURE.md](./ARCHITECTURE.md).
- CR: None

### D-005 — DB 範圍與 Migration（決定 1A）

- Current interpretation: the listed tables are the household DB planning scope, not a requirement to install or operate a DB in the unapproved M0 preparation gate. D-023 defines M0 acceptance; D-025 does not approve any new schema or migration.
- Date: 2026-11-11
- Decision: M0 DB 包括 `families`、`members`、`events`、`todos`、`event_changes`、`inputs`、`photos`、`memories`、`memory_members` 及 `memory_photos`。所有成員關聯使用關聯表，不使用 UUID array。Migration 使用純 SQL 檔案及 `schema_migrations` 版本表；每個版本一個檔案，明確提供 up 同 down，不使用 ORM 自動 migrate。M0 只定下原則，不執行 migration。舊 `DB_SCHEMA_DRAFT.sql` 及 Supabase migrations 不可作為起點。
- Rationale: 明確定義關聯、可審核的 schema 變更及回退方式，避免沿用未批准的舊 DB 草稿或 Supabase 實作。
- Impact: DEVELOP 開始後才按此原則設計及執行 migration；本輪只更新文件，不建立 schema 或執行 migration。
- **決定人：** Joe
- Status: Approved
- Approver: Joe
- Supersedes: None
- Superseded By: None
- Architecture Impact: See impact above; [ARCHITECTURE.md](./ARCHITECTURE.md).
- CR: None

### D-006 — 資料目錄與相片（決定 1B）

- Date: 2026-11-11
- Decision: D: 根目錄使用 `D:\docker-data\timemem`，下設 `postgres`、`backups`、`photos\originals`、`photos\thumbs` 及 `exports`。相片原檔不可變及不可覆寫；檔名為 SHA-256 加副檔名，路徑按年、月分層，metadata 存於 `photos` 表。去重分兩層：SHA-256 判定完全相同；pHash 判定相似，Hamming distance 不多於 5 時只提示 Joe 選擇，永不自動當重複而刪除。刪除一律 soft delete 並記錄 `deleted_at`；原檔及縮圖保留 30 日，期間可 Undo，期滿後才硬刪檔案及記錄。舊有刪除 record 即時刪附件的做法不採用。
- Rationale: 保留不可變的相片原件及可復原刪除，同時讓完全相同與視覺相似的相片各自有明確處理政策。
- Impact: 相片資料、檔案配置、去重及保留行為依此實作；任何疑似相似相片都須由 Joe 決定，不自動刪除。
- **決定人：** Joe
- Status: Approved
- Approver: Joe
- Supersedes: None
- Superseded By: None
- Architecture Impact: See impact above; [ARCHITECTURE.md](./ARCHITECTURE.md).
- CR: None

### D-007 — 資料保護與還原（決定 2）

- Date: 2026-11-11
- Decision: 備份包括 `pg_dump`、`photos\originals` 及 `photos\thumbs`，存放於 `D:\docker-data\timemem\backups`。每晚備份一次並保留 30 日；每星期在臨時 DB 做一次全量還原測試，驗證成功才記為 PASS。備份須加密；金鑰不放在同一 D:，由 Joe 另外保管，並另備紙本金鑰復原程序，不依賴 Vault 自動復原。還原不得直接覆蓋 JOE-SERVER Primary：先還原至臨時 DB 驗證，再由 Joe 人手決定如何合併。「Keep」表示還原不刪除現有資料，只補回遺失資料。Keep 衝突時以現有資料為準，跳過備份資料並記錄衝突。舊 OneDrive、雙機都備份及非原子搬存方式不採用。
- Rationale: 保護家庭資料並確保備份可實際還原，避免還原程序破壞 Primary 上現有資料。
- Impact: 備份、還原、加密及定期演練都須符合以上規則；驗證未成功不可報 PASS。
- **決定人：** Joe
- Status: Approved
- Approver: Joe
- Supersedes: None
- Superseded By: None
- Architecture Impact: See impact above; [ARCHITECTURE.md](./ARCHITECTURE.md).
- CR: None

### D-008 — 認證與授權（決定 3）

- Current interpretation: this authentication and authorization decision governs the household closed-loop track; D-025 records Supabase Auth as the public POC direction.
- Date: 2026-11-11
- Decision: Passkey 公鑰經資料存取模組存入 DB，私鑰永不離開裝置。PIN 為 6 位數，只存 Argon2 hash，不存明文。錯誤計數只在成功登入時重設，鎖定期滿不重設；連續錯 5 次鎖定 5 分鐘，鎖定期滿後如再連續錯 5 次（自上次成功登入累計 10 次）鎖定 10 分鐘，顯示「聯絡屋企 Admin (JOE)」並記錄事件，不作自動通知。累計達 10 次後，每次鎖定期滿仍未成功登入而再次輸錯，繼續鎖定 10 分鐘。鎖定期間的輸入只記錄、不計入錯誤次數。Session 使用 DB 內 server-side session 表；token 為隨機值，只存 hash，30 日過期並可即時 revoke，不使用 JWT。手機遺失時由另一部已登入裝置或 JOE-DESKTOP revoke，不使用 email reset。角色分三級：Owner Joe 可看全部；成人可看共享及自己的資料；兒童可看共享及自己的資料，但看不到成人私人資料。私人紀錄只有建立者及 Joe 可看。舊 Email／Google Auth 加 RLS 方式不採用。
- Rationale: 將裝置私鑰保留在裝置，並以可撤銷的 server-side session 和明確的家庭角色／私人紀錄規則保護資料。
- Impact: 認證 credential、session、PIN 防護、遺失裝置復原及每次資料存取授權均依此設計；所有 DB 存取仍經資料存取模組。
- **決定人：** Joe
- Status: Approved
- Approver: Joe
- Supersedes: None
- Superseded By: None
- Architecture Impact: See impact above; [ARCHITECTURE.md](./ARCHITECTURE.md).
- CR: None

### D-009 — PWA、API 與產品目錄（決定 4）

- Date: 2026-11-11
- Decision: PWA 使用 React，包含 manifest 及 service worker。API 使用 REST JSON，路徑以 `/api/v1` 開始並採統一錯誤格式；UI 所有資料操作均經 API，不直接連 DB。產品目錄為 `src/pwa`、`src/api`、`src/dao`、`src/auth`、`src/ai`、`src/backup`，另有 `docs/` 及 `scripts/`。裝置支援近兩版 Chrome、Edge、Safari，可在 iPhone、Android 及 Windows 安裝 PWA。離線只可看已 cache 的 App 殼及最近看過的資料；寫入必須上線，不設離線 queue。舊 `public/` 靜態版不可直接當作 PWA。
- Rationale: 確立跨裝置安裝與 API 邊界，同時避免離線寫入造成家庭資料衝突。
- Impact: 前端、API 合約、產品目錄及離線行為按此規格實作；資料庫連線只由資料存取模組負責。
- **決定人：** Joe
- Status: Approved
- Approver: Joe
- Supersedes: None
- Superseded By: None
- Architecture Impact: See impact above; [ARCHITECTURE.md](./ARCHITECTURE.md).
- CR: None

### D-010 — 本機 AI 與模型校準（決定 5）

- Date: 2026-11-11
- Decision: Ollama 在 JOE-SERVER Docker 內執行。`bge-m3` 及 `qwen3:8b` 使用固定 tag 加 digest；在 DEVELOP 開始時鎖定，之後不得自動更新，更新須 Joe 再批准。模型拉取及匯入只在本機進行，執行期間不需上網。信心值採用 `qwen3:8b` 輸出的分數，非 cosine 相似度；以 100 個假 case 校準，覆蓋 >0.9、0.7–0.9、<0.7 三級。可接受錯誤率不多於 5%，不合格須重新校準，不得靜默調整門檻。Ollama 停止或模型缺失時，PWA 顯示錯誤、AI 候選停止提供，但人手輸入仍可使用；永不 fallback 至外部 LLM。舊 BGE／Transformers.js loader、384／512 維 column、placeholder 向量均不採用。
- Rationale: 固定可追溯的本機模型版本，並讓失效時的降級方式安全、明確且不依賴外部服務。
- Impact: 模型 tag／digest 在 DEVELOP 開始時按 Joe 批准值鎖定；本機校準及故障測試須符合以上門檻，不可改動既定信心政策來掩蓋結果。
- **決定人：** Joe
- Status: Approved
- Approver: Joe
- Supersedes: None
- Superseded By: None
- Architecture Impact: See impact above; [ARCHITECTURE.md](./ARCHITECTURE.md).
- CR: None

### D-011 — 入口與提醒（決定 6）

- Date: 2026-11-11
- Decision: Reverse proxy 使用 Caddy，重寫為 TimeMem App endpoint，綁定 Tailscale IP；不開 router port，HTTPS 經 Tailscale MagicDNS。非 tailnet 不可連入；LAN 離線時須顯示清楚錯誤。提醒在 PWA 內提供：event 開始前 30 分鐘及 todo 到期時提醒；M0 只驗收 App 開啟時可彈出，鎖屏或背景時不保證，且不使用外部或 Cloud push。支援重複提醒，時區跟隨裝置時區。失敗測試涵蓋非 tailnet 無法連入、HTTPS 錯誤、MagicDNS 錯誤及 Ollama 停止時人手輸入與提醒列表仍可用。舊作 Supabase gateway 的 Caddy 不能直接沿用，必須重寫；舊只記 log 的 reminders scheduler 不採用。
- Rationale: 入口只在 tailnet 可達，提醒以本機 PWA 能力提供，避免依賴公網、Cloud 或舊 gateway。
- Impact: Proxy、離線錯誤、提醒及故障測試依此規格設計；不宣稱 App 關閉後一定能收到提醒。
- **決定人：** Joe
- Status: Approved
- Approver: Joe
- Supersedes: None
- Superseded By: None
- Architecture Impact: See impact above; [ARCHITECTURE.md](./ARCHITECTURE.md).
- CR: None

### D-012 — MCP 與相片牆（決定 7）

- Current interpretation: the MCP timing and design clauses are superseded by D-025 pending the lesson; the photo-wall decision is unchanged. No MCP implementation is authorized by this historical text.
- Date: 2026-11-11
- Decision: M0 啟用 MCP，但只准讀取，使用 HTTP transport，經 API 授權；每個工具都要驗證身份，不准寫入或直接連 DB。MCP 使用與 App 相同 ACL；兒童私人紀錄只限建立者及 Joe，成人不可查看。相片牆以會動的背景圖為核心，輸入層是 SECOND layer。頂部 `living-wall-topbar` 為 48px 瘦 bar，左側 `FAMILY CALENDAR`，右側 bell 及 Master 身份顯示。背景為 `<div class="living-photo-wall" aria-hidden="true">`，放 12 張本機佔位家庭感圖片，隨機大小 80–220px、radius 16px、未 hover opacity 0.35、hover 0.65、`pointer-events: none`。Login 及 dashboard 共用背景；登入卡及輸入卡浮起並以 SECOND layer 置中 `page-shell`。`<main>` 內 `record-editor` 固定置中、寬 520px、`backdrop-blur` 12px、白色 0.92、radius 24px；textarea 自動增高、最小 56px，字體 16px／行高 1.6、padding 24px、gap 16px、touch target 44px，整個中央區域可拖曳。輸入時背景 opacity 降至 0.15。移除左側 HISTORY drawer、3 個 chips、確認內容非私人 checkbox 及 max collapsible 以外的多餘功能；其他功能收在底部 `<details><summary>更多功能</summary>`。支援觸控及鍵盤掃動、左右箭咀、Enter 開大圖、Esc 關閉及可見 focus。Google 登入卡改為 Passkey／PIN；Unsplash Source 改成本機佔位圖以支援離線及本地優先。
- Rationale: 保持相片牆作為主要視覺層，令輸入操作簡潔，同時確保互動可離線、可觸控及可用鍵盤操作。
- Impact: MCP 權限及 UI 結構／互動按以上規格實作；MCP 無寫入權，登入及圖片來源不得依賴 Google Auth 或 Unsplash Source。
- **決定人：** Joe
- Status: Approved
- Approver: Joe
- Supersedes: None
- Superseded By: None
- Architecture Impact: See impact above; [ARCHITECTURE.md](./ARCHITECTURE.md).
- CR: None

### D-013 — Vault、產品政策、更新與拆分門檻（決定 8）

- Current interpretation: D-025 records a future public POC and possible sharing; the historical private-only policy does not prohibit that separate POC. Commercial terms remain undecided.
- Date: 2026-11-11
- Decision: Vault 不接觸 TimeMem 備份金鑰；金鑰由 Joe 另外保管並有紙本復原程序，不依賴 Vault 自動復原。TimeMem 暫作私人家庭自用，不收費、不作公開授權；支援由 Joe 自行維護。更新須 Joe 手動批准，不自動更新，並提供回退；安全修補期限由 Joe 決定。長遠商業價值留待日後評估，M0 不作商業承諾。現階段不拆微服務；CPU、RAM、延遲、queue 或可用性指標連續一個月超標後，才重新評估是否拆分。所有 TBD 清除後，先做 Skill 流程實測，再做 GPT-LUNA review、第三方方案覆核、Joe 最終批准及 CI／branch protection 證據；全部齊備才可記為 M0 批准。文件檢查 PASS 不等於產品驗收。
- Rationale: 保留 Joe 對金鑰、更新、維護及批准的控制權，避免在家庭自用 M0 階段作未經驗證的商業或拆分承諾。
- Impact: 不把 Vault 納入金鑰復原、不得自動更新或擅自宣稱 M0 已批准；完成文件決策後仍須完成指定流程及證據。
- **決定人：** Joe
- Status: Superseded
- Approver: Joe
- Supersedes: None
- Superseded By: D-014
- Architecture Impact: See impact above; [ARCHITECTURE.md](./ARCHITECTURE.md).
- CR: CR-001

### D-014 — Framework M0 gate 與文件分工

- Status: Approved
- Date: 2026-11-12
- Decision: M0 requires a documented Skill-flow test, a Luna consistency review, and an independent review of the same six gate documents. Both reviews report findings; neither reviewer approves or must agree. Exit requires Critical=0 and Major=0; Joe alone approves M0. The existing CI gate continues to require a complete Joe approval record on the base branch for product-code PRs. Branch Protection is not an M0 approval condition; Joe enables the `M0 Gate` required check and Owner review as the first DEVELOP action, before product code, migrations, or database setup. DECISIONS records policy, SOPs record operating steps, and M0-READY records gate status, acceptance, reviews, and evidence links.
- Rationale: Align the project gate with New-Start-Project-Framework without implying M0 approval.
- Approver: Joe
- Supersedes: D-002, D-013
- Superseded By: None
- Architecture Impact: Workflow and document ownership only; [ARCHITECTURE.md](./ARCHITECTURE.md).
- CR: CR-001

### D-015 — Undo ordering and deletion boundary

- Status: Approved
- Date: 2026-11-14
- Decision: Undo supports two distinct scopes in the same session, each in LIFO order. For events/todos, within 30 seconds of a successful update it reverses the latest un-undone event/todo update, whether automatic or user-confirmed; memories and deletions are excluded. For each teach operation, snapshot `nlp-synonyms.json`, `reminder-defaults.json`, and `teach-log.md` before changing them; within 30 seconds of a successful teach operation, Undo restores the latest un-undone teach snapshot as files, not as database Items. AI cannot delete records automatically, and scheduled hard deletion after the retention period cannot be undone.
- Rationale: Define predictable, reversible record updates and file-based teach recovery without conflating the two Undo scopes or permitting silent deletion.
- Approver: Joe
- Supersedes: None
- Superseded By: None
- Architecture Impact: Event/todo update handling and file-snapshot teach Undo; [ARCHITECTURE.md](./ARCHITECTURE.md).
- CR: None

### D-016 — JOE-DESKTOP disaster recovery

- Status: Draft
- Date: 2026-11-12
- Decision: Joe may promote JOE-DESKTOP only after fencing JOE-SERVER, restoring the latest verified backup, and switching the tailnet endpoint; keep the old server isolated until Joe decides how to reconcile it. Only one host may accept writes.
- Rationale: Avoid split-brain writes during recovery.
- Approver: Pending
- Supersedes: None
- Superseded By: None
- Architecture Impact: Pending Joe approval; [ARCHITECTURE.md](./ARCHITECTURE.md).
- CR: None

### D-017 — 10-second / 3-tap acceptance procedure

- Status: Draft
- Date: 2026-11-12
- Decision: On a logged-in foreground phone, run 10 fixed utterances three times each; time from focusing the input to DB commit and result display. Text entry is excluded from tap count; all other touch actions count. Every run must meet 10 seconds and 3 taps; retain screen and DB evidence.
- Rationale: Make the existing UX target reproducible and auditable.
- Approver: Pending
- Supersedes: None
- Superseded By: None
- Architecture Impact: Acceptance method only; [ARCHITECTURE.md](./ARCHITECTURE.md).
- CR: None

### D-018 — Restore conflict report and reapply

- Status: Draft
- Date: 2026-11-12
- Decision: Show conflict ID, fields, and skip reason in the restore page and `exports`; Joe may review current and backup values and explicitly reapply a selected value after rechecking current data, recording before and after values. Never overwrite automatically.
- Rationale: Make skipped conflicts visible and safely actionable.
- Approver: Pending
- Supersedes: None
- Superseded By: None
- Architecture Impact: Restore UX and audit trail; [ARCHITECTURE.md](./ARCHITECTURE.md).
- CR: None

### D-019 — Offline recovery backup copy

- Status: Draft
- Date: 2026-11-12
- Decision: Copy each encrypted nightly backup to Joe-held offline media for JOE-DESKTOP disaster recovery; do not synchronize the live DB between machines.
- Rationale: Keep recovery data available if JOE-SERVER fails.
- Approver: Pending
- Supersedes: None
- Superseded By: None
- Architecture Impact: Backup storage and recovery source; [ARCHITECTURE.md](./ARCHITECTURE.md).
- CR: None

### D-020 — Session invalidation after recovery

- Status: Draft
- Date: 2026-11-12
- Decision: Revoke every active App session in the restored database and require users to sign in again before using the recovery primary.
- Rationale: Prevent stale sessions from surviving a failover.
- Approver: Pending
- Supersedes: None
- Superseded By: None
- Architecture Impact: Authentication recovery behavior; [ARCHITECTURE.md](./ARCHITECTURE.md).
- CR: None

### D-021 — AI case scoring

- Status: Draft
- Date: 2026-11-12
- Decision: A case passes only when the expected record, action, fields, and confidence tier all match; any partial error fails. Error rate is failed cases / 100, with at most 5 failures.
- Rationale: Make model calibration scoring deterministic.
- Approver: Pending
- Supersedes: None
- Superseded By: None
- Architecture Impact: Model evaluation only; [ARCHITECTURE.md](./ARCHITECTURE.md).
- CR: None

### D-022 — Manual input when Ollama is unavailable

- Status: Draft
- Date: 2026-11-12
- Decision: If Ollama is unavailable, the PWA shows an error and offers standard Calendar/todo forms for manual create/update; natural-language AI writes stop and no external LLM fallback is allowed.
- Rationale: Preserve essential manual use without unsafe or external inference.
- Approver: Pending
- Supersedes: None
- Superseded By: None
- Architecture Impact: PWA degradation behavior; [ARCHITECTURE.md](./ARCHITECTURE.md).
- CR: None

### D-023 — M0 scope clarification

- Current interpretation: D-025 supersedes only the MCP M1 timing; its purpose, design and milestone are TBD after the lesson. All M0 acceptance criteria remain unchanged.
- Status: Approved
- Date: 2026-11-12
- Decision: M0 includes the five PRD M0 setup items, Tailnet remote-reachability validation, and opening the PWA app shell. Tailnet validation checks one authorized remote Tailnet device can reach the HTTPS endpoint and one external non-Tailnet device cannot; no router port is opened. The PWA check confirms only that the shell opens over Tailnet; login, reminders, data access, and Calendar entry are excluded. Natural-language AI, confidence behavior, Undo, and Ollama fallback are later-milestone work (AI input begins in M2); Passkey/login is M4, Face ID is M5, and device remembrance / direct Calendar entry remain for a later milestone. MCP is M1 as stated in the PRD. This scope decision overrides only the M0 timing clauses in D-004, D-009, D-010, D-011, and D-012; their other approved technical decisions remain in force.
- Rationale: Follow the PRD M0 boundary while explicitly adding the Tailnet and PWA-shell checks Joe selected.
- Approver: Joe
- Supersedes: None (M0 timing clauses only; see CR-002)
- Superseded By: None
- Architecture Impact: Adds Tailnet reachability and PWA-shell acceptance to M0; defers the listed AI and authenticated PWA capabilities. See [ARCHITECTURE.md](./ARCHITECTURE.md).
- CR: CR-002

### D-024 — Local hybrid AI service architecture

- Current interpretation: D-025 scopes the Cloud exclusion and local-only invariants to the household closed-loop track; the separate public POC may use Cloud with synthetic/test data only. Local topology and safeguards remain.
- Status: Approved
- Date: 2026-11-13
- Decision: Adopt a local service architecture inspired by [gen-ai-reading-app](https://github.com/bocyslamventurenixlab/gen-ai-reading-app): React PWA → Node/Express API Gateway/Auth with the sole application-runtime PostgreSQL data-access module → one internal Python/FastAPI backend containing AI/ML and RAG modules → local PostgreSQL with pgvector and local Ollama. The target logical project areas are `frontend/`, `gateway/`, `backend/`, and `database/`; this does not create or approve product code or a detailed migration layout. Use Docker Compose as the target local orchestration for development and JOE-SERVER. Development uses synthetic/test data and a separate disposable DB; JOE-SERVER remains the only writable production Primary. Retain Caddy as the Tailscale-only HTTPS ingress in front of the application. The Python backend receives only authorized context, returns structured candidates/proposals, and has no database credentials or write path. All application reads and writes, including vector retrieval and persistence, go through the Node data-access module; backup and migration operations remain governed separately by D-005 and D-007. Household storage and inference stay local; real household data is not sent to public Cloud, the POC, or external services. Authorized remote viewing may transmit data only over encrypted Tailnet to authorized devices, with encrypted caches cleared on logout or device/session revocation. Do not use Supabase, OpenRouter, Cloud, or external LLM services for the household runtime. pgvector is an architecture-level target only: this decision does not approve schema, table, dimension, or migration changes. M0 scope remains as approved in D-023; no product code, database setup, or migration is authorized before M0 approval.
- Clarification (2026-11-14): Tailscale Serve is an approved alternative to Caddy for Tailnet-only HTTPS ingress. Neither option permits a public router port. The M0-READY record identifies which ingress was actually used; this clarification does not assert that the future application architecture has been implemented.
- Rationale: Follow the instructor's service boundaries while retaining TimeMem's local-first privacy, single database-access boundary, and closed-loop write policy.
- Approver: Joe
- Supersedes: D-003 deployment-topology clauses and D-009 product-directory/API-implementation clauses only; supplements D-005 with the pgvector target.
- Superseded By: None
- Architecture Impact: Defines the target service topology and internal data flow; see [ARCHITECTURE.md](./ARCHITECTURE.md). Existing M0 acceptance scope and criteria are unchanged.
- CR: CR-003

### D-025 — Two-track product direction

- Status: Approved
- Date: 2026-11-14
- Decision: Maintain two isolated target tracks: a public POC using Supabase / Cloud and Supabase Auth, exclusively with synthetic/test data; and the household closed-loop deployment using local PostgreSQL + pgvector and Ollama on JOE-SERVER. OpenRouter and Railway are POC candidates, not an approved detailed deployment. Real household data must not be sent to public Cloud, the POC, or external services, including copies, attachments, embeddings, logs, backups and model inputs. For authorized remote viewing, real household data may be transmitted only over encrypted Tailnet connections to authorized devices; any device cache must be encrypted and cleared on logout or device/session revocation. Keep POC data, credentials and environments separate. D-024's local service boundaries, local inference, single household Primary, Tailnet-only ingress and no public router port remain in force for the household track.
- Product direction: Preserve S1–S10, with reminders a core need. Finance statistics/analysis is Later, phase TBD; smart home and Space are TBD; reserve a Multi-Agent concept only, without promising implementation or no future code changes. MCP purpose, design and milestone are TBD until after the lesson; it is not M0 work. Shareability is a future goal, not a commercial or delivery commitment; PRD M6 SHARE is uncommitted, with scope and timing TBD and subject to separate approval, not a delivery or acceptance commitment.
- Rationale: Allow an accessible test POC without exposing household data to public Cloud or changing M0.
- Approver: Joe
- Supersedes: Only the blanket Cloud exclusion as applied to the separate synthetic-data POC in D-003 / D-024; the private-only product policy as applied to that POC in D-013; and the MCP timing/design clauses of D-012 and M1 timing in D-023. D-004 and D-008 describe the household track, not POC access or authentication. D-023's M0 scope and all household privacy safeguards remain.
- Superseded By: None
- Architecture Impact: Two separated deployment and data boundaries; detailed POC security, deployment, Space, MCP and backup encryption design remain open. No schema, migration, code, deployment or M0 approval is authorized.
- CR: CR-004

### CR-001 — M0 gate alignment

- Status: Approved
- Content: Replace the legacy grill-me / third-party-agreement gate with Framework dual reviews and findings-based exit criteria; move Branch Protection to the first DEVELOP action after Joe approves M0; define document ownership per D-014 while retaining the CI approval gate.
- Reason: Follow the project New-Start-Project-Framework gate and avoid a pre-approval platform setup dependency.
- Approver: Joe
- Affected Requirements: M0 gate workflow
- Affected Decisions: D-002, D-013
- Resulting Decision: D-014

### CR-002 — Resolve M0 scope conflict

- Current interpretation: D-025 defers MCP purpose, design and milestone; the M0 acceptance scope remains unchanged.
- Status: Approved
- Content: M0 is the five PRD setup items plus Tailnet remote-reachability validation and opening the PWA shell only. AI natural language, confidence, Undo, Ollama fallback, PWA login, device remembrance, reminders, and Calendar entry are later-milestone features; MCP is M1.
- Reason: Follow the PRD M0 scope with Joe's two explicit additions.
- Approver: Joe
- Affected Requirements: REQUIREMENTS.md, REQ-001 through REQ-007
- Affected Decisions: D-004, D-009, D-010, D-011, D-012
- Resulting Decision: D-023

### CR-003 — Align local service architecture

- Current interpretation: D-025 permits Supabase / Cloud for the separate synthetic-data POC only; the household track remains local.
- Status: Approved
- Date: 2026-11-13
- Content: Adopt React PWA, Node/Express Gateway/Auth with a sole DB-access module, one Python/FastAPI AI/ML + RAG backend, local PostgreSQL + pgvector, and local Ollama, orchestrated as local Docker Compose services; retain Caddy as the Tailnet-only ingress. Do not adopt Supabase or OpenRouter. pgvector is documented as an architecture target only; schema and migration work remain deferred.
- Reason: Follow the instructor's architecture pattern without weakening TimeMem's local-only and closed-loop requirements.
- Approver: Joe
- Affected Requirements: None; M0 scope remains governed by D-023.
- Affected Decisions: D-003 deployment topology, D-005 vector-storage target, D-009 product directory and API implementation.
- Resulting Decision: D-024

### CR-004 — Separate public POC and household closed-loop tracks

- Status: Approved
- Date: 2026-11-14
- Content: Record the two-track direction, synthetic-only POC boundary, later/TBD product items and MCP deferral in D-025; update the six gate documents. The M0 scope and acceptance in D-023 do not change.
- Reason: Resolve the blanket Cloud exclusion while keeping household storage and inference local and defining controlled Tailnet access.
- Approver: Joe
- Affected Requirements: Product direction and out-of-scope wording; REQ-001 through REQ-007 unchanged.
- Affected Decisions: D-003, D-004, D-008, D-012, D-013, D-023 and D-024, only to the extent specified in D-025.
- Resulting Decision: D-025

### D-026 — Space 作權限及資料分界

- Date: 2026-11-22
- Status: Approved
- Decision: 建立六個初始 Space：Joe、Joy、Josie、Jolie、Ailene 各一個私人 Space，再加一個 Family Shared。新 Item 預設入 Family Shared。Item 同一時間只屬一個 Space。登入者可將自己擁有嘅 Item 搬入自己私人 Space；搬去其他人私人 Space 需要來源及 destination owner 批准。private 搬去 Family Shared 必須顯示來源／目的、5 秒倒數及第二次確認。Ailene 預設只見 Family Shared；小朋友 Space 可先由父母代管，之後再 activate login。
- Rationale: 令私人／共享成為可執行的 authorization boundary，同時保留簡單 default。
- Implementation constraint: Space 概念已批准，但 database tables、columns、foreign keys、grant model 及 migration 未批准。
- Conflict handling: D-008「Owner Joe 可看全部」已由 D-033 選 B 限定；之後私人 Space schema/API 必須保留明確理由、警告及 immutable audit log，唔可以默認讓 System Admin 直接讀私人內容。
- Approver: Joe
- Supersedes: D-025 only for `Space = TBD`.

### D-027 — TimeMem outbound read-only MCP direction

- Date: 2026-11-22
- Status: Approved as direction
- Decision: TimeMem 作 MCP client，主動呼叫 allowlisted local/public MCP servers；初期只使用 read-only tools。第一批只設計 local filesystem allowlist、calendar-file import、time/timezone 等不需要私人資料的 connector。Closed-loop private payload、真實姓名、關係、Vault、附件、embedding、logs、backups 不得送去 Cloud connector。Public POC 只用 synthetic/test data，UI 必須顯示 Cloud upload warning。
- Rationale: TimeMem 控制何時、傳咩、傳去邊，避免另一個服務主動讀取完整家庭系統。
- Pending detail: transport、connector registry、credential storage、per-tool payload class、approval、audit、revoke、rate limit、offline behavior 及 milestone。
- M0 effect: None; D-027 不批准 MCP implementation 或 M1 scheduling。
- Approver: Joe

### D-028 — M2 compact local model benchmark

- Date: 2026-11-22
- Status: Approved as benchmark direction
- Decision: M2 用以下本機候選做 benchmark：embedding primary `paraphrase-multilingual-MiniLM-L12-v2` 384D；backup `intfloat/multilingual-e5-small` 384D；classification LLM `qwen2.5:3b`。固定版本／digest 後，以 100 個 synthetic Cantonese/中文/英文/中英夾雜 cases 測 retrieval、latency、RAM、cold start 及 confidence calibration；固定 benchmark 重跑一次仍合格，才可選為 runtime。失敗時 fallback 為 local rule/structured/keyword search 或細型本機 model，永不呼叫外部 LLM。
- Rationale: 配合 JOE-SERVER 16 GB RAM、降低 latency，並保留決策前的可重現 benchmark。
- Preserved policy: D-010/D-021 的 0.7/0.9 thresholds、≤5% error target、confirmation 及 fail-closed policies 不變。
- Supersedes: D-010 model-name/dimension clauses for bge-m3、qwen3:8b and the prohibition on 384D columns, only if benchmark passes and runtime selection is separately recorded.
- Approver: Joe

### D-029 — Vault security zone

- Date: 2026-11-22
- Status: Approved as policy; detailed cryptography pending
- Decision: Vault 是獨立 security zone，只由 Joe/Joy unlock/access；Ailene 只可 request。Vault 接收身份／旅行文件、民事證明、健康、保險及敏感財務文件；密碼、private key、seed phrase、2FA secret 及完整卡 security code 不入 TimeMem。Vault content 不做普通 semantic embedding、AI summary 或 log/trace；搜尋只限 title/category/tags。敏感內容若被提議放入普通 Space，先 quarantine/mask 為 Vault candidate，再要求 confirm。提醒只顯示「有重要文件快到期」等不泄露內容字句。
- Backup direction: 一個 outer backup archive，但 normal data 與 Vault 使用獨立 encryption key hierarchy；Vault key 不可只依賴 PIN hash，亦不與 D: 同位。每週隔離 restore 必須驗證 ordinary restore 與 Vault unlock/restore。
- Pending detail: encryption format、KDF、key wrapping、paper recovery、rotation、OCR/thumbnail、expiry metadata、audit 及 restore conflicts。
- Approver: Joe

### D-030 — Reminder taxonomy and acknowledgement policy

- Date: 2026-11-22
- Status: Approved
- Decision: 提醒分出門前 checklist、到時提醒、現場即時提醒、逾期跟進四類。預設為 T-60 第一次提醒、T-30 第二次及 checklist、event time 要求 acknowledgement；冇 response 時每 10 分鐘重提一次，連續兩次冇 response 後停止重複聲音／彈窗並記 `missed`，稍後作溫和跟進。每個 event/todo 可以 override。
- Delivery boundary: PWA/server 長開、cached shell 或 Tailnet connected 不等於 offline phone guarantee。V1 只承諾 in-app/reachable-device reminder 及 reconnect missed reconciliation；OS-level offline alarm 需 mobile Calendar/Reminders bridge 或 native companion，另行批准及測試。
- Approver: Joe

### D-031 — Canonical repository document structure

- Date: 2026-11-22
- Status: Approved
- Decision: 每個新 repo 採統一文件結構：root `README.md`；`docs/README.md`、`docs/PRD.md`、`docs/DECISIONS.md`、`docs/GATE.md`、`docs/TODO.md`、`docs/PROGRESS.md`、`docs/ERRORLOG.md`、`docs/ARCHITECTURE.md`、`docs/archive/`、`docs/evidence/`。當前 PRD 是唯一 active version，舊版歸 `archive/`。TODO 只放未完成，PROGRESS 只放已完成及 evidence，ERRORLOG 只放錯誤與 regression evidence。Routine task evidence updates 不需逐項批准；scope/security/privacy/schema/auth/model/deploy/gate 仍要 Joe 批准。
- TimeMem migration note: 2026-11-22 按 Joe 指示以 `git mv` 將舊 M0/working 路徑 normalize 到 `docs/GATE.md`、`docs/TODO.md`、`docs/PROGRESS.md`、`docs/ERRORLOG.md`；舊 V10.2 同 M0 snapshot 保留在 `docs/archive/`。只改名及引用，唔改 approval。
- Approver: Joe

### D-032 — Google Login proposal for household track

- Date: 2026-11-22
- Status: Draft / not approved
- Proposal: Joe 提議所有 users 使用 Google accounts login。
- Current authority: D-008/D-025 仍規定 household closed-loop 使用 Passkey + PIN，Google/Supabase Auth 只屬 public POC。未完成 offline dependency、account recovery、child account、data boundary、consent、revoke 及 Tailnet integration review 前，不可實作或宣稱已改。
- Required next step: Joe 決定採用 `Passkey/PIN only`、`Google only` 或 `Google optional bootstrap/recovery`；批核後寫新 superseding decision。

### D-033 — System Admin versus private data access

- Date: 2026-11-22
- Status: Approved
- Approval date: 2026-11-23
- Approver: Joe
- Selected option: B
- Issue: D-008 令 Owner Joe 可看全部私人內容，而 D-026 將私人 Space 定義為真正權限邊界。
- Decision: Joe 已批准選項 B：System Admin 可以因明確理由受控讀取其他人私人 Space/Vault，但每次讀取前必須顯示警告並留有不可改、不可靜默刪除嘅 immutable audit log；Joe 只以管理身份存取管理功能唔會自動取得私人內容。Backup 仍只係 encrypted operation，唔代表可喺 App 直接讀 plaintext。
- Rationale: 保留支援、救急及 accountability，同時唔再把 System Admin 身份直接等同無限制私人內容讀取。
- Supersedes: D-008 同角色／私人內容存取有衝突嘅條款。
- Required next step: 後續私人 Space/Vault authorization、break-glass 流程同 audit tests 必須按本決定實作及驗證；本決定唔改 M0 整體 approval。

### D-034 — REQ-001 8 月清機證據缺口

- Date: 2026-11-22
- Status: Approved
- Approval date: 2026-11-22
- Issue: REQ-001 現行做法要求一份已完成及有執行日期嘅 clean-device checklist；2026 年 8 月清機當時冇留低足夠 contemporaneous evidence。現有 `systeminfo`、磁碟及候選備份 evidence 能證明現狀，但唔足以重建當時完整流程。
- Joe confirmation: Joe 於 2026-11-22 確認 JOE-SERVER 已於 2026 年 8 月清理完成；現時部機正在使用，唔需要再清機。
- Proposal: REQ-001 改為接受以下組合：一份日期為 2026-11-22 的現狀 clean-device checklist、已核實嘅 JOE-SERVER Windows 11／硬件／磁碟現狀證據、Joe 對 2026 年 8 月已清機同毋須再清機嘅明確確認。唔會倒推、重建或補造 8 月當時嘅 backup manifest 或執行 log。
- Rationale: 已清好的運行中 SERVER 唔應為補歷史 evidence 而再清機；但要保留證據缺口、現狀可觀察性及 Joe 的明確責任確認。
- Affected Requirement: REQ-001 acceptance evidence definition only；M0 scope 不變。
- GATE effect: 本決定只批准 REQ-001 acceptance evidence basis；REQ-001 checklist 已可標示 PASS。`GATE.md` 及整體 M0 approval 未獲額外批准前保持不變；其餘 REQ 不受影響。
- Supersedes: None
- Approver: Joe
- Required next step: REQ-001 可按已批核嘅 acceptance basis 更新 checklist；`GATE.md` 及整體 M0 approval 未獲額外批准前不得改，REQ-002 亦不得由本次決定自動開始。

### D-035 — REQ-002 installer 與現行 Docker / Ollama 配置

- Date: 2026-11-22
- Status: Approved
- Approval date: 2026-11-22
- Approver: Joe
- Approval note: Joe 表示「裝囉 冇問題」。
- Findings:
  - `Install-OneClick.ps1` 預期 `timemem-ollama` 容器，但現有 `docker-compose.yml` 冇定義該容器。
  - JOE-SERVER 現有主機 Ollama 程序 PID 18748，正聆聽 `127.0.0.1:11434`。
  - frontend 現時只 expose port 80，冇將 host `127.0.0.1:3000` map 去容器 port 80；installer 使用嘅 `localhost:3000` 因此未對齊。
  - installer 仍拉取 `bge-m3` 同 `qwen3:8b`，同 D-028 已記錄嘅 benchmark 候選 `paraphrase-multilingual-MiniLM-L12-v2`／`qwen2.5:3b` 唔同。
- Decision:
  - installer 及 runtime 改為使用主機 Ollama `127.0.0.1:11434`，唔新增 `timemem-ollama` 容器。
  - frontend 增加 `127.0.0.1:3000:80` port map，令 installer 使用嘅 `localhost:3000` 可達。
  - 今次安裝模型跟 installer 現有 `bge-m3`／`qwen3:8b`。
  - 上述模型同 D-028 嘅 MiniLM／`qwen2.5:3b` 方向有差異，記作後續跟進；呢項差異唔阻 REQ-002。
- Approval boundary: 本決定只批准 installer／compose 應作嘅修改；`GATE.md`、整體 M0 approval 及其他 REQ 唔受本決定自動改變。
- Required next step: 按本決定修改 installer／compose，之後重新驗證 REQ-002。

### D-036 — REQ-003 Server Lock 現實運行政策

- Date: 2026-11-22
- Status: Approved
- Approval date: 2026-11-22
- Approver: Joe
- Decision:
  - Ethernet 唔再係 REQ-003 強制條件；接受 WiFi 取代 LAN。Joe 已實測 JOE-SERVER 放喺 Router 隔離使用 WiFi 一星期冇斷過，重點係連線穩定，唔係一定要有 LAN 線。
  - Lock 8 小時電話 Search 測試可以 BYPASS。Power 設定驗證，加上服務已連續 Up 46 小時，而且 3000 / 444 / 11434 仍回 HTTP 200，已證明長時間鎖機期間 SERVER 唔會睡眠。
  - Docker restart policy 保持 `unless-stopped`；容器會喺 crash 或 Docker／主機重開後自動恢復，而人手 stop 會維持停止狀態以便維修。SOP 原先要求 `always` 唔符合現實運行需要，改以 `unless-stopped` 為準。
- Rationale: 以實測穩定性、長時間運行證據同可維修性判定 REQ-003，唔為咗字面 SOP 要求增加冇必要嘅硬件或測試成本。
- Affected Requirement: REQ-003 acceptance policy only；M0 scope 不變。
- Approval boundary: 本決定只批准 REQ-003 嘅上述判定原則；唔改整體 M0 approval、其他 REQ、installer 或 compose。

### D-037 — REQ-004 實體擺位政策

- 日期: 2026-11-22
- 狀態: 已批准
- 批准日期: 2026-11-22
- 批核人: Joe
- 決定:
  - REQ-004 接受 WiFi 代替 LAN 線，唔再把 LAN 線列為必須條件。
  - 接受 JOE-SERVER 直接放喺枱面，唔需要鋁架。
  - Joe 已實測 JOE-SERVER 使用 WiFi 一星期保持穩定；擺位相顯示部機同 ROUTER 並排放喺枱面，位置通風、唔入櫃、唔入袋，按此政策足以通過 REQ-004。
  - 擺位相證據放喺 `docs/evidence/M0-REQ-004/`。
- 理由: 以 Joe 一星期實測嘅 WiFi 穩定性，以及實際擺位相顯示嘅通風與 ROUTER 隔離條件，接受現實運行狀態，唔為咗原 SOP 嘅字面要求額外加鋁架或 LAN 線。
- 受影響要求: 只改 REQ-004 驗收政策；M0 範圍不變。
- 批准邊界: 本決定只批准 REQ-004 擺位同連線判定；唔改 M0 整體批准、其他 REQ、installer 或 compose。
- 2026-11-23 補充批准: Joe 已明確批准維持以上 REQ-004 判定，並 REJECT 另加「必須再影一張同時見到完整 SERVER、ROUTER、擺位及通風位嘅全景相」作額外審計要求。現有 `docs/evidence/M0-REQ-004/` 已足夠支持 D-037；唔再追交新相。

### D-038 — REQ-005 自動啟動證據政策

- 日期: 2026-11-23
- 狀態: 已批准
- 批准日期: 2026-11-23
- 批核人: Joe
- 決定:
  - REQ-005 接受 Joe 親自確認做證據；Joe 確認兩日前已實測重啟後 TimeMem 自動開返成功。
  - Joe 確認 2026-11-23 00:24:50 嘅 JOE-SERVER 本機 Logon 驗證 JSON 為 PASS；3000 / 444 / 11434 全部 HTTP 200，Docker 三個容器全部 healthy，Ollama API 有 `bge-m3` 同 `qwen3:8b`。
  - 呢次本機 PASS JSON 嘅 SHA-256 為 `0B2F6319B1E3F70412B92E10AC87679F30AB429FFEEAE3E9C29EF871119B482C`。
  - 驗證程式寫入雜湊同同步共享失敗屬工具問題，唔係 TimeMem 自動啟動或服務問題，唔再阻擋 REQ-005；工具寫入及同步修正列做後續處理。
- 理由: Joe 親自重啟實測成功，加上當晚本機 Logon 驗證已逐項確認服務端點、容器健康同模型可用；共享證據傳送問題唔影響產品重啟驗收結果。
- 受影響要求: 只改 REQ-005 驗收判定；M0 範圍不變。
- 批准邊界: 本決定只批准 REQ-005 以 Joe 親自確認及本機 PASS JSON 驗收；唔改 M0 整體批准、其他 REQ、installer、compose 或產品 code。

### D-039 — Hybrid 5 已部署狀態嘅 M0 例外

- 日期: 2026-11-23
- 狀態: 已批准
- 批准日期: 2026-11-23
- 批核人: Joe
- 決定:
  - 確認 Hybrid 5 已經喺 JOE-SERVER 部署，包括 frontend、Node gateway、local PostgreSQL、database init、Docker Compose 及相關 installer/script。
  - 為避免倒填歷史，呢個已發生狀態只記錄成「已執行嘅 M0 例外」，唔追認為 M0 原批准流程已覆蓋，亦唔等同正式產品 baseline。
  - M0 期間只接受現有 stack 作 REQ-002 至 REQ-005 嘅驗收目標；Space、Vault、private authorization、production data、migration 及新功能仍保持 blocked。
  - M0 整體尚未批准前，唔再新增會改 product code、schema、migration 或 deployment 嘅工作。
- 理由: 現有文件話 M0 未批准前不建立 product code／DB，但 Hybrid 5 已實際部署。用明確例外記錄實況，比靜默當冇發生或倒填批准更安全。
- 批准邊界: Joe 只批准 D-039 所記嘅已部署 M0 例外；唔改 `Owner Joe final approval=NOT APPROVED`，唔批准新 product code、schema、migration、production data 或 M0 整體。
- Supersedes: None
- Architecture Impact: 只界定現有 Hybrid 5 嘅歷史及 M0 驗收地位；正式 architecture baseline 仍要另外確認。

### D-042 — Off-host HDD 備份、restore evidence 及 REQ-006 LINK 驗證

- 日期: 2026-11-23
- 狀態: 已批准
- 批准日期: 2026-11-23
- 批核人: Joe
- 決定:
  - M0 備份及 restore 接納一隻 Off-host HDD 1TB 作離站保存；Joe 今晚返屋企插 HDD 後，先由 SERVER LUNA 執行加密備份同隔離 restore 驗證。
  - HDD 未插之前，備份及 restore evidence 維持 TBD；唔准冒認已完成，唔要求 Joe 而家插 HDD。
  - REQ-006 接納 `docs/evidence/M0-REQ-006/REQ-006-link-boundary-verification-20261123-120507.json` 作最新 LINK 模擬驗證：Tailnet URL 先後維持 HTTP 200，非 Tailnet `192.168.1.136:8444` 三次 TCP 連線均失敗，listener 只綁定 Tailnet address；REQ-006 記為 PASS。
  - 上述 JSON 嘅 SHA-256 為 `C233134D4AC51780D6FD4500416C17804A6A24ED7E455A803D729C839D465B1E`。
- 理由: 用實際 LINK 邊界驗證收窄 REQ-006 證據缺口，同時保留尚未完成嘅 Off-host HDD 備份及 restore 係唯一 M0 TBD。
- 受影響要求: REQ-006 驗證判定轉 PASS；Off-host HDD 備份及 restore 仍待實作證據。
- 批准邊界: 本決定只批准指定方案及 REQ-006 判定；唔改 M0 整體 approval。M0 整體仍係 NOT APPROVED，Joe 要喺 HDD 備份及 restore 證據完成後先作最後一句 PASS 或 NOT PASS 決定。

### D-043 — 刪除 public track，owner-private 成為唯一正本

- 日期: 2026-11-23
- 狀態: 已批准
- 批准日期: 2026-11-23
- 批核人: Joe
- 決定:
  - 刪除 `owner-public` track；`owner-private` 係 TimeMem 唯一正本。
  - 唔再維護任何獨立 public POC、公開 Cloud 或 Supabase 路線。
  - 所有後續產品、測試及文件工作只圍繞 `owner-private` 本地閉環方向。
- 理由: 避免同一產品維護兩套隔離度高但目標互相牽制嘅 repo／架構路線，集中資源落單一正本。
- 批准邊界: 本決定只改現行產品 track 同維護方向；M0 整體仍維持原 approval 狀態，唔透過呢項決定自行改 `GATE`。
- Supersedes: D-025；以及 D-003、D-008、D-013、D-024 中只適用於獨立 public POC 嘅條款。

### D-044 — M1 只做 Text → Embedding → Vector DB → UI 小圈

- 日期: 2026-11-23
- 狀態: 已批准
- 批准日期: 2026-11-23
- 批核人: Joe
- 決定:
  - M1 優先次序固定為先完成 `Text → Embedding → Vector DB → UI` 呢個最小驗證圈。
  - PDF ingestion 遲一個明確後續階段先加入。
  - M1 唔一次過實作完整 pipeline；每一步先驗證可用，再進入下一步。
- 理由: 先完成一條細而可證明嘅本地 RAG 路徑，可及早發現模型、向量儲存同 UI 整合問題，避免大範圍返工。
- 批准邊界: 本決定設定 M1 實作次序；唔批准 schema、migration 或 PDF 功能提早施工。

### D-045 — M1 採用阿SIR Reading App Logic 同全本地技術

- 日期: 2026-11-23
- 狀態: 已批准
- 批准日期: 2026-11-23
- 批核人: Joe
- 決定:
  - 照抄阿SIR Reading App Logic：將文字切成約 1000 字一段。
  - 每段經 Embedding 後存入 Vector DB。
  - 使用者問問題時，先搵最似嘅 Top 5 chunks。
  - 將 Top 5 context 俾 LLM 生成答案，再由 UI 顯示。
  - Embedding 使用本地 Ollama `bge-m3`；LLM 使用本地 Ollama `qwen3:8b`。
  - Vector DB 使用本地 PostgreSQL；M1 唔使用 Supabase 雲端。
- 理由: 沿用已清楚理解嘅小型 RAG 流程，配合現有本地模型同資料主權要求。
- 批准邊界: 本決定固定 M1 邏輯同技術選擇；詳細 schema、API contract 及 UI 行為仍按一步一驗證方式落地。

### D-046 — qwen3:8b 性能基準及後備模型

- 日期: 2026-11-23
- 狀態: 已批准
- 批准日期: 2026-11-23
- 批核人: Joe
- 決定:
  - M1 繼續使用 `qwen3:8b`。
  - 喺 16GB RAM、冇 GPU 嘅環境，5–10 tok/s 視為正常表現。
  - 200 字答覆須喺 30 秒內完整輸出先算合格。
  - 只有 `qwen3:8b` 未達合格線，先允許改用 `qwen3:4b` 作後備；未證明不合格前不得預先降級。
- 理由: 用明確速度同完成時間管理本地 CPU inference 預期，亦保留可追溯嘅降級門檻。
- 批准邊界: 本決定只批准模型維持及性能驗收／後備規則；唔改其他模型、資料或安全決策。

### D-047 — M1 test data 固定使用公開文件

- 日期: 2026-11-23
- 狀態: 已批准
- 批准日期: 2026-11-23
- 批核人: Joe
- 決定:
  - M1 測試資料使用 `docs/README.md`。
  - 所用測試內容必須公開、唔敏感；唔使用假資料，亦唔使用私人資料。
- 理由: 以真實 repo 公開文件驗證 ingestion／retrieval，避免測試資料脱離實際用途，亦避免私人資料流入測試環境。
- 批准邊界: 本決定只界定 M1 test dataset；唔批准 production data、外部資料集或其他私人來源。

### D-048 — 今晚 Off-host HDD 及 qwen3:8b 測速工作

- 日期: 2026-11-23
- 狀態: 已批准
- 批准日期: 2026-11-23
- 批核人: Joe
- 決定:
  - 今晚使用 Joe 直接插 USB 嘅 Off-host HDD。
  - HDD 容量少過 500GB 唔接納；1TB 為優先。
  - 接駁後除加密備份及 restore evidence 外，順便執行 `qwen3:8b` 速度測試。
  - HDD 未插或未確認容量前，唔可宣稱備份／restore 或速度測試完成。
- 理由: 一次完成硬碟接駁、容量確認、M0 唯一 HDD TBD 同 M1 模型性能基準。
- 批准邊界: 本決定補充 D-042 嘅今晚執行條件；唔改 M0 整體 approval，亦唔將速度測試納入 M0 pass 條件。

### D-049 — AI 互動節奏

- 日期: 2026-11-23
- 狀態: 已批准
- 批准日期: 2026-11-23
- 批核人: Joe
- 決定:
  - AI 必須一步一步執行，一次只做一樣。
  - 回覆保持短，唔可以又快又長。
  - Joe 一講停，AI 即時停止，不續做下一步。
- 理由: 保持 Joe 對工作範圍、進度同風險嘅即時掌控，避免一次執行過多而失去審閱機會。
- 批准邊界: 呢項係持續工作節奏規則，唔改已批准架構、M0 approval 或其他決策內容。

### D-050 — 2026-11-23 Off-host HDD 備份、restore 同 qwen3:8b 測速證據

- 日期: 2026-11-23
- 狀態: 已批准
- 批准日期: 2026-11-23
- 批核人: Joe
- 決定:
  - 接納 `E:` BUFFALO 2TB 外置 USB HDD 作今晚 Off-host backup；裝置採 BitLocker XTS-AES 256、FullyEncrypted，Protection On。
  - 已將 TimeMem 備份至 `E:\JOE-SERVER\C-Project-20261123-221322`；備份包含 1055 個 file，共 50,429,049 bytes，所有 SHA-256 全部核對正確。
  - 已由備份還原 `TimeMem\docs` 40 個 file，所有 SHA-256 全部核對正確；還原測試用 temp 已清除。
  - `qwen3:8b` 實測為 9.02 tok/s，200 字約 22.17 秒，達到 D-046 合格線。
  - D-042 及 D-048 所需今晚 HDD 備份、restore evidence 同速度測試已完成；相應 TODO 移入 PROGRESS。
- 理由: 將 Joe 已批准同步嘅實測結果正式固化，完整保留儲存位置、加密狀態、數量、大小、hash、restore 同性能結果，供後續審計。
- 批准邊界: 本決定只記錄並接納指定證據；唔改 M0 整體 approval、`GATE.md` 或其他 approval 狀態，亦唔等同自動將 M0 改為 PASS。M0 最終係 PASS 定 NOT PASS 仍須由 Joe 另外作決定。

### D-051 — M0 正式批准 PASS

- 日期: 2026-11-23
- 狀態: 已批准
- 批准日期: 2026-11-23
- 批核人: Joe
- 決定:
  - M0 於 2026-11-23 正式批准為 PASS。
  - 三項整體判定全部 PASS：安全、穩定、頂到 M1。
  - D-034 至 D-042 嘅需求證據、D-050 嘅 Off-host HDD 加密備份、restore 同性能結果，連同已完成 review，一併構成今次 M0 批准基礎。
  - D-023 所定 M0 範圍已完成，可由 M0 轉入 M1 下一階段。
- 理由: Joe 已覆核現有證據，並明確批准 M0 以安全、穩定及可承接 M1 三項標準正式通過。
- 批准邊界: 本決定只將 M0 正式批准為 PASS；M1 仍須按既定次序逐步執行、驗證及停候下一次批准，唔代表所有後續 milestone 已自動批准。

### D-052 — M1 private test plan 固定規格

- 日期: 2026-11-25
- 狀態: 已批准
- 批准日期: 2026-11-25
- 批核人: Joe
- 決定:
  - M1 private test 固定使用 5 條合成版行程、2 條 test 問題同 2 個 PASS 標準；完整資料放喺 `docs/owner-private/04-PRIVATE-TEST.md`，只留本機，唔 commit、唔 push。
  - 技術固定為 Embedding `bge-m3`、本地 PostgreSQL 加 `pgvector`、LLM `qwen3:8b`；現有 UI 基準係 PWA `index`。
  - 切段規則為 1 條行程 = 1 個 chunk，唔再切；DB 使用 `test_schedules`，欄位為 `id`、`content`、`embedding`、`time`、`person`、`place`、`action`。
  - 流程為打問題、轉 Embedding、由 DB 搵最似 2 條、將嗰 2 條交 `qwen3:8b` 答、用 RESULT 彈出框顯示結果。
  - UI 唔加嘢落 PWA；PWA 原有魚保持原樣。RESULT 彈出 2 張行程卡，頂係時間、中係人 + 地、底係做咩；搵唔到就顯示「搵唔到相關行程」，閂框後返回 PWA 主頁。
  - 2 條 test 問題只喺分別答到星期一 + 星期四，或星期二 + 星期六嗰指定 2 條時先算 PASS。PASS 後先加 PDF、加行程同加人。
  - 呢項只定下 M1 test plan；下個月先寫 code，呢個月唔寫 code。
- 理由: 將合成行程、問題、PASS、模型、儲存、retrieval 數量及 UI 邊界一次寫清，令實作前有一致、可驗證嘅小圈規格。
- 批准邊界: 本決定覆蓋 D-045 同 D-047 對今次 M1 private test 嘅 1000 字切段、Top 5、`docs/README.md` 唯一 test data 規格；唔改其他已批准安全、部署或模型規則，亦唔批准提前寫 code、migration、PDF 或新產品資料。
- Supersedes: D-045 及 D-047 限今次 M1 private test 嘅切段、retrieval 同 test data 條款。

## IDEA 備註（未批准；不是正式 D-ID 決策）

- 首頁構想：中央放一行輸入，周圍以隨機相片作背景；滑鼠停留時彈出記憶回顧卡片，作為 S6 相片故事卡片體驗的補充想法。
- 以手機左右掃動切換頁面；每頁按主題使用一種顏色，例如相片頁紅色、證書頁綠色、財務頁藍色。
- 構想上每頁由一個 Agent 配一個 Skill 負責，頁面之間以 Link 串連；例如證書連到相片，相片再連到財務（如 HKT 續約 $88／月），並保留可延展的循環連結方向。具體頁面、連結圖及責任邊界未定。
- Multi-Agent 只預留為概念，不代表現階段實作；新增頁面應以毋須大改整體設計為方向。
- 本備註只記錄 IDEA，不批准功能、架構、里程碑或 Finance 分析範圍；D-025 對 Finance statistics/analysis 為 Later、phase TBD 的描述維持不變。S1–S10 及所有已批准決策不變；不授權程式碼、schema 或 migration 工作。

### D-027 — M1 階段多模態圖文閉環測試流向（以興趣班 Schedule 為例）

- 日期: 2026-11-26
- 狀態: Meta 共識；待正式批准後才展開實作
- 批准人: 待 Joe 確認
- 決定方向:
  - 使用興趣班 Schedule 圖片作 M1 合成多模態閉環測試，不以真實家庭相片或個資做驗證資料。
  - 透過 Vision / OCR 由圖片萃取人物、活動、時間及地點等欄位；固定使用 `qwen3:8b` 作文字／識別任務判定。
  - OCR 結果經 `bge-m3` 轉為 embedding；每條行程固定為 1 個 chunk。
  - embedding 寫入本地 PostgreSQL `pgvector`；M1 測試只使用隔離表 `test_schedules`。
  - 使用者輸入問題後，先轉 embedding，再由 `test_schedules` 即時檢索最相似的 2 條行程。
  - PWA 即時彈出 RESULT 框，卡片頂部顯示時間、中部顯示人物及地點、底部顯示活動；無結果時顯示「搵唔到相關行程」。
- 資安合規（Rule-SEC-01）:
  - 真實相片、OCR 私人內容、個人資料、credentials、`.env`、embeddings、logs及私人 backup 嚴禁寫入 Git。
  - 公開設定只依賴脫敏 `.env.example`；測試及 evidence 只使用合成資料及本機受控儲存。
- 理由: 將 M1 圖片上傳、Vision / OCR、embedding、向量入庫、檢索及 PWA 渲染串成單一可量測閉環，方便以興趣班 Schedule 驗證實際流向。
- 批准邊界: 本決定只記錄 D-052 框架下嘅多模態測試流向；未取得 Joe 正式批准前，不代表批准圖片上傳實作、schema migration、模型選型、外部 API、Cloud 部署或真實資料處理。

### D-053 — M1 圖片主線與 n8n 後勤分工

- 日期: 2026-11-26
- 狀態: 正式架構方向；實作仍受 D-052 私密測試邊界約束
- 決策:
  - M1 第一 Priority 固定為 FastAPI 圖片上傳主線：`Multipart Upload` → 本地 Ollama `qwen3:8b` Vision / OCR → `bge-m3` embedding → PostgreSQL `pgvector` 寫入／檢索 → PWA 彈出 RESULT 框。
  - 圖片及 OCR 萃取只限合成 Schedule 資料、本機受控儲存及 M1 隔離表 `test_schedules`；未經批准不得加入真實家庭相片或私人 OCR 內容。
  - 本地 Docker n8n（Port `5678`）定位為後勤自動化外掛及外部觸發器，可接收 Backend Webhook，負責日曆同步、通知提醒或開發期 API 測試。
  - 核心業務邏輯包括圖片接收、Vision / OCR、embedding、向量寫入、檢索及結果判定，一律留喺 FastAPI，不放入 n8n。
- 資安合規（Rule-SEC-01）:
  - 真實 credentials、`.env`、個人資料、相片、OCR 結果、embedding、log及backup 不得進入 Git、公開分享位置或外部服務。
  - n8n workflow、測試 payload、Webhook 設定及日誌不得保存敏感內容；外部觸發只使用脫敏合成資料。
- 理由:
  - 將可量測的多模態最小閉環集中喺 FastAPI，確保核心資料及模型路徑可審計、可停止及可本機驗證；n8n 只承擔非核心後勤工作。
- 批准邊界:
  - 本決定固定 M1 主線及後勤分工；唔代表自動批准 production schema、真實個資、PDF、雲端部署或任何外部服務整合。

### D-054 — 置頂錨點機制及工作樹疊加打包規範

- 日期: 2026-11-26
- 狀態: Approved
- 決策:
  - `.github/copilot-instructions.md` 必須喺最前 25 行保留顯眼嘅 `## 🚨 CURRENT ACTIVE DIRECTIVE (M1 OVERRIDE)`；新對話必須優先採用置頂區塊及 `docs/TODO.md` 頂部為最高準則。
  - `docs/ARCHITECTURE.md` 頂部必須同步維護 M1 當前有效資料流；舊版 Express Gateway 及 Obsidian 雙向橋接分別標示 Legacy／Hold；`docs/archive/`、舊版 M0 草稿及舊架構圖不可凌駕現行決策。
  - `cold-start-pack.ps1` 必須先匯出當前 `HEAD`，再疊加未 commit 嘅受控工作樹修改及新檔；疊加後仍執行完整 Rule-SEC-01 路徑及內容過濾。
  - 重建 ZIP 後，需核對 `.github/copilot-instructions.md`、`docs/ARCHITECTURE.md` 及 `docs/PROGRESS.md` 嘅置頂錨點，以及 ZIP 掃描 0 路徑違規／0 Secret 命中。
- 理由:
  - 置頂錨點消除新對話讀取順序造成嘅 Lost in the Middle 與舊文件干擾；工作樹疊加避免打包產出只反映 HEAD 而漏載最新未提交紀錄。
- 批准邊界:
  - 本決策只規範 AI 新對話準則、現行架構錨點及 Cold Start 打包完整性；唔改變 M0 PASS 或 M1 product approval 範圍。

### D-055 — docs/working 草稿隔離及 Cold Start 打包強制過濾

- 日期: 2026-11-27
- 狀態: Approved
- 決策:
  - Cold Start 打包必須喺腳本層面強制排除整個 `docs/working/`，不得依靠人工提示、排序或檔案名稱規則作為唯一防線。
  - 已過時、與 M1 OVERRIDE 衝突或已被正式 Canonical Files 取代嘅草稿，必須物理移入 `docs/archive/`；未批准草稿唔得留喺現役工作目錄。
  - `.agents/skills/cold-start-pack/SKILL.md` 必須同步記錄相同排除規範，ZIP 重建後仍須由路徑掃描及內容掃描覆核。
- 理由:
  - 第二次 Cold Start 得 87 分；第 1 題因 `docs/working/` 未批准草稿干擾，未能精準吐出 M1 唯一閉環。此為 Lost in the Middle／關鍵字檢索干擾風險，需由腳本與目錄治理雙重防重犯。
- 批准邊界:
  - 本決策只規範冷啟動資料供給及草稿治理；M1 正式閉環、雙機拓撲及 n8n 邊界仍以 D-052 至 D-054 為準。