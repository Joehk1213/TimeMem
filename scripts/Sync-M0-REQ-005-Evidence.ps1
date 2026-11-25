# 只可喺 JOE-SERVER 執行；同步指定 Logon PASS evidence，唔重啟、唔改驗證內容。
[CmdletBinding()]
param(
    [string]$SourceFile = "C:\ProgramData\TimeMem\evidence\M0-REQ-005\REQ-005-verification-20261123-002605.json",
    [string]$DestinationRoot = "\\JOE-DESKTOP\TimeMem\docs\evidence\M0-REQ-005"
)

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

if ($env:COMPUTERNAME -ne "JOE-SERVER") {
    throw "呢份 script 只可喺 JOE-SERVER 執行；目前主機係 $env:COMPUTERNAME。"
}
if (-not (Test-Path -LiteralPath $SourceFile -PathType Leaf)) {
    throw "搵唔到指定 Logon evidence：$SourceFile"
}

$sourceHash = (Get-FileHash -LiteralPath $SourceFile -Algorithm SHA256).Hash.ToUpperInvariant()
$evidence = Get-Content -LiteralPath $SourceFile -Raw | ConvertFrom-Json

if ($evidence.trigger -ne "Logon") {
    throw "指定 evidence 唔係 Logon trigger，停止同步。"
}
if ($evidence.verificationResult -ne "PASS" -or $evidence.verificationPassed -ne $true) {
    throw "指定 evidence 唔係 PASS；停止同步，唔會封存舊 FAIL 檔。"
}
if (@($evidence.endpoints | Where-Object { -not $_.Passed }).Count -gt 0 -or
    @($evidence.dockerContainers | Where-Object { -not $_.Passed }).Count -gt 0 -or
    @($evidence.ollamaModels | Where-Object { -not $_.Passed }).Count -gt 0) {
    throw "PASS 標誌同 endpoint/container/model 詳細結果唔一致；停止同步。"
}

New-Item -ItemType Directory -Path $DestinationRoot -Force | Out-Null
$fileName = Split-Path -Leaf $SourceFile
$destinationFile = Join-Path $DestinationRoot $fileName
$destinationHashFile = "$destinationFile.sha256.txt"

Copy-Item -LiteralPath $SourceFile -Destination $destinationFile -Force
"$sourceHash  $fileName" | Set-Content -LiteralPath $destinationHashFile -Encoding ASCII

$copiedHash = (Get-FileHash -LiteralPath $destinationFile -Algorithm SHA256).Hash.ToUpperInvariant()
if ($copiedHash -ne $sourceHash) {
    throw "Copy 後 SHA-256 不符；source=$sourceHash copied=$copiedHash"
}

$historyRoot = Join-Path $DestinationRoot "superseded"
New-Item -ItemType Directory -Path $historyRoot -Force | Out-Null
Get-ChildItem -LiteralPath $DestinationRoot -File |
    Where-Object { $_.Name -like "REQ-005-verification-20261122-235400.json*" } |
    Move-Item -Destination $historyRoot -Force

Write-Output "REQ-005 Logon PASS evidence 已同步並驗 hash。"
Write-Output "Destination：$destinationFile"
Write-Output "SHA-256：$sourceHash"
