# 📋 TimeMem & Global REPO 全自動共識與部署閉環總結

## 1. 系統架構與雙軌雙庫定位

* **專案級 (`C:\Project\TimeMem`)**：負責實際程式碼開發、PWA 前端及 Docker 容器化部署，配備一鍵自動化部署腳本 `scripts\deploy_all.bat`。
* **全局級 (`C:\Project\REPO`)**：作為跨專案通用的全域知識與模板中樞（存放 Cold Start 範本、Prompt 模板與規範文件），配備一鍵知識同步腳本 `scripts\sync_repo.bat`。

## 2. 雙軌自動化執行機制

* **軌道 A（代碼與遠端伺服器部署）**：
  * 本機執行 `deploy_all.bat` 自動執行 `git add`、`git commit`、`git push`。
  * 透過 `plink.exe` 安全連線至 `joe-server`（已排除批次檔特殊字元衝突並完成 Host Key 指紋授權），自動執行遠端 `git pull`、清理快取重建前端 Docker (`docker compose build --no-cache frontend`) 以及重啟容器 (`docker compose up -d`)。
* **軌道 B（智慧型共識與知識同步）**：
  * 拒絕盲目備份冗長對話，透過 Gemini 的 `consensus-sync-agent` 提煉高質素結構化 Markdown 共識摘要，並直接生成可供下載的 `latest_summary.md` 檔案。

## 3. n8n 雲端到本地全自動閉環架構 (Pipeline)

透過 n8n 串聯 Google Drive 與本機自動化腳本，實現無人值守的知識歸檔與代碼部署：

1. **Trigger（雲端觸發）**：將 Gemini 產出的 `latest_summary.md` 儲存至 Google Drive 指定監控目錄（Dropzone），由 n8n Google Drive Trigger 自動偵測並下載內容。
2. **Routing（智能路由與入機）**：n8n 根據內容路由判斷目標庫：
   * 寫入對應本地目錄（`C:\Project\TimeMem` 或 `C:\Project\REPO`）。
   * 觸發對應的本機自動化腳本（需加入靜默參數 `--silent` 以跳過 `pause` 防止進程阻塞），自動完成文檔歸納、Git Commit/Push 及 SSH 遠端伺服器更新。
3. **Cleanup & Archive（防重複觸發與歷史歸檔）**：
   * 流水線執行完畢後，n8n 自動將 Google Drive Dropzone 中的 `latest_summary.md` 移動至 `Archive/` 資料夾。
   * **命名規範**：移動前自動重命名為香港時間戳記格式 `YYYYMMDDHHMM_latest_summary.md`（Luxon 語法：`{{ $now.setZone('Asia/Hong_Kong').toFormat('yyyyMMddHHmm') }}_latest_summary.md`），避免重複觸發並建立按時間排序的歷史共識庫。

## 4. 下一步行動 (Next Steps)

1. 生成可直接匯入的 **n8n Workflow JSON** 配置文件（包含 Google Drive 監控、路由、本機/SSH 執行及 `Archive/` 重命名搬移節點）。
2. 為 `deploy_all.bat` 與 `sync_repo.bat` 加入**靜默執行模式 (`--silent`)**，確保手動雙擊時保留 `pause` 檢視結果，而由 n8n 自動調用時則無阻塞直接完成。