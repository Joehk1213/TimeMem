<#!
性質：輕量防呆檔
用途：檢查程式碼修改是否同步更新 PROGRESS.md / AGENT-STATE.md
邊個叫開：Joe
幾時可刪：Joe 親口要求刪除或自動收尾同步改用其他正式機制
#>

[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

$RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path

$GitCommand = Get-Command git -ErrorAction SilentlyContinue
if ($null -eq $GitCommand) {
    Write-Output '[WARNING] git executable is unavailable.'
    exit 1
}

$StatusOutput = @(& $GitCommand.Source -C $RepoRoot status --porcelain 2>&1)
$GitExitCode = $LASTEXITCODE
if ($GitExitCode -ne 0) {
    Write-Output '[WARNING] Unable to read git status.'
    exit 1
}

$CodeModified = $false
$DocsModified = $false

foreach ($Line in $StatusOutput) {
    if (-not $Line) {
        continue
    }

    $PathText = ''
    if ($Line.Length -gt 3) {
        $PathText = $Line.Substring(3)
    }
    $PathText = $PathText -replace '\\', '/'
    $Paths = @($PathText -split ' -> ')

    foreach ($Path in $Paths) {
        $NormalizedPath = $Path.Trim('"').TrimStart('/')

        if ($NormalizedPath -match '^frontend/' -or
            $NormalizedPath -match '^backend/' -or
            $NormalizedPath -match '^database/') {
            $CodeModified = $true
        }

        if ($NormalizedPath -eq 'docs/PROGRESS.md' -or
            $NormalizedPath -eq 'docs/working/AGENT-STATE.md') {
            $DocsModified = $true
        }
    }
}

if ($CodeModified -and -not $DocsModified) {
    Write-Output '[WARNING] Code modified without updating PROGRESS.md / AGENT-STATE.md!'
    exit 1
}

Write-Output '[OK] Docs synced.'
exit 0
