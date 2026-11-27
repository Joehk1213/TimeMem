---
title: TimeMem M0／M1 Gate Canonical
date: 2026-11-27
type: GATE
status: Canonical
---

<!--
性質：Gate 狀態及驗收規範
用途：鎖定 M0 歷史通過證據、M1 目前範圍及下一輪驗證流程
邊個叫開：Joe
幾時可刪：Gate 流程正式停用並由新 Gate Canonical 取代
-->

# TimeMem Gate 狀態

## 目前階段

- **M0：PASS**；於 2026-11-23 經 Joe 正式批准。
- **M1：進行中**；現行 Priority 1 只限下列唯一閉環：

```text
PWA 圖片上傳
  -> FastAPI Multipart Upload
  -> 本地 Ollama（qwen3:8b Vision/OCR + bge-m3 embedding）
  -> PostgreSQL pgvector 寫入／檢索
  -> PWA 彈出式 RESULT 框
```

## M1 Gate 鐵律

- 必須使用合成／測試資料完成最小閉環，不得先擴展真實資料、正式 schema 或雲端範圍。
- JOE-SERVER 為唯一可寫生產資料庫主機；JOE-DESKTOP 不可成為第二 Primary。
- 所有遠端存取只限 Tailscale；嚴禁開 Router Port。
- Obsidian 為 **Hold**，禁止編寫整合程式碼。
- n8n（Port `5678`）只作後勤自動化外掛／外部觸發器；可接收 FastAPI Webhook，但嚴禁直連或直接寫入 PostgreSQL。
- Node / Express Gateway、雲端 Supabase及其他舊 POC 架構不得重新進入現役 M1 主線。
- `docs/working/` 必須排除於 Cold Start；未批准草稿只可歸檔至 `docs/archive/`。

## 雙機及硬件 Gate

- JOE-DESKTOP：Windows 10、僅 C 槽、`C:\Project\TimeMem`；VS Code、GitHub Copilot、MAI LLM；用 Tailscale RDP 操控 Server。
- JOE-SERVER：Windows 11、C 槽加 D 槽、`C:\Project\TimeMem`；`D:\docker-data\timemem\` 的 Docker Compose、`pgdata`、`model` 部署 PostgreSQL + pgvector + Ollama。
- 兩部機同為 Fujitsu Lifebook U9311X：i7-1165G7 @ 2.80GHz、16 GB RAM、Intel Iris Xe、477 GB NVMe SSD。

## M1 驗收項目

1. PWA 圖片上傳可經 FastAPI Multipart Upload 正常接收。
2. 本地 `qwen3:8b` 完成 Vision / OCR；本地 `bge-m3` 完成 embedding。
3. 結果可寫入及檢索 PostgreSQL pgvector。
4. PWA 彈出 RESULT 框並正確顯示結果；無結果有清楚提示。
5. 全程不使用外部模型、雲端資料庫或公開資料端點。

## Cold Start Gate

- `cold-start-pack.ps1` 必須疊加工作樹後過濾 `docs/working/`，並掃描路徑及 Secret。
- 最新 ZIP 必須為 `C:\Project\TimeMem-clean.zip`，資安掃描為 0 路徑違規／0 Secret 命中。
- 新對話如未精準重申 M1 閉環、雙機拓撲、Obsidian Hold、n8n 禁直連 DB及 Canonical 同步，仍不得視為通過。
- 第一次、第二次及第三次考牌分數分別為 68、87、65；未鎖定上述事項前，不得宣稱新對話理解滿分。
- 文件同步及 Git Commit 完成後，執行最新一輪 cold-start 打包並進行滿分覆核。
