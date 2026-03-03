#!/usr/bin/env bash
# Demo content displayed in screenshot window
THEME_NAME="$1"
THEMES_DIR="${2:-$HOME/.config/starship-themes}"

export STARSHIP_CONFIG="$THEMES_DIR/${THEME_NAME}.toml"
export STARSHIP_THEME_NAME="$THEME_NAME"
source "$THEMES_DIR/terminal-colors.sh"
_apply_terminal_theme

clear
sleep 0.2
clear

# Use starship in a real PS1 context via PROMPT_COMMAND
if command -v starship &>/dev/null; then
    eval "$(starship init bash)"
elif [[ -x "$HOME/.local/bin/starship" ]]; then
    eval "$("$HOME/.local/bin/starship" init bash)"
fi

# Force PROMPT_COMMAND to run so PS1 is set
eval "${PROMPT_COMMAND:-:}"

# Now print the PS1 prompt properly using bash's prompt expansion
# Use \n to get the prompt on the line, then show commands after it
echo ""

# Emit the prompt using printf %b which interprets \e escapes,
# and use bash's built-in prompt expansion via PS1
_show_prompt() {
    # Use bash's builtin to expand PS1 properly
    local expanded
    expanded="${PS1@P}"
    printf '%s' "$expanded"
}

_show_prompt
echo "ls -la src/"
echo "drwxr-xr-x  3 user user  4096 Mar  3 10:22 components/"
echo "drwxr-xr-x  2 user user  4096 Mar  3 09:15 utils/"
echo "-rw-r--r--  1 user user  2847 Mar  3 10:22 main.ts"
echo "-rw-r--r--  1 user user   493 Mar  2 14:30 index.ts"
echo ""
_show_prompt
echo "git log --oneline -5"
echo "a3f82c1 feat: add theme randomizer"
echo "e7b19d4 fix: correct palette ordering"
echo "1c4a5e9 refactor: extract color config"
echo "b28f3d7 docs: update README"
echo "f91c2a8 init: project setup"
echo ""
_show_prompt
echo ""

sleep 999
