#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════════════════
# Terminal Roulette - Installer
# ═══════════════════════════════════════════════════════════════════
set -e

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
THEMES_DEST="$HOME/.config/starship-themes"
SCRIPT_DEST="$HOME/.local/share/terminal-roulette"
BOLD="\033[1m"
GREEN="\033[1;32m"
CYAN="\033[1;36m"
YELLOW="\033[1;33m"
RED="\033[1;31m"
DIM="\033[2m"
RESET="\033[0m"

echo ""
echo -e "  ${CYAN}Terminal Roulette${RESET} ${DIM}installer${RESET}"
echo -e "  ${DIM}──────────────────────────${RESET}"
echo ""

# ─── Check for Starship ─────────────────────────────────────────

if command -v starship &>/dev/null; then
    echo -e "  ${GREEN}✓${RESET} Starship found: $(starship --version 2>/dev/null | head -1)"
elif [[ -x "$HOME/.local/bin/starship" ]]; then
    echo -e "  ${GREEN}✓${RESET} Starship found: $("$HOME/.local/bin/starship" --version 2>/dev/null | head -1)"
else
    echo -e "  ${YELLOW}!${RESET} Starship not found. Installing..."
    curl -sS https://starship.rs/install.sh | sh -s -- --yes --bin-dir="$HOME/.local/bin"
    echo -e "  ${GREEN}✓${RESET} Starship installed"
fi

# ─── Check for Nerd Font ────────────────────────────────────────

if fc-list 2>/dev/null | grep -qi "nerd"; then
    echo -e "  ${GREEN}✓${RESET} Nerd Font detected"
else
    echo -e "  ${YELLOW}!${RESET} No Nerd Font found. For best results, install one:"
    echo -e "    ${DIM}https://www.nerdfonts.com/font-downloads${RESET}"
    echo -e "    ${DIM}Recommended: FiraCode Nerd Font or Hack Nerd Font${RESET}"
fi

# ─── Install themes ─────────────────────────────────────────────

echo ""
mkdir -p "$THEMES_DEST"

# Back up existing themes if present
if [[ -d "$THEMES_DEST" ]] && ls "$THEMES_DEST"/*.toml &>/dev/null 2>&1; then
    BACKUP_DIR="$THEMES_DEST.backup.$(date +%s)"
    echo -e "  ${DIM}Backing up existing themes to ${BACKUP_DIR}${RESET}"
    cp -r "$THEMES_DEST" "$BACKUP_DIR"
fi

cp "$REPO_DIR"/themes/*.toml "$THEMES_DEST/"
cp "$REPO_DIR"/themes/terminal-colors.sh "$THEMES_DEST/"
THEME_COUNT=$(ls "$THEMES_DEST"/*.toml 2>/dev/null | wc -l)
echo -e "  ${GREEN}✓${RESET} Installed ${BOLD}${THEME_COUNT}${RESET} themes to ${DIM}${THEMES_DEST}${RESET}"

# ─── Install main script ────────────────────────────────────────

mkdir -p "$SCRIPT_DEST"
cp "$REPO_DIR/themeshift.sh" "$SCRIPT_DEST/themeshift.sh"
echo -e "  ${GREEN}✓${RESET} Installed themeshift.sh to ${DIM}${SCRIPT_DEST}${RESET}"

# ─── Add to shell config ────────────────────────────────────────

SOURCE_LINE='# Terminal Roulette - random theme on every new shell'
SOURCE_CMD="source \"$SCRIPT_DEST/themeshift.sh\""
BASHRC="$HOME/.bashrc"

if [[ -f "$BASHRC" ]] && grep -qF "terminal-roulette" "$BASHRC" 2>/dev/null; then
    echo -e "  ${GREEN}✓${RESET} Already configured in ${DIM}~/.bashrc${RESET}"
elif [[ -f "$BASHRC" ]] && grep -qF "themeshift" "$BASHRC" 2>/dev/null; then
    echo -e "  ${GREEN}✓${RESET} Already configured in ${DIM}~/.bashrc${RESET}"
else
    # Back up bashrc
    cp "$BASHRC" "$BASHRC.backup.$(date +%s)" 2>/dev/null || true
    echo "" >> "$BASHRC"
    echo "$SOURCE_LINE" >> "$BASHRC"
    echo "$SOURCE_CMD" >> "$BASHRC"
    echo -e "  ${GREEN}✓${RESET} Added to ${DIM}~/.bashrc${RESET} ${DIM}(backup created)${RESET}"
fi

# ─── Done ────────────────────────────────────────────────────────

echo ""
echo -e "  ${GREEN}Done!${RESET} Open a new terminal to see a random theme."
echo ""
echo -e "  ${BOLD}Commands:${RESET}"
echo -e "    ${CYAN}theme${RESET}            List all themes"
echo -e "    ${CYAN}theme${RESET} <name>      Switch to a theme"
echo -e "    ${CYAN}theme random${RESET}      Random theme"
echo -e "    ${CYAN}theme preview${RESET}     Cycle through all themes"
echo ""
