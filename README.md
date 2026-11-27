# TimeMem

TimeMem 係一個以家庭為本、優先本機託管嘅時間與記憶系統。

## 目前階段與核心閉環

**現行階段：M1。** 唯一主線閉環為：

`FastAPI Multipart 上傳 ➔ 本地 Ollama (qwen3:8b Vision/OCR + bge-m3) ➔ pgvector 寫入 ➔ PWA 彈出式 RESULT 框`

- M1 只完成上述最小閉環：FastAPI 負責上傳、OCR / embedding、向量檢索、判定及資料寫入。
- 未經 Owner批准前，不擴展真實資料、雲端範圍、schema 或產品功能。
- `docs/archive/`、舊 M0 草稿、Legacy Express Gateway 圖或其他衝突描述一律唔凌駕現行 M1 錨點。

## 關鍵邊界

- **Obsidian 雙向整合：Hold（暫緩）**；Vault 唔係現行 M1 主線，亦唔凌駕 Repo 決策。
- **本地 Docker n8n：僅後勤自動化外掛**；可接收 Backend Webhook 作日曆同步、通知或開發期測試。
- n8n **嚴禁直連寫入資料庫**、取代 FastAPI 核心閉環或成為資料權威。

## 權威文件入口

冷啟動要先讀置頂指令，再依下列七份 Canonical Files 執行：

1. [PRD](docs/PRD.md) — 現行產品需求及驗收範圍。
2. [DECISIONS](docs/DECISIONS.md) — 已批准決策及取代關係。
3. [GATE](docs/GATE.md) — 目前 Gate、批准狀態及驗收準則。
4. [TODO](docs/TODO.md) — 現役未完成工作。
5. [PROGRESS](docs/PROGRESS.md) — 已完成工作、驗證及 evidence。
6. [ERRORLOG](docs/ERRORLOG.md) — 系統衝突、工具鏈漏洞、根本原因及防重犯測試。
7. [ARCHITECTURE](docs/ARCHITECTURE.md) — 現行系統架構及 M1 資料流。

新對話亦應先讀 `.github/copilot-instructions.md` 同置頂錨點；詳細索引見 [docs/README.md](docs/README.md)。

## 冷啟動與快速開始

- 執行 `.agents/skills/cold-start-pack/cold-start-pack.ps1` 建立最新 `TimeMem-clean.zip`；腳本支援 Working Tree Overlay，不得只依賴 `git archive HEAD`。
- 冷啟動打包會強制排除整個 `docs/working/`；未批准草稿只可歸檔至 `docs/archive/`，不得流入 ZIP。
- 本機環境先複製 `.env.docker.example` 成 `.env`，再用 `docker compose config` 檢查設定。
- 不提交 `.env`、真密碼、API key 或其他 secret。
