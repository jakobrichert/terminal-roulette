#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════════════════
# Terminal Roulette - Random terminal theme on every new shell
# https://github.com/jakobrichert/terminal-roulette
# ═══════════════════════════════════════════════════════════════════

THEMESHIFT_DIR="${THEMESHIFT_DIR:-$HOME/.config/starship-themes}"

# Load terminal color definitions (background, foreground, cursor, palette, font, transparency)
if [[ -f "$THEMESHIFT_DIR/terminal-colors.sh" ]]; then
    source "$THEMESHIFT_DIR/terminal-colors.sh"
fi

# Pick a random theme if no theme is currently set for this session
if [[ -z "$STARSHIP_THEME_NAME" ]]; then
    _themes=("$THEMESHIFT_DIR"/*.toml)
    if [[ ${#_themes[@]} -gt 0 ]]; then
        _pick="${_themes[$((RANDOM % ${#_themes[@]}))]}"
        export STARSHIP_CONFIG="$_pick"
        export STARSHIP_THEME_NAME="$(basename "$_pick" .toml)"
    fi
    unset _themes _pick
fi

# Apply terminal colors for the selected theme
if command -v _apply_terminal_theme &>/dev/null; then
    _apply_terminal_theme
fi

# Initialize Starship prompt
if command -v starship &>/dev/null; then
    eval "$(starship init bash)"
elif [[ -x "$HOME/.local/bin/starship" ]]; then
    eval "$("$HOME/.local/bin/starship" init bash)"
fi

# ─── Theme switcher ──────────────────────────────────────────────
# Usage:
#   theme            - list all available themes
#   theme <name>     - switch to a specific theme
#   theme random     - pick a new random theme
#   theme preview    - cycle through all themes with a preview

theme() {
    local themes_dir="$THEMESHIFT_DIR"

    if [[ $# -eq 0 ]]; then
        echo ""
        echo "  Available themes:"
        echo ""
        local col=0
        for f in "$themes_dir"/*.toml; do
            local name="$(basename "$f" .toml)"
            if [[ "$name" == "$STARSHIP_THEME_NAME" ]]; then
                printf "    \033[1;32m● %-20s\033[0m" "$name"
            else
                printf "      %-20s" "$name"
            fi
            col=$((col + 1))
            if [[ $((col % 3)) -eq 0 ]]; then echo ""; fi
        done
        [[ $((col % 3)) -ne 0 ]] && echo ""
        echo ""
        echo "  Usage: theme <name> | theme random | theme preview"
        echo ""
        return
    fi

    if [[ "$1" == "random" ]]; then
        local _themes=("$themes_dir"/*.toml)
        local _pick="${_themes[$((RANDOM % ${#_themes[@]}))]}"
        export STARSHIP_CONFIG="$_pick"
        export STARSHIP_THEME_NAME="$(basename "$_pick" .toml)"
        _apply_terminal_theme 2>/dev/null
        echo "Switched to: $STARSHIP_THEME_NAME"
        eval "$(starship init bash 2>/dev/null || "$HOME/.local/bin/starship" init bash 2>/dev/null)"
        return
    fi

    if [[ "$1" == "preview" ]]; then
        echo ""
        echo "  Previewing all themes (press Ctrl+C to stop)..."
        echo ""
        for f in "$themes_dir"/*.toml; do
            local name="$(basename "$f" .toml)"
            export STARSHIP_CONFIG="$f"
            export STARSHIP_THEME_NAME="$name"
            _apply_terminal_theme 2>/dev/null
            eval "$(starship init bash 2>/dev/null || "$HOME/.local/bin/starship" init bash 2>/dev/null)"
            echo -e "  \033[1m$name\033[0m"
            echo "  The quick brown fox jumps over the lazy dog."
            echo "  ~/projects/myapp (main) $ git status"
            echo ""
            sleep 2
        done
        return
    fi

    if [[ -f "$themes_dir/$1.toml" ]]; then
        export STARSHIP_CONFIG="$themes_dir/$1.toml"
        export STARSHIP_THEME_NAME="$1"
        _apply_terminal_theme 2>/dev/null
        echo "Switched to: $STARSHIP_THEME_NAME"
        eval "$(starship init bash 2>/dev/null || "$HOME/.local/bin/starship" init bash 2>/dev/null)"
    else
        echo "Theme '$1' not found. Run 'theme' to see available themes."
    fi
}

# ─── Greeting ────────────────────────────────────────────────────

_terminal_greeting() {
    local -a greetings=(
        "Ready to build something great."
        "Let's get to work."
        "New shell, new possibilities."
        "Happy coding."
        "Welcome back."
        "Time to ship some code."
        "Another day, another commit."
        "Make it happen."
        "Stay curious."
        "Build. Break. Learn. Repeat."
    )
    local greeting="${greetings[$((RANDOM % ${#greetings[@]}))]}"

    # Theme color accents (true-color RGB)
    local color="\033[1;36m" # default cyan
    case "$STARSHIP_THEME_NAME" in
        tokyo-night) color="\033[38;2;122;162;247m" ;;
        cyberpunk)   color="\033[38;2;255;0;255m" ;;
        nord)        color="\033[38;2;136;192;208m" ;;
        dracula)     color="\033[38;2;189;147;249m" ;;
        gruvbox)     color="\033[38;2;254;128;25m" ;;
        catppuccin)  color="\033[38;2;203;166;247m" ;;
        solarized)   color="\033[38;2;38;139;210m" ;;
        synthwave)   color="\033[38;2;255;126;219m" ;;
        ocean)       color="\033[38;2;100;210;255m" ;;
        rose-pine)   color="\033[38;2;196;167;231m" ;;
        monokai)     color="\033[38;2;166;226;46m" ;;
        one-dark)    color="\033[38;2;198;120;221m" ;;
        material)    color="\033[38;2;130;170;255m" ;;
        kanagawa)    color="\033[38;2;126;156;216m" ;;
        everforest)  color="\033[38;2;167;192;128m" ;;
        ayu-dark)    color="\033[38;2;230;180;80m" ;;
        palenight)   color="\033[38;2;199;146;234m" ;;
        horizon)     color="\033[38;2;233;86;120m" ;;
        moonlight)   color="\033[38;2;192;153;255m" ;;
        iceberg)     color="\033[38;2;132;160;198m" ;;
        sonokai)     color="\033[38;2;118;204;224m" ;;
        github-dark) color="\033[38;2;88;166;255m" ;;
        nightowl)    color="\033[38;2;130;170;255m" ;;
        fairy-floss) color="\033[38;2;255;184;209m" ;;
        aurora)      color="\033[38;2;143;188;187m" ;;
        ember)       color="\033[38;2;255;109;58m" ;;
        midnight)    color="\033[38;2;83;154;252m" ;;
        matrix)      color="\033[38;2;0;255;65m" ;;
        retrowave)   color="\033[38;2;255;110;199m" ;;
        forest)      color="\033[38;2;143;190;110m" ;;
        poimandres)  color="\033[38;2;93;228;199m" ;;
        vesper)      color="\033[38;2;255;199;153m" ;;
        oxocarbon)   color="\033[38;2;120;169;255m" ;;
        laserwave)   color="\033[38;2;255;82;191m" ;;
        cobalt)      color="\033[38;2;0;170;255m" ;;
        paper)       color="\033[38;2;58;148;197m" ;;
        snow)        color="\033[38;2;94;129;172m" ;;
        latte)       color="\033[38;2;136;57;239m" ;;
        github-light) color="\033[38;2;9;105;218m" ;;
        ivory)       color="\033[38;2;139;105;20m" ;;
        noctis)      color="\033[38;2;73;233;166m" ;;
        andromeda)   color="\033[38;2;0;232;198m" ;;
        shades-of-purple) color="\033[38;2;165;153;233m" ;;
        copper)      color="\033[38;2;224;138;83m" ;;
        vitesse)     color="\033[38;2;77;147;117m" ;;
    esac

    local reset="\033[0m"
    local dim="\033[2m"
    echo ""
    echo -e "  ${color}${greeting}${reset}"
    echo -e "  ${dim}theme: ${STARSHIP_THEME_NAME}${reset}"
    echo ""
}
_terminal_greeting
