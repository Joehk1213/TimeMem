# TimeMem Set-Server-Lock-Simple.ps1
# 一鍵 SET Server：合蓋 = 唔做任何嘢 + 永不睡眠 + 關 Hibernate + 螢幕 5 分鐘關 + 網絡卡一直開
# 用法：右鍵「以系統管理員身份執行」
# 唔使入 BIOS，唔使搞 WOL

Write-Host "=== TimeMem 一鍵 SET Server 鎖機版 ===" -ForegroundColor Cyan
Write-Host "正在設定，唔好關視窗..." -ForegroundColor Yellow

$fail = 0

# 1. 關 Hibernate
Write-Host "[1/7] 關閉 Hibernate..." -ForegroundColor Yellow
powercfg /hibernate off
Write-Host "  OK，Hibernate 已關" -ForegroundColor Green

# 2. 合蓋 = 唔做任何嘢，0 = 唔做任何嘢，1 = 睡眠，2 = 休眠，3 = 關機
Write-Host "[2/7] 合蓋動作 = 唔做任何嘢..." -ForegroundColor Yellow
powercfg /setacvalueindex SCHEME_CURRENT SUB_BUTTONS LIDACTION 0
powercfg /setdcvalueindex SCHEME_CURRENT SUB_BUTTONS LIDACTION 0
powercfg /setactive SCHEME_CURRENT
Write-Host "  OK，合蓋 = 唔做任何嘢，唔係睡眠，唔係熄機" -ForegroundColor Green

# 3. 插電時，永不睡眠，永不休眠
Write-Host "[3/7] 插電時，永不睡眠..." -ForegroundColor Yellow
powercfg /change standby-timeout-ac 0
powercfg /change hibernate-timeout-ac 0
powercfg /change monitor-timeout-ac 5
Write-Host "  OK，插電唔會睡眠，螢幕 5 分鐘後關，但 CPU 繼續行" -ForegroundColor Green

# 4. 用電池時，都唔好自動睡眠，費事合蓋之後自己瞓咗
Write-Host "[4/7] 用電池時，都唔好自動睡眠..." -ForegroundColor Yellow
powercfg /change standby-timeout-dc 0
powercfg /change hibernate-timeout-dc 0
Write-Host "  OK，用電池都唔會自動睡眠" -ForegroundColor Green

# 5. 允許 Wake Timer，但其實唔使 Wake，因為根本冇瞓
Write-Host "[5/7] 允許 Wake Timer..." -ForegroundColor Yellow
powercfg /setacvalueindex SCHEME_CURRENT SUB_SLEEP RTCWAKE 1
powercfg /setactive SCHEME_CURRENT
Write-Host "  OK" -ForegroundColor Green

# 6. 提示網絡卡，唔好自動化到錯
Write-Host "[6/7] 網絡卡提示..." -ForegroundColor Yellow
Write-Host "  提示：請喺裝置管理員確認網絡卡冇勾「允許電腦關閉這個裝置以節省電源」" -ForegroundColor Yellow
Write-Host "  如果唔識，跳過呢步，插 Ethernet 線已經夠穩" -ForegroundColor Yellow

# 7. 檢查 Docker + Ollama
Write-Host "[7/7] 檢查 Docker + Ollama..." -ForegroundColor Yellow
$dockerCmd = Get-Command docker -ErrorAction SilentlyContinue
if ($dockerCmd) { Write-Host "  OK，Docker 已裝" -ForegroundColor Green } else { Write-Host "  未裝 Docker" -ForegroundColor Red; $fail++ }

Write-Host ""
Write-Host "=== 檢查結果 ===" -ForegroundColor Cyan
powercfg /a

if ($fail -eq 0) {
    Write-Host ""
    Write-Host "PASS：Server 設定已完成" -ForegroundColor Green
    Write-Host "正常狀況：" -ForegroundColor Yellow
    Write-Host "  1. 插火牛 + 插 LAN 線" -ForegroundColor Yellow
    Write-Host "  2. WIN+L 鎖機，或者 Notebook 合上蓋" -ForegroundColor Yellow
    Write-Host "  3. 部機一直開住，鎖住畫面，唔使 WOL，唔使 BIOS" -ForegroundColor Yellow
    Write-Host "  4. 唔好放入袋，要放喺枱面通風" -ForegroundColor Yellow
} else {
    Write-Host "FAIL：有設定未完成" -ForegroundColor Red
}
Write-Host ""
Write-Host "按任意鍵關閉..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
