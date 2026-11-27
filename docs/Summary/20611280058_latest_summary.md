# TimeMem 專案：遠端自動化部署共識摘要

## 1. 核心架構決策 (Direct Mode)

* **取消背景遠端重啟**：放棄透過非互動式 SSH（`plink`）在遠端執行 `net stop/start` 嚟重啟 Docker 服務的做法，徹底避免 Windows 憑證死結與 `npipe:////./pipe/dockerDesktopLinuxEngine` 找不到檔案的報錯。

* **常駐運行模式**：遠端伺服器（`joe-server`）維持 Docker Desktop 背景長開（Always Running），確保 Linux 引擎命名管道與 API 隨時處於備妥狀態。

## 2. 部署流程自動化 (`deploy_all.bat`)

* **本機端動作**：自動檢查本機 Git 狀態、提交變更 (`git commit`) 并推送至 GitHub (`git push origin main`)。

* **遠端端動作**：透過 SSH (`plink`) 連線至 `joe-server`，直接執行專案更新與容器重啟：

  ```
  cd /d C:\Project\TimeMem && git pull origin main && docker compose up -d
  ```

## 3. 執行成果

* 成功實現「本機一鍵雙擊，遠端自動同步並啟動容器（`database`、`frontend`、`backend` 順利進入 `Running` 與 `Healthy` 狀態）」。