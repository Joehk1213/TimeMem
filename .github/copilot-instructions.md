## 🚨 CURRENT ACTIVE DIRECTIVE (M1 OVERRIDE)

**最高準則：所有新對話都必須優先以呢個置頂區塊及 `docs/TODO.md` 頂部作最高準則。禁止採信 `docs/archive/`、舊版 M0 草稿、舊架構圖或任何其他舊文件入面與本指令衝突嘅描述。**

1. **當前階段與唯一主線（M1 Priority 1）：** FastAPI 圖片上傳（Multipart Upload）→ 本地 Ollama `qwen3:8b` Vision / OCR 萃取 → 本地 `bge-m3` embedding → 寫入 PostgreSQL `pgvector` → PWA 彈出式 RESULT 框渲染[cite: 12]。
2. **Obsidian 狀態：** Obsidian Vault 整合目前列為 **Hold（暫緩／不作當前優先）**[cite: 12]。
3. **n8n 定位：** 本地 Docker n8n（Port `5678`）只作**後勤自動化外掛／外部觸發器**，負責接收 Backend Webhook 觸發日曆同步／通知或開發期測試；嚴禁取代 FastAPI 核心閉環，亦嚴禁直連或寫入 DB[cite: 12]。
4. **品牌與閉環：** 中文名「時光管家」、英文名「TimeMem」、Slogan「守護每一刻時光／Remember what matters.」；堅持 100% Self-Host、資料不出雲[cite: 12]。
5. **雙機與網絡：** 兩部 Fujitsu Lifebook U9311X；JOE-DESKTOP 為 Windows 10 僅 C 槽隨身開發及 Tailscale RDP 機；JOE-SERVER 為 Windows 11 C+D 槽家中主力機及唯一可寫生產資料庫主機，資料放 `D:\docker-data\timemem\`，只限 Tailscale、禁止開 Router Port[cite: 12]。
6. **部署與資安：** `scripts\deploy_all.bat` 只作 Direct Mode 部署，使用本機 PPK 私鑰及 `plink.exe`，Docker Desktop 需常駐；不得內嵌密碼、私鑰或秘密，Docker／SSH 異常時必須停止並由 Joe 人手介入[cite: 12]。n8n 只作後勤觸發及知識同步，不得直連 PostgreSQL、取代 FastAPI 或保存真實私人資料[cite: 12]。
7. **後勤自動化閉環與去重鐵律（Automation & Auto-Sync Rules）：**
   - **保留去重防線：** 絕對不得廢除本機 `n8n_receiver.py` 的 MD5 去重機制（`Deduplication Filter`）[cite: 12]。若遇到相同 Hash 內容，必須透過**智慧時間戳獨立備份落盤（Smart-Bypass / Timestamped Backup，格式如 `YYYYMMDDHHMMSS_latest_summary.md`）**確保背景流水線順利執行，不可直接略過[cite: 12]。
   - **非互動背景 Git Push：** `sync_consensus.bat` 等背景同步腳本執行時，必須確保切換至正確根目錄（`cd /d C:\Project\TimeMem`）並能在無互動背景視窗下順利通過 Git 鑑權完成 `git add .`、`git commit` 及 `git push origin main`，確保 GitHub 狀態即時更新[cite: 12]。
   - **流水線三部曲：** 本地落盤後依序非同步執行 `sync_consensus.py`（更新 `PROGRESS.md`）→ `sync_consensus.bat`（同步推送上 GitHub）→ `deploy_all.bat --silent`（更新 JOE-SERVER 容器）[cite: 12]。

# TimeMem Copilot Instructions

<!--
性質：Repository Copilot 操作指引
用途：規範收尾同步、語言、資安及現行工作範圍
邊個叫開：Joe
幾時可刪：Joe 親口要求刪除，或呢套指引正式停用
-->

## 強制收尾同步

- 完成任何程式碼修改、架構調整或腳本執行後，必須自動更新 `docs/TODO.md`、`docs/PROGRESS.md`，並同步完成項目[cite: 12]。
- 架構、技術選型、資料邊界或系統分工變更必須寫入 `docs/DECISIONS.md`[cite: 12]。
- 開工前讀取 `docs/TODO.md`、`docs/DECISIONS.md`、`docs/PROGRESS.md`；收尾時再核對三份文件一致[cite: 12]。

## Record 語言

- 所有 Record 新內容一律用繁體廣東話[cite: 12]。
- 可保留英文嘅範圍限於檔案名、路徑、D-ID、REQ-ID、TASK-ID、指令、code、文件名及專有名詞[cite: 12]。
- 解釋、原因、做法、Blocker 同下一步必須用廣東話[cite: 12]。

## 資安紅線（Rule-SEC-01）

- 絕對禁止將真實密碼、API Key、真實 `.env`、私人家庭個資、真實相片、私人 OCR 結果、embedding、log 或 backup 寫入 Git、公開分享位置或外部服務[cite: 12]。
- 公開設定只可使用脫敏 `.env.example`；測試只用合成資料及本機受控儲存[cite: 12]。
- 未經 Joe 明確批准，不得處理真實相片、私人附件、credentials 或新資料來源[cite: 12]。
- `docs/owner-private/`、證據及任何私密資料不得提交或推送[cite: 12]。

## 受管理範圍

- `docs/` 係 TimeMem 產品及實作決策嘅現行來源；七份 Canonical Files 為 `PRD.md`、`DECISIONS.md`、`ARCHITECTURE.md`、`GATE.md`、`TODO.md`、`PROGRESS.md`、`ERRORLOG.md`[cite: 12]。
- `docs/PRD.md` 為現行 PRD V10.2；舊版本及 M0 歷史文件只可放喺 `docs/archive/`[cite: 12]。
- Obsidian Vault 整合目前列為 Hold；暫不處理任何 Vault 同步、搬移或新整合工作[cite: 12]。
- Vault 唔係產品決策權威；Repo 文檔有衝突時以 `docs/` 決策為準[cite: 12]。
- M0 已 PASS，現正處於 M1 階段；後續實作仍要依批准邊界逐項執行[cite: 12]。

## Skills

- 只維護 `.agents/skills/`；唔重新啟用或鏡像同步 `.github/skills/`、`.github/skills-cold/` 或任何已停用腳本[cite: 12]。