---
title: TimeMem 現行系統架構
date: 2026-11-27
type: ARCHITECTURE
status: Canonical
---

<!--
性質：現行架構唯一規範
用途：鎖定 M1 閉環、雙機硬體拓撲、組件邊界及生產資料主權
邊個叫開：Joe
幾時可刪：架構正式由新 Canonical 文件取代並經 Joe 批准
-->

# TimeMem 現行系統架構

## 最高架構準則

本文件與 [README.md](../README.md)、[PRD.md](./PRD.md)、[GATE.md](./GATE.md)、[DECISIONS.md](./DECISIONS.md) 一起構成現行規範。歷史草稿、舊架構圖、`docs/working/`及 `docs/archive/` 不得覆蓋本文件。

## M1 唯一資料閉環

```text
PWA 圖片上傳
  -> FastAPI Multipart Upload
  -> 本地 Ollama qwen3:8b（Vision / OCR）
  -> 本地 Ollama bge-m3（embedding）
  -> PostgreSQL pgvector 寫入／檢索
  -> FastAPI 結果判定
  -> PWA 彈出式 RESULT 框
```

- 圖片上傳、OCR、embedding、向量寫入／檢索及 PWA RESULT 都屬同一 M1 關鍵閉環。
- FastAPI 喺核心閉環內負責圖片接收及所有業務協調；PostgreSQL 只由經授權嘅應用層存取。
- M1 初期只用合成／測試資料；未經批准不得擴張真實資料、正式 schema 或雲端範圍。

## 雙機硬體拓撲

兩部機均為 **Fujitsu Lifebook U9311X**：Intel Core i7-1165G7、2.80GHz、16.0 GB RAM、Intel Iris Xe Graphics、477 GB NVMe SSD。

| 主機 | 作業系統／磁碟 | 現行責任 |
|---|---|---|
| `JOE-DESKTOP` | Windows 10；僅 C 槽 | 隨身開發；於 `C:\Project\TimeMem` 使用 VS Code、GitHub Copilot、MAI LLM 開發及 GitHub 同步；透過 Tailscale RDP 操控 Server。 |
| `JOE-SERVER` | Windows 11；C 槽及 D 槽 | 家中主力機；目前按需開機、目標 7x24。`C:\Project\TimeMem` 同步 Repo；`D:\docker-data\timemem\`（`docker-compose`、`pgdata`、`model`）執行 PostgreSQL + pgvector + Ollama。唯一可寫生產資料庫主機。 |

網絡與存取規則：

- 所有遠端存取只經 Tailscale VPN 內網。
- Desktop 不可成為第二可寫 Primary，亦不可同步生產 DB。
- 嚴禁開 Router Port；對外入口及 DB/API/model endpoint 不得公網暴露。
- JOE-SERVER 唯一擁有生產資料庫寫入權；家中資料不得送往公開 POC 或外部 LLM。

## 組件邊界

| 組件 | M1 邊界 |
|---|---|
| React PWA | 圖片上傳、顯示檢索結果及彈出式 RESULT 框；不得直連 PostgreSQL。 |
| FastAPI | 唯一 M1 核心應用服務；處理 Multipart Upload、Vision/OCR、bge-m3、pgvector 查詢／寫入及回傳結果。 |
| Ollama | JOE-SERVER 本地執行 `qwen3:8b` 及 `bge-m3`；不得 fallback 外部 LLM。 |
| PostgreSQL + pgvector | 生產資料庫只存在 JOE-SERVER Docker 生產環境；唯一可寫資料主機。 |
| n8n | Port `5678` 本地 Docker 後勤外掛／外部觸發器；可接收 FastAPI Webhook，嚴禁直連或直接寫入 PostgreSQL。 |
| Obsidian | Hold（暫緩）；`C:\Project\Obsidian-Hub` 只作設計參考；禁止編寫 M1 整合程式碼。 |

## Legacy 防污染

- Node.js / Express Gateway、Express API Gateway、DAO 及雲端 Supabase 架構構想僅屬歷史 POC 草稿。
- 佢哋唔代表 M1 現役資料流，亦不得重新成為資料庫唯一入口或核心業務權威。
- 舊 Obsidian 雙向橋接／同步構想亦為 Hold，不得繼續實作。

## Self-Host 商業邊界

- 100% Self-Host、資料不出雲係絕對私隱底線。
- 應用層可集中維護及未來複製；生產資料庫由各家庭自行擁有及 Self-Host。
- 未來多家庭複製時仍必須維持相同資料主權、tailnet 隔離及禁止直連資料庫規則。
