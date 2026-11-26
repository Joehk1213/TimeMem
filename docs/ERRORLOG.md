<!--
性質：錯誤與回歸紀錄
用途：保存已發現問題、影響、處理方法及驗證狀態
邊個叫開：Joe
幾時可刪：Joe 批准清除完整歷史紀錄，或紀錄正式由新系統取代
-->

# 2026-11-23 — M0 evidence 同 AUDIT 工具錯誤

- **問題：** REQ-005 嘅 SYSTEM trigger 用 `Get-Process` 搵唔到 `ollama.exe`，曾被誤判做 FAIL。
- **影響：** 早期 Startup evidence 顯示 FAIL，令服務已正常運行都可能被當成 REQ-005 未通過。
- **處理：** 後續以 2026-11-23 00:24 Logon PASS JSON、endpoint HTTP 狀態、container health 同 Ollama API 模型清單作 evidence；JSON hash 已對返，舊 Startup FAIL 已移去 `superseded/`。呢次係驗證工具判斷問題，唔係 TimeMem 自動啟動問題。

- **問題：** `SYSTEM` 執行同步時無法存取共享位置，令本機 PASS JSON 未即時 copy 去 DESKTOP。
- **影響：** SERVER 有真實 PASS evidence，但 DESKTOP evidence 目錄一度未更新。
- **處理：** 已由具權限流程同步指定檔案，並分開核對 SHA-256；共享同步失敗係工具及權限問題，唔係 TimeMem 服務問題。

- **問題：** Logon 排程比 boot 慢大約 6 分鐘，STARTUP probe 太早執行，可能喺服務未 ready 時失敗。
- **影響：** 排程 timing 令早期驗證唔等同真實重啟後穩定結果。
- **處理：** 接受 00:24 Logon JSON 作正式 evidence，清楚記錄 trigger、boot time 同完成時間；排程校時屬工具問題，唔係 TimeMem 問題。

- **問題：** 產生 Logon PASS JSON 後，驗證流程未先寫 hash 就嘗試 sync。
- **影響：** 當 sync 或共享位置失敗時，evidence copy 同完整性記錄唔能一次過完成，增加追查成本。
- **處理：** 現時已保留 JSON 同 `.sha256.txt`，並將舊 FAIL 移入 `superseded/`；日後先產生並核對 hash，再同步同驗 destination hash。

- **問題：** WinRM 未通、`C$` 被拒絕，令 DESKTOP 唔可以直接由 SERVER 攞 evidence。
- **影響：** 初期 AUDIT 只睇到 DESKTOP 狀態，唔代表 SERVER 冇 PASS evidence。
- **處理：** 已改用同步後嘅 JSON 作正式 evidence，唔用未確認來源代替；WinRM／`C$` 係遠端存取工具問題，唔係 TimeMem 問題。

- **問題：** AUDIT 同時見到舊 REQ-005 Startup FAIL、SERVER Logon PASS 同已同步檔案狀態，未先分開 trigger 同時序，出現自相矛盾結論。
- **影響：** PROGRESS／GATE 一度保留「PASS」同「仍未交付」兩種說法，令審計訊息混亂。
- **處理：** 以指定 Logon JSON、已對返 hash 同 `superseded/` 舊 FAIL 作唯一狀態來源；REQ-005 現為 PASS，過時 AUDIT blocker 已清除。呢項係 AUDIT 工具同流程問題，唔係 TimeMem 服務問題。

# 2026-10-23 — OpenRouter 免費模型測試

- **問題：** 免費路由曾回傳非 JSON 的安全提示；另一回應自行把「星期五」轉成輸入中不存在的日期。固定免費模型亦遇到供應商 `429`，另一免費供應商請求逾時。
- **影響：** Service 的即時結構化輸出尚未完成端對端驗證，Task 1.2 暫不勾完成。
- **處理：** Service 僅接受免費模型 ID，對日期／時間只保留輸入原文中實際出現的片段；新增非 JSON HTTP 錯誤處理。Mock 測試通過。
- **測試資料／秘密：** 只使用虛構句子「星期五下午 3 點開會」；沒有輸出或記錄 API Key，亦沒有傳送真實家庭資料。
- **狀態：** 待免費上游恢復後重跑 `node scripts/test-openrouter.js`。

# 2026-10-23 — 每週課表解析容錯與錯誤行號

- **問題：** 課表遇到 emoji 分隔列、星期標題尾端裝飾、全形冒號／破折號、點號時間或多餘空行時，解析器未能穩定分辨星期和課堂；失敗提示亦未指出來源行。
- **影響：** 使用者難以定位格式錯誤，可能無法把週課表展開為具體行程。
- **處理：** 加入 Unicode 正規化與分隔符清理、寬鬆星期／時間解析、繁中／英文逐行錯誤提示，並新增只用虛構資料的 `test:recurring` 單元測試。
- **測試資料／秘密：** 使用虛構參與者與活動名稱；沒有保存或輸出對話提供的真實課表，也沒有呼叫外部服務。
- **狀態：** 已修正；以 `npm run test:recurring` 驗證。

# 2026-10-23 — 無效課堂列中止週表匯入

- **問題：** 單一課堂列格式無法識別時，整份週表解析會立即失敗；含空格時間範圍缺少持續回歸測試。
- **影響：** 其他格式正確的課堂亦無法產生預覽，錯誤定位不清楚。
- **處理：** 無效列改為略過並回報行號／原因，保留其他有效課堂；補測 `3:25 - 4:10`、`12:00-12:45` 與混合有效／無效行。
- **隱私：** console 僅記錄行號及錯誤原因，不記錄原始課表文字，避免姓名或地點留在瀏覽器日誌。
- **狀態：** 已修正；`npm run test:recurring` 通過。