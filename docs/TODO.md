# TODO — 未完成事項

> 以下只列未完成工作。原有 Family Calendar System MVP + AI Co-Pilot 清單中的已完成項目已移至 [PROGRESS.md](PROGRESS.md)；該清單的雲端／舊架構工作須先對照現行 PRD V10.2（V10.1 已移至 `docs/archive/TimeMem-PRD-V10-1.md`），不能直接視為已批准的 TimeMem 方向。

## M1 下一階段

> D-051 已正式批准 M0 PASS；`owner-private` 係唯一正本，M1 按以下最小圈逐步執行。

- [x] D-052 已定 M1 test plan：5 條合成版行程、2 條問題、2 個 PASS 標準；資料及完整規格保留喺 `docs/owner-private/04-PRIVATE-TEST.md`。
- [ ] 下個月先按 D-052 寫 code；呢個月唔寫 code。
- [ ] 實作 `bge-m3 + Postgres + pgvector + qwen3:8b` 最小圈：1 條行程 = 1 chunk，`test_schedules` 取最似 2 條，再以 RESULT 彈出框顯示。
- [ ] PASS 後先加 PDF、加多啲行程、加多啲人。

### 後續 milestone 待決定

- [ ] 依 D-015 至 D-022 草案逐項取得 Joe 決定；未批准前不作架構或產品行為依據。

## 2026-11-22 reviewed direction follow-up

- [ ] **TASK-032-A:** Joe 決定 D-032 household login：Passkey/PIN、Google-only 或 Google optional bootstrap/recovery；未批不得改 D-008 implementation。
- [ ] **TASK-027-A:** 定義 MCP connector contract：transport、credential store、payload classification、allowlist、audit、revoke、warning text。
- [ ] **TASK-028-A:** 準備 100 個 synthetic mixed-language benchmark cases；固定 model version/digest 後測 MiniLM/E5/qwen2.5 candidates。
- [ ] **TASK-029-A:** 設計 Vault key hierarchy、re-auth、OCR/thumbnail、title-only search、backup/restore 及 weekly restore evidence。
- [ ] **TASK-030-A:** 定義 reminder schema、ack state、missed state、T-60/T-30/10-minute defaults、OS Calendar/Reminders bridge。
- [ ] **TASK-031-A:** 確認 canonical rename 後所有 links/script/check 通過；完成後唔再使用舊 `M0-READY.md`／`working/` active paths。
- [ ] **TASK-000-A:** 將目前 Hybrid 5 scaffold 定義為 prototype/reference 或正式 approved baseline；M0 未批前不新增 product code/schema。

## Archived legacy backlog

FamilySystem / Supabase / OpenRouter / Telegram 嘅未完項目已移至 [Legacy-FamilySystem-TODO-2026-11-22.md](./archive/Legacy-FamilySystem-TODO-2026-11-22.md)。呢啲項目唔係現行 TimeMem TODO，亦不能自動重新納入。