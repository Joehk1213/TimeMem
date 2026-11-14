[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

$RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$script:HasFailures = $false

function Add-CheckResult {
    param(
        [string]$Name,
        [bool]$Passed,
        [string]$Detail = ''
    )

    if ($Passed) {
        Write-Output "[PASS] $Name"
    }
    else {
        $script:HasFailures = $true
        if ($Detail) {
            Write-Output "[FAIL] $Name - $Detail"
        }
        else {
            Write-Output "[FAIL] $Name"
        }
    }
}

$GitIgnorePath = Join-Path $RepoRoot '.gitignore'
if (Test-Path -LiteralPath $GitIgnorePath -PathType Leaf) {
    $GitIgnoreLines = Get-Content -LiteralPath $GitIgnorePath
    $HasPyCacheRule = $GitIgnoreLines -contains '__pycache__/'
    $HasPycRule = $GitIgnoreLines -contains '*.pyc'
    Add-CheckResult -Name '.gitignore Python cache rules' `
        -Passed ($HasPyCacheRule -and $HasPycRule) `
        -Detail 'Required rules are __pycache__/ and *.pyc.'
}
else {
    Add-CheckResult -Name '.gitignore Python cache rules' -Passed $false -Detail '.gitignore is missing.'
}

$EnvExamplePath = Join-Path $RepoRoot '.env.example'
if (Test-Path -LiteralPath $EnvExamplePath -PathType Leaf) {
    $EnvLines = @(Get-Content -LiteralPath $EnvExamplePath -Encoding UTF8)
    $InvalidEnvLineCount = 0
    foreach ($Line in $EnvLines) {
        $TrimmedLine = $Line.Trim()
        if (-not $TrimmedLine -or $TrimmedLine.StartsWith('#')) {
            continue
        }
        if ($TrimmedLine -notmatch '^[A-Za-z_][A-Za-z0-9_]*\s*=\s*(?:#.*)?$') {
            $InvalidEnvLineCount++
        }
    }
    Add-CheckResult -Name '.env.example contains empty assignments and comments only' `
        -Passed ($InvalidEnvLineCount -eq 0) `
        -Detail "$InvalidEnvLineCount line(s) contain a value or invalid content."
}
else {
    Add-CheckResult -Name '.env.example contains empty assignments and comments only' `
        -Passed $false -Detail '.env.example is missing.'
}

$DecisionsPath = Join-Path $RepoRoot 'docs\DECISIONS.md'
if (Test-Path -LiteralPath $DecisionsPath -PathType Leaf) {
    $DecisionsText = Get-Content -LiteralPath $DecisionsPath -Raw -Encoding UTF8
    $RequiredDecisionFields = @(
        'Date:',
        'Decision:',
        'Rationale:',
        'Impact:',
        'Status:',
        'Approver:',
        'Supersedes:',
        'Superseded By:',
        'Architecture Impact:',
        'CR:'
    )
    $HasDecisionFields = $true
    foreach ($Field in $RequiredDecisionFields) {
        if (-not [regex]::IsMatch($DecisionsText, $Field)) {
            $HasDecisionFields = $false
        }
    }
    $HasVaultDraftStatement = [regex]::IsMatch($DecisionsText, 'Vault `02-\u6C7A\u7B56-ADR`')
    Add-CheckResult -Name 'docs/DECISIONS.md Framework fields and Vault draft statement' `
        -Passed ($HasDecisionFields -and $HasVaultDraftStatement) `
        -Detail 'Expected the Framework decision fields and Vault draft wording.'
}
else {
    Add-CheckResult -Name 'docs/DECISIONS.md Framework fields and Vault draft statement' `
        -Passed $false -Detail 'docs/DECISIONS.md is missing.'
}

$DocsReadmePath = Join-Path $RepoRoot 'docs\README.md'
if (Test-Path -LiteralPath $DocsReadmePath -PathType Leaf) {
    $DocsReadmeText = Get-Content -LiteralPath $DocsReadmePath -Raw -Encoding UTF8
    $IndexEntryCount = [regex]::Matches($DocsReadmeText, '(?m)^\| \[').Count
    Add-CheckResult -Name 'docs/README.md has exactly sixteen index entries' `
        -Passed ($IndexEntryCount -eq 16) `
        -Detail "Found $IndexEntryCount linked entries."
}
else {
    Add-CheckResult -Name 'docs/README.md has exactly fourteen index entries' `
        -Passed $false -Detail 'docs/README.md is missing.'
}

$FormalDocsPath = Join-Path $RepoRoot 'docs'
$FormalDocs = @(Get-ChildItem -LiteralPath $FormalDocsPath -File | Where-Object {
    $_.Name -ne 'README.md' -and $_.Extension -in @('.md', '.txt')
})
Add-CheckResult -Name 'docs contains exactly fifteen formal documents' `
    -Passed ($FormalDocs.Count -eq 15) `
    -Detail "Found $($FormalDocs.Count) formal Markdown/text documents (README and reports excluded)."

$GateDocNames = @(
    'REQUIREMENTS.md',
    'DECISIONS.md',
    'ARCHITECTURE.md',
    'TEST-PLAN.md',
    'RISKS.md',
    'M0-READY.md'
)
$MissingGateDocs = @($GateDocNames | Where-Object {
    -not (Test-Path -LiteralPath (Join-Path $FormalDocsPath $_) -PathType Leaf)
})
Add-CheckResult -Name 'all six New-Start-Project-Framework gate documents exist' `
    -Passed ($MissingGateDocs.Count -eq 0) `
    -Detail "Missing: $($MissingGateDocs -join ', ')."

$ArchitecturePath = Join-Path $RepoRoot 'docs\ARCHITECTURE.md'
if (Test-Path -LiteralPath $ArchitecturePath -PathType Leaf) {
    $ArchitectureText = Get-Content -LiteralPath $ArchitecturePath -Raw -Encoding UTF8
    $ArchitectureHasTbdOrCriteria = [regex]::IsMatch($ArchitectureText, '(?i)\bTBD\b|通過準則')
    Add-CheckResult -Name 'docs/ARCHITECTURE.md exists and marks TBD or pass criteria' `
        -Passed $ArchitectureHasTbdOrCriteria `
        -Detail 'Expected TBD or 通過準則 in docs/ARCHITECTURE.md.'
}
else {
    Add-CheckResult -Name 'docs/ARCHITECTURE.md exists and marks TBD or pass criteria' `
        -Passed $false -Detail 'docs/ARCHITECTURE.md is missing.'
}

$M0ReadyPath = Join-Path $RepoRoot 'docs\M0-READY.md'
if (Test-Path -LiteralPath $M0ReadyPath -PathType Leaf) {
    $M0ReadyText = Get-Content -LiteralPath $M0ReadyPath -Raw -Encoding UTF8
    $M0ReadyHasTbdOrCriteria = [regex]::IsMatch($M0ReadyText, '(?i)\bTBD\b|通過準則')
    Add-CheckResult -Name 'docs/M0-READY.md exists and marks TBD or pass criteria' `
        -Passed $M0ReadyHasTbdOrCriteria `
        -Detail 'Expected TBD or 通過準則 in docs/M0-READY.md.'
}
else {
    Add-CheckResult -Name 'docs/M0-READY.md exists and marks TBD or pass criteria' `
        -Passed $false -Detail 'docs/M0-READY.md is missing.'
}

$ExpectedRootEntries = @(
    '.agents',
    '.env.example',
    '.git',
    '.github',
    '.gitignore',
    'docs',
    'README.md',
    'reference',
    'scripts',
    'skills-lock.json'
)
$ActualRootEntries = @(Get-ChildItem -LiteralPath $RepoRoot -Force | ForEach-Object { $_.Name } | Sort-Object)
$RootEntriesMatch = ($ActualRootEntries.Count -eq $ExpectedRootEntries.Count) -and
    (@(Compare-Object -ReferenceObject ($ExpectedRootEntries | Sort-Object) -DifferenceObject $ActualRootEntries).Count -eq 0)
Add-CheckResult -Name 'Repo root contains only approved files and folders' `
    -Passed $RootEntriesMatch `
    -Detail "Found root entries: $($ActualRootEntries -join ', ')."

$DocsTodoPath = Join-Path $RepoRoot 'docs\TODO.md'
$RootTodoPath = Join-Path $RepoRoot 'TODO.md'
Add-CheckResult -Name 'docs/TODO.md exists and root TODO.md is absent' `
    -Passed ((Test-Path -LiteralPath $DocsTodoPath -PathType Leaf) -and
        (-not (Test-Path -LiteralPath $RootTodoPath))) `
    -Detail 'TODO.md must exist under docs/ and not in the repository root.'

$DocsErrorLogPath = Join-Path $RepoRoot 'docs\ERROR_LOG.md'
$RootErrorLogPath = Join-Path $RepoRoot 'ERROR_LOG.md'
Add-CheckResult -Name 'docs/ERROR_LOG.md exists and root ERROR_LOG.md is absent' `
    -Passed ((Test-Path -LiteralPath $DocsErrorLogPath -PathType Leaf) -and
        (-not (Test-Path -LiteralPath $RootErrorLogPath))) `
    -Detail 'ERROR_LOG.md must exist under docs/ and not in the repository root.'

$ReportPath = Join-Path $RepoRoot 'docs\reports\2026-11-10-m0-ready.html'
if (Test-Path -LiteralPath $ReportPath -PathType Leaf) {
    $ReportText = Get-Content -LiteralPath $ReportPath -Raw -Encoding UTF8
    $RequiredReportPhrases = @(
        '日期時間：10/11 22:30',
        '狀態：完成報告（待批核）',
        '改咗 8 個檔案',
        '第一次驗證有 fail 過，係編碼同空白字元問題，修完第二次先 PASS。',
        'reference/README-HOME-HUB-OVERVIEW.md：Root README 舊詳細內容搬咗嚟呢度，唔係新寫，唔好刪。',
        '唔好做：唔好一次過 commit 晒所有'
    )
    $MissingReportPhraseCount = 0
    foreach ($Phrase in $RequiredReportPhrases) {
        if (-not $ReportText.Contains($Phrase)) {
            $MissingReportPhraseCount++
        }
    }
    Add-CheckResult -Name 'M0 report exists and contains all six required phrases' `
        -Passed ($MissingReportPhraseCount -eq 0) `
        -Detail "$MissingReportPhraseCount required phrase(s) are missing."
}
else {
    Add-CheckResult -Name 'M0 report exists and contains all six required phrases' `
        -Passed $false -Detail 'docs/reports/2026-11-10-m0-ready.html is missing.'
}

$GitCommand = Get-Command git -ErrorAction SilentlyContinue
if ($null -eq $GitCommand) {
    Add-CheckResult -Name 'git diff --check' -Passed $false -Detail 'git executable is unavailable.'
}
else {
    $OriginalErrorActionPreference = $ErrorActionPreference
    try {
        $ErrorActionPreference = 'Continue'
        $null = & $GitCommand.Source -C $RepoRoot diff --check 2>&1
        $GitDiffCheckExitCode = $LASTEXITCODE
    }
    finally {
        $ErrorActionPreference = $OriginalErrorActionPreference
    }
    Add-CheckResult -Name 'git diff --check' `
        -Passed ($GitDiffCheckExitCode -eq 0) `
        -Detail "git diff --check exited with code $GitDiffCheckExitCode."
}

if ($script:HasFailures) {
    Write-Output '[FAIL] One or more checks failed.'
    exit 1
}

Write-Output '[PASS] All checks passed.'
exit 0
