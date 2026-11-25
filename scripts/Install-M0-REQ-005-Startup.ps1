# 只可喺 JOE-SERVER 以系統管理員身份執行。
[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"

if ($env:COMPUTERNAME -ne "JOE-SERVER") {
    throw "呢份部署 script 只可喺 JOE-SERVER 執行；目前主機係 $env:COMPUTERNAME。"
}

$identity = [Security.Principal.WindowsIdentity]::GetCurrent()
$principal = New-Object Security.Principal.WindowsPrincipal($identity)
if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    throw "請右鍵用「以系統管理員身份執行」。"
}

$sourceScript = Join-Path $PSScriptRoot "Verify-M0-REQ-005.ps1"
if (-not (Test-Path -LiteralPath $sourceScript)) {
    throw "搵唔到驗證 script：$sourceScript"
}

$targetRoot = "C:\ProgramData\TimeMem"
$targetScriptRoot = Join-Path $targetRoot "scripts"
$targetScript = Join-Path $targetScriptRoot "Verify-M0-REQ-005.ps1"
$localEvidenceRoot = "C:\ProgramData\TimeMem\evidence\M0-REQ-005"
$remoteEvidenceRoot = "\\JOE-DESKTOP\TimeMem\docs\evidence\M0-REQ-005"
$powerShellPath = "$env:SystemRoot\System32\WindowsPowerShell\v1.0\powershell.exe"

New-Item -ItemType Directory -Path $targetScriptRoot -Force | Out-Null
New-Item -ItemType Directory -Path $localEvidenceRoot -Force | Out-Null
Copy-Item -LiteralPath $sourceScript -Destination $targetScript -Force

$startupTaskName = "TimeMem-M0-REQ-005-Startup"
$logonTaskName = "TimeMem-M0-REQ-005-Logon"

$startupArguments = '-NoLogo -NoProfile -NonInteractive -ExecutionPolicy Bypass -File "' + $targetScript +
    '" -Trigger "Startup" -LocalEvidenceRoot "' + $localEvidenceRoot +
    '" -RemoteEvidenceRoot "' + $remoteEvidenceRoot + '" -MaxWaitSeconds 240 -LocalOnly'
$logonArguments = '-NoLogo -NoProfile -NonInteractive -ExecutionPolicy Bypass -File "' + $targetScript +
    '" -Trigger "Logon" -LocalEvidenceRoot "' + $localEvidenceRoot +
    '" -RemoteEvidenceRoot "' + $remoteEvidenceRoot + '" -MaxWaitSeconds 240 -RemoteWaitSeconds 120'

$startupAction = New-ScheduledTaskAction -Execute $powerShellPath -Argument $startupArguments -WorkingDirectory $targetScriptRoot
$startupTrigger = New-ScheduledTaskTrigger -AtStartup
$startupTrigger.Delay = "PT30S"
$startupPrincipal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -LogonType ServiceAccount -RunLevel Highest

$logonAction = New-ScheduledTaskAction -Execute $powerShellPath -Argument $logonArguments -WorkingDirectory $targetScriptRoot
$logonTrigger = New-ScheduledTaskTrigger -AtLogOn -User $identity.Name
$logonPrincipal = New-ScheduledTaskPrincipal -UserId $identity.Name -LogonType Interactive -RunLevel Limited

$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries `
    -StartWhenAvailable -ExecutionTimeLimit (New-TimeSpan -Minutes 15) -MultipleInstances IgnoreNew

Register-ScheduledTask -TaskName $startupTaskName -Action $startupAction -Trigger $startupTrigger `
    -Principal $startupPrincipal -Settings $settings -Force | Out-Null
Register-ScheduledTask -TaskName $logonTaskName -Action $logonAction -Trigger $logonTrigger `
    -Principal $logonPrincipal -Settings $settings -Force | Out-Null

Get-ScheduledTask -TaskName $startupTaskName, $logonTaskName |
    Select-Object TaskName, State, TaskPath |
    Format-Table -AutoSize

Write-Output "REQ-005 script 已部署去 $targetScript"
Write-Output "開機後 30 秒會由 SYSTEM 執行驗證並只寫本機 evidence；Joe 登入後 Logon task 會以登入身份完整重驗並同步 evidence 去 $remoteEvidenceRoot"
Write-Output "驗證唔會 Start Docker、唔會重啟服務、亦唔會開 TimeMem。"
