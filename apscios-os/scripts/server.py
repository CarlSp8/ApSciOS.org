#!/usr/bin/env python3
import http.server
import socketserver
import os
import sys

PORT = 8000
DIRECTORY = "."

if len(sys.argv) > 1:
    DIRECTORY = sys.argv[1]

class Handler(http.server.SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=DIRECTORY, **kwargs)

print(f"Serving directory {DIRECTORY} at http://localhost:{PORT}")
try:
    with socketserver.TCPServer(("", PORT), Handler) as httpd:
        httpd.serve_forever()
except KeyboardInterrupt:
    print("\nServer stopped.")
