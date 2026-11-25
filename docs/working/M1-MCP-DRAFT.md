# M1 MCP Tool 清單草稿

> **狀態：REVIEW ONLY / 草稿 / 未批准**  
> D-027 只批准 TimeMem outbound、allowlisted、首階段 read-only 嘅方向。transport、credential、payload class、approval、audit、revoke、rate limit、offline 行為及 milestone 全部未定。

## 通用原則

- 預設 deny；只可使用 allowlisted Tool。
- 首階段全部 read-only，唔傳送私人 payload 去 Cloud connector。
- 封閉屋企環境可接本機 connector；Cloud connector 只可處理 synthetic/test data 或公開資料。
- 每次呼叫記 Tool、actor、目的、資料級別、時間、結果及錯誤；唔記原始敏感 payload。
- credential 唔放 `prompt`、logs、repo 或 UI。
- 使用者要清楚見到資料會去邊、邊個 server 回答、係咪 Cloud。
- 失敗要明確顯示，唔假裝讀成功。

## 建議清單

| Tool ID | 來源 | 建議模式 | 可做 | 明確不可做 |
|---|---|---|---|---|
| `calendar.read.events` | Google Calendar／匯出的 calendar file | read-only | 列出指定日期事件、時間、地點、參與者摘要 | 新增、修改、刪除、發邀請、傳整個私人行事曆去 Cloud LLM |
| `calendar.read.freebusy` | Calendar provider | read-only | 查指定時段忙／閒 | 公開詳細私人活動名稱 |
| `whatsapp.read.allowlist` | WhatsApp 匯出／授權 connector | read-only + allowlist | 讀指定群組或已授權對話、抽取活動候選 | 發訊、刪訊、讀全部 chat、上載附件、Cloud 私人 payload |
| `notes.read.allowlist` | Apple Notes／Microsoft Notes／本機 notes export | read-only | 讀指定 folder／note／allowlisted path | 修改 note、同步全部 Notes、讀 Vault 內容 |
| `school-team.read.assignments` | Microsoft Teams 學校租戶 | read-only | 讀指定班級功課、期限摘要 | 代交功課、發訊、加入會議、讀私人聊天 |
| `school-team.read.calendar` | Microsoft Teams／School calendar | read-only | 讀指定班活動、考試、deadline | 修改課表、通知家長、讀唔相關 Channel |
| `filesystem.read.allowlist` | 本機檔案 | read-only | 讀核准的 import folder 同 allowlisted 副檔名 | 任意絕對路徑、執行檔、Vault ciphertext、backup key |
| `calendar-file.import.preview` | 本機 file | read-only preview | 解析檔案並產生 preview | 未確認就寫 DB |
| `time.now` | 本機 clock | read-only | 取本機時間、timezone | 改系統時間 |
| `timezone.resolve` | 本機資料 | read-only | 解香港時間、DST／timezone | 查外部私人位置 |

## 連線來源分類

### 本機 connector

- filesystem allowlist
- calendar-file preview
- time/timezone
- 只可由 TimeMem 主動呼叫。
- 最適合首階段，因唔需將家庭 payload 傳出。

### 帶帳號 connector

- Calendar
- WhatsApp
- Notes
- 學校 Team
- 必須綁定指定家庭帳號及最小 scope。
- 需要 token storage、expiry、revoke、reauth 同 Cloud data boundary 設計。
- read-only OAuth scope 唔可同時申請寫 scope。

## 每個 Tool 必須嘅 contract

```text
tool_id
purpose
transport
credential_scope
payload_class
source_boundary
read_only_enforced
rate_limit
timeout
audit_event
revoke_action
offline_failure
```

## payload 級別草稿

| 級別 | 例子 | 允許去向 |
|---|---|---|
| `PUBLIC` | 公開校曆、公開活動 | 經批准 Cloud connector 可用 |
| `SYNTHETIC` | 測試人物、假資料 | 公開 POC |
| `HOUSEHOLD` | 真實姓名、關係、活動、位置 | 只可留本機或經加密 Tailnet 指定裝置 |
| `VAULT` | 文件、證件、健康、保險、敏感財務 | 不得進 MCP |
| `SECRET` | token、key、PIN、seed phrase | 不得進任何 Tool payload |

## 高風險點

- WhatsApp 讀取容易一次取得大量關係資料，必須有群組／日期範圍／主題篩選。
- Notes 可能混有 Vault 級內容，不能按 app 名稱自動當安全。
- 學校 Team 要防讀取全租戶；先限定班級、Channel 同日期。
- Calendar attendee／description 可能包含地址、電話、私人訊息；預設只回摘要。
- Cloud MCP connector 要顯示 upload warning，POC 只用 synthetic／test data。

## 未決事項

- transport：本機進程、stdio、HTTP 定邊種。
- credential store 同 rotation。
- 逐 Tool approval 同 expiry。
- 每個來源嘅最小 OAuth scope。
- rate limit、timeout、重試及 idempotency。
- connector 失效、revoke、離線同 partial result 呈現。

