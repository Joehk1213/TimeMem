@echo off
chcp 65001 >nul
title TimeMem Consensus Sync

echo [1/3] 檢查最新共識總結檔案...
if not exist "latest_summary.md" (
    echo [ERROR] 找不到 latest_summary.md，請先叫 Gemini 幫你產出總結！
    goto :end
)

echo [2/3] 將共識與專案更新加入 Git 追蹤...
cd /d "%~dp0.."
git add latest_summary.md docs/

echo [3/3] 提交並推送到 GitHub Repo...
git commit -m "docs: sync latest conversation consensus"
git push origin main

echo ------------------------------------------
echo [SUCCESS] 共識同步完成！
:end
pause