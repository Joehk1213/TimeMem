# PROGRESS — 已完成事項

## 2026-11-28 23:00 — 自動化共識同步

- 透過自動化流水線成功同步最新對話共識摘要。

## 2026-11-28 22:50 — 自動化共識同步

- 透過自動化流水線成功同步最新對話共識摘要。

## 2026-11-28 22:34 — 自動化共識同步

- 透過自動化流水線成功同步最新對話共識摘要。

## 2026-11-28 18:39 — 自動化共識同步

- 透過自動化流水線成功同步最新對話共識摘要。

## 2026-11-28 18:18 — 自動化共識同步

- 透過自動化流水線成功同步最新對話共識摘要。

## 2026-11-28 — Direct Mode、雙軌雙庫及部署資安共識落檔

- 已核實 `scripts\deploy_all.bat`係現行 Direct Mode 入口：本機先執行 Git 狀態檢查、Commit／Push，再透過 `plink.exe -i %USERPROFILE%\.ssh\joe-server.ppk`連至 `joe-server`，遠端執行 `git pull origin main && docker compose up -d`。
- 已確認 JOE-SERVER Docker Desktop 需保持常駐；不再由腳本背景執行遠端 `net stop/start`或把 Docker daemon 崩潰設為可盲目自癒流程。若遇 npipe、認證或容器異常，由 Joe 人手登入伺服器排查。
- 已確認雙軌定位：`C:\Project\TimeMem`負責產品、PWA及部署；`C:\Project\REPO`負責跨專案知識、模板及 Cold Start；兩者使用獨立 Repo 與資料邊界。
- 已落實 n8n 為雲端觸發與本地知識同步閉環嘅後勤設計，但未核實可匯入嘅 Workflow JSON；n8n 仍不得直連 PostgreSQL、不能取代 FastAPI核心閉環或保存私人內容。
- 已確認香港時間 Summary 歷史檔名規範為 `YYYYMMDDHHMM_latest_summary.md`；自動歸檔使用 Luxon `Asia/Hong_Kong`轉換。
- 已核實部署腳本使用 PPK 私鑰而非內嵌密碼；部署密碼、API Key、Private Key及 `.env`不得提交 Git。未發現遠端密碼明文寫入現行 `deploy_all.bat`；文件仍記錄歷史教訓及人工介入止境。
- 已將三項共識沉澱至 `docs/DECISIONS.md`：D-059 Direct Mode 部署、D-060 雙軌雙庫及 n8n 閉環、D-061 SSH 私鑰鑑權與人工介入資安。
- 下一步仍需核對及補齊：`sync_consensus.bat`靜默模式、n8n Workflow JSON、Google Drive Archive／命名節點，以及部署腳本是否需要前端 no-cache rebuild；未完成項目同步至 TODO，不得當作已落地。

## 2026-11-27 — FamilySystem 舊 Repo 歷史資產 Autopsy 共識落檔

- 已完成舊 Repo 壓縮包 `C:\Project\FamilySystem-Cleaned.zip` 共 352 個檔案項目的歷史資產審查；呢次只確認可攜資產、架構參考及資安紅線，唔代表批准直接搬運舊程式碼、資料或相片。
- 已確認可直接利用／搬遷保留嘅資產包括：`public/vendor/pdfjs/` 完整離線工具鏈（core、worker、cmaps、standard_fonts、WASM）；`supabase/migrations/` 與 `database/init/` 歷次演進、RLS 政策及資料庫初始化架構；`20261028000011_family_encryption_real.sql` 所示基於 `pgcrypto` 嘅欄位加密方案；以及經實戰驗證嘅 `scripts/` PowerShell 備份與維運檢核腳本。上述資產使用前仍須逐項資安審查、相容性評估及 Joe 批准；唔得直接匯入私人資料。
- 已確認可作高價值架構參考嘅資產包括：`docs/obsidian/` 載入死循環與災難復原等除錯筆記，以及紅隊安全審查報告；`server/hybrid/` 與 `source/agents/` 嘅多 Agent 職責分工、編排設計及 Supabase 兼容層思維。兩者只作架構同除錯參考，不構成 M1 自動批准範圍。
- 已正式沉澱 Cold Start／備份打包絕對排除清單：禁止 `.git/`、`node_modules/`、`.venv/`、`venv/`、`.validation-venv/`、`__pycache__/`；禁止全部 `.env*`、私鑰、憑證及 `.pem`、`.key`、`.p12`、`.pfx`、`id_rsa*`、`id_ed25519*` 等；禁止 `reference/photo/`、`docs/` 下私人相片及整個 `docs/working/` 草稿夾。
- 已確認打包機制仍須重做工作樹疊加、強制路徑過濾、ZIP 串流文字掃描及 0 路徑違規／0 真實 Secret 命中兩項 PASS 門檻；任何路徑違規、Secret 命中、內容無法可靠讀取或掃描失敗均只得回報 FAIL，不得成功形態回報。
- 完成規範落檔至 `docs/DECISIONS.md`（D-058）；現階段未搬移任何舊資產、未加入 PDF 工具鏈、未建立加密 migration、未執行資料庫變更、未修改現行 UI，仍需按功能逐項批准。

## 2026-11-27 — Gemini 協同資安、備份及介面方向同步

- 已確認舊 Repo 已完成嚴格資安脫敏及清理，安全備份產物為 `C:\Project\FamilySystem-Cleaned.zip`；實測包含 352 個檔案項目，後續以壓縮包實測清單及 Rule-SEC-01 掃描為證據，不把真實相片、credentials或私密目錄帶入現行 Repo。
- 已確認全域共用入口 `C:\Project\REPO\README.md` 已建立標準知識產出物及可重用 Repo 模板，涵蓋文件權威次序、廣東話記錄規則、Cold Start 打包規範及新 Repo 建立清單；未將共享資料夾視為 TimeMem product code 或新 project approval。
- 已確認 `.agents/skills/cold-start-pack/cold-start-pack.ps1` 為 TimeMem Cold Start 強制打包入口；腳本及 `SKILL.md` 已鎖定 `.git/`、`node_modules/`、`.venv/`、`venv/`、`.validation-venv/`、`__pycache__/`、全部 `.env*`、私鑰憑證、副檔名相片及 `docs/working/` 排除規則。
- 已確認打包後必須逐項掃描 ZIP 路徑及文字內容；AWS Key、OpenAI／GitHub／Bearer／通用 Token、Password assignment、私鑰標頭等任何命中均須回報 FAIL；只有 0 路徑違規及 0 真實 Secret 命中才可回報 PASS。
- 已將介面後續方向列案：重新融合舊 Repo 的「背景相片浮動縮放漫遊」與 TimeMem 現有「ASCII 鯊魚／魚群游動特效」；此項目前只作進度及設計方向紀錄，未執行程式碼還原、未改動現行 UI、未變更 M1 approved scope。
- 下一步只可在開發者與 AI 協同檢視脫敏備份及現行介面後，再按各功能單獨需求取得批准並實作；不得直接自動把舊 Repo 整體功能或私人內容帶回現行專案。

## 2026-11-27 — Canonical Files 全倉核心規範同步

- 已把品牌、初心、願景、商業模式及 100% Self-Host 私隱閉環同步至 Root `README.md` 及 `docs/PRD.md`。
- 已把 PWA 圖片上傳、FastAPI Multipart Upload、Ollama `qwen3:8b` + `bge-m3`、PostgreSQL pgvector及 PWA RESULT 框鎖定為唯一 M1 閉環。
- 已將兩部 Fujitsu Lifebook U9311X、JOE-DESKTOP 隨身開發／Tailscale RDP、JOE-SERVER C + D 槽及唯一可寫生產資料庫主機拓撲寫入現行文件。
- 已鎖定 Obsidian 為 Hold、n8n 為 Port 5678 後勤外掛及 `docs/working/` 強制隔離鐵律。
- 已記錄三輪 Cold Start 分數 68 → 87 → 65 的路徑依賴及 Lost in the Middle 教訓。
- 下一步：完成現行入口同 Git 同步後執行最新 cold-start 打包及滿分驗證；現階段仍為待驗證，未宣稱已滿分。

## 2026-11-27 — 兩輪 Cold Start 考牌收尾與草稿物理隔離

- 第一次 Cold Start 得 68 分：現有 AI 偏向舊版 Express／Node.js 架構，亦誤判 Obsidian 為核心介面；其後已建立 M1 OVERRIDE 置頂錨點、Root README 60 秒入口及 Working Tree Overlay 打包規範。
- 第二次 Cold Start 得 87 分（B+）：雙機拓撲、Obsidian Hold、n8n 禁止直連 DB、七份 Canonical Files 一致性均滿分；唯一未滿分係第 1 題受 `docs/working/` 未批准草稿干擾，未精準吐出 M1 唯一閉環。
- 已確認第二輪根本原因屬 Lost in the Middle／關鍵字檢索干擾；已將已取代的 M1 草稿移入 `docs/archive/`，並已由 D-055 正式決策。
- 已強化 `.agents/skills/cold-start-pack/cold-start-pack.ps1` 與 `SKILL.md`，打包層強制排除整個 `docs/working/`，不再依賴單一文件提示。
- 已同步更新 `README.md`、`.github/copilot-instructions.md`、`PRD.md`、`ARCHITECTURE.md`、`GATE.md`、`DECISIONS.md`、`ERRORLOG.md`、`TODO.md`，確保 Server＋Desktop＋Tailscale、Obsidian Hold、n8n 後勤邊界及 M1 唯一閉環一致。
- 下一步：執行第三次 Cold Start 滿分（100 分）驗證，確認第 1 題精準回覆 FastAPI Multipart Upload → 本地 Ollama qwen3:8b Vision／OCR＋bge-m3 → pgvector 寫入 → PWA 彈出式 RESULT 框。

## 2026-11-27 — Root README M1 冷啟動入口對齊

- 已將 root `README.md` 收斂為 60 秒入口：明確鎖定 M1 階段、唯一閉環為 FastAPI Multipart Upload、Ollama Vision / OCR＋bge-m3、pgvector 寫入及 PWA RESULT 框。
- 已補齊關鍵邊界：Obsidian 雙向整合設為 Hold；本地 Docker n8n 只作後勤自動化外掛，嚴禁直連或寫入 DB。
- 已列出七份現行 Canonical Files 入口及 `.agents/skills/cold-start-pack/cold-start-pack.ps1` 冷啟動打包指引。
- 已重跑 Cold Start 包裝：HEAD `fbdc8d37c099`、`TimeMem-clean.zip` 352 個檔案、0 路徑違規、0 Secret 命中、`SCAN_STATUS=PASS`；ZIP 已核對含最新 README 及 M1／Hold／Working Tree Overlay 關鍵內容。

## 2026-11-26 — Cold Start 考牌除錯、腳本升級及第二次重考準備

- 已完成一次 M1 置頂錨點 Cold Start 考牌除錯；確認舊版架構敘述會造成 Lost in the Middle，新對話需以置頂指令及 TODO 頂部為最高準則。
- 已升級 `cold-start-pack.ps1`：先匯出當前 HEAD，再疊加工作樹修改及未追蹤受控新檔，重新過濾敏感資料後重建 ZIP。
- 最新 ZIP 已完成第二次重建及終檔核對：置頂指令、架構 Active Data Flow、PROGRESS 錨點三項均已命中；資安掃描為 352 個檔案、0 路徑違規、0 Secret 命中、SCAN_STATUS=PASS。
- 已將兩大除錯教訓同步至 `docs/ERRORLOG.md`，並以 D-054 正式記錄置頂錨點機制及工作樹疊加打包規範。
- 下一步進入第二次 100 分 Cold Start 考牌重考，重點驗證新對話能否自動鎖定 M1 Priority 1、Obsidian Hold、n8n 後勤定位及 FastAPI 核心閉環。

## 2026-11-26 — M1 置頂錨點鎖死完成

- 已將 `.github/copilot-instructions.md` 新對話置頂區塊更新為 `## 🚨 CURRENT ACTIVE DIRECTIVE (M1 OVERRIDE)`，並鎖定 M1 Priority 1、Obsidian Hold 同 n8n 後勤外掛定位。
- 已明確要求所有新對話優先採用置頂指令及 `docs/TODO.md` 頂部，唔採信 `docs/archive/`、M0 草稿、舊版架構圖或衝突描述。
- 已喺 `docs/ARCHITECTURE.md` 頂部加入一致嘅 M1 Active Data Flow，並將舊版 Express Gateway 同 Obsidian 雙向橋接標示為 Legacy／Hold。
- 已修正 `cold-start-pack`，打包時疊加未 commit 嘅工作樹修改，避免新 ZIP 漏載置頂錨點；最終仍依 Rule-SEC-01 敏感資料過濾及 ZIP 掃描。
- 本次只調整新對話指引及現行架構／進度文件，唔改產品批准範圍或程式碼。

## 2026-11-26 — Cold Start 安全打包 Skill 完成

- 已新增 `.agents/skills/cold-start-pack/SKILL.md`，定義 `cold-start-pack`、打包乾淨 Repo、做 Cold Start Test 等觸發條件。
- 已新增 `.agents/skills/cold-start-pack/cold-start-pack.ps1`，使用 `git archive HEAD` 建立暫存匯出；強制剔除 Git metadata、全部 `.env*`、`reference/photo/`、`docs/` 圖片、虛擬環境、私鑰及私人資料目錄，並覆蓋 `C:\Project\TimeMem-clean.zip`。
- 腳本會掃描 ZIP 路徑及文字內容，檔案、真實 Secret 或私鑰命中非零時回報 FAIL；PASS 時回報 HEAD、ZIP 路徑、檔案總數及 0 違規結果。
- 已提供標準 Cold Start 測試官 Prompt，可直接複製到新聊天室作冷啓動理解測試。

## 2026-11-26 — M1 基底結構與核心主線正式對齊

- 已精簡 `.github/copilot-instructions.md`，保留強制收尾同步、架構決策同步、繁體廣東話 Record 語言、Rule-SEC-01 資安紅線及 Obsidian Vault Hold 狀態。
- 已確認 M0 已 PASS，現行階段正式鎖定為 M1。
- 已補齊 `docs/GATE.md` 同 `docs/ERRORLOG.md` 為根目錄 Canonical Files；舊 M0／歷史文件繼續隔離喺 `docs/archive/`。
- 已將 M1 Priority 1 定為 FastAPI Multipart Upload → 本地 Ollama `qwen3:8b` Vision / OCR → `bge-m3` embedding → PostgreSQL `pgvector` 寫入 → PWA RESULT 框閉環。
- 已記錄本地 Docker n8n（Port `5678`）只做後勤自動化外掛／外部觸發器；核心業務邏輯繼續留喺 FastAPI。

## 2026-11-26 — 文件瘦身及腳本導覽完成

- 已完成 `docs/` 根目錄瘦身；保留 `PRD.md`、`TODO.md`、`PROGRESS.md`、`DECISIONS.md`、`ARCHITECTURE.md` 作核心現行文件。
- 已將 `GATE.md`、`ERRORLOG.md`、`REQUIREMENTS.md`、`RISKS.md`、`TEST-PLAN.md`、`plan4.md` 歸入 `docs/archive/`；同名衝突時會加上 `2026-11-` 前綴。
- 已更新 `docs/README.md`，只索引五份核心文件、`docs/working/` 及歷史 `docs/archive/`。
- 已建立 `scripts/README.md`，按環境安裝與啟動、日常檢查與驗證、備份與證據同步、AI Skills 維護四類整理現有 `.ps1` Script。
- 專案準備度已達滿分狀態，M0 已 PASS，並已準備隨時開啟 M1 功能模組開發；後續仍須按範圍及批准流程逐步執行。

## 2026-11-25 — Multi-Agent 交接機制同專案文件重整

- 已新增 `docs/working/AGENT-STATE.md`，作為 Multi-Agent 唯一交接狀態板。
- `.github/copilot-instructions.md` 已加入開工前讀取交接文件、完工後同步更新嘅強制規則。
- 已確認 `docs/PRD.md` 係現行 V10.2，並只修正開頭格式；舊 V10.2 snapshot 仍保留喺 `docs/archive/`。
- 舊架構圖及歷史說明已由 `reference/` 移入 `docs/archive/`；無刪除程式碼。
- PWA 合併候選已列入 `docs/working/AGENT-STATE.md`：`TimeMem-PWA/manifest.json`、`TimeMem-PWA/sw.js`，預定目的地為 `frontend/public/`；暫未搬動或刪除任何程式碼。

## 2026-11-25 — M1 test plan 完成

- Joe 已批准 M1 private test plan，正式編號為 D-052。
- Test plan 固定 5 條合成版行程、2 條問題、2 個 PASS 標準；技術為 `bge-m3 + Postgres + pgvector + qwen3:8b`，1 條行程 = 1 chunk。
- RESULT 使用彈出框，唔加功能落 PWA 原有頁面；PWA 主頁魚仔保持原樣。
- M1 test 資料及完整 plan 已放喺 `docs/owner-private/04-PRIVATE-TEST.md`。
- D-052 已同步到 TODO：下個月先寫 code，呢個月唔寫 code；PASS 後先加 PDF、行程同人。
- 呢輪只更新記錄；冇 commit，亦冇 push。

## 2026-11-23 — M0 正式通過

- Joe 於 2026-11-23 正式批准 M0 PASS，已記入 D-051。
- 三項整體判定全部 PASS：安全、穩定、頂到 M1。
- M0 requirements、review、D-050 Off-host HDD 加密備份／restore 同 `qwen3:8b` 測速證據已齊。
- `GATE.md` 已更新為 M0 PASS 及批准日期 2026-11-23；TODO 已移除 M0 部分，改為 M1 下一階段。
- M1 仍須按 `Text → Embedding → Vector DB → UI` 最小圈逐步執行、驗證及停候下一次批准。
- 呢輪冇 commit，亦冇 push。

## 2026-11-23 — Off-host HDD 備份、restore 同模型測速完成

- Joe 已批准將今晚結果以 D-050 同步入正式記錄。
- HDD：`E:` BUFFALO 2TB 外置 USB HDD，使用 BitLocker XTS-AES 256，FullyEncrypted，Protection On。
- 備份：已寫入 `E:\JOE-SERVER\C-Project-20261123-221322`，合共 1055 個 file、50,429,049 bytes；全部 SHA-256 核對正確。
- Restore：由備份還原 `TimeMem\docs` 40 個 file；全部 SHA-256 核對正確，temp 已清除。
- `qwen3:8b`：實測 9.02 tok/s；200 字約 22.17 秒，符合 D-046 所定性能基準。
- D-042 同 D-048 要求嘅今晚 HDD／restore／測速證據已齊；原兩項未完成工作已由 TODO 移除。
- 呢輪只記錄證據；冇改 `GATE.md`、approval，亦冇 commit 或 push。M0 整體仍等 Joe 最後決定 PASS 或 NOT PASS。

## 2026-11-23 — Meta AI 決定已入 repo

- Joe 已批准並記錄 D-043 至 D-049。
- D-043：移除 `owner-public`，`owner-private` 成為唯一正本；唔再維護 public POC、公開 Cloud 或 Supabase 雲端路線。
- D-044：M1 先做 `Text → Embedding → Vector DB → UI` 小圈，PDF 遲啲先加，唔一次過做晒完整 pipeline。
- D-045：採用阿SIR Reading App Logic；約 1000 字切段、Embedding、存本地 PostgreSQL Vector DB、Top 5 retrieval、`qwen3:8b` 回答、UI 顯示；Embedding 用本地 Ollama `bge-m3`。
- D-046：`qwen3:8b` 維持首選；16GB RAM／冇 GPU 以 5–10 tok/s 為正常，200 字答覆 30 秒內完成先合格，唔合格先落 `qwen3:4b` 後備。
- D-047：M1 test data 固定用公開、唔敏感嘅 `docs/README.md`，唔用假資料或私人資料。
- D-048：今晚直接插 USB 嘅 Off-host HDD；500GB 以上先得、1TB 最好，順便做 `qwen3:8b` 速度測試。
- D-049：AI 要一步一步，一次只做一樣，短回覆；Joe 講停就即停。
- 呢輪只更新決策及記錄；冇改 `GATE.md`、approval、code，亦冇 commit 或 push。

## 2026-11-23 — M0 當前狀態

| 要求 | 狀態 | 已記錄證據／說明 |
|---|---|---|
| REQ-001 | PASS | D-034；Joe 確認 2026 年 8 月已清機，現狀 evidence 已收錄。 |
| REQ-002 | PASS | D-035；installer exit code 0，三個 endpoint HTTP 200，Docker container healthy，模型可用。 |
| REQ-003 | PASS | D-036；接受穩定 WiFi、Power 及長時間運行 evidence、`unless-stopped`。 |
| REQ-004 | PASS | D-037；接受現有 WiFi 同枱面擺位 evidence。另加全景相審計要求已由 Joe REJECT，唔再重拍。 |
| REQ-005 | PASS | D-038；00:24 Logon JSON 逐項 PASS，SHA-256 已對返，舊 FAIL 已移入 `superseded/`。 |
| REQ-006 | PASS | D-042；LINK JSON 顯示 Tailnet HTTP 200、非 Tailnet 連唔到，SHA-256 已對返。 |

- D-033 選 B、D-039、D-042、D-050 同 D-051 已由 Joe 批准；M0 整體已於 2026-11-23 正式 PASS。
- D-050 已記錄唯一 HDD TBD 所需嘅 Off-host 備份及 restore evidence，今晚技術證據已完成。
- M0 已轉入 PASS；下一步只按 D-043 至 D-047 進行 M1 最小圈，唔代表後續 milestone 自動批准。

## 2026-11-23 — M0 Audit 補救準備完成

- 已對 PRD、D-026 至 D-038、GATE、TODO、Hybrid 5 stack、scripts 同 evidence 做一次 post-change consistency review；呢次只係 MAI 單次 review，唔取代 D-014 要求嘅兩位 reviewer，亦唔改 M0 NOT APPROVED。
- D-039 已由 Joe 批准；Hybrid 5 已部署事實正式記作 M0 例外，但唔修改 M0 整體 approval。
- 已加入 `scripts/Backup-TimeMem-Encrypted.ps1` 及 `docs/working/TimeMem-Backup-Restore-Test.md`；script 會要求 off-host path、`age` public recipient 同 label，唔會喺未提供條件時跑。
- REQ-006 最新 LINK JSON 已收錄，D-042 批准以 Tailnet HTTP 200 同非 Tailnet 連唔到作 PASS；唔再要求重做電話測試。
- REQ-005 指定 Logon JSON 已同步、hash 已核對；舊 FAIL 已移入 `superseded/`，冇再用 AUDIT 早前嘅自相矛盾狀態。

## 2026-11-23 — REQ-005 PASS

- Joe 已批准 D-038；REQ-005 按 Joe 親自確認加 2026-11-23 00:24:50 本機 Logon PASS JSON 記為 PASS：3000 / 444 / 11434 全部 HTTP 200，Docker 三個容器 healthy，Ollama API 有 `bge-m3` + `qwen3:8b`；SHA-256 為 `0B2F6319B1E3F70412B92E10AC87679F30AB429FFEEAE3E9C29EF871119B482C`。驗證程式寫入雜湊／共享同步失敗列做工具後續處理，唔影響 TimeMem 驗收；M0 整體仍為 NOT APPROVED。

## 2026-11-22 — REQ-004 PASS

- Joe 已批准 D-037；REQ-004 按新政策記為 PASS：接受 WiFi 代替 LAN，同接受 JOE-SERVER 直接放枱面而唔使鋁架。Joe 已實測 WiFi 一星期穩定；擺位相證明部機同 ROUTER 並排、通風、唔入櫃、唔入袋；證據已收錄於 `docs/evidence/M0-REQ-004/`。M0 整體仍為 NOT APPROVED。

## 2026-11-22 — REQ-003 PASS

- Joe 已批准 D-036；REQ-003 按新政策記為 PASS：Ethernet 接受一星期穩定 WiFi；Lock 8 小時電話 Search 測試 BYPASS；Docker restart policy 接受 `unless-stopped`。M0 整體仍為 NOT APPROVED。

## 2026-11-22 — REQ-002 PASS

- Joe 於 2026-11-22 批准本 REQ；SERVER installer exit code 0，`bge-m3` + `qwen3:8b` 齊全，3000 / 444 / 11434 全部 HTTP 200，三個容器 healthy；完整證據已收錄於 `docs/evidence/M0-REQ-002/`，REQ-002 記為 PASS。M0 整體仍為 NOT APPROVED。

## 2026-11-22 — M0-REQ-001 至 M0-REQ-005 初次 evidence 檢查

- 初次檢查 `docs/evidence/` 時只見 `M0-REQ-006`，因此當時 REQ-001 至 REQ-005 保持 NOT EVIDENCED；後續 REQ PASS 狀態見頂部現況表。

## 2026-11-22 — 記錄語言規則已統一

- 所有 record 嘅新內容一律用廣東話；只保留明確准用嘅英文檔名、路徑、ID、指令、code、文件名、M0、Space、Vault、MCP、人名、Space 名及專有名詞。
- 已將規則記入 `.github/copilot-instructions.md` 及 `C:\Project\REPO\README.md`，之後所有新 repo 都跟同一做法。
- 舊 record 唔一次過重寫；下一次更新嗰份檔時，會順手將受影響嘅英文段落轉返廣東話。

## 2026-11-22 — canonical document rename and product detail review recorded

- 以 `git mv` 將舊 active files normalize 到 `docs/GATE.md`、`docs/TODO.md`、`docs/PROGRESS.md`、`docs/ERRORLOG.md`；`docs/PRD.md` 係 active Version 10.2。
- 舊 `M0-READY.md`、V10.2 PRD snapshot 已保留於 `docs/archive/`；沒有 delete。
- PRD/DECISIONS/ARCHITECTURE 記入 Space、MCP、Vault、reminder 及 compact local model direction；M0 仍 NOT APPROVED。
- 舊 FamilySystem / Supabase backlog 已 archive，現行 TODO 只保留 TimeMem 工作。
- 此次只處理 rename、link normalization 及文件整理；無 product code、schema、deployment 或 approval status change。

## TimeMem 文件與規劃

- 2026-11-05 首次建立本進度文件。
- PROMPT 1：README Review 完成，結果 PASS，檢查 11 項。
- 舊 Phase 1 Implementation Plan 僅完成規劃，現已封存為 obsolete 歷史文件；不得視為已批准範圍或已實作功能。
- STEP 4：建立 `.github/copilot-instructions.md`。
- 四份基礎文件細執完成。
- GitHub 第一次 Push 次序已決定：先 Review 四份基礎文件，再 Push；不一開波就 Sync。
- 開工前 scaffold 文件整理完成：Root README 作為入口、`docs/README.md` 保留九份文件索引、正式決策位置記錄於 `docs/DECISIONS.md`。
- 建立 `.env.example`，只列變數名稱及用途註解，沒有真密碼或 API key。
- 確認 `.gitignore` 有 `__pycache__/` 及 `*.pyc` 規則；清除過往的 Python cache 資料夾，保留 `.py` 原始碼。

## 既有 Family Calendar System MVP + AI Co-Pilot 完成紀錄

以下保留原 TODO 已標記完成的事項；仍未完成的驗證及後續工作已移至 `docs\TODO.md`。

### 階段一：地基與數據鏈路

- 已設定專案規範 `.github/copilot-instructions.md` 與 Supabase Key。
- Task 1.1：已測試 Supabase DB 連線與 Schema 讀取（`source/DB_SCHEMA_DRAFT.sql`）。

### 階段二：輸入層與 RAG 記憶庫

- Task 2.1：已串接 Chat-First 本機規則解析及 Supabase records/RLS 寫入；parser 與請求路徑已檢查。
- Task 2.2：已建立 development-only Telegram Bot Webhook 虛構資料預覽與確認流程，只接受固定測試句、不寫 Supabase。
- Task 2.3：已加入 Family Memory/RAG、家庭提醒及引用；新增獨立 migrations、同家庭 active-member RLS、`/chat` 及 `/today` 總覽。模型載入只在本機嘗試；無權重或維度不符時記錄 `using placeholder`，並回退至 384D normalized feature-hash，不能視為真實權重已載入。
  - 已完成 Reminder API、同家庭資料隔離、source memory 家庭範圍檢查及 cosine/L2/inner-product 搜尋。
  - `family-file-ingestion-bge-housekeeper`：已支援本機 `.txt`／`.md` 以 1,000 字元、200 overlap 分段後經登入 API 入庫；未安裝權重時保留 placeholder 並明確記錄；加入每 15 分鐘、只記 log 的提醒 scheduler。
  - `family-pdf-local-and-today-citations`：已使用本機 vendored PDF.js 擷取 PDF 內嵌文字（不做 OCR、不上載原檔），沿用 1,000/200 分段；`/today` 顯示近期記憶來源及日期、管家提醒排序／剩餘時間／來源引用與完成切換。
  - `family-bge-real-try`：已實作只在本機模型目錄有 `config.json` 時載入 Transformers.js，使用 `local_files_only` 並停用遠端模型；缺少目錄／設定、載入或推論失敗時明確記錄 placeholder。
  - 已完成私人 record body 加密：pgcrypto 加密 `visibility='private'` 記錄的 `content`；DB trigger 拒絕 authenticated plaintext 寫入，API 經原用戶 JWT/RLS 讀取後才解密。標題及其他 metadata 仍是明文；已用虛構資料驗證 round-trip，未使用真實資料。
- Task 2.4：已加入本機多代理記憶查詢流程，包括安全檢查及 `security_logs`、同家庭 RAG librarian、無外網 analyst、引用 editor 及 orchestrator；`/api/memories/search` 要求登入並回傳安全狀態、引用及 metadata；`/chat` 顯示安全 badge、回答及 MEMORY 引用。`source/DB_SCHEMA_DRAFT.sql` 未修改。
  - `family-4agent-loop`：已按 Security → Librarian → Analyst → Editor 次序落地 Node 防幻覺流程；以 `family_members.profile_id/status='active'` 驗證同家庭權限，強制 cosine 門檻、引用檢查及安全事件記錄。
  - Local disposable 驗證：RLS 15/15、approval 3/3、family memories 10/10、reminders 5/5、agents 3/3；未登入搜尋 401，injection log 寫入後已清理。
  - Cloud Supabase Auth health endpoint 回 200；只送 anon key，沒有送出用戶資料。

### 階段三：時間軸與前端呈現

- Task 3.1：已實作 FR005 未來 7 天 Calendar View，active plan 按本地日期分組並依 event_start 排序，沿用 RLS 可見記錄；加入日曆、提醒及最近 5 條家庭記憶總覽。
- Task 3.2：已整合 Chat-First 輸入匣 UI 與互動，包括本機解析、預覽確認、JWT 寫入及成功後刷新記錄檢視。

### 自託管 Supabase 部署

- 已建立 JOE-SERVER Docker Compose stack 配置，原定持久化資料路徑為 `D:\docker-data\family-system`。
- 已在本機 disposable Docker stack 套用現有 migrations（包括 Stage 3 RLS/Storage policies）。
- 本機 `@family-calendar.test` seed、15/15 RLS、3 項 approval 測試已通過。
- 已新增 JOE-SERVER 離線部署指南及支援 C:/D: `FAMILY_DATA_ROOT` 的 image exporter。

### Markdown 文件治理（2026-11-01）

- 已以 `.github/copilot-instructions.md` 作為 LLM 指引主入口，以 `docs/obsidian/FamilySystem-Story.md` 作為人讀故事入口；沿用既有文件，未另建重複主題檔。
- 已在 `docs/obsidian/README.md` 加入故事入口，保留原有 Obsidian 同步說明。
- 已核對本輪指定的歷史報告；只為有日期／後續證據的狀態快照加入範圍清楚的歷史提示，並保留原文。

### TimeMem 正式決策與 M0 Gate（2026-11-11）

- Joe accepted 三項正式決策：M0 approval + CI Gate；PWA modular monolith 與唯一 DB 存取模組；JOE-SERVER Primary、Tailscale tailnet、順暢版及三級信心輸入層。完整內容以 `docs/DECISIONS.md` 為準。
- 已更新 `docs/ARCHITECTURE.md`、`docs/GATE.md`，並加入 `scripts/check-m0-gate.ps1` 及 `.github/workflows/Check-M0-Gate.yml`。
- Repo skills source/mirror 檢查、Repo 文件檢查及 diff whitespace 檢查 PASS；GitHub branch protection 的 required check 仍待 Repo 管理者設定，產品／設備 M0 驗收未宣稱完成。