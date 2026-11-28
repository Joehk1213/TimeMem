@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul

echo [TimeMem Pipeline] Starting automated consensus sync & deployment...

cd /d C:\Project\TimeMem
set "LOG=C:\Project\TimeMem\scripts\pipeline_last_run.log"
echo ==========================================>>"%LOG%"
echo [%DATE% %TIME%] run_auto_pipeline.bat start>>"%LOG%"

:: Step 4: 執行 Python 共識解析與文檔更新
python scripts\sync_consensus.py>>"%LOG%" 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Consensus sync failed! Stopping pipeline.
    echo [ERROR] Consensus sync failed! Stopping pipeline.>>"%LOG%"
    exit /b 1
)

:: Step 5: 調用現有經已驗證成功嘅一鍵推送與遠端部署腳本
call scripts\deploy_all.bat --silent>>"%LOG%" 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Deploy failed.>>"%LOG%"
    exit /b %errorlevel%
)

echo [SUCCESS] Full automated pipeline completed successfully!
echo [SUCCESS] Full automated pipeline completed successfully!>>"%LOG%"
echo [%DATE% %TIME%] run_auto_pipeline.bat end>>"%LOG%"
exit /b 0