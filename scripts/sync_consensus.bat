@echo off
chcp 65001 >nul
title TimeMem Consensus & Docs Full Sync

echo [1/3] 檢查專案目錄結構...
if not exist "%~dp0..\docs\Summary" (
    echo [ERROR] 找不到 docs\Summary 資料夾！
    goto :end
)

echo [2/3] 將所有核心文檔、Summary 與腳本變更加入 Git 追蹤...
cd /d "%~dp0.."
git add .

echo [3/3] 提交並推送到 GitHub Repo...
git commit -m "docs: full sync consensus summaries, core canonical docs, and automation scripts"
git push origin main

echo ------------------------------------------
echo [SUCCESS] 全面共識與文檔同步完成！
:end
pause