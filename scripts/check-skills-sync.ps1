[CmdletBinding()]
param(
    [switch]$RepoOnly,
    [string]$VaultRoot = 'C:\Project\Obsidian-Hub\TimeMem'
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

$RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$RepoSkills = Join-Path $RepoRoot '.agents\skills'
if ($RepoOnly) {
    # 已停用，用家主要用 GPT-6 Luna，唔再同步去 .github，停用日期 2026-11-15
    throw '[DISABLED] GitHub Skills comparison mode disabled on 2026-11-15.'
}
$ComparisonSkills = Join-Path $VaultRoot '.agents\skills'
$ComparisonLabel = 'Vault .agents/skills'
$Skills = @('obsidian-markdown', 'obsidian-bases', 'obsidian-cli', 'defuddle')

function Get-SkillFileMap {
    param([string]$Root, [string]$Skill)

    $SkillRoot = Join-Path $Root $Skill
    if (-not (Test-Path -LiteralPath $SkillRoot -PathType Container)) {
        throw "Skill directory not found: $SkillRoot"
    }

    $Files = @(Get-ChildItem -LiteralPath $SkillRoot -Force -Recurse -File)
    if ($Files.Count -eq 0) {
        throw "Skill directory contains no files: $SkillRoot"
    }

    $Map = [System.Collections.Generic.Dictionary[string, string]]::new(
        [System.StringComparer]::Ordinal
    )
    foreach ($File in $Files) {
        $RelativePath = $File.FullName.Substring($SkillRoot.Length).TrimStart(
            [System.IO.Path]::DirectorySeparatorChar,
            [System.IO.Path]::AltDirectorySeparatorChar
        )
        $Map[$RelativePath] = (Get-FileHash -LiteralPath $File.FullName -Algorithm SHA256).Hash
    }
    return $Map
}

if (-not (Test-Path -LiteralPath $RepoSkills -PathType Container)) {
    throw "Repository skills directory not found: $RepoSkills"
}
if (-not (Test-Path -LiteralPath $ComparisonSkills -PathType Container)) {
    throw "$ComparisonLabel directory not found: $ComparisonSkills"
}

$Differences = @()
foreach ($Skill in $Skills) {
    $RepoFiles = Get-SkillFileMap -Root $RepoSkills -Skill $Skill
    $ComparisonFiles = Get-SkillFileMap -Root $ComparisonSkills -Skill $Skill
    $RelativePaths = @($RepoFiles.Keys) + @($ComparisonFiles.Keys) | Sort-Object -CaseSensitive -Unique

    foreach ($RelativePath in $RelativePaths) {
        if (-not $RepoFiles.ContainsKey($RelativePath)) {
            $Differences += "$Skill/$RelativePath (only in $ComparisonLabel)"
        }
        elseif (-not $ComparisonFiles.ContainsKey($RelativePath)) {
            $Differences += "$Skill/$RelativePath (only in repo .agents/skills)"
        }
        elseif ($RepoFiles[$RelativePath] -ne $ComparisonFiles[$RelativePath]) {
            $Differences += "$Skill/$RelativePath (content differs)"
        }
    }
}

if ($Differences.Count -gt 0) {
    Write-Error ("[FAIL] Selected skills differ:`n" + ($Differences -join "`n"))
    exit 1
}

Write-Host "[OK] All four selected skills match between repo .agents/skills and $ComparisonLabel."
