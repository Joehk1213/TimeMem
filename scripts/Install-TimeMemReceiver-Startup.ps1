# 性質：Windows Task Scheduler 註冊腳本
# 用途：將 TimeMem Receiver 註冊為開機後 30 秒及登入後 30 秒自動啟動，監聽 Port 8765
# 邊個叫開：Joe
# 幾時可刪：唔再需要自動啟動 Receiver，或由正式服務管理器取代時

[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"

$identity = [Security.Principal.WindowsIdentity]::GetCurrent()
$principal = New-Object Security.Principal.WindowsPrincipal($identity)
if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    throw "請以系統管理員身份執行呢個 script。"
}

$taskName = "TimeMemReceiver"
$batchPath = "C:\Project\TimeMem\scripts\run_receiver.bat"
$workingDirectory = "C:\Project\TimeMem"

if (-not (Test-Path -LiteralPath $batchPath)) {
    throw "搵唔到 Receiver 啟動腳本：$batchPath"
}

$account = "$env:USERDOMAIN\$env:USERNAME"
$action = New-ScheduledTaskAction -Execute "cmd.exe" `
    -Argument "/d /c `"$batchPath`"" `
    -WorkingDirectory $workingDirectory

$startupTrigger = New-ScheduledTaskTrigger -AtStartup
$startupTrigger.Delay = "PT30S"
$logonTrigger = New-ScheduledTaskTrigger -AtLogOn -User $account
$logonTrigger.Delay = "PT30S"

$taskPrincipal = New-ScheduledTaskPrincipal `
    -UserId $account `
    -LogonType S4U `
    -RunLevel Highest

$settings = New-ScheduledTaskSettingsSet `
    -AllowStartIfOnBatteries `
    -DontStopIfGoingOnBatteries `
    -StartWhenAvailable `
    -RestartCount 3 `
    -RestartInterval (New-TimeSpan -Minutes 1) `
    -ExecutionTimeLimit (New-TimeSpan -Days 365) `
    -MultipleInstances IgnoreNew

Register-ScheduledTask `
    -TaskName $taskName `
    -Action $action `
    -Trigger @($startupTrigger, $logonTrigger) `
    -Principal $taskPrincipal `
    -Settings $settings `
    -Force | Out-Null

Get-ScheduledTask -TaskName $taskName |
    Select-Object TaskName, State, @{Name="Principal";Expression={$_.Principal.UserId}}, TaskPath |
    Format-Table -AutoSize

Write-Output "已註冊 $taskName：開機後 30 秒及登入後 30 秒執行 run_receiver.bat，使用目前 Windows 帳戶背景監聽 Port 8765。"
