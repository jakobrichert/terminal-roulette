#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════════════════
# Terminal Roulette - Uninstaller
# ═══════════════════════════════════════════════════════════════════
set -e

GREEN="\033[1;32m"
CYAN="\033[1;36m"
DIM="\033[2m"
RESET="\033[0m"

echo ""
echo -e "  ${CYAN}Terminal Roulette${RESET} ${DIM}uninstaller${RESET}"
echo ""

# Remove themes
if [[ -d "$HOME/.config/starship-themes" ]]; then
    rm -rf "$HOME/.config/starship-themes"
    echo -e "  ${GREEN}✓${RESET} Removed themes from ${DIM}~/.config/starship-themes${RESET}"
fi

# Remove script
if [[ -d "$HOME/.local/share/terminal-roulette" ]]; then
    rm -rf "$HOME/.local/share/terminal-roulette"
    echo -e "  ${GREEN}✓${RESET} Removed themeshift.sh"
fi

# Remove from bashrc
if [[ -f "$HOME/.bashrc" ]]; then
    sed -i '/# Terminal Roulette/d' "$HOME/.bashrc"
    sed -i '/terminal-roulette\/themeshift.sh/d' "$HOME/.bashrc"
    echo -e "  ${GREEN}✓${RESET} Removed from ${DIM}~/.bashrc${RESET}"
fi

echo ""
echo -e "  ${GREEN}Done.${RESET} Restart your terminal to apply changes."
echo -e "  ${DIM}Note: Starship itself was not removed.${RESET}"
echo ""
