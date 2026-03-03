#!/usr/bin/env python3
"""Terminal Roulette - Theme Manager API Server

Zero-dependency Python HTTP server for the Terminal Roulette web UI.
Serves the single-page app and provides REST API for theme management.
"""

import http.server
import json
import os
import re
import shutil
import subprocess
import sys
import urllib.parse

PORT = 8378
THEMES_DIR = os.path.expanduser("~/.config/starship-themes")
CONFIG_FILE = os.path.join(THEMES_DIR, "config.json")
UI_DIR = os.path.dirname(os.path.abspath(__file__))


def read_config():
    if os.path.exists(CONFIG_FILE):
        with open(CONFIG_FILE) as f:
            return json.load(f)
    return {"favorites": [], "favoritesOnly": False, "locked": None, "version": 1}


def write_config(config):
    os.makedirs(os.path.dirname(CONFIG_FILE), exist_ok=True)
    with open(CONFIG_FILE, "w") as f:
        json.dump(config, f, indent=2)


def parse_terminal_colors():
    """Parse terminal-colors.sh to extract per-theme color data."""
    colors_file = os.path.join(THEMES_DIR, "terminal-colors.sh")
    if not os.path.exists(colors_file):
        return {}

    with open(colors_file) as f:
        content = f.read()

    themes = {}
    # Match each theme case block: theme-name) ... ;;
    pattern = re.compile(
        r"^ {8}(\S+)\)\s*\n(.*?)^ {12};;",
        re.MULTILINE | re.DOTALL,
    )
    for m in pattern.finditer(content):
        name = m.group(1)
        block = m.group(2)
        if name == "*":
            continue

        theme = {}
        # Extract bg, fg, cursor
        for key in ("bg", "fg", "cursor"):
            val = re.search(rf"{key}='(#[0-9A-Fa-f]{{6}})'", block)
            if val:
                theme[key] = val.group(1)

        # Extract font
        font_m = re.search(r"font='([^']+)'", block)
        if font_m:
            theme["font"] = font_m.group(1)

        # Extract transparency
        trans_m = re.search(r"transparency=(\d+)", block)
        if trans_m:
            theme["transparency"] = int(trans_m.group(1))

        # Extract palette
        palette_m = re.search(
            r"palette=\(\s*((?:'#[0-9A-Fa-f]{6}'\s*)+)\)", block
        )
        if palette_m:
            colors = re.findall(r"'(#[0-9A-Fa-f]{6})'", palette_m.group(1))
            theme["palette"] = colors

        themes[name] = theme

    return themes


def read_terminal_colors_raw():
    colors_file = os.path.join(THEMES_DIR, "terminal-colors.sh")
    if os.path.exists(colors_file):
        with open(colors_file) as f:
            return f.read()
    return ""


def write_theme_to_terminal_colors(name, data):
    """Add or update a theme entry in terminal-colors.sh."""
    colors_file = os.path.join(THEMES_DIR, "terminal-colors.sh")
    if not os.path.exists(colors_file):
        return False

    with open(colors_file) as f:
        content = f.read()

    # Build the new case block
    palette = data.get("palette", [])
    palette_str = ""
    if len(palette) == 16:
        lines = []
        for i in range(0, 16, 4):
            row = " ".join(f"'{c}'" for c in palette[i : i + 4])
            lines.append(f"                {row}")
        palette_str = "\n".join(lines)

    new_block = f"""        {name})
            bg='{data.get("bg", "#1A1B26")}' fg='{data.get("fg", "#C0CAF5")}' cursor='{data.get("cursor", "#C0CAF5")}'
            font='{data.get("font", "FiraCode Nerd Font Mono 11")}'
            transparency={data.get("transparency", 0)}
            palette=(
{palette_str}
            )
            ;;"""

    # Check if theme already exists
    existing = re.search(
        rf"^ {{8}}{re.escape(name)}\)\s*\n.*?^ {{12}};;",
        content,
        re.MULTILINE | re.DOTALL,
    )

    if existing:
        # Replace existing
        content = content[: existing.start()] + new_block + content[existing.end() :]
    else:
        # Insert before the *) fallback
        fallback = re.search(r"^ {8}\*\)", content, re.MULTILINE)
        if fallback:
            content = (
                content[: fallback.start()]
                + new_block
                + "\n"
                + content[fallback.start() :]
            )

    with open(colors_file, "w") as f:
        f.write(content)

    # Also update the repo copy if it exists
    repo_colors = os.path.join(
        os.path.dirname(UI_DIR), "themes", "terminal-colors.sh"
    )
    if os.path.exists(repo_colors):
        shutil.copy2(colors_file, repo_colors)

    return True


def delete_theme_from_terminal_colors(name):
    """Remove a theme entry from terminal-colors.sh."""
    colors_file = os.path.join(THEMES_DIR, "terminal-colors.sh")
    if not os.path.exists(colors_file):
        return False

    with open(colors_file) as f:
        content = f.read()

    existing = re.search(
        rf"^ {{8}}{re.escape(name)}\)\s*\n.*?^ {{12}};;\n?",
        content,
        re.MULTILINE | re.DOTALL,
    )
    if existing:
        content = content[: existing.start()] + content[existing.end() :]
        with open(colors_file, "w") as f:
            f.write(content)
        return True
    return False


def list_themes():
    """List all themes with their data."""
    colors = parse_terminal_colors()
    config = read_config()
    themes = []

    toml_files = sorted(
        f
        for f in os.listdir(THEMES_DIR)
        if f.endswith(".toml")
    )

    for fname in toml_files:
        name = fname[:-5]  # strip .toml
        theme = {
            "name": name,
            "favorite": name in config.get("favorites", []),
        }
        if name in colors:
            theme.update(colors[name])
        themes.append(theme)

    return themes


def get_theme_toml(name):
    """Read a theme's .toml file content."""
    path = os.path.join(THEMES_DIR, f"{name}.toml")
    if os.path.exists(path):
        with open(path) as f:
            return f.read()
    return None


def write_theme_toml(name, content):
    """Write a theme's .toml file."""
    path = os.path.join(THEMES_DIR, f"{name}.toml")
    with open(path, "w") as f:
        f.write(content)
    # Also copy to repo themes dir
    repo_path = os.path.join(os.path.dirname(UI_DIR), "themes", f"{name}.toml")
    repo_dir = os.path.dirname(repo_path)
    if os.path.isdir(repo_dir):
        shutil.copy2(path, repo_path)


def delete_theme(name):
    """Delete a theme completely."""
    toml_path = os.path.join(THEMES_DIR, f"{name}.toml")
    if os.path.exists(toml_path):
        os.remove(toml_path)
    delete_theme_from_terminal_colors(name)
    # Remove from config favorites
    config = read_config()
    if name in config.get("favorites", []):
        config["favorites"].remove(name)
    if config.get("locked") == name:
        config["locked"] = None
    write_config(config)
    # Remove repo copy
    repo_path = os.path.join(os.path.dirname(UI_DIR), "themes", f"{name}.toml")
    if os.path.exists(repo_path):
        os.remove(repo_path)


class Handler(http.server.BaseHTTPRequestHandler):
    def log_message(self, format, *args):
        # Quieter logging
        pass

    def send_json(self, data, status=200):
        body = json.dumps(data).encode()
        self.send_response(status)
        self.send_header("Content-Type", "application/json")
        self.send_header("Content-Length", len(body))
        self.send_header("Access-Control-Allow-Origin", "*")
        self.end_headers()
        self.wfile.write(body)

    def send_text(self, text, content_type="text/html", status=200):
        body = text.encode()
        self.send_response(status)
        self.send_header("Content-Type", content_type)
        self.send_header("Content-Length", len(body))
        self.end_headers()
        self.wfile.write(body)

    def read_body(self):
        length = int(self.headers.get("Content-Length", 0))
        return self.rfile.read(length)

    def do_OPTIONS(self):
        self.send_response(200)
        self.send_header("Access-Control-Allow-Origin", "*")
        self.send_header("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS")
        self.send_header("Access-Control-Allow-Headers", "Content-Type")
        self.end_headers()

    def do_GET(self):
        parsed = urllib.parse.urlparse(self.path)
        path = parsed.path

        if path == "/" or path == "/index.html":
            index_path = os.path.join(UI_DIR, "index.html")
            if os.path.exists(index_path):
                with open(index_path) as f:
                    self.send_text(f.read())
            else:
                self.send_text("index.html not found", status=404)

        elif path == "/api/themes":
            self.send_json(list_themes())

        elif path.startswith("/api/themes/"):
            name = urllib.parse.unquote(path[len("/api/themes/") :])
            colors = parse_terminal_colors()
            toml = get_theme_toml(name)
            if toml is None:
                self.send_json({"error": "Theme not found"}, 404)
                return
            config = read_config()
            data = {
                "name": name,
                "toml": toml,
                "favorite": name in config.get("favorites", []),
            }
            if name in colors:
                data.update(colors[name])
            self.send_json(data)

        elif path == "/api/config":
            self.send_json(read_config())

        else:
            self.send_text("Not Found", status=404)

    def do_POST(self):
        parsed = urllib.parse.urlparse(self.path)
        path = parsed.path

        if path.startswith("/api/themes/") and path.endswith("/apply"):
            name = urllib.parse.unquote(path[len("/api/themes/") : -len("/apply")])
            toml_path = os.path.join(THEMES_DIR, f"{name}.toml")
            if not os.path.exists(toml_path):
                self.send_json({"error": "Theme not found"}, 404)
                return
            # Launch a new gnome-terminal with env vars set.
            # The user's .bashrc sources themeshift.sh, which checks
            # STARSHIP_THEME_NAME — if already set, it skips random
            # selection and applies that theme directly.
            try:
                env = {**os.environ}
                env["STARSHIP_THEME_NAME"] = name
                env["STARSHIP_CONFIG"] = toml_path
                subprocess.Popen(
                    ["gnome-terminal", "--"],
                    env=env,
                    start_new_session=True,
                )
                self.send_json({"applied": name, "launched": True})
            except FileNotFoundError:
                self.send_json({"error": "gnome-terminal not found"}, 500)
            except Exception as e:
                self.send_json({"error": str(e)}, 500)

        elif path.startswith("/api/themes/"):
            name = urllib.parse.unquote(path[len("/api/themes/") :])
            # Validate name
            if not re.match(r"^[a-z0-9][a-z0-9-]*$", name):
                self.send_json(
                    {"error": "Invalid theme name. Use lowercase letters, numbers, and hyphens."},
                    400,
                )
                return

            body = json.loads(self.read_body())
            toml_content = body.get("toml", "")
            terminal_data = {
                "bg": body.get("bg", "#1A1B26"),
                "fg": body.get("fg", "#C0CAF5"),
                "cursor": body.get("cursor", "#C0CAF5"),
                "font": body.get("font", "FiraCode Nerd Font Mono 11"),
                "transparency": body.get("transparency", 0),
                "palette": body.get("palette", []),
            }

            write_theme_toml(name, toml_content)
            write_theme_to_terminal_colors(name, terminal_data)
            self.send_json({"saved": name})

        else:
            self.send_text("Not Found", status=404)

    def do_PUT(self):
        parsed = urllib.parse.urlparse(self.path)
        path = parsed.path

        if path == "/api/config":
            body = json.loads(self.read_body())
            config = read_config()
            # Merge updates
            for key in ("favorites", "favoritesOnly", "locked"):
                if key in body:
                    config[key] = body[key]
            write_config(config)
            self.send_json(config)
        else:
            self.send_text("Not Found", status=404)

    def do_DELETE(self):
        parsed = urllib.parse.urlparse(self.path)
        path = parsed.path

        if path.startswith("/api/themes/"):
            name = urllib.parse.unquote(path[len("/api/themes/") :])
            toml_path = os.path.join(THEMES_DIR, f"{name}.toml")
            if not os.path.exists(toml_path):
                self.send_json({"error": "Theme not found"}, 404)
                return
            delete_theme(name)
            self.send_json({"deleted": name})
        else:
            self.send_text("Not Found", status=404)


def main():
    port = int(sys.argv[1]) if len(sys.argv) > 1 else PORT
    server = http.server.HTTPServer(("127.0.0.1", port), Handler)
    print(f"\n  Terminal Roulette UI")
    print(f"  http://localhost:{port}\n")
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        print("\n  Stopped.")
        server.server_close()


if __name__ == "__main__":
    main()
