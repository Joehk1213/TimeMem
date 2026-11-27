# 時光管家 / TimeMem

**守護每一刻時光**  
**Remember what matters.**

TimeMem 緣起於小朋友放長假後忘記默書嘅痛點，目標打造家庭全能系統：智能家居總管、個人知識庫、財務管理，以及具相片隨機移動／縮放、懸停彈出記憶卡片嘅記憶時光機。

## 專案願景與私隱閉環

- 堅持 **100% Self-Host、資料不出雲**；所有家庭資料、模型輸入、embedding、相片及備份只留喺家中可控環境。
- 應用層由 TimeMem 維護；生產資料庫由家庭用戶自行 Self-Host 擁有，保留未來複製推廣至其他家庭嘅商業潛力。
- 合成／測試資料及公開 POC 只可與家庭閉環物理及憑證隔離；任何雲端 Supabase／OpenRouter／Railway 設計只屬早期 POC 歷史草稿，唔係現役主線。

## M1 唯一技術閉環

```text
PWA 圖片上傳
  -> FastAPI Multipart Upload
  -> 本地 Ollama（qwen3:8b Vision/OCR + bge-m3 embedding）
  -> PostgreSQL pgvector 寫入／檢索
  -> PWA 彈出式 RESULT 框
```

呢條閉環係 M1 唯一有效主資料流。舊 Node.js / Express Gateway、單一 Express API、雲端 Supabase 同其他替代方案只屬歷史 POC 草稿；未經新的正式批准，不得當成現役架構或重新接入。

## 真實雙機拓撲

兩部機均為 **Fujitsu Lifebook U9311X**：11th Gen Intel Core i7-1165G7 @ 2.80GHz、16.0 GB RAM、Intel Iris Xe Graphics、477 GB NVMe SSD。

| 主機 | 現況與責任 |
|---|---|
| `JOE-DESKTOP` | Windows 10 隨身開發機，僅 C 槽；喺 `C:\Project\TimeMem` 執行 VS Code、GitHub Copilot、MAI LLM 開發及 GitHub Repo 同步。透過 Tailscale VPN 用 RDP 遠端操控家中 Server；不可成為第二個可寫 Primary。 |
| `JOE-SERVER` | Windows 11 家中主力機，C 槽加 D 槽；目前按需開機，目標 7x24。`C:\Project\TimeMem` 同步 Repo；`D:\docker-data\timemem\`（包含 `docker-compose`、`pgdata`、`model`）只負責 Self-Host Docker 生產容器（PostgreSQL + pgvector + Ollama）。係唯一可寫生產資料庫主機。 |

所有遠端存取只限 Tailscale tailnet；嚴禁開 Router Port。Tailscale 裝置授權唔取代 TimeMem 應用層授權。

## M1 防污染鐵律

- **Obsidian：Hold（暫緩）**。`C:\Project\Obsidian-Hub` 只作設計參考；現階段唔參與 M1 關鍵閉環，亦禁止編寫任何 Obsidian 整合程式碼。
- **n8n：** 只作本地 Docker 後勤自動化外掛／外部觸發器（Port `5678`），可接收 FastAPI Webhook；嚴禁直連或直接寫入 PostgreSQL。
- **Cold Start 隔離：** 強制排除 `docs/working/`；未批准草稿只可歸檔至 `docs/archive/`。不能讓失效草稿重新干擾現役判斷。
- 現階段只處理合成資料最小閉環；未經批准不得擴展真實資料、schema、雲端範圍或外部資料流。

## Canonical Files

冷啟動及所有後續修改必須以以下七份為準：

1. [docs/PRD.md](docs/PRD.md) — 願景、功能及需求。
2. [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) — 雙機拓撲、組件邊界及資料流。
3. [docs/GATE.md](docs/GATE.md) — Gate／驗收狀態。
4. [docs/DECISIONS.md](docs/DECISIONS.md) — 正式決策及取代關係。
5. [docs/ERRORLOG.md](docs/ERRORLOG.md) — 錯誤、冷啟動教訓及防重犯。
6. [docs/PROGRESS.md](docs/PROGRESS.md) — 已完成工作及驗證。
7. [docs/TODO.md](docs/TODO.md) — 現役未完成工作。

冷啟動打包入口：`.agents/skills/cold-start-pack/cold-start-pack.ps1`。執行後會強制排除 `docs/working/`，並覆蓋生成 `C:\Project\TimeMem-clean.zip`。
