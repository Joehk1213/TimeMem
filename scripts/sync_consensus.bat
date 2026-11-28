@echo off
chcp 65001 >nul
title TimeMem Consensus & Docs Full Sync

echo [1/3] 檢查專案目錄結構...
if not exist "%~dp0..\docs\Summary" (
    echo [ERROR] 找不到 docs\Summary 資料夾！
    goto :end
)

cd /d "%~dp0.."

git status --porcelain
if errorlevel 1 (
    echo [ERROR] 無法取得 Git 工作目錄狀態，終止同步！
    goto :end
)

for /f "delims=" %%I in ('git status --porcelain') do set "HAS_CHANGES=1"
if not defined HAS_CHANGES (
    echo [INFO] 目前沒有新的共識變更需要同步。
    echo ------------------------------------------
    goto :end
)

echo [2/3] 將所有核心文檔、Summary 與腳本變更加入 Git 追蹤...
git add --all
if errorlevel 1 (
    echo [ERROR] Git add 失敗，終止同步！
    goto :end
)

echo [3/3] 提交並推送到 GitHub Repo...
git commit -m "docs: full sync consensus summaries, core canonical docs, and automation scripts"
if errorlevel 1 (
    echo [ERROR] Git commit 失敗，終止同步！
    goto :end
)

git push origin main
if errorlevel 1 (
    echo [ERROR] Git push 失敗，終止同步！
    goto :end
)

echo ------------------------------------------
echo [SUCCESS] 全面共識與文檔同步完成！
:end
pause