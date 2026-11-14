> 歷史文件：本文撰寫時現行版為 V10.1；現行版已為 V10.2。

# GitHub 清理檢查報告

檢查範圍：`C:\Project\TimeMem`  
檢查日期：2026-11-15  

本文件僅為清理檢查報告，不代表 M0 已獲批准。M0 仍為 **Draft / NOT APPROVED**；批准權只在 Joe 手上。

> 更新（2026-11-15）：已刪走 `.github` 嗰套 Skills，Sync 已停用，只用 `.agents/skills/`，Luna 為主要工具。本次只作本機 Commit，未 Push。

## 1. Git 現狀

- 專案已存在 `.git`，不需亦未執行初始化。
- `git status` 顯示目前分支為 `main`，追蹤 `origin/main`；檢查開始前已有 386 項工作目錄變更：346 項刪除、8 項修改及 32 項未追蹤。這些是檢查前既存狀態，並非本次檢查造成。
- `git log` 顯示已有兩筆提交；`git ls-files` 列出 465 個已追蹤檔案。
- 已配置一個名為 `origin` 的 GitHub remote。僅憑本機 Git 資訊無法判斷該 GitHub 儲存庫目前是 Private 或 Public。
- 根目錄已有 `.gitignore`。現有規則包括 Python/Node 暫存檔、`.env` 及 `.env.*`（保留 `.env.example`、`.env.docker.example`）、部分日誌及備份檔；目前未涵蓋 `docs/evidence` 原圖、一般金鑰檔及個人資料目錄。
- 根目錄只發現 `.env.example`，未發現實際 `.env` 檔案。

## 2. 敏感資料掃描結果

掃描範圍包括專案內所有 `.md`、`.txt`、`.ps1`、`.json`，以及 README 與 `.env*` 檔案；略過 `.git` 目錄。以下只記錄路徑、資料類型及行號，不記錄任何敏感值。自動掃描命中不代表已確認為真實資料；標示為範例或需覆核者，仍應在推送前人工確認。

| 檔案路徑 | 類型 | 行號／判斷 |
|---|---|---|
| `docs/ARCHITECTURE.md` | IPv4 位址樣式（回環／保留用途） | 39、56、90、93 |
| `docs/DECISIONS.md` | IPv4 位址樣式（回環／保留用途） | 60 |
| `docs/M0-READY.md` | IPv4 位址樣式（回環／保留用途）；IMEI 相關文字標記，未檢出 15 位識別碼 | 50、102 |
| `docs/RISKS.md` | IPv4 位址樣式（回環／保留用途） | 40 |
| `docs/working/TimeMem-Sprint-1-Wake-Test.md` | 私人區域網絡位址樣式 | 131 |
| `docs/reports/TimeMem-Summary-For-Sir.md` | IMEI 相關文字標記，未檢出 15 位識別碼 | 124 |
| `.agents/skills/pr-review-expert/SKILL.md` | 電郵格式字串，是否為示例未確定 | 258、273 |
| `.agents/skills-cold/database-designer/references/database-design-reference.md` | 示例／測試電郵格式字串 | 175、385 |
| `.agents/skills-cold/database-designer/references/index_strategy_patterns.md` | 示例／測試電郵格式字串 | 306 |
| `.agents/skills-cold/database-schema-designer/SKILL.md` | 電郵格式字串，是否為示例未確定 | 144 |
| `.agents/skills-cold/migration-architect/expected_outputs/rollback_runbook.json` | 電郵格式字串，是否為示例未確定 | 545–546、552–553、559–560、566–567、573–574 |
| `.agents/skills-cold/migration-architect/expected_outputs/rollback_runbook.txt` | 電郵格式字串，是否為示例未確定 | 11–12、16–17、21–22、26–27、31–32 |
| `.agents/skills-cold/migration-architect/references/migration_patterns_catalog.md` | 私人區域網絡位址樣式 | 406 |
| `.agents/skills-cold/sql-database-assistant/references/optimization_guide.md` | 示例／測試電郵格式字串；回環／保留用途 IPv4 樣式 | 158、217、238 |
| `.agents/skills-cold/sql-database-assistant/references/orm_patterns.md` | 示例／測試電郵格式字串 | 228 |
| `.github/skills/pr-review-expert/SKILL.md` | 電郵格式字串，是否為示例未確定 | 258、273 |
| `.github/skills-cold/database-designer/references/database-design-reference.md` | 示例／測試電郵格式字串 | 175、385 |
| `.github/skills-cold/database-designer/references/index_strategy_patterns.md` | 示例／測試電郵格式字串 | 306 |
| `.github/skills-cold/database-schema-designer/SKILL.md` | 電郵格式字串，是否為示例未確定 | 144 |
| `.github/skills-cold/migration-architect/expected_outputs/rollback_runbook.json` | 電郵格式字串，是否為示例未確定 | 545–546、552–553、559–560、566–567、573–574 |
| `.github/skills-cold/migration-architect/expected_outputs/rollback_runbook.txt` | 電郵格式字串，是否為示例未確定 | 11–12、16–17、21–22、26–27、31–32 |
| `.github/skills-cold/migration-architect/references/migration_patterns_catalog.md` | 私人區域網絡位址樣式 | 406 |
| `.github/skills-cold/sql-database-assistant/references/optimization_guide.md` | 示例／測試電郵格式字串；回環／保留用途 IPv4 樣式 | 158、217、238 |
| `.github/skills-cold/sql-database-assistant/references/orm_patterns.md` | 示例／測試電郵格式字串 | 228 |

未檢出密碼、API Key、Token、私鑰內容、標記式序號、實際 `.env` 內容、帶標籤的電話號碼或地址。README、`skills-lock.json` 及 `scripts` 未檢出上述敏感模式。**scripts 獨立檢查結果：未發現疑似憑證、序號或網絡位址；共檢查 9 個 scripts 檔案。** 此結果是模式掃描，並不能取代提交前的人工覆核。

`reference/photo` 下有三個影像檔；本次沒有開啟或檢視影像內容，因此無法確認是否包含人像、個人資料或可識別背景。建議在確認權利及隱私前不要推送。

## 3. evidence 清單

以下只依據檔名及 `docs/M0-READY.md` 文字判斷，沒有開啟任何 evidence 圖片。`M0-READY.md` 列出下列 evidence；其中成功連線截圖在文件中標示為 PASS。這不代表 M0 已批准。

| 檔案 | 類型 | 可能包含網絡／個人敏感資訊 |
|---|---|---|
| `docs/evidence/M0-REQ-006/iphone-11-pro-about-2026-11-14.jpg` | 裝置資訊頁截圖 | 高；可能顯示裝置識別資料或帳戶資料 |
| `docs/evidence/M0-REQ-006/non-tailnet-denial-lte-2026-11-14.jpg` | 非 Tailnet 存取拒絕截圖 | 中至高；可能顯示網址、IP 或帳戶資訊 |
| `docs/evidence/M0-REQ-006/router-admin-upnp-2026-11-14.png` | 路由器 UPnP 設定截圖 | 高；可能顯示管理設定及網絡資訊 |
| `docs/evidence/M0-REQ-006/router-ddns-2026-11-14.png` | 路由器 DDNS 設定截圖 | 高；可能顯示主機名稱或公網資訊 |
| `docs/evidence/M0-REQ-006/router-dmz-2026-11-14.png` | 路由器 DMZ 設定截圖 | 高；可能顯示內外網設定 |
| `docs/evidence/M0-REQ-006/router-firewall-2026-11-14.png` | 路由器防火牆設定截圖 | 高；可能顯示規則及網絡範圍 |
| `docs/evidence/M0-REQ-006/router-range-forward-2026-11-14.png` | 路由器連接埠轉送設定截圖 | 高；可能顯示內部主機位址及連接埠 |
| `docs/evidence/M0-REQ-006/router-range-trigger-2026-11-14.png` | 路由器連接埠觸發設定截圖 | 高；可能顯示網絡規則 |
| `docs/evidence/M0-REQ-006/router-single-2026-11-14.png` | 路由器單一連接埠設定截圖 | 高；可能顯示主機位址及連接埠 |
| `docs/evidence/M0-REQ-006/tailnet-success-https-2026-11-14.jpg` | Tailnet HTTPS 成功截圖 | 高；可能顯示 Tailnet 裝置、網址或網絡識別資料 |
| `docs/evidence/M0-REQ-006/tailscale-off-2026-11-14.jpg` | Tailscale 關閉狀態截圖 | 中至高；可能顯示裝置或帳戶資訊 |
| `docs/evidence/M0-REQ-006/tailscale-on-2026-11-14.jpg` | Tailscale 開啟狀態截圖 | 高；可能顯示 Tailnet 裝置或網絡識別資料 |

**建議：不推送 evidence 原圖。** 如有必要公開證據，應先另製打碼版本、檢查圖片內容及中繼資料，並取得 Joe 明確批准；原圖保留在本機。

## 4. 建議推／不推

### 建議推（完成清理及 Joe 批准後）

| 檔案／範圍 | 條件 |
|---|---|
| `README.md`、一般說明文件及 `reference` 文字文件 | 先覆核內容；移除或遮蔽非必要網絡資訊及未確認的電郵格式字串 |
| `skills-lock.json` | 掃描未檢出敏感模式；仍須確認為預期依賴鎖定檔 |
| `scripts/*.ps1` 及同步腳本 | 掃描未檢出疑似敏感資料；推送前人工覆核執行目標、帳戶名稱及環境設定 |
| `.env.example` | 僅在內容為無真實憑證的範例時推送 |
| 已清理的文件 | 特別覆核第 2 節列出的行號；清理後再決定是否推送 |

### 建議不推

| 檔案／範圍 | 原因 |
|---|---|
| `docs/evidence/**` 原圖 | 路由器、Tailnet、裝置及連線截圖可能包含網絡或個人識別資訊 |
| `reference/photo/**` | 未檢視影像內容，可能涉及個人影像或其他權利／隱私問題 |
| `.env`、任何含真實憑證的檔案、私鑰及金鑰檔 | 不得推送；目前未發現實際 `.env` |
| 第 2 節列出的文件行 | 在判定是否為範例或完成必要遮蔽前，不建議推送 |
| 整個目前工作目錄或未篩選的批次變更 | 檢查前已有 386 項變更；應逐項選取，不應整批推送 |

## 5. 建議 `.gitignore`

以下只作建議，**本次沒有修改現有 `.gitignore`**：

```gitignore
# Local environment and credentials
.env
.env.*
!.env.example
!.env.docker.example
*.pem
*.key
*.p12
*.pfx
id_rsa*
id_ed25519*

# Original evidence
/docs/evidence/**

# Personal data kept local unless explicitly sanitized and approved
**/personal-data/**
**/private-data/**
**/*-personal-data.*
```

## 6. 驗證未改動

以下 SHA-256 基線於新增報告前建立。報告寫入後重算結果全部一致：六份 Gate 文件及四份 v1/v2 候選版本文件均與基線相同；evidence 路徑清單及 12 個檔案的位元組摘要亦與基線相同。

六份 Gate 文件（本次按 M0 核心文件界定）：

| 檔案 | 寫入前 SHA-256 |
|---|---|
| `docs/ARCHITECTURE.md` | `14C9D07DBDC677E1F40D973E3577F5AFE5BE2B90ACE9FFFBDA10CAB7BFEB6224` |
| `docs/DECISIONS.md` | `3F9DD3A8EAAA206FB4E1B20AE8E06F0E3990B6A5E37831230836333115642055` |
| `docs/M0-READY.md` | `0A458EF0306F96B9BA4DD00770C9E3A0BCD42E575701134CC2C951698C7EBEED` |
| `docs/REQUIREMENTS.md` | `FF4011CD22B83E8E84E414DEEE3E8F2FA0DCE3D52190130E3DBC0D6BB54195B8` |
| `docs/RISKS.md` | `12E47E093CFBEF033E436274CB18ABEE965DAFFD17A4933F5AA9D8A4B30676A9` |
| `docs/TEST-PLAN.md` | `BD00363CE7E71C37B5B54E047F93CA700221EF1CC19921C83B5A88DF80EBDBCB` |

版本文件為涵蓋 v1/v2 的保守界定，同時核對 PRD 及 Sir 摘要兩組版本：

| 檔案 | 寫入前 SHA-256 |
|---|---|
| `docs/archive/TimeMem-PRD-V10-1.md` | `09FDDE9E2B06CEAB12ABE7C5CB4B69F5B4163FBD179D050139126A6747DA92C5` |
| `docs/prd/TimeMem-PRD-V10-2.md` | `E27A7D4540C61FE01C8B4EDAB6B986E8C31C9A25D13B240A0FCBB5E02D3AA190` |
| `docs/reports/TimeMem-Summary-For-Sir.md` | `F9B92FF33C18577C3F91772A2C97006A5BAEDCCE6F914AEA4E8AB16A61C1CF75` |
| `docs/reports/TimeMem-Summary-for-Sir-v2.md` | `4AB6042FC3C88214CB7357FEFD9A9A61F082A4958126B13700A4799E713438C5` |

`docs/evidence` 有 12 個檔案。檔案清單 SHA-256 為 `85DC9719D1A1F816ACBF0A4245093B52A832D56C2E451CDD572B78B935FCCE23`；按相對路徑及各檔案 SHA-256 組成的 evidence 位元組清單摘要為 `98A969AE5B21398F5570C89ED712312E9FD9994F4D6DD7B06A9023A421BEEBE9`。計算摘要僅用於完整性核對，沒有檢視圖片內容。

檢查開始時一般 `git status --porcelain` 輸出共有 386 項，其摘要為 `4337674F5400C889CE2C5297E6ACF7B1DFD38184EBC747CBEBFB53335BA92579`。由於未追蹤目錄會以目錄層級合併顯示，加入報告後一般摘要仍相同；使用 `git status --untracked-files=all` 可確認本報告是未追蹤檔案。報告在檢查前的檔案清單中不存在，且本次唯一建立的專案檔案為本報告。沒有執行 stage、commit、push、init 或 remote 設定。

## 7. 俾 Joe 決定嘅三個問題

1. GitHub 儲存庫應設為 **Private** 還是 **Public**？本機 Git 設定無法確認目前可見度。
2. 是否完全不推送 evidence 原圖？如需提供證據，是否只在另製打碼版本並完成覆核後推送？
3. 是否批准將第 5 節建議內容加入 `.gitignore`？本次未作修改。

**結論：M0 仍為 Draft / NOT APPROVED。本報告不等於 M0 已批准，批准權只在 Joe 手上。**
