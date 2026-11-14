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

## IDEA 備註（未批准；不是正式 D-ID 決策）

- 首頁構想：中央放一行輸入，周圍以隨機相片作背景；滑鼠停留時彈出記憶回顧卡片，作為 S6 相片故事卡片體驗的補充想法。
- 以手機左右掃動切換頁面；每頁按主題使用一種顏色，例如相片頁紅色、證書頁綠色、財務頁藍色。
- 構想上每頁由一個 Agent 配一個 Skill 負責，頁面之間以 Link 串連；例如證書連到相片，相片再連到財務（如 HKT 續約 $88／月），並保留可延展的循環連結方向。具體頁面、連結圖及責任邊界未定。
- Multi-Agent 只預留為概念，不代表現階段實作；新增頁面應以毋須大改整體設計為方向。
- 本備註只記錄 IDEA，不批准功能、架構、里程碑或 Finance 分析範圍；D-025 對 Finance statistics/analysis 為 Later、phase TBD 的描述維持不變。S1–S10 及所有已批准決策不變；不授權程式碼、schema 或 migration 工作。
