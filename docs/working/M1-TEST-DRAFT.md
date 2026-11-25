# M1 測試計劃草稿

> **狀態：REVIEW ONLY / 草稿 / 未批准**  
> 本計劃只覆蓋 design verification 同未來測試入口；唔係 M0、M1、功能或 schema 驗收批准。  
> 全部測試只用 synthetic/test data，禁止真實 Vault、證件、姓名、附件或家庭 logs 做 evidence。

## 測試層次

| 層次 | 目的 |
|---|---|
| 文件 review | 驗證草稿同 PRD／DECISIONS／ARCHITECTURE 無矛盾 |
| 單元測試 | 驗證單一規則、狀態轉換、權限判定 |
| 整合測試 | 驗證 API、DAO、AI、MCP 及 DB 邊界 |
| 安全測試 | 驗證資料隔離、最少權限、加密、audit、failure |
| UAT | 以 synthetic 家庭場景驗證可理解性 |
| benchmark | 固定模型、fixture、機器資源及可重現結果 |

## M1 骨架

| Test ID | 測試 | PASS 條件 |
|---|---|---|
| M1-T-001 | UI 經 `/api/v1` 做資料操作 | UI 冇 DB credential，唔直接連 PostgreSQL |
| M1-T-002 | 唯一資料存取模組 | 寫入只由核准資料存取邊界完成；Python 無 DB credential |
| M1-T-003 | 服務隔離 | PWA、Gateway、Python、DB、Ollama 只經核准網絡／API 通訊 |
| M1-T-004 | 開發資料隔離 | synthetic/test DB 無法連家庭 Primary |
| M1-T-005 | 明確 failure | 服務／DB／模型失敗顯示錯誤，不產生 success-shaped 回覆 |

## Space

| Test ID | 測試 | PASS 條件 |
|---|---|---|
| SP-T-001 | 建立新 Item | 預設 `Family Shared`，只有一個 `space_id` |
| SP-T-002 | 搬入自己私人 Space | 自己擁有時可完成；無 duplicate |
| SP-T-003 | 私人 → Family Shared | 顯示來源／目的、5 秒倒數、第二次確認；取消則不搬 |
| SP-T-004 | 跨私人 Space | 來源同 destination owner 都批准先搬 |
| SP-T-005 | 併發搬移 | transaction 只保留一個最終 Space，無 orphan |
| SP-T-006 | Ailene 權限 | 預設只能見 Family Shared |
| SP-T-007 | Option B admin 讀取 | 必須有明確理由、事前警告、短期 scope、immutable audit |
| SP-T-008 | Admin 日常使用 | 管理身份唔自動展示其他私人內容 |

## Vault

| Test ID | 測試 | PASS 條件 |
|---|---|---|
| V-T-001 | Vault 提交 | Joe／Joy 可以 unlock；Ailene 只能 request |
| V-T-002 | 普通搜尋 | 唔返回 Vault content；只返回白名單 metadata |
| V-T-003 | AI 隔離 | Vault content 唔進 embedding、prompt、AI summary、log 或 trace |
| V-T-004 | Reminder | 只顯示「有重要文件快到期」等非敏感文案 |
| V-T-005 | 泄漏防護 | 敏感候選先 quarantine／mask，唔靜默公開 |
| V-T-006 | 加密 | detail encryption design 先批准後，wrong key 明確失敗 |
| V-T-007 | restore | ordinary 同 Vault 分開驗證、隔離 restore、Joe／Joy 才 unlock |
| V-T-008 | audit | unlock、read、request、deny、restore 全有不可靜默刪紀錄 |

## Embedding

| Test ID | 測試 | PASS 條件 |
|---|---|---|
| E-T-001 | 100 個固定 cases | Cantonese、中文、英文、中英夾雜、錯字同同義詞有覆蓋 |
| E-T-002 | model identity | MiniLM／e5 版本及 digest 固定且可重現 |
| E-T-003 | retrieval | 記 top-k、預期命中、錯誤率；目標錯誤率 ≤5% |
| E-T-004 | repeat pass | 相同 fixture 同硬件重跑一次仍合格 |
| E-T-005 | 資源 | cold start、p50/p95 latency、query/index peak RAM 有證據 |
| E-T-006 | index 隔離 | e5 唔查 MiniLM vector；切換只用獨立完整 index |
| E-T-007 | failure | missing model、Ollama down、OOM 時停 AI 寫入並提供 local/manual fallback |
| E-T-008 | Vault exclusion | Vault 內容冇任何普通 embedding row |
| E-T-009 | confidence | cosine similarity 唔直接當 confidence；三級政策測試邊界 0.7／0.9 |

## Reminder

| Test ID | 測試 | PASS 條件 |
|---|---|---|
| R-T-001 | 11 月 22 屯門跳舞 | 原句抽出日期、屯門、活動；時間、人物、類型不足時問 |
| R-T-002 | T-60 | 到期產生第一次提醒 |
| R-T-003 | T-30 | 產生第二次提醒及 checklist |
| R-T-004 | acknowledgement | event time 回應後記 `acknowledged` |
| R-T-005 | no response | 每 10 分鐘重提，連續兩次後記 `missed` 並停止重複聲音 |
| R-T-006 | override | event/todo 可改預設，但留來源及 audit |
| R-T-007 | reconnect | 離線後補回 missed state；唔宣稱 OS-level alarm |
| R-T-008 | 防漏私人內容 | 通知只顯示必要資料，Vault 提醒只用通用模板 |

## MCP

| Test ID | 測試 | PASS 條件 |
|---|---|---|
| MCP-T-001 | allowlist | 未 allowlist Tool 一律拒絕 |
| MCP-T-002 | read-only | Calendar、WhatsApp、Notes、Team 只讀；寫操作被拒絕 |
| MCP-T-003 | payload class | `VAULT`／`SECRET` 永遠不得外傳 |
| MCP-T-004 | scope | WhatsApp 只讀指定群組；Notes 只讀核准 path；Team 只讀指定班 |
| MCP-T-005 | Cloud warning | 公開 POC 顯示 upload warning，只用 synthetic data |
| MCP-T-006 | timeout／offline | 顯示明確錯誤，無假成功、無 silent retry 到其他來源 |
| MCP-T-007 | revoke | token／connector 撤銷後下一次呼叫立即失敗 |
| MCP-T-008 | audit | 記目的、Tool、資料級別、結果，唔記秘密或敏感原文 |

## Google 登入

| Test ID | 測試 | PASS 條件 |
|---|---|---|
| L-T-001 | 未批准狀態 | 屋企閉環仍唔啟用 Google；現行 Passkey/PIN 保持 |
| L-T-002 | profile binding | 一個 Google subject 準確綁一位 member |
| L-T-003 | 大人首次綁定 | 清楚顯示帳戶、角色、Space 同授權並需要家長確認 |
| L-T-004 | 細路首次綁定 | 父母批准 account activation、manager 同限制 |
| L-T-005 | takeover 防護 | recovery、自動重綁定或 subject 更換唔可靜默完成 |
| L-T-006 | 新裝置 | 需要核准流程，且舊 session 可單獨 revoke |
| L-T-007 | logout／revoke | encrypted cache 清除，受影響 session 失效 |
| L-T-008 | Vault | Google login 唔足以 unlock Vault，必須短期重新驗證 |

## 跨功能情境

1. 用 synthetic Google account 讀 synthetic Calendar「11 月 22 屯門跳舞」。
2. Reminder 抽取資料後要求補完時間、場地同人物。
3. 使用者確認後，資料只入正確 Space。
4. AI 檢索只用普通 Item，唔接觸 Vault。
5. 所有寫入只經 Gateway／唯一資料存取模組。
6. 關閉模型、Calendar、WhatsApp 其中一個服務，各自顯示明確失敗。
7. audit 同 evidence 只包含 synthetic 識別及結果，唔包含 token／個人內容。

## 退出準則

- 每個已納入範圍測試有可重現步驟、預期結果同 evidence。
- Critical／Major 離群問題未關閉時，唔宣稱 PASS。
- 任何草稿同 PRD、DECISIONS、ARCHITECTURE 衝突，先停止 review。
- 測試通過只支持對應設計；唔自動批准 M1、schema、auth、model、MCP 或 production。
