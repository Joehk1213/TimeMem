@echo off
chcp 65001 >nul
setlocal
title TimeMem Consensus & Docs Full Sync

cd /d C:\Project\TimeMem
set "LOG=C:\Project\TimeMem\scripts\pipeline_last_run.log"

echo ==========================================>>"%LOG%"
echo [%DATE% %TIME%] sync_consensus.bat start>>"%LOG%"

echo [1/3] 檢查專案目錄結構...
if not exist "C:\Project\TimeMem\docs\Summary" (
    echo [ERROR] 找不到 docs\Summary 資料夾！
    echo [ERROR] 找不到 docs\Summary 資料夾！>>"%LOG%"
    goto :end
)

git fetch origin main>>"%LOG%" 2>&1
if errorlevel 1 (
    echo [ERROR] Git fetch 失敗，終止同步！
    echo [ERROR] Git fetch 失敗，終止同步！>>"%LOG%"
    goto :end
)

git pull --rebase --autostash origin main>>"%LOG%" 2>&1
if errorlevel 1 (
    echo [ERROR] Git rebase/pull 失敗，未強制 Push，請先人工處理衝突！
    echo [ERROR] Git rebase/pull 失敗，未強制 Push，請先人工處理衝突！>>"%LOG%"
    goto :end
)

git status --porcelain>>"%LOG%" 2>&1
if errorlevel 1 (
    echo [ERROR] 無法取得 Git 工作目錄狀態，終止同步！
    echo [ERROR] 無法取得 Git 工作目錄狀態，終止同步！>>"%LOG%"
    goto :end
)

set "HAS_CHANGES="
for /f "delims=" %%I in ('git status --porcelain') do set "HAS_CHANGES=1"
if not defined HAS_CHANGES (
    echo [INFO] 目前沒有新的共識變更需要同步。
    echo [INFO] 目前沒有新的共識變更需要同步。>>"%LOG%"
    goto :end
)

echo [2/3] 將所有核心文檔、Summary 與腳本變更加入 Git 追蹤...
git add --all>>"%LOG%" 2>&1
if errorlevel 1 (
    echo [ERROR] Git add 失敗，終止同步！
    echo [ERROR] Git add 失敗，終止同步！>>"%LOG%"
    goto :end
)

git diff --cached --quiet>>"%LOG%" 2>&1
if not errorlevel 1 (
    echo [INFO] 沒有可提交的 staged 變更。
    echo [INFO] 沒有可提交的 staged 變更。>>"%LOG%"
    goto :end
)

echo [3/3] 提交並推送到 GitHub Repo...
git -c user.name="TimeMem Pipeline" -c user.email="pipeline@local" commit -m "docs: full sync consensus summaries, core canonical docs, and automation scripts">>"%LOG%" 2>&1
if errorlevel 1 (
    echo [ERROR] Git commit 失敗，終止同步！
    echo [ERROR] Git commit 失敗，終止同步！>>"%LOG%"
    goto :end
)

set "GIT_TERMINAL_PROMPT=0"
set "GCM_INTERACTIVE=Never"
git push origin main>>"%LOG%" 2>&1
if errorlevel 1 (
    echo [ERROR] Git push 失敗，終止同步！
    echo [ERROR] Git push 失敗，終止同步！>>"%LOG%"
    goto :end
)

echo [SUCCESS] 全面共識與文檔同步完成！
echo [SUCCESS] 全面共識與文檔同步完成！>>"%LOG%"

:end
echo [%DATE% %TIME%] sync_consensus.bat end>>"%LOG%"
