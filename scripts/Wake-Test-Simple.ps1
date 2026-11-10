# TimeMem Wake-Test-Simple.ps1
# 一鍵測：第一次醒要幾耐 + 之後正常要幾耐
# 用法：合蓋 1 分鐘之後，喺另一部機 / 電話 Wake 咗 JOE-SERVER 之後，喺 JOE-SERVER 跑呢個 Script
# 或者喺另一部機跑，自動 Ping + 計時

param(
    [string]$Server = "JOE-SERVER",
    [string]$Url = "http://JOE-SERVER:3000/health"
)

Write-Host "=== TimeMem 簡單喚醒測試 ===" -ForegroundColor Cyan
Write-Host "目標 Server：$Server" -ForegroundColor Gray
Write-Host "正在等 Ping 通..." -ForegroundColor Yellow

$start = Get-Date
$pingOk = $false
for ($i=0; $i -lt 60; $i++) {
    $ping = Test-Connection -ComputerName $Server -Count 1 -Quiet -ErrorAction SilentlyContinue
    if ($ping) { $pingOk = $true; break }
    Start-Sleep -Seconds 1
    Write-Host "." -NoNewline
}
Write-Host ""

if (-not $pingOk) {
    Write-Host "FAIL：60 秒都 Ping 唔到，Wake 失敗" -ForegroundColor Red
    Write-Host "檢查：BIOS Wake on LAN 有冇 Enable？有冇插 Ethernet？有冇插火牛？" -ForegroundColor Yellow
    exit
}

$pingTime = (Get-Date) - $start
Write-Host "Ping 通咗，用咗 $($pingTime.TotalSeconds) 秒" -ForegroundColor Green

Write-Host "正在等 App 起返..." -ForegroundColor Yellow
$start2 = Get-Date
$appOk = $false
for ($i=0; $i -lt 60; $i++) {
    try {
        $r = Invoke-WebRequest -Uri $Url -TimeoutSec 2 -UseBasicParsing -ErrorAction Stop
        if ($r.StatusCode -eq 200) { $appOk = $true; break }
    } catch {}
    Start-Sleep -Seconds 1
}
$appTime = (Get-Date) - $start2

if ($appOk) {
    Write-Host "App 起返咗，用咗 $($appTime.TotalSeconds) 秒" -ForegroundColor Green
} else {
    Write-Host "App 60 秒都未起返，Docker 可能仲起緊，等多陣再試" -ForegroundColor Yellow
}

$total = (Get-Date) - $start
Write-Host ""
Write-Host "=== 結果，記低 2 行就得 ===" -ForegroundColor Cyan
Write-Host "第一次醒要幾耐：$([math]::Round($total.TotalSeconds,1)) 秒，目標 <= 30 秒" -ForegroundColor White
Write-Host "之後正常要幾耐：請即刻再問一次「下一堂滑板班幾時？」睇下幾耐有答案，目標 3-5 秒" -ForegroundColor White
if ($total.TotalSeconds -le 30) {
    Write-Host "結果：PASS" -ForegroundColor Green
} else {
    Write-Host "結果：FAIL，第一次醒要超過 30 秒，考慮用 Plan B：7x24 開住" -ForegroundColor Red
}
