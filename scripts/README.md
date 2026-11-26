<!--
性質：Script 使用導覽
用途：列出現有 PowerShell Script 的分類、用途及執行時機
邊個叫開：Joe
幾時可刪：專案退役，或所有 Script 已由其他正式命令系統取代
-->

# scripts 自動化腳本導覽

以下 `.ps1` 為 TimeMem 現有腳本。執行前先確認主機、權限及目標環節；涉及備份、喚醒或喺伺服器操作嘅 Script，應按對應 SOP 執行。

## 環境安裝與啟動

| Script | 用途 | 執行時機 |
|---|---|---|
| `Install-OneClick.ps1` | 一鍵檢查 Docker、啟動服務、下載本機模型及嘗試還原備份 | 首次安裝或需要重新啟動完整 TimeMem 環境 |
| `Install-M0-REQ-005-Startup.ps1` | 設定或驗證 M0 REQ-005 開機自動啟動環境 | 配置 JOE-SERVER 開機後自動啟動服務時 |
| `Set-Server-Lock-Simple.ps1` | 設定 Lock 版伺服器電源、合蓋及休眠行為 | 安裝或重新配置 JOE-SERVER 鎖機行為後 |
| `Set-Wake-Simple.ps1` | 設定 JOE-SERVER Hibernate、Wake Timer及網絡喚醒相關選項 | 配置睡眠喚醒環境時 |

## 日常檢查與驗證

| Script | 用途 | 執行時機 |
|---|---|---|
| `check-all.ps1` | 檢查 Repo 基礎設定、正式文件欄位及 Gate 條件 | 提交變更前、例行 Repo 健康檢查 |
| `check-m0-gate.ps1` | 比對變更並確認 M0 Gate 只允許批准範圍內嘅文件變更 | PR 或本地變更檢查 M0 閘口時 |
| `Verify-M0-REQ-005.ps1` | 重啟後驗證 Docker、Ollama、App 及證據同步狀態 | M0 REQ-005 重啟驗證及證據收集時 |
| `Wake-Test-Simple.ps1` | 測量喚醒後 Ping 與 App 可用所需時間 | 完成喚醒設定後做實機驗證 |

## 備份與證據同步

| Script | 用途 | 執行時機 |
|---|---|---|
| `Backup-TimeMem-Encrypted.ps1` | 建立 Project、資料庫及相片嘅 off-host 加密備份 | 定期備份，或重大變更前 |
| `Sync-M0-REQ-005-Evidence.ps1` | 同步或收集 M0 REQ-005 驗證證據 | REQ-005 驗證完成後、或需要補傳證據時 |

## AI Skills 維護

| Script | 用途 | 執行時機 |
|---|---|---|
| `sync-skills.ps1` | 維護 `.agents/skills` 同 `.github/skills` 嘅同步流程；現行設定已停用並會直接 fail-closed | 只有技能同步機制重新啟用時才執行 |
| `check-skills-sync.ps1` | 檢查 AI Skills 同步狀態 | 提交前或例行 Skills 綜合檢查 |

筆記參考：`run sync skill.txt`；只作 AI Skills 維護操作提示，不屬可執行 `.ps1`。
