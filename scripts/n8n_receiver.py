from http.server import HTTPServer, BaseHTTPRequestHandler
import hashlib
import json
import os
import re
import subprocess
import threading
from datetime import datetime

SUMMARY_DIR = r"C:\Project\TimeMem\docs\Summary"
SCRIPTS_DIR = r"C:\Project\TimeMem\scripts"
TIMESTAMPED_SUMMARY_RE = re.compile(r"^\d{12}_latest_summary\.md$")


def md5_hex(content):
    return hashlib.md5(content).hexdigest()


def find_previous_summary_hash():
    os.makedirs(SUMMARY_DIR, exist_ok=True)
    candidates = [
        os.path.join(SUMMARY_DIR, name)
        for name in os.listdir(SUMMARY_DIR)
        if TIMESTAMPED_SUMMARY_RE.match(name)
    ]
    if not candidates:
        return None
    newest_path = max(candidates, key=lambda path: os.path.basename(path))
    with open(newest_path, "rb") as previous_file:
        return md5_hex(previous_file.read())


def trigger_full_pipeline():
    print("[PIPELINE] Background thread started: Triggering automated consensus sync & deployment pipeline...")
    try:
        py_script = os.path.join(SCRIPTS_DIR, "sync_consensus.py")
        if os.path.exists(py_script):
            res = subprocess.run(["python", py_script], capture_output=True, text=True, encoding="utf-8")
            if res.returncode != 0:
                print(f"[ERROR] sync_consensus.py failed:\n{res.stderr}")
                return

        sync_bat = os.path.join(SCRIPTS_DIR, "sync_consensus.bat")
        if os.path.exists(sync_bat):
            res = subprocess.run([sync_bat], capture_output=True, text=True, encoding="utf-8")
            if res.returncode != 0:
                print(f"[ERROR] sync_consensus.bat failed:\n{res.stderr}")
                return

        deploy_bat = os.path.join(SCRIPTS_DIR, "deploy_all.bat")
        if os.path.exists(deploy_bat):
            res = subprocess.run([deploy_bat, "--silent"], capture_output=True, text=True, encoding="utf-8")
            if res.returncode != 0:
                print(f"[ERROR] deploy_all.bat failed:\n{res.stderr}")
                return

        print("[SUCCESS] Full automated pipeline executed successfully in background!")
    except Exception as e:
        print(f"[ERROR] Pipeline execution crashed: {e}")


class Handler(BaseHTTPRequestHandler):
    def do_POST(self):
        try:
            length = int(self.headers.get("Content-Length", 0))
            raw_body = self.rfile.read(length)

            content = raw_body
            try:
                data = json.loads(raw_body.decode("utf-8", errors="ignore"))
                if isinstance(data, dict) and "content" in data:
                    val = data["content"]
                    if isinstance(val, str):
                        content = val.encode("utf-8")
            except:
                pass

            os.makedirs(SUMMARY_DIR, exist_ok=True)
            incoming_hash = md5_hex(content)
            previous_hash = find_previous_summary_hash()

            if previous_hash is not None and incoming_hash == previous_hash:
                self.send_response(200)
                self.end_headers()
                self.wfile.write(b"OK")
                print("Content unchanged; skipped duplicate summary.")
                return

            timestamp = datetime.now().strftime("%Y%m%d%H%M")
            filename = f"{timestamp}_latest_summary.md"
            target_path = os.path.join(SUMMARY_DIR, filename)

            with open(target_path, "wb") as summary_file:
                summary_file.write(content)

            latest_path = os.path.join(SUMMARY_DIR, "latest_summary.md")
            with open(latest_path, "wb") as latest_file:
                latest_file.write(content)

            self.send_response(200)
            self.end_headers()
            self.wfile.write(b"OK")
            print(f"Successfully received and saved to {target_path}")

            threading.Thread(target=trigger_full_pipeline, daemon=True).start()

        except Exception as error:
            print(f"[CRITICAL ERROR] Failed to receive summary: {error}")
            try:
                self.send_response(500)
                self.end_headers()
                self.wfile.write(b"ERROR")
            except:
                pass


if __name__ == "__main__":
    print("Receiver listening on port 8765 with async background pipeline trigger...")
    HTTPServer(("0.0.0.0", 8765), Handler).serve_forever()