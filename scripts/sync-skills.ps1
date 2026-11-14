<#
.SYNOPSIS
    TimeMem - Sync .agents/skills (Source of Truth) -> .github/skills (Mirror)

.DESCRIPTION
    .agents/skills is the only Source of Truth.
    .github/skills is only a mirror for GitHub Copilot / Code Review.

    RULE: Do NOT edit .github/skills directly.
    Edit .agents/skills, then run this script.

    Works on Windows PowerShell 5.1 (powershell) and PowerShell 7 (pwsh).
    Local Windows: use powershell, no need to install pwsh.

.USAGE
    Sync:
        powershell -ExecutionPolicy Bypass -File scripts\sync-skills.ps1
        npm run sync:skills

    Check only, do not modify (for CI):
        powershell -ExecutionPolicy Bypass -File scripts\sync-skills.ps1 -Check
#>
[CmdletBinding()]
param(
    [switch]$Check
)

Write-Error '[DISABLED] 已停用，用家主要用 GPT-6 Luna，唔再同步去 .github，停用日期 2026-11-15' -ErrorAction Stop
exit 1

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

$RepoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$Source   = Join-Path $RepoRoot ".agents\skills"
$Target   = Join-Path $RepoRoot ".github\skills"

$DoNotEdit = @'
# DO NOT EDIT - Mirror Directory

This directory is auto-generated from `.agents/skills`.

DO NOT edit anything here.

Correct workflow:
1. Edit `.agents/skills` (Source of Truth)
2. Run: powershell -ExecutionPolicy Bypass -File scripts\sync-skills.ps1
3. Commit both directories together
'@

function Copy-Skills {
    param([string]$From, [string]$To)
    if (Test-Path $To) { Remove-Item $To -Recurse -Force }
    New-Item -ItemType Directory -Path $To -Force | Out-Null
    Copy-Item (Join-Path $From "*") $To -Recurse -Force
    Set-Content -Path (Join-Path $To "DO-NOT-EDIT.md") -Value $DoNotEdit -Encoding UTF8
}

function Get-FileMap {
    param([string]$Root)
    $map = @{}
    Get-ChildItem $Root -Recurse -File | ForEach-Object {
        $rel = $_.FullName.Substring($Root.Length).TrimStart('\', '/')
        $map[$rel] = (Get-FileHash $_.FullName -Algorithm SHA256).Hash
    }
    return $map
}

if (-not (Test-Path $Source)) {
    Write-Error "Source of Truth not found: $Source"
    exit 1
}

if ($Check) {
    $tmp = Join-Path ([System.IO.Path]::GetTempPath()) ("timemem-skills-" + [Guid]::NewGuid().ToString("N"))
    try {
        Copy-Skills -From $Source -To $tmp
        if (-not (Test-Path $Target)) {
            Write-Error "[FAIL] .github/skills does not exist. Run: powershell -ExecutionPolicy Bypass -File scripts\sync-skills.ps1"
            exit 1
        }
        $expected = Get-FileMap -Root $tmp
        $actual   = Get-FileMap -Root $Target
        $diffs = @(($expected.Keys + $actual.Keys) | Sort-Object -Unique | Where-Object { $expected[$_] -ne $actual[$_] })
        if ($diffs.Count -gt 0) {
            Write-Error ("[FAIL] Out of sync. Different files:`n" + ($diffs -join "`n") + "`n`nRun: powershell -ExecutionPolicy Bypass -File scripts\sync-skills.ps1")
            exit 1
        }
        Write-Host "[OK] In sync: .github/skills == .agents/skills"
    }
    finally {
        if (Test-Path $tmp) { Remove-Item $tmp -Recurse -Force -ErrorAction SilentlyContinue }
    }
}
else {
    Copy-Skills -From $Source -To $Target
    Write-Host "[OK] Synced: .agents/skills -> .github/skills"
}
