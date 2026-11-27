# TODO — 未完成事項

> 以下只列未完成工作。原有 Family Calendar System MVP + AI Co-Pilot 清單中的已完成項目已移至 [PROGRESS.md](PROGRESS.md)；該清單的雲端／舊架構工作須先對照現行 PRD V10.2（V10.1 已移至 `docs/archive/TimeMem-PRD-V10-1.md`），不能直接視為已批准的 TimeMem 方向。

## 已完成嘅 Cold Start 包裝工作

- [x] 已將 root `README.md` 收斂為 60 秒入口，明確鎖定 M1 Priority 1、Obsidian Hold、n8n 後勤邊界及七份 Canonical Files。
- [x] 已建立 `.agents/skills/cold-start-pack/`，提供 `cold-start-pack` 觸發、Git archive、安全過濾及壓縮包掃描流程；完成證據及操作記錄見 [PROGRESS.md](PROGRESS.md)。
- [x] 已鎖定 `.github/copilot-instructions.md` 同 `docs/ARCHITECTURE.md` 嘅 M1 置頂錨點，舊 Express Gateway 標示 Legacy、Obsidian 雙向橋接標示 Hold。
- [x] 已升級 `.agents/skills/cold-start-pack/cold-start-pack.ps1`，打包時疊加未 commit 工作樹修改並重跑 Rule-SEC-01 掃描；第二次 ZIP 已以 0 路徑違規、0 Secret 命中 PASS。
- [x] 已完成第一次 68 分及第二次 87 分（B+）Cold Start 考牌；兩輪證據均同步至 PROGRESS／ERRORLOG。
- [x] 已物理歸檔 `docs/working/` 下已取代嘅 M1 草稿，並強制 cold-start-pack 腳本排除整個 `docs/working/`。
- [ ] 執行第三次 Cold Start 滿分（100 分）驗證測試；要求新對話精準吐出唯一 M1 閉環、雙機＋Tailscale 拓撲、Obsidian Hold、n8n 唯後勤邊界及七份 Canonical Files。

## M1 下一階段

> D-051 已正式批准 M0 PASS；`owner-private` 係唯一正本，M1 按以下最小圈逐步執行。

- [x] D-052 已定 M1 test plan：5 條合成版行程、2 條問題、2 個 PASS 標準；資料及完整規格保留喺 `docs/owner-private/04-PRIVATE-TEST.md`。
- [ ] **Priority 1：完成 FastAPI 圖片上傳至本地 Ollama 端對端最小圈。**
  - [ ] 實作 FastAPI `Multipart Upload` 圖片上傳 API，同時限定合成資料及本機儲存。
  - [ ] 接入本地 Ollama `qwen3:8b` 做 Vision / OCR 萃取人物、時間、地點及活動。
  - [ ] 將 OCR 文字經本地 `bge-m3` 轉成 embedding；固定 1 條行程 = 1 chunk。
  - [ ] 寫入本機 PostgreSQL `pgvector`，只限隔離表 `test_schedules`。
  - [ ] 問題經同一條 embedding 路徑檢索最相似 2 條，再交由 `qwen3:8b` 判定。
  - [ ] PWA 彈出 RESULT 框顯示行程卡；無結果顯示「搵唔到相關行程」。
- [ ] 按 D-052 固定 PASS 標準驗證：只喺指定星期一／星期四或星期二／星期六問題組合答中指定 2 條行程。
- [ ] PASS 後先加 PDF、加多啲行程、加多啲人。

## n8n 後勤定位

- [ ] 保持本地 Docker `n8n`（Port `5678`）為後勤自動化外掛／外部觸發器，不放入核心業務判斷。
- [ ] n8n 可接收 FastAPI Backend Webhook，負責日曆同步、通知提醒或開發期 API 測試。
- [ ] 所有上傳、OCR、embedding、向量檢索、結果判定及資料寫入仍嚴格留喺 FastAPI；n8n 唔直接處理核心模型邏輯或權威資料存取。

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