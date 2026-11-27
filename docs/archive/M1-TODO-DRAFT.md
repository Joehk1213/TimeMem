# M1 TODO 草稿

> **狀態：REVIEW ONLY / 草稿 / 未批准**  
> 唔會改 `docs/TODO.md`、`docs/GATE.md`、`docs/DECISIONS.md` 或任何 approval。  
> 依據：PRD V10.2；M1 只有「骨架」及 MCP 外送、唯讀方向，未批准實作、schema、migration 或上線。

## M1 邊界

PRD V10.2 明確寫 M1 為骨架，所以本草稿只列「可以先 REVIEW 嘅骨架工作」，唔將 M2–M5 功能提前搬入 M1。

### 進入條件

- M0 整體仍未批准前，以下只係文件草稿同設計 review。
- 唔新增產品 code、schema、migration、產品 DB 或部署設定。
- 真實家庭資料、附件、embeddings、logs、backups 永不進公開 Cloud 或外部服務。
- 單一可寫 Primary、唯一資料存取模組、Python 後端唔直連 DB 嘅架構邊界保持不變。

## 建議工作清單

| ID | 草稿工作 | 產出 | PRD 邊界 | 完成標準 |
|---|---|---|---|---|
| M1-D-001 | 重整 M1 骨架邊界 | 模組及介面責任表 | M1 骨架 | PWA、Gateway、資料存取、Python、PostgreSQL、Ollama 各自責任無重疊 |
| M1-D-002 | Space 關聯設計 review | `M1-SPACE-DRAFT.md` | D-026 方向 | Item 單一 Space、搬 Space、Option B 管理讀取全部有規則 |
| M1-D-003 | Vault 分區設計 review | `M1-VAULT-DRAFT.md` | D-029 方向 | 普通資料、提醒、密鑰及加密資料邊界清楚 |
| M1-D-004 | Embedding 備用方案 review | `M1-EMBEDDING-DRAFT.md` | D-028；runtime 屬 M2 | model、切換、benchmark 同失敗處理有定義 |
| M1-D-005 | Reminder 分類 review | `M1-REMINDER-DRAFT.md` | D-030 方向 | 時間、地點、人物、緊急程度及 acknowledgement 欄位清楚 |
| M1-D-006 | MCP Tool 清單 review | `M1-MCP-DRAFT.md` | D-027 方向 | connector、資料級別、read-only 操作及風險逐項列出 |
| M1-D-007 | Google 登入流程 review | `M1-LOGIN-DRAFT.md` | D-032 Draft | 大人、細路、家長批准、recovery 同唔批准狀態完整列出 |
| M1-D-008 | M1 測試草稿 | `M1-TEST-DRAFT.md` | M1 骨架 | 每個設計面有單元、整合、安全及 UAT 入口 |
| M1-D-009 | API contract 骨架草稿 | 待另開文件 | M1 骨架 | UI 只經 `/api/v1`；寫入只經唯一資料存取模組 |
| M1-D-010 | 空環境執行骨架 review | 待另開文件 | M1 骨架 | 開發環境只用 synthetic/test data，同家庭 Primary 隔離 |

## PRD 已明確唔應放入 M1

| 項目 | 原定里程碑／狀態 | M1 處理 |
|---|---|---|
| 自然語言輸入、Search、理由、Undo | M2 | 只可寫介面設計；唔做執行 |
| 相片 Link | M3 | 唔做 |
| 備份／還原、Passkey | M4 | 只保留資料保護影響分析；唔做登入或備份功能 |
| Face ID | M5 | 唔做 |
| SHARE | M6，範圍及時間未定 | 唔做 |
| Google login | D-032 Draft | 只畫流程；唔實作 |
| MiniLM／e5／qwen runtime | M2 benchmark direction | 只做方案同測試設計；唔選 production model |
| MCP 寫入、Cloud 私人資料 connector | 未批准 | 禁止 |

## 建議順序

1. 先 review `M1-TODO-DRAFT.md` 本身同 M1 邊界。
2. 再 review Space / Vault / reminder 嘅資料邊界。
3. 跟住 review MCP / Embedding / login 嘅外部依賴。
4. 最後 review 測試計劃，確認每項都有可觀察 PASS／FAIL。
5. REVIEW 完成後，另由 Joe 決定邊一項先做；本文件唔代替嗰個決定。

