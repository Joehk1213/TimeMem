# M1 Vault 資料表設計草稿

> **狀態：REVIEW ONLY / 草稿 / 未批准**  
> D-029 只批准 Vault 政策方向；加密格式、KDF、key wrapping、paper recovery、OCR、thumbnail、rotation 同 restore 仍未批准。  
> 本草稿唔授權實際加密、DB、migration 或備份實作。

## Vault mode 邊界

Vault 唔係普通私人 Space 嘅另一個名，係獨立安全區：

- 只有 Joe 同 Joy 可以 unlock／access。
- Ailene 不可直接讀，只可 request。
- 接收身份／旅行文件、民事證明、健康、保險及敏感財務文件。
- 密碼、seed phrase、private key、2FA secret、完整信用卡 security code 不入 TimeMem。
- Content 不入普通 semantic embedding、不做 AI summary、不寫 prompt、log 或 trace。
- 普通搜尋只可用白名單 `title`、`category`、`tags`。
- Reminder 只顯示非敏感字句，例如「有重要文件快到期，請解鎖 Vault 查看」。

## 建議分層

| 層 | 內容 | 唔可以包含 |
|---|---|---|
| 普通 Vault metadata | `id`、類別、標題、tags、到期日、建立者、加密版本 | 文件內容、OCR 文字、thumbnail、秘密 |
| Vault 加密資料 | 文件正文、OCR、附件 bytes、加密 thumbnail | 明文備份 key、PIN、private key |
| Vault 提醒 | Item ID、到期時間、非敏感提示模板、delivery 狀態 | 顯示文件號碼、姓名、醫療內容 |
| Vault session | unlock actor、短期 session scope、到期時間、device binding | persistent reusable unlock token |
| Vault audit | unlock、拒絕、request、re-lock、restore、metadata search | 文件內容或可還原秘密 |

## 建議資料實體

| 實體 | 建議欄位 | 規則 |
|---|---|---|
| `vault_item` | `id`, `owner_member_id`, `title`, `category`, `tags`, `expires_at`, `cipher_blob_id`, `cipher_version`, `created_at`, `updated_at`, `deleted_at` | metadata 唔包含敏感正文；`cipher_blob_id` 指向加密 blob |
| `vault_blob` | `id`, `vault_item_id`, `wrapped_data_key_id`, `nonce`, `ciphertext`, `mac`, `content_sha256`, `byte_size` | plaintext 只能短暫出現喺受控記憶體；唔記 disk cache |
| `vault_file` | `id`, `vault_item_id`, `file_kind`, `ciphertext_path`, `original_name_hash`, `mime_type`, `sha256` | 原名如敏感，應加密或 hash；唔同一般 Asset 共用明文欄位 |
| `vault_reminder` | `id`, `vault_item_id`, `due_at`, `lead_time_minutes`, `template_id`, `ack_state`, `last_fired_at`, `status` | `template_id` 只可對應非敏感文案 |
| `vault_access_request` | `id`, `requester_id`, `target_item_id`, `reason`, `status`, `reviewed_by`, `reviewed_at`, `expires_at` | Ailene 只可以建立 request，唔可以直接 unlock |
| `vault_session` | `id`, `member_id`, `device_id`, `scope`, `created_at`, `expires_at`, `revoked_at` | unlock 後短期存在；唔可用一般 session 延長 Vault 權限 |
| `vault_audit_event` | `id`, `actor_id`, `event_type`, `target_id`, `reason`, `warning_shown`, `occurred_at`, `integrity_hash` | 每次 unlock、讀、request、拒絕、restore 都要記 |

## 密鑰分層草稿

```text
Vault 主恢復金鑰
  └─ 包裝 Vault root key
       └─ 包裝每份資料嘅 data key
            └─ 加密 vault blob
```

- Vault root key 唔可以只由 App PIN hash 推導。
- Vault key 唔同 D: 同位，亦要有獨立 paper recovery 草稿。
- Joe 預留嘅 outer backup 可以係一個，但 ordinary data 同 Vault 要用獨立 encryption key hierarchy。
- rotation 必須可追蹤 `cipher_version`；舊資料唔可因 rotation 靜默變成不可讀。
- 詳細 KDF、cipher、nonce policy、key wrapping、AAL 同 recovery 仲要安全 review。

## 普通 Space 候選轉 Vault

1. 偵測器只判斷候選，唔搬檔。
2. 立即 lock／mask 候選內容，停止普通搜尋結果同 AI context。
3. 顯示「疑似敏感資料，請確認 Vault」。
4. Joe／Joy 重新驗證後可搬入 Vault。
5. 搬入成功先刪普通索引及明文 cache；失敗時保持 quarantine，不可回復公開。
6. 整個流程寫 audit，唔可把敏感內容寫入 audit 或 AI 提議理由。

## 備份／還原

- 每份 outer backup 內分開 ordinary encrypted payload 同 Vault encrypted payload。
- 只有 Joe 同 Joy 可 unlock restored Vault。
- weekly restore 要分別驗證 ordinary restore 及 Vault unlock。
- Vault conflict 先隔離，唔可直接覆蓋 Primary。
- 真實 Vault 內容唔可用作日常測試 evidence，全部用 synthetic 文件。

## 未決事項

- Joe/Joy 同時需要批准定係任一人可 unlock。
- Ailene request 由邊個人 review，過期多久。
- OCR 係完全唔做、加密後本機做，定只做 search metadata。
- thumbnail 生成、加密、失敗清理同 cache。
- 到期提醒內容模板、recover paper 同 rotation runbook。

