#!/bin/bash
# Double-click to play Project Kart on a phone on the same Wi-Fi. Close this window to stop.
cd "$(dirname "$0")"
exec python3 -u - <<'PY'
import http.server, socket

PORT = 8790

def wifi_address():
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    try:
        s.connect(('10.255.255.255', 1))
        return s.getsockname()[0]
    except OSError:
        return None
    finally:
        s.close()

class GameOnly(http.server.SimpleHTTPRequestHandler):
    """Serves the game page and nothing else in this folder."""
    def do_GET(self):
        if self.path.split('?')[0] not in ('/', '/index.html'):
            self.send_error(404)
            return
        super().do_GET()
    def do_HEAD(self):
        self.do_GET()
    def log_message(self, *args):
        pass

ip = wifi_address()
print('\n  Project Kart is running.\n')
print(f'  On your phone, open:  http://{ip}:{PORT}' if ip else '  Connect this Mac to Wi-Fi first.')
print('\n  Your phone must be on the same Wi-Fi. Keep this window open while you play.\n')
http.server.ThreadingHTTPServer(('0.0.0.0', PORT), GameOnly).serve_forever()
PY
