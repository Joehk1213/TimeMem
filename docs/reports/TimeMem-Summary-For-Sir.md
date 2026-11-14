# TimeMem 項目總結：俾阿 Sir 過目

**日期：** 2026-11-15（同日晚上已更新：加入 Luna 去重 Audit 結果）
**狀態：** M0 Review 完成，M0 仍然 Draft / NOT APPROVED，等 Joe 最終批准
**更新：** 2026-11-15 晚上，Luna 做完唯讀去重 Audit，冇刪、冇搬、冇改任何檔案。以下第 7 節已更新，加入 Audit 結果，令阿 Sir 睇到嘅版本係最新。
**來源：** 001.png、002.png、原構思 IDEA.txt、REVIEW.txt、TimeMem-PRD-Detail-Review.html，另加 TimeMem LIST / TREE 檔案結構檢查
**用途：** 一頁總結，方便阿 Sir 快速判斷 M0 係咪可以批，之後仲爭咩

---

## 1. 一句話講晒 TimeMem 係咩

**中文名：** 時光管家
**英文名：** TimeMem
**中文 Slogan：** 守護每一刻時光
**英文 Slogan：** Remember what matters.
**副標：** 拒絕月費、拒絕雲鎖定、打破屋企資料壟斷、免費 AI 屋企助手

**定位：** 個人化工具，保留可擴展性，可以複製俾所有人用，唔只限家庭。
**初心：** 為屋企而做。做得到、做得好，自然可以 SHARE 俾人，甚至變成商品。
**SHARE 意思：** 有制成品後，可以複製俾人用。

**核心原則，Joe 已拍板：**
Real data NEVER 離開屋企。POC 可以用 Cloud，正式版要閉環。

**故事起因：** 小朋友放完長假期，第二日返學唔記得要默書。Joe 想做一個家居總管全能系統，ALL IN ONE，重點係要 self host。

---

## 2. 原構思 IDEA.txt 講咩

原構思要做嘅功能，歸納做 4 大塊：

**智能家居總管 + 個人知識庫 + 財務管理 + 記憶時光機**，再加超有感覺嘅相片互動效果。

具體包括：
- Vector DB、RAG Search
- 彈出提醒事項
- 日曆行事紀錄、To Do List
- 相片收納、證書收納、證件收納、財務收納、財務統計、財務分析
- 記憶回顧 Random：時、人、地、事、相片，背景相片隨機移動、隨機放大縮小，Mouse 放上去停低，彈出記憶回顧卡片，Mouse 離開還原

**商業考量：** Joe 負責前台後台 application DB，如果要 self host，User 自己負責 DB。因為初心係 security concern，唔想上 Cloud，所有資料閉環，咁就一定安全，資料唔會外洩。呢個係 selling point。

**實施環境：**
- 2 部 FUJITSU LIFEBOOK U9311X，硬件一樣：11th Gen i7-1165G7，16GB RAM，477GB NVMe
- JOE-DESKTOP：跟身開發機，Windows 10，淨係得 C:
- JOE-SERVER：放屋企，Windows 11，有 C: 同 D:，用嚟 self host 真 DB，暫時未 7x24 運作，用先開機
- 用 GitHub 互相 File Sync
- POC DB 係 Supabase Cloud

---

## 3. REVIEW.txt：Joe 親自答嘅 7 條問題

### 3.1 Vision 同定位
Joe 確認：個人化工具，保留可擴展性，可複製俾所有人用，唔只限家庭。Real data NEVER 離開屋企，POC 可以用 Supabase。Slogan 中英都要保留。SHARE 係有制成品後可以複製俾人用。

### 3.2 Scope：10 點滿意清單 S1-S10，全部要留
S1-S10 全部保留。提醒、Calendar、TODO、相先做。證件、文件 M1 / M2 先做。

- **TODO：** 俾自己記住要做咩，隨時開嚟睇。例如：call 管理處執修、帶毛巾返公司、搵返 10 月份 Excel
- **Calendar：** 真係當日行程。例如：星期四放工後鑽石山上堂 8 至 10pm 到 12 月 10 日、11 月 22 日帶小朋友出 show
- **Finance：** 每日紀錄開支小習慣，要一頁計總開支、週結、月結，加每月必須開支：電話費、上網費、管理費、按揭、水電煤、差餉、保險、工人姐姐薪金，變圖表，一鍵睇晒
- **相片：** 日常生活、趣事、回憶總目錄
- **證件：** 一家 4 口加工人姐姐，所有重要個人資料：身份證、Passport、回鄉證、出世紙、結婚紙、針卡、母嬰健康、病歷
- **證書：** 小朋友學過嘅嘢，興趣班、跆拳道、跳舞、打鼓、比賽獎狀，全部 scan 入電腦做 record。例如問：阿囡對上一次跳舞比賽幾時，咩成績，彈記憶回顧卡片加相片互動
- **文件：** 網上碌到想紀錄嘅事、link、file，要一個 centralization 加智能搵返，VectorDB 加 RAG。阿 Sir Reading App 係好參考

**痛點，Joe 特別強調唔好忽略：**
Joe 被標籤為經常遺忘事情嘅爸爸。例如：
- 阿囡打鼓表演舉手機 3 分鐘冇影到 Video，被媽媽放 FB / IG 笑
- 上打鼓班唔記得帶鼓棍、跳舞班唔記得帶舞鞋、跆拳道班唔記得帶色帶、游水唔記得帶泳帽、補習唔記得帶外套
- 工人姐姐準備好，但 Joe 冇 double check 都入 Joe 數
- 所以彈出提醒事項功能一定要做，係核心痛點，唔可以拖後

### 3.3 唔做清單：由唔做變遲做 / TBC
- **Finance 統計 / 分析：** 最終制成品要做，唔係最高 Priority，Phase TBD
- **Smart home manager：** 唔知點定義，唔識判斷，TBC
- **Multi-Agent：** scalability 問題，optional，現階段未必需要，但要預留 concept，將來可以補上唔使大改。預留好過將來夾硬加。參考阿 Sir Reading App：幾個 agent，防惡意消耗、防幻覺、防作嘢、loop 完先準
- **Cloud / Supabase / OpenRouter / Railway：** POC 值得做，應該要做

### 3.4 TECH 架構：最大衝突，分兩邊
Joe 拍板分兩邊：
- POC 資料可以放上網，User 可以試用得到
- 自用就緊係閉環做 self DB，資料唔外洩，最終目標
- 架構跟阿 Sir 001 同 002 圖
- 技術分兩 part：一 part 可以放上網，另一 part self host

### 3.5 Data 加安全
- **登入：** 公開版用 Supabase Auth，閉環版用 PIN 加 Passkey Face ID
- **AI 建議：** 每建議要有原因加信心加 Undo
- **MCP：** 新增 FR-10 MCP Read-Only，Joe 唔肯定點應用，下星期四上堂先教點用 / 設計，harness engineering
- **Space / 資料分界：** 唔識點定義，TBC
- **Backup 加密：** age 加 Argon2 講得通。Joe 唔識點測試，要幫手諗掂
- **6 張 tables 夠唔夠：** Joe 唔知，要意見。係指 DB 6 個 Table：User、Space、Item、Asset、Reminder、Embedding

### 3.6 M0 範圍
- 隨時可以開始，只要長開屋企部 JOE-SERVER 就可以開波。8 點已經重裝過部機，Windows 11 C: 同 D:。過去幾個月 develop 過兩個已停嘅 repo，暫時熄咗機
- PWA shell 喺 M0 做到邊個位：叫 Luna 決定。最終要做成完成品，Joe P0 試用，再 UAT 俾其他 user 用，先拎到真實數據
- Tailnet 測試寫入 M0：入到加唔入到都要試

### 3.7 物理加 Deploy
- 2x FUJITSU LIFEBOOK U9311X、JOE-DESKTOP、JOE-SERVER 維持不變
- 公開版繼續 Cloud / Supabase / OpenRouter / Railway
- 閉環版 JOE-SERVER 擺鋁架，擺 Router 隔籬，開 Docker 3 containers
- Develop 階段 CONFIG JOE-SERVER：合蓋加插火牛加擺鋁架棟起身加插 LAN 線加長開。WIN+L LOCK 加關蓋等於 Do Nothing
- Folder 參考阿 Sir Repo：backend / database / frontend / gateway
- 唔搞 BIOS，唔用 WOL

---

## 4. 兩張架構圖 001.png 同 002.png

### 4.1 001.png：Local Development Environment，Dev profile
- 一部 Laptop，入面一個 Docker Container，入面有 Frontend、Backend、Database 三格
- 下面一個 Developer
- 意思：本地開發用一個 Container 裝晒三樣，Developer 喺下面開發

### 4.2 002.png：Hybrid AI Web Architecture，Target profile
- Frontend UI：User、Administrator
- 中間：Node.js (Express) API Gateway 加 Auth，入面有 User Authentication、Role Based Authorization、API Routing / Proxy、Web Socket、CRUD Endpoints
- 左下：Database，Structured Table 加 Vector (Embedding)
- 右上：Python (FastAPI) AI/ML Microservice，LangChain Agent、Custom Python Logic、Python Library
- 右下：Python (FastAPI) RAG Agent Service，LangChain Agent、Vector Extension、Custom RAG Logic
- 意思：正式架構係 Hybrid，Node.js 做 Gateway，加兩個 Python FastAPI 服務做 AI 同 RAG，加 DB 做 Structured 同 Vector

### 4.3 兩張圖點解唔打架
Joe 已拍板：001 同 002 唔打架，係 Dev 同 Target。001 係點開發，002 係最終想點行。M0 唔需要做晒 002 嗰啲，M0 只做 Shell 加連通。

**重要提醒，唔好誤會：**
002 圖有 Auth、DB、RAG、Vector，唔等於 M0 要做晒。M0 故意唔做 Login、唔做 DB、唔做真資料。如果而家因為睇到呢張圖就話 M0 未完，要加返晒入去，就係 Scope Creep。

---

## 5. TimeMem-PRD-Detail-Review.html 一頁 Record 講咩

呢份 HTML 係將原 IDEA、PRD V10 Final、PRD V10.1、Joe Review (REVIEW.txt)、最新 M0-READY.md、001.png、002.png 對比後嘅拍板加仲爭咩。

**已拍板，CR-004 / D-025 建議：**
- Two-track：POC 公開版 (Supabase / Cloud) 加閉環版 (Local Postgres 加 pgvector 加 Ollama)
- Finance 統計等於 Later，Phase TBD
- Smart home TBC
- Multi-Agent 預留 concept
- Space TBC
- MCP 等上堂

**要 Update 嘅文件：** DECISIONS、ARCHITECTURE、RISKS、M0-READY、REQUIREMENTS、TEST-PLAN
**要答嘅問題：** 6 張 tables 夠唔夠，加 Backup 點測試
**M0 範圍不變：** 5 項加 Tailnet 加 PWA shell
**唔做：** 唔寫 code，唔做 migration / schema，唔 commit
**舊 review 變歷史：** 要再 review

**M0 現狀喺嗰陣：** Draft / NOT APPROVED。CR-002 / D-023：PRD 5 項加 Tailnet 加 PWA shell。CR-003 / D-024 之後要再 review，Skill 實測、獨立 review、Joe 批准全部 Pending。JOE-SERVER 未有實機證據。

---

## 6. M0 而家最新狀態：2026-11-15

呢部分係用最新 M0-READY 加 Review 檔案補上，俾阿 Sir 知 M0 已經行到邊。

### 6.1 M0 證據，12 張齊晒
- Router 單一轉寄：0 條，NAS 嗰條已 DELETE，唔係 Disabled
- 範圍轉寄：空，範圍觸發：空
- DDNS：停用，DMZ：OFF
- Firewall：IPv4 / IPv6 SPI 已啟用，IPv6 Port Services 空
- Administration：UPnP 已熄，呢個 Firmware 冇 Remote Management 呢格，唔係漏咗
- 非 Tailnet：LTE 開 Tailnet 網址，Safari 搵唔到伺服器，2026-11-14 22:52
- Tailnet：LTE 開到 M0 PWA Shell，冇 Login / 冇資料，2026-11-14 11:23
- Tailscale 狀態：ON 等於已連線，OFF 等於未連線，11:40
- 裝置：iPhone 11 Pro，iOS 27.2.1，Safari，個人名已遮，冇 Serial / IMEI

### 6.2 Review 結果，由 4 Major 到 0 / 0 / 0
- 第一次 Independent Review：4 Major / 2 Minor
- 中間：1 Major / 2 Minor，REQ-007 未有證據
- Luna Review 2026-11-15：PASS WITH MINOR FINDINGS，0 / 0 / 2
- 第三方 Final Re-Review 2026-11-15 Current State Only：0 Critical / 0 Major / 0 Minor
- REQ-006 PASS，REQ-007 PASS，R-005 Closed，Luna Review Complete，D-014 三樣齊

### 6.3 M0 仲未批
- M0 仍然 Draft，Owner Joe final approval：NOT APPROVED
- 只有 Joe 一個人可以批，Joe 講 M0 APPROVED 先至算
- 呢份 Summary 唔等於 M0 已批

---

## 7. 檔案結構：TimeMem LIST / TREE 加 Luna 去重 Audit（已更新）

用 TimeMem-LIST.txt 同 TimeMem-TREE.txt 數過，再加 Luna 2026-11-15 晚上唯讀去重 Audit：

- 總行數 1312 行，扣返 .git 自己嘅 608 個內部檔，真正 Project 檔案約 700 個
- 其中約 635 個係 Skills，TimeMem 自己得返約 69 份
- docs 已經執靚：Gate 6 份喺根目錄，加 reviews / prd / working / archive / evidence / reports
- DEVELOP 仲未開始：src 0、package.json 0、Dockerfile 0、docker-compose 0、node_modules 0、dist 0，冇 Code 可以去重，好事嚟

### 7.1 Skills 雙份，唔係錯，唔好手動刪（Audit 新發現）
- `.agents/skills` 先係正本，Source of Truth，`scripts/sync-skills.ps1` 明確指定佢為唯一來源
- `.github/skills` 係自動產生嘅 Mirror，俾 GitHub Copilot / Code Review 用。唔好手動編輯或者刪除 Mirror，同步腳本會先刪除目標目錄再重建，刪咗都會生返出嚟
- 正本都唔可以隨意刪除，任何變更要等 Joe 批准
- 細位：`skills-lock.json` 有記 skill 同 hash，但目前同步腳本冇讀佢，規則係由腳本定義

### 7.2 兩個 README 唔係重複
- 根目錄 `README.md`：保留做 Project 介紹同入門入口
- `docs/README.md`：保留做 docs 文件索引
- 兩個分工唔同，唔好合併，唔好刪其中一個。部分連結仲指向舊位置，日後如果獲批整理，要同步更新連結同索引

### 7.3 reference 同 docs/prd 唔係真重複（Audit 做咗 SHA-256 比對）
- 對 `reference` 同 `docs/prd` 嘅檔案做 SHA-256 比對，冇一個檔案係完全相同
- 而家睇到嘅係主題重疊或者唔同版本，唔係可確認嘅完全重複檔
- `reference/README-HOME-HUB-OVERVIEW.md` 嘅 Home Hub 介紹、滿意清單同安裝概念，同 `docs/prd/TimeMem-PRD-V10-2.md` 有內容重疊，但佢標明係舊 Root README 搬嚟，屬歷史版本，唔應該當成可直接刪除嘅副本
- `reference/README.md`、`Architecture.jfif`、`Structure.jfif` 同 `docs/prd/原構思 IDEA.txt` 有舊構想 / 架構上嘅關聯，要保留歷史定位，圖片唔好同說明索引分開搬，除非同步修好相對連結
- 如果 Joe 之後批准搬移：先盤點所有 inbound links，再同一個變更更新連結同索引，可以喺舊路徑保留指引頁。呢次 Audit 冇搬移

### 7.4 Gate 6 份同 evidence：大小一樣，但 Git 未追蹤，要講清楚限制
- 6 份 Gate 而家喺 `docs` 根目錄，大小同上次盤點一模一樣：REQUIREMENTS 4801、DECISIONS 36824、ARCHITECTURE 27339、TEST-PLAN 8391、RISKS 6180、M0-READY 22553
- `docs/evidence` 而家 12 個檔案，合計 896197 bytes。實際 evidence 目錄係 `docs/evidence`，唔係 repo 根目錄嗰個 `evidence`
- 限制，要老實講：6 份 Gate 同 `docs/evidence` 而家都係 Git 未追蹤檔案，冇 HEAD 版本可以比較。所以可以確認目前位置同大小，但唔可以證明大小相比之前冇變。只可以講「自從上次盤點之後冇變過」，唔可以講「由始至終冇變過」
- 呢次 Audit 冇改動佢哋

**結論：** 覺得多 Files，唔係 TimeMem 多，係 Skills 多。TimeMem 自己唔亂，docs 已經執靚，唔使再去重。

---

## 8. 仲爭咩，俾阿 Sir 拍板

### 8.1 M0 本身：唔爭嘢，可以批（Audit 冇發現新 Major）
- REQ-001 到 REQ-007 已經 PASS，0 / 0 / 0，12 張證據齊，3 份 Review 齊
- 專業意見：M0 係完，唔使加，唔使改，可以直接批

### 8.2 之後要決定，唔係 M0 入面做
- **Two-track 正式記低：** POC 公開版加閉環版，要記入 DECISIONS / ARCHITECTURE，唔好只係口頭講
- **6 張 tables 夠唔夠：** User、Space、Item、Asset、Reminder、Embedding，要阿 Sir 意見
- **Backup 點測試：** age 加 Argon2 點樣先算測到，要方法
- **Space 點定義：** TBC，點分界要定
- **MCP 點用：** 等上堂，harness engineering，唔好而家估
- **Multi-Agent 預留：** 預留 concept 就夠，唔好而家做晒
- **Finance Phase：** Later，Phase TBD，唔好入 M0

### 8.3 俾阿 Sir 嘅問題
1. M0 0 / 0 / 0，係咪可以批？
2. Two-track 方向係咪啱？
3. 6 張 tables 夠唔夠，Backup 點測試，阿 Sir 有冇建議？

---

## 9. 來源清單

- 001.png：Hybrid AI Web Architecture，Target profile
- 002.png：Local Development Environment，Dev profile
- 原構思 IDEA.txt：Joe 原始構思，TimeMem 願景、Tech Stack、實施環境
- REVIEW.txt：Joe 親自答嘅 7 條問題，Vision、Scope、唔做清單、TECH、Data、M0、物理
- TimeMem-PRD-Detail-Review.html：一頁 Record，對比後拍板加仲爭咩
- TimeMem-LIST.txt / TimeMem-TREE.txt：檔案結構檢查，確認 docs 已執靚、DEVELOP 未開始

**備註：** 呢份係 Summary，唔係 M0 批准文件。M0 批准權只喺 Joe 手上。
