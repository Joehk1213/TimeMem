# OBSOLETE — Historical Phase 1 Implementation Plan

> Archived because this proposal predates the New-Start-Project-Framework gate and conflicts with approved decisions, including the data model. It is retained for history only and is not an implementation authority. Current scope must be approved in `../REQUIREMENTS.md`; current design is in `../DECISIONS.md` and `../ARCHITECTURE.md`.

## 範圍與原則

本文件只規劃 README／PROGRESS 所列的 Phase 1，不代表已實作或已確認所有待決設計。

- 包括：家庭成員與家庭空間、待辦、日曆提醒、相片匯入整理、記憶時光機、備份匯出及基本還原測試。
- 不包括：Phase 2 Vault 證件／證書、Phase 3 家庭財務、Phase 4 RAG／助理。
- 家庭資料以家庭為界；API 必須在後端檢查家庭範圍，不能只靠介面隱藏內容。
- README／PROGRESS 尚未決定的權限、相片去重／原檔保留、提醒方式和備份還原 Keep 與否，不在本計劃內代為定案。

## User Stories

| # | 邊個 | 想做咩 | 為咗咩 |
|---|---|---|---|
| 1 | 家庭管理者 | 建立家庭空間並加入家庭成員 | 將家人的待辦、提醒和記憶放在同一個家庭範圍內 |
| 2 | 家長或家庭成員 | 建立、查看及完成待辦 | 記得默書準備等需要完成的事情 |
| 3 | 家長或家庭成員 | 建立日曆事件並設定提醒時間 | 不會錯過家庭的重要安排 |
| 4 | 家庭成員 | 匯入相片並整理時間、人物、地點及事件資料 | 日後可以找到及理解相片記錄 |
| 5 | 家庭成員 | 在記憶時光機回看相片和記憶卡 | 重溫曾經發生的重要時光 |
| 6 | 家庭管理者 | 匯出家庭資料備份，並按確認後的範圍做基本還原測試 | 保護家庭記錄，確認備份可用 |

## Data Model

以下為規劃用的最小資料形狀，不包含帳號、密碼或認證資料。需要保留待決定的地方會明確標示，實作前須覆核。

### families

| 欄位 | 型別 | 用途 |
|---|---|---|
| id | UUID，主鍵 | 家庭唯一識別 |
| name | TEXT | 家庭顯示名稱 |
| created_at | TIMESTAMPTZ | 建立時間 |
| updated_at | TIMESTAMPTZ | 最近更新時間 |

### members

| 欄位 | 型別 | 用途 |
|---|---|---|
| id | UUID，主鍵 | 成員唯一識別 |
| family_id | UUID，外鍵 → families.id | 成員所屬家庭 |
| display_name | TEXT | 成員顯示名稱 |
| created_at | TIMESTAMPTZ | 建立時間 |
| updated_at | TIMESTAMPTZ | 最近更新時間 |

兒童帳戶、成人監護、私人紀錄和成員角色權限沿用 PROGRESS 待決定項目，不在此處預設。

### tasks

| 欄位 | 型別 | 用途 |
|---|---|---|
| id | UUID，主鍵 | 待辦唯一識別 |
| family_id | UUID，外鍵 → families.id | 待辦所屬家庭 |
| title | TEXT | 待辦內容 |
| notes | TEXT，可空 | 補充說明 |
| due_at | TIMESTAMPTZ，可空 | 到期時間 |
| reminder_at | TIMESTAMPTZ，可空 | 待辦提醒時間 |
| status | TEXT | 狀態；規劃值為 open 或 completed |
| completed_at | TIMESTAMPTZ，可空 | 完成時間 |
| created_at | TIMESTAMPTZ | 建立時間 |
| updated_at | TIMESTAMPTZ | 最近更新時間 |

### events

| 欄位 | 型別 | 用途 |
|---|---|---|
| id | UUID，主鍵 | 日曆事件唯一識別 |
| family_id | UUID，外鍵 → families.id | 事件所屬家庭 |
| title | TEXT | 事件名稱 |
| description | TEXT，可空 | 事件補充資料 |
| starts_at | TIMESTAMPTZ | 開始時間 |
| ends_at | TIMESTAMPTZ，可空 | 結束時間 |
| reminder_at | TIMESTAMPTZ，可空 | 可設定的提醒時間 |
| created_at | TIMESTAMPTZ | 建立時間 |
| updated_at | TIMESTAMPTZ | 最近更新時間 |

提醒採本機通知、PWA 或外部推播的選擇仍待決定；此欄位只記錄提醒時間，不指定傳送方式。

### photos

| 欄位 | 型別 | 用途 |
|---|---|---|
| id | UUID，主鍵 | 相片記錄唯一識別 |
| family_id | UUID，外鍵 → families.id | 相片所屬家庭 |
| memory_id | UUID，可空，外鍵 → memories.id | 相片所屬記憶；可空表示尚未整理到記憶 |
| storage_path | TEXT | 本機檔案儲存位置的相對路徑 |
| original_filename | TEXT | 匯入時的檔名資料 |
| media_type | TEXT | 媒體類型 |
| size_bytes | BIGINT | 檔案大小 |
| captured_at | TIMESTAMPTZ，可空 | 相片拍攝時間；可供時間整理 |
| imported_at | TIMESTAMPTZ | 匯入時間 |

相片去重和是否保留原檔仍待決定；本欄位不代表已選定原檔保留策略。

### memories

| 欄位 | 型別 | 用途 |
|---|---|---|
| id | UUID，主鍵 | 記憶記錄唯一識別 |
| family_id | UUID，外鍵 → families.id | 記憶所屬家庭 |
| occurred_at | TIMESTAMPTZ，可空 | 記憶發生時間 |
| member_ids | UUID[]，可空 | 記憶涉及的家庭成員識別；需由後端確認均屬於同一家庭 |
| place_text | TEXT，可空 | 地點描述 |
| event_text | TEXT，可空 | 事件描述 |
| note | TEXT，可空 | 記憶補充內容 |
| created_at | TIMESTAMPTZ | 建立時間 |
| updated_at | TIMESTAMPTZ | 最近更新時間 |

未核准提案：以 member_ids UUID[] 表示一段記憶可涉及多位成員，以及不新增第七張表，兩者均未經主帥覆核，不可當作已決定或實作。若要求資料庫層級逐一外鍵約束，關聯設計仍待覆核。

## API 清單

以下是規劃介面，不是程式碼。所有讀寫均須按家庭範圍授權；欄位省略表示不需要 request body。

| Method | Path | Input | Output |
|---|---|---|---|
| POST | /api/families | 家庭名稱 | 新家庭的 id、名稱及建立時間 |
| GET | /api/families/{familyId} | Path：familyId | 家庭 id、名稱及更新時間 |
| GET | /api/families/{familyId}/members | Path：familyId | 該家庭成員清單 |
| POST | /api/families/{familyId}/members | Path：familyId；顯示名稱 | 新成員的 id、familyId、顯示名稱 |
| PATCH | /api/members/{memberId} | Path：memberId；可更新的顯示名稱 | 更新後的成員摘要 |
| GET | /api/tasks?familyId={familyId} | Query：familyId；可選狀態 | 待辦清單及狀態、到期／提醒時間 |
| POST | /api/tasks | familyId、title；可選 notes、dueAt、reminderAt | 新待辦的 id、狀態及時間欄位 |
| GET | /api/tasks/{taskId} | Path：taskId | 單一待辦資料 |
| PATCH | /api/tasks/{taskId} | Path：taskId；可更新標題、說明、到期／提醒時間、狀態 | 更新後的待辦資料 |
| GET | /api/events?familyId={familyId} | Query：familyId；可選起訖時間 | 日曆事件清單及提醒時間 |
| POST | /api/events | familyId、title、startsAt；可選 description、endsAt、reminderAt | 新事件的 id、內容及提醒時間 |
| PATCH | /api/events/{eventId} | Path：eventId；可更新事件欄位 | 更新後的事件資料 |
| GET | /api/photos?familyId={familyId} | Query：familyId；可選 memoryId | 相片中繼資料清單 |
| POST | /api/photos/import | 家庭識別、相片檔案；可選拍攝時間及整理資料 | 新相片 id、中繼資料及本機儲存狀態 |
| GET | /api/photos/{photoId} | Path：photoId | 相片中繼資料 |
| GET | /api/photos/{photoId}/file | Path：photoId | 相片檔案內容；只限獲授權的家庭範圍 |
| POST | /api/memories | familyId、時間／人物／地點／事件資料；可選相片 id 清單 | 新記憶 id 及記憶卡資料 |
| GET | /api/memories/random?familyId={familyId} | Query：familyId | 一則隨機記憶及其相關相片摘要 |
| GET | /api/memories/{memoryId} | Path：memoryId | 記憶卡資料及相關相片摘要 |
| POST | /api/backups/export | 家庭識別 | 可下載的家庭備份檔及匯出摘要 |
| POST | /api/backups/restore-test | 備份檔案；須先確認待決定第 8 項 | 還原測試結果摘要，不表示已確認保留正式還原功能 |

## 記憶時光機 Spec

- 只用於 Home／回顧頁；隨機顯示一組相片。
- 每張相片各自隨機漂移，並緩慢隨機縮放（README 方向）；未核准提案：具體速度及幅度待覆核，不視為已定數值。
- 滑鼠 hover 某張相片時，只停止該相片的移動並顯示記憶卡；卡片可展示日期、人物、地點、事件和相關相片，並提供前往當日紀錄的入口。
- 滑鼠離開相片後，卡片收起，該相片恢復移動。
- 提供減少動態效果選項；切換後降低或停止漂移／縮放，具體預設值不在此指定。
- 觸控操作為 README 要求；未核准提案：記憶卡的具體開啟／收起手勢待覆核，不視為已決定。
- 鍵盤操作為 README 要求；未核准提案：記憶卡的具體按鍵對應待覆核，不視為已決定。

## 技術限制

- 資料庫：PostgreSQL 一般關聯資料；Phase 1 不使用 pgvector。
- 相片：本機檔案儲存；使用持久化磁碟路徑，不引入 MinIO。
- 不啟動 Python／FastAPI／LangGraph AI Brain。
- 不規劃 Vault、財務或 RAG API／資料表。
- 備份匯出目標為家庭可保存的本機檔案；還原測試的保留與正式行為仍受 PROGRESS 待決定第 8 項約束。
