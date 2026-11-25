# TimeMem 項目摘要（供 Sir 審閱）— v2

| 項目 | 說明 |
|---|---|
| 日期 | 2026-11-15 |
| 狀態 | 本摘要已按指定來源核對；M0 仍為 **Draft / NOT APPROVED**。 |
| 來源 | v1、六份 Gate 文件、指定的 `docs` 子目錄、`reference`、`scripts`、根目錄及文件索引、`skills-lock.json` 和 Skill 同步腳本。 |
| 用途 | 提供經來源核對的項目概況、未決事項及供 Sir 討論的問題；不構成批准或驗收。 |

> **一句話：** TimeMem 是以家庭為本、以本機自託管為目標的時間與記憶系統；另規劃一條只使用合成／測試資料的公開 POC 路線。

## 1. Vision、定位與口號

| 主題 | 核對後內容與依據 |
|---|---|
| 願景與定位 | 原始構想源於孩子忘記默書，目標是建立家庭時間、記憶、證件及相片的整合工具。現行定位仍為個人化工具；分享是未來方向，不代表商業、收費或交付承諾。來源：[原構思 IDEA.txt](../prd/原構思%20IDEA.txt) 第 26–33 行；[PRD V10.2](../PRD.md) 第 11–21 行；[DECISIONS.md](../DECISIONS.md) 第 342–348 行。 |
| 口號 | v1 所列「守護每一刻時光」及 “Remember what matters.” 可在原始構想中找到；但現行 PRD 的「口號」欄列的是「拒絕月費、拒絕雲鎖定、打破屋企資料壟斷、免費 AI 屋企助手」。英文口號是否仍為現行正式口號，**未能確認**。來源：[原構思 IDEA.txt](../prd/原構思%20IDEA.txt) 第 26–29 行；[PRD V10.2](../PRD.md) 第 7–9 行。 |

## 2. Scope

| 主題 | 核對後內容與依據 |
|---|---|
| S1–S10 | 十項產品目標仍保留，涵蓋 PDF／行程輸入、搜尋與可撤銷更新、相片關聯、一鍵安裝、備份、相片回顧、登入、自然語言輸入、低信心澄清及教學功能。它們是產品目標，不是 M0 驗收清單。來源：[PRD V10.2](../PRD.md) 第 23–58 行；[REQUIREMENTS.md](../REQUIREMENTS.md) 第 29–35、44 行。 |
| 核心痛點 | 提醒是核心需要；文件列出的例子包括表演時忘記拍攝，以及上課忘記攜帶用品。來源：[PRD V10.2](../PRD.md) 第 60–64 行；[DECISIONS.md](../DECISIONS.md) 第 343 行。 |
| 優先次序 | 提醒是核心需要；Calendar、TODO、相片屬較早優先項目。證件及檔案屬較後工作，但其確切里程碑**未能確認**；v1 指定 M1／M2 並無現行依據。Finance 統計／分析為 Later、階段待定。來源：[REQUIREMENTS.md](../REQUIREMENTS.md) 第 31、34 行；[DECISIONS.md](../DECISIONS.md) 第 343 行。 |

## 3. 不做／延後

| 項目 | 現行狀態 | 來源 |
|---|---|---|
| Finance 統計／分析 | Later，階段待定；不屬 M0。 | [REQUIREMENTS.md](../REQUIREMENTS.md) 第 34 行；[DECISIONS.md](../DECISIONS.md) 第 343 行。 |
| Smart home、Space | 尚待定義；Space 的用途及資料分界未定。 | [REQUIREMENTS.md](../REQUIREMENTS.md) 第 34 行；[PRD V10.2](../PRD.md) 第 82–84 行。 |
| Multi-Agent | 僅保留概念，不承諾實作。 | [DECISIONS.md](../DECISIONS.md) 第 343 行。 |
| MCP | 早期 FR-10 曾描述唯讀構想；用途、設計及里程碑現均待課堂後決定，不屬 M0，也不再承諾 M1。 | [REQUIREMENTS.md](../REQUIREMENTS.md) 第 35、45 行；[PRD V10.2](../PRD.md) 第 71–73、97 行；[DECISIONS.md](../DECISIONS.md) 第 313、343 行。 |
| SHARE | 未承諾範圍或時間，須另行批准；不是交付或驗收承諾。 | [DECISIONS.md](../DECISIONS.md) 第 343 行；[PRD V10.2](../PRD.md) 第 102 行。 |
| 公開 POC | 可作獨立路線，但現階段只限合成／測試資料；POC 安全及部署細節未定，不能描述為已完成或已驗證。 | [DECISIONS.md](../DECISIONS.md) 第 342、348 行；[ARCHITECTURE.md](../ARCHITECTURE.md) 第 14、23、25 行。 |

## 4. TECH Two-track

| 路線 | 目標與邊界 |
|---|---|
| 公開 POC | Supabase／Cloud，登入方向為 Supabase Auth；只使用合成／測試資料，與家庭資料、帳戶憑證及環境隔離。OpenRouter、Railway 是候選，並非已批准的部署方案。 |
| 家庭閉環 | 本機 PostgreSQL + pgvector + Ollama；目標服務邊界為 React PWA → Node／Express Gateway/Auth（唯一應用程式資料庫存取模組）→ 內部 Python／FastAPI AI/ML + RAG。採 Tailnet-only HTTPS 入口，不開路由器公網連接埠。 |

兩條路線是已記錄的產品方向；家庭架構是目標設計，不代表服務、Compose 配置、資料庫或程式碼已建成。來源：[DECISIONS.md](../DECISIONS.md) 第 324–348 行；[ARCHITECTURE.md](../ARCHITECTURE.md) 第 18–44、48–52、60–79 行；[PRD V10.2](../PRD.md) 第 75–79 行。

**架構圖核對：** v1 將兩張圖的 Dev／Target 說明對調。現行 PRD 與 Architecture 記錄為 **001.png = Hybrid AI Web Architecture、002.png = Local Development Environment**；但目前 `reference` 目錄列出的是早期 `Architecture.jfif` 及 `Structure.jfif`，未找到 001.png／002.png 原圖，故圖像本身及其細節**未能確認**。現有 `.jfif` 被標為舊構想，不是現行架構規格。來源：[ARCHITECTURE.md](../ARCHITECTURE.md) 第 25 行；[PRD V10.2](../PRD.md) 第 79 行；[reference/README.md](../../reference/README.md) 第 3、7–8 行。

## 5. Data 同安全

| 主題 | 核對後內容與依據 |
|---|---|
| 真實家庭資料 | 不得送往公開 Cloud、POC 或外部服務，包括副本、附件、embeddings、logs、backups 及模型輸入。經授權的遠端查看可透過加密 Tailnet 傳送至授權裝置；裝置快取須加密，並於登出或撤銷時清除。因此 v1 的「Real data NEVER 離開屋企」過於絕對，應改為上述邊界。來源：[DECISIONS.md](../DECISIONS.md) 第 342 行；[REQUIREMENTS.md](../REQUIREMENTS.md) 第 32–33 行。 |
| 登入 | 公開 POC 的登入方向是 Supabase Auth；家庭閉環目標是 Passkey／PIN。家庭登入為 M4、Face ID 為 M5，均非 M0；POC 的安全設計仍待完成。不得將 Passkey、PIN 與 Face ID 說成同一項已實作功能。來源：[DECISIONS.md](../DECISIONS.md) 第 120、342 行；[REQUIREMENTS.md](../REQUIREMENTS.md) 第 25、32 行；[ARCHITECTURE.md](../ARCHITECTURE.md) 第 60–62 行。 |
| 六項資料類型 | User、Space、Item、Asset、Reminder、Embedding 是概念清單，不是已批准的六張資料表。D-005 記錄的是十個家庭資料表的規劃範圍；D-024 未批准實際 schema、表數、欄位或 migration。來源：[PRD V10.2](../PRD.md) 第 67–69 行；[DECISIONS.md](../DECISIONS.md) 第 73–80 行；[ARCHITECTURE.md](../ARCHITECTURE.md) 第 148–151 行。 |
| Backup | 已批准的政策包括加密備份、金鑰與 Primary 分開保管、紙本復原程序及定期隔離還原驗證。具體 age／Argon2 組合、金鑰管理與測試設計尚待另行批准；測試計劃明確禁止假設 age 原生使用 Argon2，亦不可把 PIN 雜湊當作備份加密。v1 將「age + Argon2 講得通」寫成已接受方案，證據不足。來源：[DECISIONS.md](../DECISIONS.md) 第 102–113 行；[TEST-PLAN.md](../TEST-PLAN.md) 第 51–60 行。 |
| MCP、Space | MCP 的舊唯讀構想不等於已批准工具或權限設計；Space 尚無已批准的實體／權限模型。來源：[PRD V10.2](../PRD.md) 第 71–84 行；[ARCHITECTURE.md](../ARCHITECTURE.md) 第 67、150 行。 |

## 6. M0 現狀

M0 範圍是五項安裝／設定驗收，加上 Tailnet 遠端可達性及 PWA shell 驗收；PWA shell 不包括登入、Calendar 或資料存取。

| 要求 | Gate 記錄狀態 |
|---|---|
| REQ-001 至 REQ-005：清機、安裝、Server Lock、實體擺位、自動啟動 | **NOT EVIDENCED**；SOP 是程序，不是完成證據。 |
| REQ-006：Tailnet HTTPS 可達、非 Tailnet 外部不可達、不開路由器連接埠 | **PASS**，按 GATE 所記錄的證據覆核結果。 |
| REQ-007：透過 Tailnet 開啟 PWA shell | **PASS**，只限空白 shell，不代表登入或資料功能驗收。 |

來源：[REQUIREMENTS.md](../REQUIREMENTS.md) 第 15–21、39–45 行；[GATE.md](../GATE.md) 第 95–103、121–138 行。

| 閘口／覆核 | 記錄結果 |
|---|---|
| Skill flow | Verified PASS。 |
| Luna 文件一致性覆核 | PASS WITH MINOR FINDINGS；0 Critical、0 Major、2 Minor。 |
| Current-state Independent Review | 0 Critical、0 Major、0 Minor；範圍是六份 Gate 文件，不是設備 UAT。 |
| Joe 最終批准 | **NOT APPROVED**；M0 狀態仍為 Draft。 |

來源：[GATE.md](../GATE.md) 第 35–54、159、169–196、210 行；[LUNA-REVIEW-2026-11-15.md](../reviews/LUNA-REVIEW-2026-11-15.md) 第 39–46 行；[INDEPENDENT-REVIEW-2026-11-15.md](../reviews/INDEPENDENT-REVIEW-2026-11-15.md) 第 86–123 行。

**結論：** v1「M0 已完，可以直接批」不成立。五項 setup 要求仍缺執行證據；文件覆核完成不等於產品驗收，亦不等於 M0 批准。批准權只屬 Joe。來源：[GATE.md](../GATE.md) 第 48–54、95–103、210 行；[REQUIREMENTS.md](../REQUIREMENTS.md) 第 39、50–52 行。

## 7. 檔案結構與去重核對

| 項目 | 核對結果與依據 |
|---|---|
| 文件分工 | 根目錄 `README.md` 是項目入口；`docs/README.md` 是文件索引，兩者用途不同，不是重複文件。根目錄現行產品目錄仍指向舊版 PRD 路徑；文件連結是否完整有效未逐一確認。來源：[README.md](../../README.md) 第 1–10 行；[docs/README.md](../README.md) 第 1–18 行。 |
| 目標程式結構 | Architecture 列出未來 `frontend/`、`gateway/`、`backend/`、`database/` 等目標目錄，並明確指出尚未建立。本次根目錄盤點亦未見這些產品目錄；不得把目標結構寫成現有實作。來源：[ARCHITECTURE.md](../ARCHITECTURE.md) 第 131–142 行；本次唯讀根目錄盤點。 |
| Skills 正本與 Mirror | `.agents/skills` 是唯一 Source of Truth；`.github/skills` 是自動產生的 Mirror，不應直接編輯。`skills-lock.json` 有 skill/hash 記錄，但 `sync-skills.ps1` 沒有讀取該檔；故 `docs/README.md` 所述同步依賴 lock file 的說法不受腳本支持。來源：[sync-skills.ps1](../../scripts/sync-skills.ps1) 第 3–10、32–43、48–94 行；[skills-lock.json](../../skills-lock.json) 第 2–8 行；[docs/README.md](../README.md) 第 37 行。 |
| 完全重複檔案 | 本次以 SHA-256 比較 `reference` 與 `docs/prd` 的現有檔案，未發現完全相同檔案。此結果只覆蓋這兩個目錄；v1 所稱 Luna 全項去重 Audit 未能獨立確認，現有 Luna 報告的範圍是六份 Gate 文件。主題相似不等於內容完全重複。來源：[LUNA-REVIEW-2026-11-15.md](../reviews/LUNA-REVIEW-2026-11-15.md) 第 5–6 行；本次唯讀 SHA-256 比對。 |
| 舊清單數字及 Git 狀態 | v1 所列 LIST 為 1,312 行，與清單檔行數相符；但其 `.git` 檔案數、Skills 檔案數及約 69 個項目檔案的拆分未獨立核實。`.git` 內容按要求未檢查，Skills 內容亦未讀取。Gate、evidence 是否 Git tracked/untracked **未能確認**。 |

物理部署方面，直立架、靠近 Router、供電／LAN 接線及 Lock 版是 SOP 的目標做法，不是設備已完成設定的證明。舊 Standby／WOL 文件只作歷史參考，應以 Lock 版 SOP 為準。來源：[TimeMem-Home-Hub-Physical-Setup.md](../working/TimeMem-Home-Hub-Physical-Setup.md) 第 3–5、17–33 行；[docs/README.md](../README.md) 第 16–18 行；[REQUIREMENTS.md](../REQUIREMENTS.md) 第 50 行。

本次只核對 `docs/evidence` 的檔案清單及 GATE 的文字記錄，沒有開啟 evidence 圖片；因此圖片內容未由本摘要作者再次目視驗證。序號、IMEI、個人裝置名稱均未納入本摘要。

## 8. 尚待處理或未能確認

| 項目 | 狀態 |
|---|---|
| REQ-001 至 REQ-005 的實機執行紀錄及證據 | 尚缺；依 Gate 完成相應驗收並記錄。 |
| M0 最終狀態 | 必須由 Joe 決定；本摘要及任何文件覆核均不替代批准。 |
| 公開 POC | 安全、權限、濫用防護、資料流及部署方案待設計和驗證。 |
| Schema | 六項概念清單不是 schema；後續須按需求審查實際資料模型。 |
| 備份加密 | age／Argon2 的具體方案、金鑰管理及可重複還原程序尚待決定和驗證。 |
| 圖片、舊來源及 Audit | 001.png／002.png 原圖未在目前 `reference` 清單中；v1 所列 `REVIEW.txt` 及 `TimeMem-PRD-Detail-Review.html` 亦未在本次盤點範圍找到，因此只由這些舊來源支持的說法**未能確認**。現有 Luna 報告只涵蓋六份 Gate 文件，不能證明全項去重 Audit；圖片內容亦未目視核對。來源：[2026-11-15-TimeMem-LIST.txt](./2026-11-15-TimeMem-LIST.txt) 第 1280–1287 行；[LUNA-REVIEW-2026-11-15.md](../reviews/LUNA-REVIEW-2026-11-15.md) 第 5–6 行。 |
| Git 追蹤狀態 | 未檢查 `.git`，所以 Gate、evidence 及 v1 的 tracked/untracked 狀態未能確認。 |

## 9. 供 Sir 討論的三個問題

1. 公開 POC 在正式開放前，您認為還須優先完成哪些資料隔離、授權及濫用防護設計？
2. 六項概念資料類型與 D-005 的十表規劃並不等同；您建議後續如何以實際用例檢視資料模型，而不預先假定表數？
3. 對照 D-007 的加密備份及隔離還原要求，您建議如何規範金鑰管理、失敗測試與復原演練？age／Argon2 仍未定案。

---

**本文件是摘要，不等於 M0 已批准。M0 批准權只在 Joe 手上；目前狀態仍為 Draft / NOT APPROVED。**