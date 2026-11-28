@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul

echo [TimeMem Pipeline] Starting automated consensus sync & deployment...

cd /d C:\Project\TimeMem

:: Step 4: 執行 Python 共識解析與文檔更新
python scripts\sync_consensus.py
if %errorlevel% neq 0 (
    echo [ERROR] Consensus sync failed! Stopping pipeline.
    exit /b 1
)

:: Step 5: 調用現有經已驗證成功嘅一鍵推送與遠端部署腳本
call scripts\deploy_all.bat

echo [SUCCESS] Full automated pipeline completed successfully!

if "%~1"=="--silent" (
    exit /b 0
)

pause