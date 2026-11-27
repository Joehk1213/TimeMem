# TimeMem 文件索引

現行 Canonical Files 包含以下七份；歷史、階段性及待處理資料歸入各自目錄。

| 文件 | 用途 |
|---|---|
| [PRD.md](./PRD.md) | 現行產品需求來源。 |
| [TODO.md](./TODO.md) | 尚未完成及進行緊嘅工作。 |
| [PROGRESS.md](./PROGRESS.md) | 已完成事項、驗證及交接現況。 |
| [DECISIONS.md](./DECISIONS.md) | 正式決策紀錄。 |
| [ARCHITECTURE.md](./ARCHITECTURE.md) | 系統藍圖及架構參考。 |
| [GATE.md](./GATE.md) | M0／M1 Gate 狀態及批准邊界。 |
| [ERRORLOG.md](./ERRORLOG.md) | 錯誤、回歸及處理紀錄。 |
| [working/](./working/) | 正在使用嘅 SOP、交接狀態及工作草稿。 |
| [archive/](./archive/) | 歷史及階段性文件；不作現行核心依據。 |

## 2026-11-27 規範錨點

- 現行品牌：時光管家 / TimeMem；守護每一刻時光／Remember what matters.。
- M1 唯一閉環：PWA 圖片上傳 → FastAPI Multipart Upload → 本地 Ollama `qwen3:8b` Vision/OCR + `bge-m3` embedding → PostgreSQL pgvector → PWA RESULT。
- 雙機硬件：兩部 Fujitsu Lifebook U9311X；JOE-DESKTOP 為 Windows 10 僅 C 槽開發／Tailscale RDP 機，JOE-SERVER 為 Windows 11 C+D 槽唯一可寫生產資料庫主機。
- 私隱閉環：100% Self-Host、資料不出雲；無 Router Port，遠端存取只限 Tailscale。
- Obsidian 為 Hold；n8n（Port `5678`）只作後勤外掛，嚴禁直連或寫入 PostgreSQL。

## 文件權威次序

1. [PRD.md](./PRD.md) 定義產品範圍。
2. [DECISIONS.md](./DECISIONS.md) 記已批准或取代嘅決定。
3. [ARCHITECTURE.md](./ARCHITECTURE.md) 提供系統藍圖參考。
4. [TODO.md](./TODO.md) 只列現役未完成工作。
5. [PROGRESS.md](./PROGRESS.md) 只列已完成工作及驗證 evidence。