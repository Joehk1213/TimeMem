# TimeMem Install-OneClick.ps1
# 一鍵安裝：檢查 Docker -> Compose 起晒 -> Pull Model -> 還原 TEMP BACKUP -> 問「要打開 TimeMem 嗎？」
# 用法：右鍵「以系統管理員身份執行」

Write-Host "=== TimeMem 一鍵安裝 ===" -ForegroundColor Cyan

# 1. 檢查 Docker
Write-Host "[1/5] 檢查 Docker..." -ForegroundColor Yellow
$docker = Get-Command docker -ErrorAction SilentlyContinue
if (-not $docker) {
    Write-Host "未裝 Docker，正在開 Docker 下載頁..." -ForegroundColor Red
    Start-Process "https://www.docker.com/products/docker-desktop/"
    Write-Host "請先裝 Docker Desktop，裝完重新開機，再跑一次呢個 Script。" -ForegroundColor Yellow
    exit
}
Write-Host "  OK，Docker 已裝" -ForegroundColor Green

# 2. Docker Compose 起晒
Write-Host "[2/5] 正在啟動 TimeMem，App + DB + Ollama..." -ForegroundColor Yellow
docker compose up -d
if ($LASTEXITCODE -ne 0) {
    Write-Host "FAIL，Docker Compose 起唔到，請 Copy 段 Error 俾 JOE 睇" -ForegroundColor Red
    exit
}
Write-Host "  OK，3 個容器已起" -ForegroundColor Green

# 3. Pull Local Model
Write-Host "[3/5] 正在下載 Local Model，bge-m3 + qwen3:8b，可能要等幾分鐘..." -ForegroundColor Yellow
docker exec timemem-ollama ollama pull bge-m3
docker exec timemem-ollama ollama pull qwen3:8b
Write-Host "  OK，Model 已下載" -ForegroundColor Green

# 4. TEMP BACKUP 還原，如果 DB 係空
Write-Host "[4/5] 檢查係咪第一次安裝..." -ForegroundColor Yellow
$tempBackup = ".\temp-backup.zip"
if (Test-Path $tempBackup) {
    Write-Host "  找到 TEMP BACKUP，正在還原示範資料..." -ForegroundColor Yellow
    # 呢度呼叫 App 嘅 Restore API，唔好直接抄 DB，費事整壞
    try {
        $r = Invoke-WebRequest -Uri "http://localhost:3000/api/restore-temp" -Method POST -TimeoutSec 30 -UseBasicParsing -ErrorAction Stop
        Write-Host "  OK，TEMP BACKUP 已還原，20 個 Item + 10 張相 + 同義詞已入" -ForegroundColor Green
    } catch {
        Write-Host "  提示：TEMP BACKUP 還原失敗，可能已經有資料，跳過，唔會覆蓋你啲真資料" -ForegroundColor Yellow
    }
} else {
    Write-Host "  未找到 TEMP BACKUP，跳過，第一次開會係空 DB" -ForegroundColor Yellow
}

# 5. 問要打開 TimeMem 嗎
Write-Host ""
Write-Host "=== 安裝完成 ===" -ForegroundColor Green
Write-Host "要打開 TimeMem 嗎？" -ForegroundColor Cyan
$answer = Read-Host "撳 Y 打開，撳 N 唔開 (Y/N)"
if ($answer -eq "Y" -or $answer -eq "y" -or $answer -eq "") {
    Start-Process "http://localhost:3000"
    Write-Host "已打開 TimeMem，首頁應該見到隨機相片 + 故事卡片" -ForegroundColor Green
} else {
    Write-Host "好，之後自己去 http://localhost:3000 開" -ForegroundColor Yellow
}
Write-Host ""
Write-Host "下一步：跑 Set-Server-Lock-Simple.ps1，設定 Server 鎖機" -ForegroundColor Yellow
