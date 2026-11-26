# TimeMem Copilot Instructions

<!--
性質：Repository Copilot 操作指引
用途：規範收尾同步、語言、資安及現行工作範圍
邊個叫開：Joe
幾時可刪：Joe 親口要求刪除，或呢套指引正式停用
-->

## 強制收尾同步

- 完成任何程式碼修改、架構調整或腳本執行後，必須自動更新 `docs/TODO.md`、`docs/PROGRESS.md`，並同步完成項目。
- 架構、技術選型、資料邊界或系統分工變更必須寫入 `docs/DECISIONS.md`。
- 開工前讀取 `docs/TODO.md`、`docs/DECISIONS.md`、`docs/PROGRESS.md`；收尾時再核對三份文件一致。

## Record 語言

- 所有 Record 新內容一律用繁體廣東話。
- 可保留英文嘅範圍限於檔案名、路徑、D-ID、REQ-ID、TASK-ID、指令、code、文件名及專有名詞。
- 解釋、原因、做法、Blocker 同下一步必須用廣東話。

## 資安紅線（Rule-SEC-01）

- 絕對禁止將真實密碼、API Key、真實 `.env`、私人家庭個資、真實相片、私人 OCR 結果、embedding、log 或 backup 寫入 Git、公開分享位置或外部服務。
- 公開設定只可使用脫敏 `.env.example`；測試只用合成資料及本機受控儲存。
- 未經 Joe 明確批准，不得處理真實相片、私人附件、credentials 或新資料來源。
- `docs/owner-private/`、證據及任何私密資料不得提交或推送。

## 受管理範圍

- `docs/` 係 TimeMem 產品及實作決策嘅現行來源；七份 Canonical Files 為 `PRD.md`、`DECISIONS.md`、`ARCHITECTURE.md`、`GATE.md`、`TODO.md`、`PROGRESS.md`、`ERRORLOG.md`。
- `docs/PRD.md` 為現行 PRD V10.2；舊版本及 M0 歷史文件只可放喺 `docs/archive/`。
- Obsidian Vault 整合目前列為 Hold；暫不處理任何 Vault 同步、搬移或新整合工作。
- Vault 唔係產品決策權威；Repo 文檔有衝突時以 `docs/` 決策為準。
- M0 已 PASS，現正處於 M1 階段；後續實作仍要依批准邊界逐項執行。

## Skills

- 只維護 `.agents/skills/`；唔重新啟用或鏡像同步 `.github/skills/`、`.github/skills-cold/` 或任何已停用腳本。