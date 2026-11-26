# TimeMem — PRD V10.2

Version: 10.2

> 版本：V10.2，日期：2026-11-14  
> 基於 V10.1，只按 CR-004 / D-025 對齊雙軌、Cloud 資料邊界、概念資料類型、MCP / Space 狀態及架構圖引用。  
> S1–S10、口號、提醒痛點及 M0 內容保留；V10 Final / V10.1 原檔不覆寫。

## 口號

**Remember what matters。**

## 係咩

TimeMem 係屋企嘅時間 + 記憶 + 證件 + 相片，全部喺一個平台，入 DB 簡單，Search 快。

舊電腦翻新，好似 ROUTER 咁，長開喺屋企，做屋企個人整合中心，好似 NAS 咁，多一樣長插電嘅電子產品。

定位仍然係個人化工具，唔係商業賺錢產品。系統分兩條互相隔離嘅路線：

- **公開 POC：** Supabase / Cloud + Supabase Auth，供測試使用；只可以放合成／測試資料。OpenRouter / Railway 只係 POC 候選，未批准具體部署。真實屋企資料及其副本、附件、embeddings、logs、backups 或模型輸入，全部不得放上公開 Cloud、POC 或交俾外部服務。獲授權遠端查看只可經加密 Tailnet 傳送到已授權裝置；裝置 cache 必須加密，登出或撤銷裝置／session 時清除。
- **屋企閉環版：** Local Postgres + pgvector + Ollama，真實屋企資料唔會送去公開 Cloud 或外部服務；授權遠端查看只經加密 Tailnet 傳去授權裝置，裝置 cache 加密並於登出／撤銷時清除。沿用本機推理、Tailnet-only 入口、JOE-SERVER 單一可寫 Primary 同唔開 router port 嘅方向。
- 兩條路線嘅資料、帳戶／憑證及環境分開。公開 POC 唔可以連屋企閉環 DB 或取得真實屋企資料。

## 10 個滿足點

### S1 拖 PDF，20 堂一次入
拖學校興趣班時間表 PDF (1 年) → Prompt「係咪想紀錄行事曆」→ Preview 20 堂 → Confirm → 20 Items + 提醒 + Embeddings。
Preview 嗰陣，每堂要寫理由，例如「第 3 堂係 11 月 15 日，因為 PDF 第 2 頁第 3 行寫咗」。

### S2 問問題，3-5 秒有答案 + 理由 + Undo
問「下一堂滑板班幾時？」→ RAG 答。
每次 AI 提議 / 每次改 DB，都要帶 3 樣：
1. 理由：點解咁估，例如「因為 EXIF 嗰日同滑板班同一日，所以估係嗰堂」。
2. 信心值：所有 AI 分類及提議統一用同一組門檻：低過 0.7 唔寫入，要列出候選並澄清；0.7–0.9（包括兩端）要用家確認；高過 0.9 只可按該功能已批准嘅政策自動更新。唔可以靜靜入。
3. Undo：events / todos 成功更新後 30 秒內可以一撳 Undo，還原同一 session 內最近一項未 Undo 嘅更新（LIFO）；包括自動更新及用家確認後嘅更新。memories 同刪除唔包括。AI 唔可以直接改 DB，唔可以直接刪。

### S3 相片自動指返 RECORD
相片 EXIF 日期同 RECORD 同一日，自動建議 Link。建議要寫理由「因為相片係 2026-11-09 影，同滑板班同一日」，用家 Confirm 先 Link，唔啱就撳「唔係呢個」，系統記低，下次唔再估錯。

### S4 NAS / 舊電腦一鍵安裝，裝完自動開
Install-OneClick.ps1 → docker compose up -d 之後，自動做 3 樣：自動檢查起咗未、自動開 http://localhost:3000、自動話「起咗啦」。

### S5 備份 / 還原一鍵
一鍵備份 → 一個 File。一鍵還原 → 揀 File → 還原。備份 File 要寫明日期 + 有幾多 Items + 有幾多相。

### S6 生動相片牆背景 + 卡片回顧
相片牆輪播，唔好同一張相連續 3 日出，唔好同一模板連續 2 日出。每張相有故事卡片，Cantonese 寫法。

### S7 好用，家人唔使問 JOE，登入加 Passkey
PIN + Passkey 兩樣都有。手機開 TimeMem，可以用 Face ID / Touch ID / 指紋入，唔使記 PIN。PIN 留返做後備，必須係 6 位。錯誤計數只喺成功登入時重設，鎖完唔重設：連續錯 5 次鎖 5 分鐘；鎖完再連續錯 5 次（冇成功登入，總共 10 次）鎖 10 分鐘，並顯示「聯絡屋企 Admin (JOE)」及記錄事件，唔做自動通知。累計到 10 次後，每次鎖完仍然登入失敗就繼續鎖 10 分鐘。鎖緊期間嘅輸入只記錄、不計數。第一次開，要教屋企人「用 Face ID 就入到啦」。

### S8 人咁嘅，Cantonese + 中英夾雜都明
Input 層分 RECORD 定 SEARCH，3 層：Rules → Embedding Similarity → Ollama 分類。每次分類都要出信心值，同 S2 / S9 用相同門檻：<0.7 唔寫入並即時澄清「係咪想紀錄定想搵嘢？」；0.7–0.9 要確認；>0.9 只可按已批准嘅功能政策自動執行。

### S9 唔明就問，唔好估
唔止 NLP，PDF、相片、提醒等 AI 提議都用 S2 / S8 相同門檻：<0.7 唔寫入並要問；0.7–0.9 要確認；>0.9 只可按已批准嘅功能政策自動執行（例如 S3 相片 Link 仍然一定要用家確認）。問嘅時候要帶理由 + 信心值 + 2-3 個選擇。

### S10 越用越啱我，JOE Notebook + Undo
用家教系統，系統越嚟越準。每次教之前，先 snapshot `nlp-synonyms.json`、`reminder-defaults.json` 同 `teach-log.md`；之後寫入 teach-log.md 一行，JOE 直接改 nlp-synonyms.json，Commit，2 分鐘。每次教學成功後 30 秒內，同一 session 可以 Undo 最近一次未 Undo 嘅教學（LIFO），以 snapshot 還原呢三個檔案；呢個係 File 還原，唔係 DB Item 還原。

## 核心痛點 — 提醒唔好忽略

Joe 係經常遺忘事情嘅爸爸；即使屋企人已經準備好物品，冇 double-check 都會入 Joe 數。需要彈出提醒，減少以下情況：

- 阿囡打鼓表演，舉起手機準備拍片，三分鐘後先發現冇影到 video。
- 上打鼓班忘記帶鼓棍；跳舞班忘記帶跳舞鞋；跆拳道班忘記帶色帶；游水班忘記帶泳帽；補習班忘記帶外套。

## 概念資料類型（唔係已批准嘅 DB schema）

`User / Space / Item / Asset / Reminder / Embedding` 六項只係概念資料類型，唔代表恰好六張 tables；實際 schema、table／column、關聯及 migration 仍須另行設計及批准。2026-11-22 已批准 Space 作權限及資料分界嘅核心概念，詳見 D-026。Space 模型不取代正式 DB review。

## FR-10 MCP Read-Only

TimeMem 係 MCP client，主動呼叫已批准、allowlisted 嘅 tool/server；預設只准 read-only。第一階段優先本機 read-only connector，例如 allowlisted file、calendar-file import、time／timezone；Cloud tool 只可供公開 POC 或不含真實屋企資料嘅公開查詢。嚴禁將真實姓名、關係、地址、私人內容、附件、Vault、embedding、logs 或 backups 傳去 Cloud MCP。Transport、credential storage、connector allowlist、revoke、milestone 同 data-loss warning 仍待 D-027 follow-up 批准；MCP 不屬 M0。

## Vault

Vault 係獨立安全區，不只是普通私人 Space。只有 Joe 同 Joy 可以 unlock；Ailene 不可直接 access，只可提出 request。身份／旅行證件、民事證明、健康紀錄、保險及敏感財務文件可入 Vault；密碼、seed phrase、private key、2FA secret 等登入秘密不放 TimeMem，完整信用卡 security code 亦不保存。

Vault content 不進普通 semantic embedding、不做 AI summary、不寫入 prompt/log/trace；搜尋只用白名單 title、category 及 tags。敏感內容被判定放入普通 Space 時，系統先 lock/mask 為 Vault candidate，再由已授權用家確認，唔可以靜靜公開。Vault reminders 可以存在，但只顯示非敏感提示，例如「有份重要文件快到期，請解鎖 Vault 查看」。提醒內容、backup key hierarchy、OCR/thumbnail 及 restore policy 仍須通過安全設計 review。

## 提醒分類

提醒分四類：出門前檢查清單、到時提醒、現場即時提醒、逾期跟進提醒。預設候選規則為活動前 60 分鐘第一次提醒、30 分鐘前再次提醒及顯示 checklist；沒有回應時每 10 分鐘重提一次，連續兩次冇回應後停止重複聲音／彈窗並記 `missed`，稍後再用溫和跟進。每個 event/todo 可覆寫。

PWA／server 長開唔等於手機斷網或 PWA 已關閉時仍保證彈出。V1 只承諾 in-app/reachable-device 提醒及重新連線後補回 missed state；offline local alarm 需要手機 OS Calendar/Reminders bridge 或 native companion，兩者屬後續實作，唔可以將 server scheduler 當 OS 保證。

## 架構

- **公開 POC：** Supabase / Cloud，登入方向為 Supabase Auth；只用合成／測試資料。OpenRouter / Railway 係候選，詳細服務同安全設計未定。
- **屋企閉環：** App + Local Postgres + pgvector + Ollama；家庭資料同推理留喺本機。沿用 Node / Express Gateway/Auth、單一應用層 DB access module、內部 Python / FastAPI AI/ML + RAG 服務及 Docker Compose 嘅本機目標架構。POC 唔可以接觸屋企閉環資料或憑證。
- **參考圖片：** 001.png 係 Hybrid AI Web Architecture；002.png 係 Local Development Environment。以圖片實際內容為準；佢哋係架構／開發概念參考，唔代表服務已實作或每個圖示細節已批准。
- pnpm + Turborepo Lite，唔用 Nx。
- M2 embedding 候選改為 `paraphrase-multilingual-MiniLM-L12-v2` 384D，backup 為 `intfloat/multilingual-e5-small` 384D；LLM classification 候選為 `qwen2.5:3b`。以上仍須先用固定 model version/digest、100 個 synthetic case、latency/RAM benchmark 及兩次 repeat pass，先可以作正式 runtime selection。
- Google Auth 只是公開 POC / Supabase Auth 的方向；屋企閉環仍使用 Passkey + PIN。Joe 提議所有 login 轉 Google 已記錄為 D-032 Draft，不是 closed-loop approved auth。

## Space

已批准六個初始 Space：Joe、Joy、Josie、Jolie、Ailene 各有私人 Space，再加一個 Family Shared。新 Item 預設入 Family Shared；登入者可將自己建立或擁有嘅 Item 搬入自己私人 Space，無需其他人批准。Item 同一時間只屬一個 Space，不以 copy 隱藏 duplicate。

將 private Item 搬去 Family Shared 屬提高曝光操作，必須顯示來源／目的、5 秒倒數及第二次確認。將 Item 搬去另一人的私人 Space，需要來源及 destination Space owner 批准。Ailene 預設只見 Family Shared；可 request Vault，但不能直接讀 Vault。Josie/Jolie 嘅 Space 可先由父母代管，帳號 activation 屬後續 Auth milestone。

D-008「Owner Joe 可讀全部」嘅私人內容條款已由 D-033 選 B 收窄：System Admin 唔會自動取得私人內容；只有有明確理由嘅受控讀取，並須先顯示警告及留下 immutable audit log。後續私人 Space/Vault schema/API 必須按呢個規則設計及測試，唔可以沿用舊嘅無限制 Owner access。

## 物理擺位

FUJITSU LIFEBOOK U9311X，企喺鋁合金直立架，喺 ROUTER 隔離。左邊插電，右邊插 LAN，直接 LAN，唔使轉接頭。WIN+L LOCK，合埋蓋 = Do Nothing，唔係 Sleep，唔用 WOL，唔使入 BIOS。

## 唔做嘅嘢

唔賣 Box。屋企閉環版唔用 Supabase / Cloud / OpenRouter / Railway，唔用外部 LLM API Key；真實家庭資料永遠唔入公開 POC。公開 POC 可用 Supabase / Cloud，但只限合成／測試資料；OpenRouter / Railway 仍係候選，未批准具體部署。唔用 WOL / BIOS。唔抄健身宣傳圖。NLP Synonyms 喺 nlp-synonyms.json，唔好 Hardcode。Teach Loop = JOE Notebook。

## 里程碑

M0 清機 → 一鍵安裝 → SET Lock → 企喺 ROUTER 隔離，裝完自動開。
M1 骨架；MCP 方向為 TimeMem outbound read-only client，但 connector/tool/transport、milestone 仍待 detail design。
M2 Input + Search + 理由 + Undo。
M3 相片 + 理由。
M4 備份 + Passkey。
M5 好用 + Face ID。
M6 SHARE：未承諾；範圍同時間 TBD，須另行批准，唔係交付或驗收承諾。README 第一行係新口號。

## 驗收

1. AI 每次提議有理由 + 信心值 + Undo，冇理由唔好入 DB。
2. 手機用 Face ID 入到，唔使記 PIN 都入到。
3. 裝完自動開 http://localhost:3000。
4. 拖 PDF 20 堂一次入，問問題 3-5 秒有答案，相片自動指返 RECORD。

## IDEA 備註（未批准；S1–S10 保持不變）

- 首頁構想：中央放一行輸入，周圍以隨機相片作背景；滑鼠停留時彈出記憶回顧卡片，作為 S6 相片故事卡片體驗的補充想法。
- 以手機左右掃動切換頁面；每頁按主題使用一種顏色，例如相片頁紅色、證書頁綠色、財務頁藍色。
- 構想上每頁由一個 Agent 配一個 Skill 負責，頁面之間以 Link 串連；例如證書連到相片，相片再連到財務（如 HKT 續約 $88／月），並保留可延展的循環連結方向。具體頁面、連結圖及責任邊界未定。
- Multi-Agent 只預留為概念，不代表現階段實作；新增頁面應以毋須大改整體設計為方向。
- 本備註只記錄 IDEA，不批准功能、架構、里程碑或 Finance 分析範圍；D-025 對 Finance statistics/analysis 為 Later、phase TBD 的描述維持不變。S1–S10 及所有已批准決策不變；不授權程式碼、schema 或 migration 工作。
