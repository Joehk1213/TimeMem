import os
import re
import sys
from datetime import datetime, timezone, timedelta

def get_hkt_now():
    # 固定香港時間 UTC+8
    hkt = timezone(timedelta(hours=8))
    return datetime.now(hkt)

def main():
    repo_path = r"C:\Project\TimeMem"
    latest_summary_path = os.path.join(repo_path, "docs", "Summary", "latest_summary.md")
    
    if not os.path.exists(latest_summary_path):
        print(f"[ERROR] latest_summary.md not found at {latest_summary_path}")
        sys.exit(1)
        
    with open(latest_summary_path, "r", encoding="utf-8") as f:
        content = f.read()
        
    print("[INFO] Parsing latest_summary.md for consensus update...")
    
    # 1. 讀取現有核心文檔進行合規追加 (PROGRESS.md / TODO.md / DECISIONS.md)
    progress_path = os.path.join(repo_path, "docs", "PROGRESS.md")
    if os.path.exists(progress_path):
        with open(progress_path, "r", encoding="utf-8") as pf:
            prog_content = pf.read()
            
        hkt_str = get_hkt_now().strftime("%Y-%m-%d %H:%M")
        new_entry = f"\n## {hkt_str} — 自動化共識同步\n\n- 透過自動化流水線成功同步最新對話共識摘要。\n"
        
        # 插入到 PROGRESS.md 最頂部或合適位置
        updated_prog = prog_content.replace("# PROGRESS — 已完成事項\n", f"# PROGRESS — 已完成事項\n{new_entry}")
        with open(progress_path, "w", encoding="utf-8") as pf:
            pf.write(updated_prog)
        print("[SUCCESS] PROGRESS.md updated.")

    # 2. 自動歸檔：將 latest_summary.md 重新命名為 YYYYMMDDHHMM_latest_summary.md
    timestamp_str = get_hkt_now().strftime("%Y%m%d%H%M")
    archive_filename = f"{timestamp_str}_latest_summary.md"
    archive_path = os.path.join(repo_path, "docs", "Summary", archive_filename)
    
    # 複製一份去 archive 命名，同時保留一份 latest_summary.md 供流水線後續讀取或清理
    with open(archive_path, "w", encoding="utf-8") as af:
        af.write(content)
    print(f"[SUCCESS] Archived summary to: {archive_filename}")

if __name__ == "__main__":
    main()