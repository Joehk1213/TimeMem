# 🚀 TimeMem 專案：遠端自動化部署與知識同步總結 (2026-11-28)

## 1. 核心架構決策 (Direct Mode 落地)
* **取消背景遠端重啟**：放棄透過非互動式 SSH（`plink`）在遠端執行 `net stop/start` 嚟重啟 Docker 服務的做法，徹底避免 Windows 憑證死結與 `npipe:////./pipe/dockerDesktopLinuxEngine` 找不到檔案的報錯。
* **常駐運行模式**：遠端伺服器（`joe-server`）維持 Docker Desktop 背景長開（Always Running），確保 Linux 引擎命名管道與 API 隨時處於備妥狀態。

## 2. 部署流程自動化 (`deploy_all.bat`)
* **本機端動作**：自動檢查本機 Git 狀態、提交變更 (`git commit`) 並推送至 GitHub (`origin main`)。
* **遠端端動作**：透過 SSH (`plink`) 連線至 `joe-server`，直接執行專案更新與容器重啟：
  ```cmd
  cd /d C:\Project\TimeMem && git pull origin main && docker compose up -d
  ```

## 3. 雙軌雙庫與知識歸檔
* **專案級 (`C:\Project\TimeMem`)**：負責實際程式碼開發、PWA 前端及 Docker 容器化部署。
* **全局級 (`C:\Project\REPO`)**：作為跨專案通用的全域知識與模板中樞。
* **歸檔規範**：將今晚累積的多份共識摘要統一收錄至 `docs/Summary/` 資料夾，並透過升級版的 `sync_consensus.bat` 實現全域文檔與共識的一鍵同步。

## 4. 資安防護原則 (Security First)
* **禁絕明文密碼**：全面移除批次檔中可能存在的硬寫密碼，改由本機 `%USERPROFILE%\.ssh\joe-server.ppk` 私鑰與 `plink.exe` 進行安全認證。
* **人工介入防線**：當遠端容器或 Docker 發生異常時，腳本安全停止並報錯，拒絕盲目自動重試，確保由人工登入排查。

## 5. 執行成果
* 成功實現半自動化一鍵部署閉環，遠端容器（`database`、`frontend`、`backend`）全數順利進入 `Running` 與 `Healthy` 狀態。