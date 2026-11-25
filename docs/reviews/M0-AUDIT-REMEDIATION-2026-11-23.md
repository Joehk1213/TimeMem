# M0 Audit 補救 Review — 2026-11-23

## Review 範圍

本 review 重看現行 PRD、D-026 至 D-038、GATE、TODO、PROGRESS、Hybrid 5 stack、installer/scripts 同 M0 evidence。目的只係講清楚衝突及後續，不改 M0 整體批准，不補寫實機測試結果。

## Post-change consistency 結果

| 範圍 | 結果 | 說明 |
|---|---|---|
| PRD 同 D-026 | 相容 | PRD 已定私人 Space 為真權限 boundary；D-033 未決前私人 schema/API 要 blocked。 |
| PRD 同 D-027 | 相容 | MCP 只係後續 read-only direction，唔改 M0。 |
| PRD 同 D-028 | 有可追蹤差異 | 現有 installer 仲用 `bge-m3`／`qwen3:8b`；D-035 已將呢點列做 M0 安裝例外，D-028 只係 M2 benchmark direction，未等同 runtime 批准。 |
| PRD 同 D-029 | 相容但未完成 | Vault policy 一致；encryption/KDF/key wrapping/paper recovery/restore details 仍係 pending，M0 唔應當已驗證。 |
| PRD 同 D-030 | 相容 | Reminder 係後續 milestone，M0 shell 驗收唔涵蓋。 |
| GATE 同 D-034 至 D-038 | 有時序例外 | 每個 D-ID 都係針對單一 REQ policy；必須保留「其他 REQ／M0 整體不變」boundary。 |
| GATE Review 日期 | 有缺口 | 2026-11-15 review 先於 D-026 至 D-038；呢份 review 係 MAI 單次 post-change consistency check，唔自動取代 GATE 要求嘅兩位指定 reviewer 同 Joe 最終批准。 |
| Hybrid 5 同 GATE rule | 衝突／已記錄 | 現行 stack 已部署，但 GATE 原則話未批前唔做 product code、DB 或 deployment；D-039 Draft 將佢明確列成等 Joe 決定嘅 M0 例外，未倒填 Approved。 |
| REQ-005 evidence | 未完成補救 | `20261122-235400` 係 Startup FAIL，唔可以作唯一 PASS evidence。指定嘅 `20261123-002605` 未可從 DESKTOP 讀取；WinRM 未配置，`C$` 亦無權。 |

## 需要保留嘅 blocker

- REQ-005：要 SERVER LUNA／Joe 將指定 Logon JSON 同 `.sha256.txt` 交付，驗過 content hash 及 PASS 狀態後，先可以考慮更新 evidence status。
- D-033：現有 `owner` authorization 同真正私人 Space 互相衝突；Joe 未決前唔改 code。
- REQ-004：現有圖片未同時清楚顯示成部 SERVER、Router、擺位及通風位。
- 備份：script 已草擬，但 off-host path、recipient/key custody 同 Vault key hierarchy 未決，唔可以宣稱備份 PASS。
- REQ-006/007：現有 2026-11-14 evidence 唔等於現行 Hybrid 5 stack 已重測；非 Tailnet 拒絕要 Joe/另一裝置實測。

## D-033 — 等 Joe 揀

| 選項 | 內容 | 後果 |
|---|---|---|
| A | System Admin 完全唔可以睇其他人私人 Space／Vault | 私隱最強；普通 support/backup 只做加密操作，Joe 自己查私人內容亦要 owner 授權／解鎖。 |
| B | Admin 可以喺有理由嘅情況睇，但每次讀取都記 immutable audit log 同顯示警告 | 支援/救急較方便；仍削弱「真正私密」語義，audit log 同 break-glass 流程要先設計及測試。 |
| C | M0 接受風險，留返 M1 處理 D-033 | 最快過 M0，但本身高風險；現有 owner 可讀所有私人內容嘅 code 不能當作已符合 PRD。 |

## 結論

本次 post-change review 無發現 PRD 同 D-026 至 D-038 有不可解釋嘅新衝突；真正 blocker 係 evidence、review authority、D-033、backup key/off-host 同實際部署例外未完成。以上事項未齊之前，M0 仍應保持 NOT APPROVED。
