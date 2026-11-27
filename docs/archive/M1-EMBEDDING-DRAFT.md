# M1 Embedding 備份方案草稿

> **狀態：REVIEW ONLY / 草稿 / 未批准**  
> 來源：D-028。主 `paraphrase-multilingual-MiniLM-L12-v2` 384D、備份 `intfloat/multilingual-e5-small` 384D、分類 LLM `qwen2.5:3b` 只係 benchmark 候選；M2 runtime 仍要另行記錄。

## 角色分工

| 角色 | 候選 | 用途 |
|---|---|---|
| 主 embedding | `paraphrase-multilingual-MiniLM-L12-v2` | 將 Cantonese、中文、英文及中英夾雜 Item／查詢轉 384D 向量 |
| 備份 embedding | `intfloat/multilingual-e5-small` | 主模型缺失、載入失敗、延遲或質素唔達標時採用；唔可以混合當互通向量 |
| 分類 LLM | `qwen2.5:3b` | RECORD／SEARCH 分類及理由、候選；唔直接寫 DB |
| 最後備援 | local rule + structured/keyword search + 手動表格 | embedding／LLM 故障時維持基本操作 |

## 唔變嘅邊界

- 所有模型只喺本機，永不改用外部 LLM fallback。
- `cosine similarity` 只係檢索排序，唔直接當 confidence。
- AI 仍受 `<0.7`、`0.7–0.9`、`>0.9` 三級政策控制。
- Python backend 唔直連 DB；向量讀寫經唯一 Node 資料存取模組。
- MiniLM 同 e5 向量只會同模型版本匹配；唔可以喺同一 index 混用兩組語義空間。
- Vault content 唔做普通 embedding。

## 切換方案

### 正常模式

1. Runtime 設定記錄固定 `model_id`、`version`、`digest`、dimension。
2. 新 Item 使用主模型建立向量。
3. Gateway 查詢先使用同一模型版本嘅索引。
4. 結果交分類 LLM 產生候選、理由及信心值。

### 主模型故障

1. health check 記錄錯誤，PWA 顯示 AI 檢索不可用。
2. 先切 local rule／structured／keyword search，令手動功能繼續。
3. 如已經為 e5 建立完整獨立 index，並經 benchmark 同切換測試，可以切到 e5 namespace。
4. 唔可以即場用 e5 查 MiniLM index；必須重新索引或直接讀 e5 index。
5. qwen 故障時停止 AI 分類同 AI 寫入，保留手動輸入；唔外送。

### 人手切換

- 由 local admin 修改經驗證設定，唔由 AI 自己切。
- 設定變更要記錄舊／新 model、原因、時間、benchmark ID。
- 切換後先做 smoke test，再開給使用者。
- 回切時重做同樣驗證，唔假設舊 index 一定完整。

## 建議 index 設計

| 欄位 | 意義 |
|---|---|
| `owner_type` / `owner_id` | 向量對應普通 Item 或其他已批准實體 |
| `model_id` | MiniLM 或 e5 |
| `model_digest` | 固定模型 bytes／版本 |
| `dimension` | 只可為 384D |
| `text_hash` | 判斷來源文字有冇變 |
| `vector` | pgvector 數據 |
| `indexed_at` | 建立時間 |
| `status` | `ready`、`stale`、`failed` |

每個模型應使用獨立 namespace 或 composite identity；換模型唔改寫舊向量。

## 測試方法

固定 100 個 synthetic cases，平均覆蓋：

- Cantonese：30 個。
- 中文書面：20 個。
- 英文：20 個。
- 中英夾雜：20 個。
- 縮寫、錯別字、同義詞、相近活動：10 個。

每個 case 記錄預期 Item、理由、confidence、retrieval rank、結果及時間。

### 測試項目

| 項目 | 驗收草案 |
|---|---|
| Retrieval | top-k 是否搵到預期 synthetic Item；記錄錯誤率 |
| Latency | cold start、warm p50、warm p95 |
| RAM | model load、indexing、query peak |
| Repeat pass | 相同固定 fixture 重跑一次仍符合門檻 |
| Calibration | confidence 三級行為與實際錯誤相符；錯誤率目標 ≤5% |
| Model digest | 同一 benchmark 可重現同一 model |
| e5 切換 | 單獨 e5 index 能查；唔誤查 MiniLM index |
| 故障 | model 缺失、Ollama 停、OOM、index stale 都顯示錯誤或安全 fallback |

## TODO

- 固定 model version/digest。
- 整理 100 個 synthetic cases。
- 決定 16 GB RAM 限額、latency target 同 top-k。
- 設計 indexing queue；M1 只做設計，唔自動重新索引 Vault。
- benchmark 通過後，另行決定邊個做 runtime，唔可由草稿直接宣稱。

