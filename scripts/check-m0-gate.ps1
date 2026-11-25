[CmdletBinding()]
param(
    [string]$BaseRef,
    [string]$HeadRef = 'HEAD',
    [string[]]$ChangedFiles
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

$RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$ApprovalPath = Join-Path $RepoRoot 'docs\GATE.md'

function Get-ChangedFiles {
    if ($ChangedFiles -and $ChangedFiles.Count -gt 0) {
        return @($ChangedFiles | ForEach-Object { $_ -replace '\\', '/' })
    }

    if (-not $BaseRef) {
        throw 'Pass BaseRef and HeadRef, or provide ChangedFiles.'
    }

    $DiffRange = "${BaseRef}...${HeadRef}"
    $Paths = @(& git -C $RepoRoot diff --name-only --diff-filter=ACMRT $DiffRange)
    if ($LASTEXITCODE -ne 0) {
        throw "Unable to compare Git refs: $DiffRange"
    }

    return @($Paths | ForEach-Object { $_ -replace '\\', '/' })
}

function Test-ProductCodePath {
    param([string]$Path)

    $NormalizedPath = $Path.TrimStart('./')
    if ($NormalizedPath -match '^(docs|reference|\.agents/skills|\.github/skills)/') {
        return $false
    }
    if ($NormalizedPath -match '^scripts/(check-m0-gate|check-all|check-skills-sync|sync-skills)\.ps1$') {
        return $false
    }

    if ($NormalizedPath -match '(?i)\.(ts|tsx|js|jsx|mjs|cjs|py|sql|ps1|cs|go|rs|java|kt|swift|vue|svelte|html|css)$') {
        return $true
    }

    return $NormalizedPath -match '(?i)(^|/)(package\.json|pnpm-lock\.yaml|pnpm-workspace\.yaml|turbo\.json|requirements\.txt|pyproject\.toml|Cargo\.toml|go\.mod|Dockerfile(?:\.[^/]*)?|docker-compose(?:\.[^/]*)?\.(?:yml|yaml))$'
}

function Get-ApprovalText {
    if ($BaseRef) {
        $ApprovalRef = "${BaseRef}:docs/GATE.md"
        $Text = @(& git -C $RepoRoot show $ApprovalRef 2>$null)
        if ($LASTEXITCODE -ne 0) {
            throw "Approval record is missing from the base branch: $ApprovalRef"
        }
        return ($Text -join "`n")
    }

    if (-not (Test-Path -LiteralPath $ApprovalPath -PathType Leaf)) {
        throw "Approval record not found: $ApprovalPath"
    }
    return Get-Content -LiteralPath $ApprovalPath -Raw -Encoding UTF8
}

function Get-ApprovalValue {
    param(
        [string]$Text,
        [string]$Label
    )

    $Pattern = '(?m)^\s*-\s*(?:\*\*)?' + [regex]::Escape($Label) + ':(?:\*\*)?\s*(.*?)\s*$'
    $Matches = [regex]::Matches($Text, $Pattern)
    if ($Matches.Count -ne 1) {
        return $null
    }

    return $Matches[0].Groups[1].Value.Trim()
}

$Changed = @(Get-ChangedFiles)
$ProductCode = @($Changed | Where-Object { Test-ProductCodePath -Path $_ })

if ($ProductCode.Count -eq 0) {
    Write-Output '[PASS] M0 Gate: no product code changes in this PR.'
    exit 0
}

$ApprovalText = Get-ApprovalText
$M0StatusMatch = [regex]::Match($ApprovalText, '(?m)^status:\s*(\S+)\s*$')
$M0Status = if ($M0StatusMatch.Success) { $M0StatusMatch.Groups[1].Value } else { $null }
$LunaReview = Get-ApprovalValue -Text $ApprovalText -Label 'Luna Review'
$IndependentReview = Get-ApprovalValue -Text $ApprovalText -Label 'Independent Review'
$CriticalFindings = Get-ApprovalValue -Text $ApprovalText -Label 'Critical Findings'
$MajorFindings = Get-ApprovalValue -Text $ApprovalText -Label 'Major Findings'
$JoeApproval = Get-ApprovalValue -Text $ApprovalText -Label 'Owner Joe final approval'
$ApprovalDate = Get-ApprovalValue -Text $ApprovalText -Label 'Approval date'
$ApprovedScope = Get-ApprovalValue -Text $ApprovalText -Label 'Approved scope'
$ValidApprovalDate = $false
if ($ApprovalDate) {
    $ParsedDate = [datetime]::MinValue
    $ValidApprovalDate = [datetime]::TryParseExact(
        $ApprovalDate,
        'yyyy-MM-dd',
        [System.Globalization.CultureInfo]::InvariantCulture,
        [System.Globalization.DateTimeStyles]::None,
        [ref]$ParsedDate
    )
}

if (($M0Status -cne 'Approved') -or
    ($LunaReview -cne 'PASS') -or
    ($IndependentReview -cne 'PASS') -or
    ($CriticalFindings -cne '0') -or
    ($MajorFindings -cne '0') -or
    ($JoeApproval -cne 'APPROVED') -or
    (-not $ValidApprovalDate) -or
    (-not $ApprovedScope) -or
    ($ApprovedScope -ceq 'NONE')) {
    Write-Error ("[FAIL] M0 Gate: product code requires Approved M0 status, two passing reviews, zero Critical/Major findings, Joe's approval, date, and scope on the base branch. Product code files:`n" + ($ProductCode -join "`n"))
    exit 1
}

Write-Output ("[PASS] M0 Gate: base-branch approval verified for product code changes:`n" + ($ProductCode -join "`n"))