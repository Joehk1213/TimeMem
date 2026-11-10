# TimeMem Set-Wake-Simple.ps1
# 一鍵 SET 晒 JOE-SERVER 喚醒設定，唔使逐個撳
# 用法：右鍵「以系統管理員身份執行」
# 跑完會話你知 PASS / FAIL

Write-Host "=== TimeMem 一鍵 SET 喚醒 ===" -ForegroundColor Cyan
Write-Host "正在設定，唔好關視窗..." -ForegroundColor Yellow

$fail = 0

# 1. 關 Hibernate，唔好瞓 2 個鐘自動轉 Hibernate
Write-Host "[1/6] 關閉 Hibernate..."
powercfg /hibernate off
if ($LASTEXITCODE -eq 0) { Write-Host "  OK，Hibernate 已關" -ForegroundColor Green } else { Write-Host "  FAIL，Hibernate 關唔到" -ForegroundColor Red; $fail++ }

# 2. 合蓋 = 睡眠，插電 + 用電池都係睡眠
Write-Host "[2/6] 合蓋動作 = 睡眠..."
powercfg /setacvalueindex SCHEME_CURRENT SUB_BUTTONS LIDACTION 1
powercfg /setdcvalueindex SCHEME_CURRENT SUB_BUTTONS LIDACTION 1
powercfg /setactive SCHEME_CURRENT
Write-Host "  OK，合蓋 = 睡眠" -ForegroundColor Green

# 3. 插電時，永不自動進入休眠
Write-Host "[3/6] 插電時，永不自動休眠..."
powercfg /change standby-timeout-ac 0
powercfg /change hibernate-timeout-ac 0
Write-Host "  OK，插電唔會自動休眠" -ForegroundColor Green

# 4. 允許 Wake Timer
Write-Host "[4/6] 允許 Wake Timer..."
powercfg /setacvalueindex SCHEME_CURRENT SUB_SLEEP RTCWAKE 1
powercfg /setactive SCHEME_CURRENT
Write-Host "  OK，Wake Timer 已允許" -ForegroundColor Green

# 5. 網絡卡提示，唔好自動化到錯
Write-Host "[5/6] 網絡卡允許喚醒..."
Write-Host "  提示：請喺裝置管理員確認網絡卡已勾「允許這個裝置喚醒電腦」" -ForegroundColor Yellow
Write-Host "  如果唔識，跳過呢步，插 Ethernet 線已經夠穩" -ForegroundColor Yellow

# 6. 檢查 Docker + Tailscale 有冇裝
Write-Host "[6/6] 檢查 Docker + Tailscale..."
$dockerCmd = Get-Command docker -ErrorAction SilentlyContinue
if ($dockerCmd) { Write-Host "  OK，Docker 已裝" -ForegroundColor Green } else { Write-Host "  未裝 Docker，請先裝 Docker Desktop" -ForegroundColor Red; $fail++ }

$tailscaleCmd = Get-Command tailscale -ErrorAction SilentlyContinue
if ($tailscaleCmd) { Write-Host "  OK，Tailscale 已裝" -ForegroundColor Green } else { Write-Host "  未裝 Tailscale，請先裝 Tailscale" -ForegroundColor Yellow }

Write-Host ""
Write-Host "=== 檢查結果 ===" -ForegroundColor Cyan
Write-Host "Sleep 支援："
powercfg /a

if ($fail -eq 0) {
    Write-Host ""
    Write-Host "PASS：Windows 設定已完成" -ForegroundColor Green
    Write-Host "仲要做 2 樣手動嘢：" -ForegroundColor Yellow
    Write-Host "  1. 插火牛 + 插 Ethernet 線" -ForegroundColor Yellow
    Write-Host "  2. BIOS 入面，Wake on LAN = Enable" -ForegroundColor Yellow
    Write-Host "做完就可以做喚醒測試。" -ForegroundColor Yellow
} else {
    Write-Host ""
    Write-Host "FAIL：有 $fail 個設定未完成，請 Copy 段 Error 俾 JOE 睇" -ForegroundColor Red
}
Write-Host ""
Write-Host "按任意鍵關閉..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
