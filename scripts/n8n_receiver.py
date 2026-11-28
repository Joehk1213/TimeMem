import os
import re
import json
import hashlib
from http.server import HTTPServer, BaseHTTPRequestHandler
from datetime import datetime, timedelta, timezone

PORT = 8765
SUMMARY_DIR = r"C:\Project\TimeMem\docs\Summary"
HKT = timezone(timedelta(hours=8))
CONTROLLABLE_BINARY_RE = re.compile(r"[\x00-\x08\x0b\x0c\x0e-\x1f\x7f]")

def md5_hex(content):
    return hashlib.md5(content).hexdigest()

def validate_text_payload(raw_body):
    if not raw_body:
        raise ValueError("empty payload")

    content = raw_body
    try:
        data = json.loads(raw_body.decode("utf-8"))
        if isinstance(data, dict) and "content" in data:
            val = data["content"]
            if not isinstance(val, str):
                raise ValueError("JSON content field is not text")
            content = val.encode("utf-8")
    except json.JSONDecodeError:
        content = raw_body

    try:
        text = content.decode("utf-8", errors="strict")
    except UnicodeDecodeError as error:
        raise ValueError("payload is not valid UTF-8") from error

    if not text.strip():
        raise ValueError("payload contains no readable text")
    if CONTROLLABLE_BINARY_RE.search(text):
        raise ValueError("payload contains binary control characters")

    printable = sum(character.isprintable() or character in "\r\n\t" for character in text)
    if len(text) == 0 or printable / len(text) < 0.95:
        raise ValueError("payload is not readable text")

    return content

class Handler(BaseHTTPRequestHandler):
    def do_POST(self):
        try:
            length = int(self.headers.get("Content-Length", 0))
            raw_body = self.rfile.read(length)
            
            try:
                content = validate_text_payload(raw_body)
            except ValueError as validation_error:
                print(f"[ERROR] Invalid binary/corrupted payload received: {validation_error}")
                self.send_response(400)
                self.send_header("Content-Type", "text/plain; charset=utf-8")
                self.end_headers()
                self.wfile.write(b"Invalid binary/corrupted payload")
                return

            os.makedirs(SUMMARY_DIR, exist_ok=True)
            incoming_hash = md5_hex(content)
            
            print(f"[DEBUG] Incoming MD5: {incoming_hash}")

            # 統一強制使用 12 位分鐘格式 (YYYYMMDDHHMM)，絕不產生秒數撞車檔
            timestamp = datetime.now(HKT).strftime("%Y%m%d%H%M")
            filename = f"{timestamp}_latest_summary.md"
            filepath = os.path.join(SUMMARY_DIR, filename)
            latest_path = os.path.join(SUMMARY_DIR, "latest_summary.md")

            with open(filepath, "wb") as f:
                f.write(content)
            with open(latest_path, "wb") as f:
                f.write(content)

            print(f"[SUCCESS] Saved summary to {filepath} and updated latest_summary.md")

            self.send_response(200)
            self.send_header("Content-Type", "text/plain; charset=utf-8")
            self.end_headers()
            self.wfile.write(b"OK_SAVED")

        except Exception as e:
            print(f"[ERROR] Exception in receiver: {e}")
            self.send_response(500)
            self.end_headers()
            self.wfile.write(str(e).encode("utf-8"))

def run():
    server_address = ('', PORT)
    httpd = HTTPServer(server_address, Handler)
    print(f"TimeMem Receiver listening on port {PORT}...")
    httpd.serve_forever()

if __name__ == "__main__":
    run()