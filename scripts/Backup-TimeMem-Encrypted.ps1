# 建立 TimeMem ordinary data 加密備份；未提供 off-host 位同 recipient 前會 fail-closed。
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$DestinationRoot,

    [Parameter(Mandatory = $true)]
    [string]$AgeRecipientFile,

    [Parameter(Mandatory = $true)]
    [string]$OffHostLabel,

    [string]$ProjectDirectory = (Split-Path -Parent $PSScriptRoot),
    [string]$AssetsRoot = "D:\docker-data\timemem\photos",
    [string]$ComposeProjectName = "timemem-hybrid5",
    [string]$DatabaseService = "database",
    [string]$DatabaseUser = "timemem",
    [string]$DatabaseName = "timemem"
)

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

function Resolve-RequiredCommand {
    param([string]$Name)
    $command = Get-Command $Name -ErrorAction SilentlyContinue
    if (-not $command) {
        throw "搵唔到必要工具 '$Name'。未做任何備份。"
    }
    return $command.Source
}

function Get-Sha256 {
    param([string]$Path)
    return (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash.ToLowerInvariant()
}

function Test-OffHostDestination {
    param([string]$Path)
    $fullPath = [IO.Path]::GetFullPath($Path)
    if ($fullPath.StartsWith("\\", [StringComparison]::Ordinal)) {
        return
    }
    $root = [IO.Path]::GetPathRoot($fullPath)
    if ($root -in @("C:\", "D:\")) {
        throw "DestinationRoot 係 JOE-SERVER 嘅本機 C:/D:，唔算 off-host：$fullPath"
    }
}

$docker = Resolve-RequiredCommand -Name "docker"
$age = Resolve-RequiredCommand -Name "age"
$tar = Resolve-RequiredCommand -Name "tar"

$projectPath = [IO.Path]::GetFullPath($ProjectDirectory)
$recipientPath = [IO.Path]::GetFullPath($AgeRecipientFile)
$destinationPath = [IO.Path]::GetFullPath($DestinationRoot)

if (-not (Test-Path -LiteralPath (Join-Path $projectPath "docker-compose.yml") -PathType Leaf)) {
    throw "ProjectDirectory 入面搵唔到 docker-compose.yml：$projectPath"
}
if (-not (Test-Path -LiteralPath $recipientPath -PathType Leaf)) {
    throw "搵唔到 AgeRecipientFile：$recipientPath"
}
if ([string]::IsNullOrWhiteSpace($OffHostLabel)) {
    throw "OffHostLabel 唔可以係空白。"
}
if ((Get-Content -LiteralPath $recipientPath -Raw).Trim().Length -eq 0) {
    throw "AgeRecipientFile 冇 recipient，未做任何備份。"
}
if (-not (Test-Path -LiteralPath (Join-Path $AssetsRoot "originals") -PathType Container)) {
    throw "搵唔到 photos originals：$AssetsRoot"
}
if (-not (Test-Path -LiteralPath (Join-Path $AssetsRoot "thumbs") -PathType Container)) {
    throw "搵唔到 photos thumbs：$AssetsRoot"
}

Test-OffHostDestination -Path $destinationPath
New-Item -ItemType Directory -Path $destinationPath -Force | Out-Null

$backupId = "timemem-backup-" + (Get-Date).ToUniversalTime().ToString("yyyyMMddTHHmmssZ")
$tempRoot = Join-Path ([IO.Path]::GetTempPath()) ("timemem-backup-" + [Guid]::NewGuid().ToString("N"))
$stageRoot = Join-Path $tempRoot $backupId
$databaseDump = Join-Path $stageRoot "database.sql"
$photosRoot = Join-Path $stageRoot "photos"
$archivePath = Join-Path $tempRoot "$backupId.zip"
$encryptedPath = Join-Path $tempRoot "$backupId.age"

try {
    New-Item -ItemType Directory -Path $stageRoot -Force | Out-Null
    New-Item -ItemType Directory -Path $photosRoot -Force | Out-Null

    Push-Location $projectPath
    try {
        & $docker compose -p $ComposeProjectName exec -T $DatabaseService pg_dump `
            -U $DatabaseUser -d $DatabaseName --format=plain --no-owner --no-privileges |
            Set-Content -LiteralPath $databaseDump -Encoding UTF8
        if ($LASTEXITCODE -ne 0) {
            throw "pg_dump 失敗，exit code=$LASTEXITCODE"
        }
    }
    finally {
        Pop-Location
    }

    Copy-Item -LiteralPath (Join-Path $AssetsRoot "originals") -Destination $photosRoot -Recurse
    Copy-Item -LiteralPath (Join-Path $AssetsRoot "thumbs") -Destination $photosRoot -Recurse

    $originals = @(Get-ChildItem -LiteralPath (Join-Path $photosRoot "originals") -File -Recurse)
    $thumbs = @(Get-ChildItem -LiteralPath (Join-Path $photosRoot "thumbs") -File -Recurse)
    $manifest = [ordered]@{
        backupId = $backupId
        createdAtUtc = (Get-Date).ToUniversalTime().ToString("o")
        scope = "ordinary-database-and-photos"
        vaultIncluded = $false
        vaultLimit = "D-029 Vault key hierarchy 未批准；呢個 backup 唔宣稱包含或可還原 Vault。"
        database = [ordered]@{
            file = "database.sql"
            sha256 = (Get-Sha256 -Path $databaseDump)
            byteLength = (Get-Item -LiteralPath $databaseDump).Length
        }
        photos = [ordered]@{
            originalsCount = $originals.Count
            thumbsCount = $thumbs.Count
            files = @($originals + $thumbs | ForEach-Object {
                [ordered]@{
                    path = [IO.Path]::GetRelativePath($stageRoot, $_.FullName).Replace("\", "/")
                    sha256 = (Get-Sha256 -Path $_.FullName)
                    byteLength = $_.Length
                }
            })
        }
        encryption = [ordered]@{
            tool = "age"
            recipientFile = (Split-Path -Leaf $recipientPath)
        }
        offHostLabel = $OffHostLabel
    }

    $manifestPath = Join-Path $stageRoot "manifest.json"
    $manifest | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $manifestPath -Encoding UTF8

    & $tar -a -cf $archivePath -C $tempRoot $backupId
    if ($LASTEXITCODE -ne 0) {
        throw "壓縮備份失敗，exit code=$LASTEXITCODE"
    }

    & $age -R $recipientPath -o $encryptedPath $archivePath
    if ($LASTEXITCODE -ne 0) {
        throw "age 加密失敗，exit code=$LASTEXITCODE"
    }

    $encryptedHash = Get-Sha256 -Path $encryptedPath
    $finalEncryptedPath = Join-Path $destinationPath (Split-Path -Leaf $encryptedPath)
    $finalHashPath = "$finalEncryptedPath.sha256.txt"
    Copy-Item -LiteralPath $encryptedPath -Destination $finalEncryptedPath -Force
    "$encryptedHash  $(Split-Path -Leaf $encryptedPath)" |
        Set-Content -LiteralPath $finalHashPath -Encoding ASCII

    if ((Get-Sha256 -Path $finalEncryptedPath) -ne $encryptedHash) {
        throw "off-host copy 完成後 hash 不符，未宣稱備份成功：$finalEncryptedPath"
    }

    Write-Output "TimeMem encrypted backup 完成：$finalEncryptedPath"
    Write-Output "SHA-256：$encryptedHash"
    Write-Output "Off-host label：$OffHostLabel"
    Write-Output "注意：呢份 backup 唔包含已批准 Vault key hierarchy；未做 restore test 唔可以記 PASS。"
}
finally {
    if (Test-Path -LiteralPath $tempRoot) {
        Remove-Item -LiteralPath $tempRoot -Recurse -Force
    }
}
