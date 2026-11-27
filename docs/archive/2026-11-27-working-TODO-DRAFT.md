<!-- 性質：專案執行待辦；用途：記錄 M1 多模態驗證項目及後續工作；叫開者：Joe 透過 MAI；刪除條件：M1 驗證完成並由 Joe 歸檔至 PROGRESS.md 後可刪除或替換。 -->

# M1 多模態圖文閉環驗證清單

> 本清單依據剔除式驗證流程建立；現階段只做 synthetic／test data，不使用真實相片、家庭個資或會推送至 Git/Cloud 嘅私人資料。

## 圖片上傳 API

- [ ] 定義圖片上傳 API contract、size／format／timeout／error response。
- [ ] 驗證 PWA 可上傳興趣班 Schedule 圖片並取得 upload result。
- [ ] 確認 backend 唯一接收入口及非公開儲存位置；真實相片不寫入 repo。
- [ ] 驗證錯誤及重傳流程唔洩漏檔案內容或個人資料。

## OCR 欄位萃取

- [ ] 使用 Vision / OCR 流程由圖片萃取人物、活動、時間及地點。
- [ ] 固定並記錄 `qwen3:8b` 測試模型／版本及合成 test image。
- [ ] 驗證 5 條合成興趣班 Schedule 可逐欄解析為 `person`、`action`、`time`、`place`。
- [ ] 對錯誤識別、缺欄及低辨識度結果做明確 PASS／FAIL 判定。

## Embedding 與向量入庫

- [ ] 驗證每條行程只形成 1 個 `bge-m3` chunk。
- [ ] 驗證 embedding 可寫入 PostgreSQL `pgvector`。
- [ ] 驗證資料只寫入隔離表 `test_schedules`；欄位至少包含 `id`、`content`、`embedding`、`time`、`person`、`place`、`action`。
- [ ] 驗證 test 問題轉 embedding 後可由 `test_schedules` 揀出最似 2 條。

## PWA RESULT 渲染

- [ ] 驗證 PWA 可即時顯示最似 2 條行程嘅 RESULT 彈出框。
- [ ] 驗證卡片頂部為時間、中部為人物加地點、底部為活動。
- [ ] 驗證搜尋無結果時顯示「搵唔到相關行程」。
- [ ] 驗證閂 RESULT 框後可安全返回 PWA 主頁，且不殘留私人資料於畫面或 log。

## M1 完成 Gate

- [ ] 依 `D-052` 完成 5 條合成行程、2 條問題及 2 個 PASS 標準。
- [ ] 所有結果只用合成資料及本機 Private／owner-private 證據保存。
- [ ] 確認無真實相片、credentials、個人資料、`.env` 或 private backup 被新增至 Git。
