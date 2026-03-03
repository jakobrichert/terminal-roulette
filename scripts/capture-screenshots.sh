#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════════════════
# Capture screenshots of all Terminal Roulette themes
# Requires: gnome-terminal, gnome-screenshot or import (ImageMagick)
# ═══════════════════════════════════════════════════════════════════
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"
THEMES_DIR="$REPO_DIR/themes"
SCREENSHOTS_DIR="$REPO_DIR/screenshots"
DEMO_SCRIPT="$REPO_DIR/scripts/_demo_content.sh"

mkdir -p "$SCREENSHOTS_DIR"

# Create a demo script that shows sample content
cat > "$DEMO_SCRIPT" << 'DEMO'
#!/usr/bin/env bash
THEME_NAME="$1"
THEMES_DIR="$2"
SCREENSHOTS_DIR="$3"

# Apply theme
export STARSHIP_CONFIG="$THEMES_DIR/${THEME_NAME}.toml"
export STARSHIP_THEME_NAME="$THEME_NAME"
source "$THEMES_DIR/terminal-colors.sh"
_apply_terminal_theme

# Set up starship
eval "$(starship init bash 2>/dev/null || "$HOME/.local/bin/starship" init bash 2>/dev/null)"

# Resize terminal
printf '\033[8;24;88t'
sleep 0.3

clear

# Print demo content with the starship prompt
echo ""
echo -e "  \033[1m$THEME_NAME\033[0m"
echo ""

# Simulate a prompt + commands
PROMPT_CMD='PS1="$(starship prompt 2>/dev/null)"'
eval "$PROMPT_CMD"
echo -e "${PS1}ls -la"
echo "drwxr-xr-x  5 user user  4096 Mar  3 10:22 src/"
echo "drwxr-xr-x  3 user user  4096 Mar  3 09:15 tests/"
echo "-rw-r--r--  1 user user  2847 Mar  3 10:22 main.rs"
echo "-rw-r--r--  1 user user   493 Mar  2 14:30 Cargo.toml"
echo ""
echo -e "${PS1}git status"
echo -e "On branch \033[1mmain\033[0m"
echo "Changes not staged for commit:"
echo -e "  \033[31mmodified:   src/lib.rs\033[0m"
echo ""
echo -e "${PS1}"

sleep 0.5

# Take screenshot
import -window "$(xdotool getactivewindow)" "$SCREENSHOTS_DIR/${THEME_NAME}.png" 2>/dev/null \
    || gnome-screenshot -w -f "$SCREENSHOTS_DIR/${THEME_NAME}.png" 2>/dev/null \
    || echo "Screenshot failed for $THEME_NAME"

sleep 0.3
DEMO
chmod +x "$DEMO_SCRIPT"

# List of themes to capture
THEMES=($(ls "$THEMES_DIR"/*.toml 2>/dev/null | xargs -I{} basename {} .toml | sort))

echo "Capturing ${#THEMES[@]} theme screenshots..."
echo ""

for theme in "${THEMES[@]}"; do
    echo "  Capturing: $theme"

    # Run in current terminal
    bash "$DEMO_SCRIPT" "$theme" "$THEMES_DIR" "$SCREENSHOTS_DIR"
done

rm -f "$DEMO_SCRIPT"

echo ""
echo "Done! Screenshots saved to $SCREENSHOTS_DIR/"
