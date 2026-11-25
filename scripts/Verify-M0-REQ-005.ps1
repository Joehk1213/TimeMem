# 驗證 JOE-SERVER 重啟後自動服務狀態；唔會啟動、重啟或開啟 TimeMem。
[CmdletBinding()]
param(
    [string]$Trigger = "Manual",
    [string]$LocalEvidenceRoot = "C:\ProgramData\TimeMem\evidence\M0-REQ-005",
    [string]$RemoteEvidenceRoot = "\\JOE-DESKTOP\TimeMem\docs\evidence\M0-REQ-005",
    [int]$MaxWaitSeconds = 240,
    [int]$RemoteWaitSeconds = 120,
    [switch]$SyncExistingOnly,
    [switch]$LocalOnly
)

$ErrorActionPreference = "Stop"

if ($env:COMPUTERNAME -ne "JOE-SERVER") {
    throw "呢份驗證 script 只可喺 JOE-SERVER 執行；目前主機係 $env:COMPUTERNAME。"
}

function Resolve-Executable {
    param(
        [string]$Name,
        [string[]]$Candidates
    )

    foreach ($candidate in $Candidates) {
        if ($candidate -and (Test-Path -LiteralPath $candidate)) {
            return $candidate
        }
    }

    $command = Get-Command $Name -ErrorAction SilentlyContinue
    if ($command) {
        return $command.Source
    }

    return $null
}

$dockerExecutable = Resolve-Executable -Name "docker" -Candidates @(
    "$env:ProgramFiles\Docker\Docker\resources\bin\docker.exe",
    "${env:ProgramFiles(x86)}\Docker\Docker\resources\bin\docker.exe"
)

function Sync-EvidenceToRemote {
    param(
        [string]$LocalRoot,
        [string]$RemoteRoot,
        [int]$WaitSeconds
    )

    $deadline = (Get-Date).AddSeconds($WaitSeconds)
    $lastError = $null

    do {
        try {
            New-Item -ItemType Directory -Path $RemoteRoot -Force | Out-Null
            Get-ChildItem -LiteralPath $LocalRoot -File -ErrorAction Stop |
                Where-Object { $_.Extension -in @(".json", ".txt") } |
                ForEach-Object {
                    Copy-Item -LiteralPath $_.FullName -Destination (Join-Path $RemoteRoot $_.Name) -Force
                }
            return [pscustomobject]@{
                Passed = $true
                Path = $RemoteRoot
                Error = $null
            }
        }
        catch {
            $lastError = $_.Exception.Message
            if ((Get-Date) -lt $deadline) {
                Start-Sleep -Seconds 10
            }
        }
    } while ((Get-Date) -lt $deadline)

    return [pscustomobject]@{
        Passed = $false
        Path = $RemoteRoot
        Error = $lastError
    }
}

New-Item -ItemType Directory -Path $LocalEvidenceRoot -Force | Out-Null

if ($SyncExistingOnly) {
    $sync = Sync-EvidenceToRemote -LocalRoot $LocalEvidenceRoot -RemoteRoot $RemoteEvidenceRoot -WaitSeconds $RemoteWaitSeconds
    if (-not $sync.Passed) {
        Write-Error "無法將 REQ-005 evidence 同步去 $RemoteEvidenceRoot：$($sync.Error)"
        exit 1
    }

    Write-Output "REQ-005 evidence 已同步去 $RemoteEvidenceRoot"
    exit 0
}

$startedAt = Get-Date
$deadline = $startedAt.AddSeconds($MaxWaitSeconds)
$bootTime = (Get-CimInstance -ClassName Win32_OperatingSystem).LastBootUpTime
$endpoints = @(
    "http://127.0.0.1:3000",
    "http://127.0.0.1:444",
    "http://127.0.0.1:11434"
)
$composeServices = @("frontend", "backend", "database")
$requiredModels = @("bge-m3", "qwen3:8b")

function Test-Endpoints {
    foreach ($uri in $endpoints) {
        $statusCode = $null
        $errorMessage = $null

        try {
            $response = Invoke-WebRequest -Uri $uri -UseBasicParsing -TimeoutSec 10 -ErrorAction Stop
            $statusCode = [int]$response.StatusCode
        }
        catch {
            $errorMessage = $_.Exception.Message
            if ($_.Exception.Response -and $_.Exception.Response.StatusCode) {
                $statusCode = [int]$_.Exception.Response.StatusCode
            }
        }

        [pscustomobject]@{
            Uri = $uri
            StatusCode = $statusCode
            Passed = ($statusCode -eq 200)
            Error = $errorMessage
        }
    }
}

function Test-Containers {
    foreach ($service in $composeServices) {
        if (-not $dockerExecutable) {
            [pscustomobject]@{
                Service = $service
                Container = $null
                Count = 0
                State = $null
                Health = $null
                Passed = $false
                Error = "搵唔到 docker.exe。"
            }
            continue
        }

        $containerIds = @()
        $containerId = $containerIds | Select-Object -First 1
        $containerName = $null
        $state = $null
        $health = $null
        $errorMessage = $null

        try {
            $containerIds = @(
                & $dockerExecutable ps --filter "label=com.docker.compose.project=timemem-hybrid5" --filter "label=com.docker.compose.service=$service" --quiet 2>$null
            ) | Where-Object { -not [string]::IsNullOrWhiteSpace($_) }
        }
        catch {
            $containerIds = @()
            $errorMessage = $_.Exception.Message
        }

        $containerId = $containerIds | Select-Object -First 1
        if ($containerIds.Count -ne 1) {
            if (-not $errorMessage) {
                $errorMessage = "預期 1 個 $service 容器，實際搵到 $($containerIds.Count) 個。"
            }
        }
        else {
            try {
                $inspect = & $dockerExecutable inspect $containerId --format "{{.Name}}|{{.State.Status}}|{{.State.Health.Status}}" 2>$null
                $parts = $inspect -split "\|", 3
                $containerName = $parts[0].TrimStart("/")
                $state = $parts[1]
                $health = $parts[2]
            }
            catch {
                $errorMessage = $_.Exception.Message
            }
        }

        [pscustomobject]@{
            Service = $service
            Container = $containerName
            Count = $containerIds.Count
            State = $state
            Health = $health
            Passed = (($containerIds.Count -eq 1) -and ($state -eq "running") -and ($health -eq "healthy"))
            Error = $errorMessage
        }
    }
}

function Test-Models {
    $apiUri = "http://127.0.0.1:11434/api/tags"
    $availableModels = @()
    $errorMessage = $null

    try {
        $response = Invoke-RestMethod -Uri $apiUri -TimeoutSec 10 -ErrorAction Stop
        $availableModels = @(
            $response.models |
                ForEach-Object {
                    if ($_.name) { $_.name }
                    elseif ($_.model) { $_.model }
                } |
                Where-Object { -not [string]::IsNullOrWhiteSpace($_) }
        )
    }
    catch {
        $errorMessage = $_.Exception.Message
    }

    foreach ($model in $requiredModels) {
        $expected = $model
        $found = $availableModels | Where-Object {
            if ($expected -match ":") {
                $_ -ieq $expected
            }
            else {
                ($_ -split ":", 2)[0] -ieq $expected
            }
        }

        [pscustomobject]@{
            Model = $model
            ApiUri = $apiUri
            AvailableModels = $availableModels
            Passed = ($null -ne $found)
            Error = $errorMessage
        }
    }
}

$lastEndpointResults = @()
$lastContainerResults = @()
$lastModelResults = @()
$verificationPassed = $false

do {
    $lastEndpointResults = @(Test-Endpoints)
    $lastContainerResults = @(Test-Containers)
    $lastModelResults = @(Test-Models)
    $verificationPassed = -not (
        ($lastEndpointResults | Where-Object { -not $_.Passed }) -or
        ($lastContainerResults | Where-Object { -not $_.Passed }) -or
        ($lastModelResults | Where-Object { -not $_.Passed })
    )

    if ($verificationPassed -or (Get-Date) -ge $deadline) {
        break
    }

    Start-Sleep -Seconds 10
} while ((Get-Date) -lt $deadline)

$completedAt = Get-Date
$stamp = $completedAt.ToString("yyyyMMdd-HHmmss")
$resultPath = Join-Path $LocalEvidenceRoot "REQ-005-verification-$stamp.json"
$hashPath = "$resultPath.sha256.txt"

$result = [ordered]@{
    requirement = "REQ-005"
    trigger = $Trigger
    computerName = $env:COMPUTERNAME
    startedAt = $startedAt.ToString("o")
    completedAt = $completedAt.ToString("o")
    bootTime = $bootTime.ToString("o")
    secondsSinceBoot = [math]::Round(($completedAt - $bootTime).TotalSeconds, 1)
    maxWaitSeconds = $MaxWaitSeconds
    endpoints = $lastEndpointResults
    dockerContainers = $lastContainerResults
    ollamaModels = $lastModelResults
    verificationPassed = $verificationPassed
    verificationResult = $(if ($verificationPassed) { "PASS" } else { "FAIL" })
    localEvidencePath = $resultPath
    remoteEvidencePath = $RemoteEvidenceRoot
    remoteEvidenceSynced = $false
    remoteSyncAttempted = (-not $LocalOnly)
}

$result | ConvertTo-Json -Depth 6 | Set-Content -LiteralPath $resultPath -Encoding UTF8
$hash = (Get-FileHash -LiteralPath $resultPath -Algorithm SHA256).Hash
"$hash  $(Split-Path -Leaf $resultPath)" | Set-Content -LiteralPath $hashPath -Encoding ASCII

if ($LocalOnly) {
    $sync = [pscustomobject]@{
        Passed = $false
        Path = $RemoteEvidenceRoot
        Error = "Startup SYSTEM 只寫本機 evidence；共享同步交由 Logon task。"
    }
}
else {
    $sync = Sync-EvidenceToRemote -LocalRoot $LocalEvidenceRoot -RemoteRoot $RemoteEvidenceRoot -WaitSeconds $RemoteWaitSeconds
}

$result.remoteEvidenceSynced = $sync.Passed
$result.remoteSyncError = $sync.Error
$result | ConvertTo-Json -Depth 6 | Set-Content -LiteralPath $resultPath -Encoding UTF8

$hash = (Get-FileHash -LiteralPath $resultPath -Algorithm SHA256).Hash
"$hash  $(Split-Path -Leaf $resultPath)" | Set-Content -LiteralPath $hashPath -Encoding ASCII

if ($sync.Passed) {
    Copy-Item -LiteralPath $resultPath -Destination (Join-Path $RemoteEvidenceRoot (Split-Path -Leaf $resultPath)) -Force
    Copy-Item -LiteralPath $hashPath -Destination (Join-Path $RemoteEvidenceRoot (Split-Path -Leaf $hashPath)) -Force
}

Write-Output "REQ-005 $($result.verificationResult)"
Write-Output "本機 evidence：$resultPath"
Write-Output "SHA-256：$hash"
Write-Output "網絡 evidence：$(if ($LocalOnly) { '由 Logon task 同步' } elseif ($sync.Passed) { '已同步' } else { '未同步：' + $sync.Error })"

if (-not $verificationPassed -or ((-not $LocalOnly) -and -not $sync.Passed)) {
    exit 1
}

exit 0
