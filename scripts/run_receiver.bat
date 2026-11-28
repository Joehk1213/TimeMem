@echo off
cd /d C:\Project\TimeMem
set "PYTHONUNBUFFERED=1"
python C:\Project\TimeMem\scripts\n8n_receiver.py >>C:\Project\TimeMem\scripts\receiver_last_run.log 2>&1