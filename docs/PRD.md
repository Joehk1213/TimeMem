# TimeMem — PRD Canonical

**Version: 10.3 Canonical Sync**  
**Status: Canonical**  
**Date: 2026-11-27**

<!--
性質：產品需求唯一現行規範
用途：鎖定品牌、願景、M1 驗收及未來功能邊界
邊個叫開：Joe
幾時可刪：產品願景正式由新版 PRD 取代並經 Joe 批准
-->

## 品牌及初心

- 中文名：**時光管家**
- 英文名：**TimeMem**
- 主 Slogan：**守護每一刻時光**
- 英文 Slogan：**Remember what matters.**

緣起於小朋友放長假後忘記默書嘅痛點。產品目標係打造一個家庭全能系統，整合：

- 智能家居總管
- 個人知識庫
- 財務管理
- 記憶時光機：相片隨機移動／縮放，懸停時彈出記憶卡片

核心商業考量係 100% Self-Host、資料絕不送出雲端；應用層由我們維護，生產資料庫由家庭用戶自行 Self-Host 擁有，保留未來複製推廣至其他家庭嘅潛力。

## M1 現役範圍

M1 唯一有效閉環：

```text
PWA 圖片上傳
  -> FastAPI Multipart Upload
  -> 本地 Ollama qwen3:8b Vision / OCR
  -> 本地 Ollama bge-m3 embedding
  -> PostgreSQL pgvector 寫入／檢索
  -> PWA 彈出式 RESULT 框
```

驗收重點：

1. PWA 可以選取並上傳圖片。
2. FastAPI 透過 Multipart Upload 接收圖片。
3. JOE-SERVER 本地 Ollama 使用 `qwen3:8b` 做 Vision／OCR，使用 `bge-m3` 建立 embedding。
4. 結果寫入／檢索 PostgreSQL + pgvector。
5. PWA 彈出 RESULT 框，顯示檢索結果；無結果時清楚提示。

M1 初期只處理合成／測試資料；未經批准不得擴展真實家庭資料、正式 schema、PDF、雲端部署或外部資料來源。

## 真實雙機部署

兩部機均為 Fujitsu Lifebook U9311X：Intel Core i7-1165G7 @ 2.80GHz、16.0 GB RAM、Intel Iris Xe Graphics、477 GB NVMe SSD。

- **JOE-DESKTOP**：Windows 10、僅 C 槽。隨身攜帶；於 `C:\Project\TimeMem` 使用 VS Code、GitHub Copilot、MAI LLM 開發及 GitHub 同步；透過 Tailscale VPN 使用 RDP 操控 JOE-SERVER。
- **JOE-SERVER**：Windows 11、C 槽加 D 槽。家中主力機，目前按需開機、目標 7x24；`C:\Project\TimeMem` 同步 Repo；`D:\docker-data\timemem\` 包含 Docker Compose、`pgdata`及 `model`，承載 PostgreSQL + pgvector + Ollama。
- JOE-SERVER 為唯一可寫生產資料庫主機；Desktop 不同步或並行寫入生產 DB。
- 所有遠端存取只限 Tailscale；嚴禁開 Router Port。

## 組件與防污染邊界

- **Obsidian：Hold（暫緩）**；`C:\Project\Obsidian-Hub` 只作設計參考，不參與 M1 關鍵閉環，禁止編寫 Obsidian 整合程式碼。
- **n8n：** 本地 Docker 後勤外掛／外部觸發器（Port `5678`），可接收 FastAPI Webhook；嚴禁直連或直接寫入 PostgreSQL。
- Node.js / Express Gateway、雲端 Supabase及其他早期 POC 架構只屬歷史草稿，絕非 M1 現役主資料流。
- `docs/working/` 草稿不得進入 Cold Start；強制歸檔至 `docs/archive/`。

## 核心使用場景

- 相片上傳後抽取文字、人物、時間、地點及活動。
- 系統用本地 embedding 建立／檢索記憶，並以 PWA 彈出式卡片回顧。
- 家庭成員可透過 Tailnet 存取；任何真實資料不得送去公開 POC、外部 LLM 或雲端。
- 財務、智能家居、認證、Vault、PDF、知識庫及分享能力可作未來里程碑，但唔代表已納入 M1。

## 未納入 M1

智能家居控制、財務分析、Face ID、Vault、PDF 批量匯入、公開 POC、雲端部署、mcp、複雜 Multi-Agent、Obsidian 整合及其他未批准功能均不在 M1 首輪閉環內。完成最小圈並 PASS 前，不得擅自新增範圍。
