# TimeMem — PRD V10.1

> 版本：V10.1，日期：2026-11-09
> 基於 V10 Final，加咗 openGym 借鏡 5 點，唔係重寫。
> 定位：個人化工具，唔係商業賺錢產品。Real data NEVER 離開屋企。

## 口號

**TimeMem — 拒絕月費、拒絕雲鎖定、打破屋企資料壟斷、免費 AI 屋企助手。**

## 係咩

TimeMem 係屋企嘅時間 + 記憶 + 證件 + 相片，全部喺一個平台，入 DB 簡單，Search 快。

舊電腦翻新，好似 ROUTER 咁，長開喺屋企，做屋企個人整合中心，好似 NAS 咁，多一樣長插電嘅電子產品。

## 10 個滿足點

### S1 拖 PDF，20 堂一次入
拖學校興趣班時間表 PDF (1 年) → Prompt「係咪想紀錄行事曆」→ Preview 20 堂 → Confirm → 20 Items + 提醒 + Embeddings。
Preview 嗰陣，每堂要寫理由，例如「第 3 堂係 11 月 15 日，因為 PDF 第 2 頁第 3 行寫咗」。

### S2 問問題，3-5 秒有答案 + 理由 + Undo
問「下一堂滑板班幾時？」→ RAG 答。
每次 AI 提議 / 每次改 DB，都要帶 3 樣：
1. 理由：點解咁估，例如「因為 EXIF 嗰日同滑板班同一日，所以估係嗰堂」。
2. 信心值：例如 0.82，低過 0.6 就要問，唔好靜靜入。
3. Undo：Confirm 咗之後，30 秒內可以一撳 Undo，DB 還原。AI 唔可以直接改 DB，唔可以直接刪。

### S3 相片自動指返 RECORD
相片 EXIF 日期同 RECORD 同一日，自動建議 Link。建議要寫理由「因為相片係 2026-11-09 影，同滑板班同一日」，用家 Confirm 先 Link，唔啱就撳「唔係呢個」，系統記低，下次唔再估錯。

### S4 NAS / 舊電腦一鍵安裝，裝完自動開
Install-OneClick.ps1 → docker compose up -d 之後，自動做 3 樣：自動檢查起咗未、自動開 http://localhost:3000、自動話「起咗啦」。

### S5 備份 / 還原一鍵
一鍵備份 → 一個 File。一鍵還原 → 揀 File → 還原。備份 File 要寫明日期 + 有幾多 Items + 有幾多相。

### S6 生動相片牆背景 + 卡片回顧
相片牆輪播，唔好同一張相連續 3 日出，唔好同一模板連續 2 日出。每張相有故事卡片，Cantonese 寫法。

### S7 好用，家人唔使問 JOE，登入加 Passkey
PIN + Passkey 兩樣都有。手機開 TimeMem，可以用 Face ID / Touch ID / 指紋入，唔使記 PIN。PIN 留返做後備，6 位 PIN，錯 5 次鎖 5 分鐘，錯 10 次聯絡 Admin。第一次開，要教屋企人「用 Face ID 就入到啦」。

### S8 人咁嘅，Cantonese + 中英夾雜都明
Input 層分 RECORD 定 SEARCH，3 層：Rules → Embedding Similarity → Ollama 分類。每次分類都要出信心值，低信心就喺問嗰一刻問「係咪想紀錄定想搵嘢？」。

### S9 唔明就問，唔好估
唔止 NLP，PDF、相片、提醒，全部低信心都要問。問嘅時候要帶理由 + 信心值 + 2-3 個選擇。

### S10 越用越啱我，JOE Notebook + Undo
用家教系統，系統越嚟越準。每次教完，寫入 teach-log.md 一行，JOE 直接改 nlp-synonyms.json，Commit，2 分鐘。教錯咗可以 Undo。

## 新功能 FR-10 MCP Read-Only
只讀，唔俾寫。俾 Copilot / AI 讀 Items，唔俾改 DB。工具：search_items、get_item、list_recent，3 個就夠。

## 架構
App + DB (Local Postgres + pgvector) + Ollama (bge-m3 + qwen3:8b) + MCP Read-Only (新，只讀，optional)
pnpm + Turborepo Lite，唔用 Nx。

## 物理擺位
FUJITSU LIFEBOOK U9311X，企喺鋁合金直立架，喺 ROUTER 隔離。左邊插電，右邊插 LAN，直接 LAN，唔使轉接頭。WIN+L LOCK，合埋蓋 = Do Nothing，唔係 Sleep，唔用 WOL，唔使入 BIOS。

## 唔做嘅嘢
唔賣 Box。唔用 Supabase / OpenRouter / Railway / Cloud。唔用 WOL / BIOS。唔用外部 LLM API Key。唔抄健身宣傳圖。NLP Synonyms 喺 nlp-synonyms.json，唔好 Hardcode。Teach Loop = JOE Notebook。

## 里程碑
M0 清機 → 一鍵安裝 → SET Lock → 企喺 ROUTER 隔離，裝完自動開。
M1 骨架 + MCP 起到。
M2 Input + Search + 理由 + Undo。
M3 相片 + 理由。
M4 備份 + Passkey。
M5 好用 + Face ID。
M6 SHARE，README 第一行係新口號。

## 驗收
1. AI 每次提議有理由 + 信心值 + Undo，冇理由唔好入 DB。
2. 手機用 Face ID 入到，唔使記 PIN 都入到。
3. 裝完自動開 http://localhost:3000。
4. 拖 PDF 20 堂一次入，問問題 3-5 秒有答案，相片自動指返 RECORD。
