# 性質：專案安全打包 Script
# 用途：用 git archive 製作乾淨 Cold Start Repo 壓縮包並掃描敏感資料
# 叫開者：@Joehk1213
# 刪除條件：cold-start-pack Skill 停用或改由更安全、可審計的正式工具取代

$ErrorActionPreference = 'Stop'

$repo = 'C:\Project\TimeMem'
$zipPath = 'C:\Project\TimeMem-clean.zip'

Set-Location -LiteralPath $repo
$head = (git rev-parse --verify HEAD).Trim()
git rev-parse --is-inside-work-tree | Out-Null

$stage = Join-Path ([System.IO.Path]::GetTempPath()) ('timemem-cold-start-' + [guid]::NewGuid().ToString('N'))
$tarPath = Join-Path ([System.IO.Path]::GetTempPath()) ('timemem-cold-start-' + [guid]::NewGuid().ToString('N') + '.tar')
New-Item -ItemType Directory -Path $stage | Out-Null

try {
    git archive --format=tar --output=$tarPath $head
    tar -xf $tarPath -C $stage
    Remove-Item -LiteralPath $tarPath -Force

    $workingFiles = @(
        @(git diff --name-only HEAD)
        @(git ls-files --others --exclude-standard)
    ) | Where-Object { $_ } | Sort-Object -Unique

    foreach ($relativePath in $workingFiles) {
        $sourcePath = Join-Path $repo $relativePath
        $targetPath = Join-Path $stage $relativePath

        if (-not (Test-Path -LiteralPath $sourcePath)) {
            if (Test-Path -LiteralPath $targetPath) {
                Remove-Item -LiteralPath $targetPath -Force
            }
            continue
        }

        $targetDirectory = Split-Path -Parent $targetPath
        if (-not (Test-Path -LiteralPath $targetDirectory)) {
            New-Item -ItemType Directory -Path $targetDirectory -Force | Out-Null
        }
        Copy-Item -LiteralPath $sourcePath -Destination $targetPath -Force
    }

    $forbiddenDirs = @(
        '.git', '.venv', 'venv', '.validation-venv', 'node_modules',
        '__pycache__', 'evidence', 'owner-private', 'personal-data', 'private-data'
    )
    $forbiddenRelativeDirs = @('docs/working')

    Get-ChildItem -LiteralPath $stage -Directory -Recurse -Force |
        Where-Object {
            $relativePath = $_.FullName.Substring($stage.Length).TrimStart('\') -replace '\\', '/'
            ($forbiddenDirs -contains $_.Name) -or ($forbiddenRelativeDirs -contains $relativePath)
        } |
        Sort-Object FullName -Descending |
        ForEach-Object { Remove-Item -LiteralPath $_.FullName -Recurse -Force }

    Get-ChildItem -LiteralPath $stage -Recurse -Force |
        Where-Object {
            $_.Name -match '^\.env($|\.)' -or
            $_.Name -match '^id_rsa' -or
            $_.Name -match '^id_ed25519' -or
            $_.Name -match '\.(pem|key|p12|pfx)$' -or
            (
                $_.FullName -match '\\docs\\[^\\]+\.(png|jpg|jpeg|gif|bmp|tif|tiff|webp|jfif|heic|heif)$' -or
                $_.FullName -match '\\docs\\'
            ) -and $_.Name -match '\.(png|jpg|jpeg|gif|bmp|tif|tiff|webp|jfif|heic|heif)$'
        } |
        Sort-Object FullName -Descending |
        ForEach-Object {
            if ($_.PSIsContainer) {
                Remove-Item -LiteralPath $_.FullName -Recurse -Force
            } else {
                Remove-Item -LiteralPath $_.FullName -Force
            }
        }

    $referencePhoto = Join-Path $stage 'reference\photo'
    if (Test-Path -LiteralPath $referencePhoto) {
        Remove-Item -LiteralPath $referencePhoto -Recurse -Force
    }

    Get-ChildItem -LiteralPath $stage -File -Recurse -Force |
        Where-Object { $_.Name -like '.env*' } |
        ForEach-Object { Remove-Item -LiteralPath $_.FullName -Force }

    if (Test-Path -LiteralPath $zipPath) {
        Remove-Item -LiteralPath $zipPath -Force
    }

    Compress-Archive -Path (Join-Path $stage '*') -DestinationPath $zipPath -CompressionLevel Optimal

    Add-Type -AssemblyName System.IO.Compression.FileSystem
    $archive = [System.IO.Compression.ZipFile]::OpenRead($zipPath)
    $entries = @($archive.Entries)
    $pathViolations = @()
    $secretHits = @()

    $pathPatterns = @(
        '(?i)(^|/)\.git(/|$)',
        '(?i)(^|/)node_modules(/|$)',
        '(?i)(^|/)(\.venv|venv|\.validation-venv)(/|$)',
        '(?i)(^|/)\.env([^/]*)(/|$|$)',
        '(?i)(^|/)reference/photo(/|$)',
        '(?i)(^|/)(docs/evidence|docs/owner-private|personal-data|private-data)(/|$)',
        '(?i)(^|/)docs/working(/|$)',
        '(?i)(^|/)(id_rsa[^/]*|id_ed25519[^/]*|[^/]*\.(pem|key|p12|pfx))$',
        '(?i)(^|/)docs/[^/]*\.(png|jpg|jpeg|gif|bmp|tif|tiff|webp|jfif|heic|heif)$'
    )

    $secretPatterns = @(
        '(?i)\bAKIA[0-9A-Z]{16}\b',
        '(?i)\bBEGIN\s+(?:RSA\s+|EC\s+|OPENSSH\s+)?PRIVATE\s+KEY\b',
        '(?i)\b(?:api[_-]?key|secret[_-]?key|access[_-]?token|auth[_-]?token|password|private[_-]?key)\b\s*[:=]\s*["'']?[A-Za-z0-9_./+\-=]{12,}',
        '(?i)\bBearer\s+[A-Za-z0-9_./+\-=]{20,}',
        '(?i)\bgh[pousr]_[A-Za-z0-9]{20,}\b',
        '(?i)\bsk-(?:proj-|svc-|live-|test-)?[A-Za-z0-9]{20,}\b'
    )

    foreach ($entry in $entries) {
        foreach ($pattern in $pathPatterns) {
            if ($entry.FullName -match $pattern) {
                $pathViolations += $entry.FullName
            }
        }

        if (-not $entry.FullName.EndsWith('/') -and $entry.Length -le 5MB) {
            try {
                $reader = New-Object System.IO.StreamReader($entry.Open())
                $text = $reader.ReadToEnd()
                $reader.Close()

                foreach ($pattern in $secretPatterns) {
                    if ($text -match $pattern) {
                        $secretHits += $entry.FullName
                        break
                    }
                }
            } catch {
                # Binary or unreadable files are ignored by text scan but remain in path scan.
            }
        }
    }

    $archive.Dispose()

    $fileCount = @($entries | Where-Object { -not $_.FullName.EndsWith('/') }).Count
    $pathViolationCount = @($pathViolations | Sort-Object -Unique).Count
    $secretHitCount = @($secretHits | Sort-Object -Unique).Count

    Write-Output "HEAD=$($head.Substring(0,12))"
    Write-Output "ZIP=$zipPath"
    Write-Output "FILE_COUNT=$fileCount"
    Write-Output "PATH_VIOLATIONS=$pathViolationCount"
    Write-Output "SECRET_HINTS=$secretHitCount"

    if ($pathViolationCount -eq 0 -and $secretHitCount -eq 0) {
        Write-Output 'SCAN_STATUS=PASS'
    } else {
        if ($pathViolations.Count) {
            $pathViolations | Sort-Object -Unique | ForEach-Object { Write-Error "PATH_VIOLATION=$_" }
        }
        if ($secretHits.Count) {
            $secretHits | Sort-Object -Unique | ForEach-Object { Write-Error "SECRET_HINT=$_" }
        }
        Write-Output 'SCAN_STATUS=FAIL'
        throw 'Rule-SEC-01 scan failed.'
    }
} finally {
    if (Test-Path -LiteralPath $stage) {
        Remove-Item -LiteralPath $stage -Recurse -Force
    }
    if (Test-Path -LiteralPath $tarPath) {
        Remove-Item -LiteralPath $tarPath -Force
    }
}
