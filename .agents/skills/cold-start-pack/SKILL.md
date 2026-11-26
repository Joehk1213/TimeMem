<!--
性質：專案 Skill
用途：安全打包乾淨 Repo，用於 Cold Start 測試
叫開者：@Joehk1213
刪除條件：冷啓動打包流程停用或改由更安全、可審計的正式工具取代
-->
---
name: cold-start-pack
description: "Use when the user asks to pack a clean repository, run a Cold Start Test, or invokes cold-start-pack; it creates C:\\Project\\TimeMem-clean.zip and verifies it under Rule-SEC-01."
---

# Cold Start Safety Pack

## Trigger

當用戶提出以下任一需求時自動觸發：

- 「打包乾淨 Repo」
- 「做 Cold Start Test」
- 執行 `cold-start-pack`

## Rule-SEC-01

執行前及輸出後都必須遵守以下資安紅線：

- 不可包含 `.git/` 或其他 Git metadata。
- 不可包含任何 `.env*` 檔案，包括 `.env.example`。
- 不可包含 `reference/photo/`。
- 不可包含 `docs/` 下任何圖片檔。
- 不可包含 `venv/`、`.venv/`、`.validation-venv/`、`node_modules/` 或 Python cache。
- 不可包含私鑰、憑證或敏感個人資料目錄。
- 不可讀取、輸出或複製任何真實 Secret；只允許保留無值的變數名稱範例。

## Execution

執行專案內腳本：

```powershell
powershell -ExecutionPolicy Bypass -File C:\Project\TimeMem\.agents\skills\cold-start-pack\cold-start-pack.ps1
```

腳本必須：

1. 驗證 `C:\Project\TimeMem` 是 Git Repo，並確認 `HEAD` 可用。
2. 使用 `git archive --format=tar --output=<temp>.tar HEAD` 匯出當前 `HEAD` 至暫存目錄。
3. 疊加未 commit 嘅受控工作樹修改及未追蹤新檔：
   - 使用 `git diff --name-only HEAD` 找出 HEAD 相對嘅修改／刪除。
   - 使用 `git ls-files --others --exclude-standard` 找出未追蹤新檔。
   - 修改後嘅暫存內容覆蓋相同路徑；刪除項同步移除暫存副本。
4. 從暫存目錄強制剔除：
   - `.git/`、所有 `.env*`
   - `reference/photo/`
   - `docs/` 下副檔名為 `.png`、`.jpg`、`.jpeg`、`.gif`、`.bmp`、`.tif`、`.tiff`、`.webp`、`.jfif`、`.heic` 或 `.heif` 的檔案
   - `venv/`、`.venv/`、`.validation-venv/`、`node_modules/`、`__pycache__/`
   - `.pem`、`.key`、`.p12`、`.pfx`、`id_rsa*`、`id_ed25519*`
   - `docs/evidence/`、`docs/owner-private/`、`personal-data/`、`private-data/`
5. 直接覆蓋 `C:\Project\TimeMem-clean.zip`。
6. 探測 ZIP 中的每個檔案路徑及可讀文字內容。
7. 掃描時必須同時檢查路徑違規及以下內容：
   - AWS access key pattern
   - OpenAI、GitHub、Linear、Bearer 或通用 API token assignment
   - Password assignment
   - Private key PEM header
8. 只有掃描結果為 0 名路徑違規及 0 個真正 Secret 內容命中時才可回報 PASS。

若任何步驟失敗、掃描有 1 個或以上命中、或無法確認內容乾淨，必須停止並回報 FAIL，不可偽裝成成功。

## Output

完成時回報：

```text
壓縮包：C:\Project\TimeMem-clean.zip
檔案總數：<count>
資安掃描：PASS / 0 路徑違規 / 0 真實 Secret 命中
來源 HEAD：<short commit sha>
```

同時附上以下標準 Cold Start 測試官 Prompt，供用戶複製到新聊天室：

```text
你現在位於全新聊天室，執行 Cold Start 測試。請先讀取壓縮包解壓後的 Repo：
1. 只以 Repo 內的 `.agents/skills/`、`docs/`、`README.md`、`.gitignore` 和現有程式碼為準。
2. 先讀取 `README.md`、`docs/README.md`、`docs/PRD.md`、`docs/TODO.md`、`docs/PROGRESS.md`、`docs/DECISIONS.md` 和 `.github/copilot-instructions.md`。
3. 不可以假設任何早前對話、未解壓檔案或未出現的會話記憑。
4. 重申現行 M1 範圍、Rule-SEC-01 資安紅線及 TODO 項目。
5. 完成第一輪理解後，逐項列出：現況、已批准範圍、下一個可開始工作、仍需批准或決定的事項。
6. 未經我確認，不可修改任何程式碼、Schema、部署設定或正式記錄。
```
