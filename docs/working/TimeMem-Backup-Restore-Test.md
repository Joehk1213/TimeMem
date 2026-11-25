# TimeMem 加密備份與隔離 Restore 測試

## 範圍

- 本 runbook 只處理 ordinary PostgreSQL dump 加相片 originals/thumbs。
- Vault 仍未有正式 key hierarchy，唔可以聲稱 Vault backup/restore PASS。
- 唔會還原到 JOE-SERVER Primary，亦唔會自動覆蓋現有資料。

## Joe 先要提供

1. `OffHostDestination`：真正離開 JOE-SERVER 嘅位置，例如 Joe 持有嘅離線硬碟路徑或可信 Recovery 主機 shared path；唔可以只用 JOE-SERVER `C:`／`D:`。
2. `AgeRecipientFile`：含 `age` public recipient 嘅檔案。private key 唔可以放 Repo、D: backup 或 script。
3. key custody／paper recovery 負責人及保存位置。

## 備份步驟

```powershell
.\scripts\Backup-TimeMem-Encrypted.ps1 `
  -DestinationRoot "<Joe 提供嘅 off-host 位>" `
  -AgeRecipientFile "<Joe 提供嘅 public-recipient 檔>" `
  -OffHostLabel "<Joe 認可嘅媒體標籤>"
```

script 會：

1. 用 `docker compose exec -T database pg_dump` 建 consistent SQL dump。
2. 複製 `D:\docker-data\timemem\photos\originals` 同 `thumbs`。
3. 產生 `manifest.json`、檔案數量及 SHA-256。
4. 壓縮成只存喺暫存目錄嘅 zip。
5. 用 `age` recipient 加密；private key 唔會進入 script。
6. 只將 `.age` 及 `.sha256.txt` copy 去 off-host destination。
7. `finally` 只刪除本次建立嘅 plaintext temp 目錄。

任何步驟失敗都係 FAIL，唔產生 PASS-shaped result。

## 每週隔離 Restore 測試

1. 由 off-host copy 將 `.age` 檔返去隔離測試機；核對外置 `.sha256.txt`。
2. Joe 喺可信 Recovery host 提供 private identity，執行 `age -d` 解密到只限嗰次測試嘅 temp 目錄。
3. 解壓 archive；再核對 `manifest.json` 入面每個 component hash。
4. 建全新 disposable PostgreSQL container／database，名字明確加 `_restore_test_`；唔連 Primary。
5. 還原 SQL；相片 originals/thumbs 還原到另一個隔離 temp folder。
6. 比對：
   - row count／代表性 relationships；
   - `sha256`、原檔/縮圖數量及可開啟檔案；
   - backup timestamp 同 manifest 內容一致。
7. 試一次 wrong key，確認無法解密；試一次 hash mismatch，確認停止。
8. 記錄 backup ID、時間、測試 host、PASS/FAIL、各步驟結果及清除時間；唔記錄 key、password 或家庭資料。
9. 只刪除本次 disposable container/database/temp directory。Primary 保持不變。

## 未批准／未測項目

- `D-018` restore conflict reapply 仍係 Draft。
- `D-019` offline copy 仍未批准。
- `D-020` recovery 後 revoke all sessions 仍係 Draft。
- Vault unlock、separate key hierarchy、paper recovery、rotation 仍係 D-029 pending detail。
- 未提供 off-host 位之前，不會跑 backup；未批 D-018 至 D-020 之前，不會做 production recovery。
