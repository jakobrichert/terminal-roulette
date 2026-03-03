# ═══════════════════════════════════════════════════════════════════
# Terminal color definitions for each Starship theme
# Colors applied via OSC sequences (per-window)
# Font + transparency via dconf (gnome-terminal)
# ═══════════════════════════════════════════════════════════════════

_apply_terminal_theme() {
    local theme="${1:-$STARSHIP_THEME_NAME}"

    local bg fg cursor font
    local transparency=0  # 0 = opaque, up to 25
    local -a palette

    case "$theme" in

        # ── Dark themes ──────────────────────────────────────────

        tokyo-night)
            bg='#1A1B26' fg='#C0CAF5' cursor='#C0CAF5'
            font='FiraCode Nerd Font Mono 11'
            transparency=8
            palette=(
                '#15161E' '#F7768E' '#9ECE6A' '#E0AF68'
                '#7AA2F7' '#BB9AF7' '#7DCFFF' '#A9B1D6'
                '#414868' '#F7768E' '#9ECE6A' '#E0AF68'
                '#7AA2F7' '#BB9AF7' '#7DCFFF' '#C0CAF5'
            )
            ;;
        cyberpunk)
            bg='#0D0221' fg='#E0E0FF' cursor='#00FFFF'
            font='Hack 11'
            transparency=12
            palette=(
                '#0D0221' '#FF0040' '#00FF88' '#FFE600'
                '#00CCFF' '#FF00FF' '#00FFFF' '#E0E0FF'
                '#1A1040' '#FF3366' '#39FF9F' '#FFE94A'
                '#33D6FF' '#FF33FF' '#33FFFF' '#FFFFFF'
            )
            ;;
        nord)
            bg='#2E3440' fg='#D8DEE9' cursor='#88C0D0'
            font='FiraCode Nerd Font Mono 11'
            transparency=5
            palette=(
                '#3B4252' '#BF616A' '#A3BE8C' '#EBCB8B'
                '#81A1C1' '#B48EAD' '#88C0D0' '#E5E9F0'
                '#4C566A' '#BF616A' '#A3BE8C' '#EBCB8B'
                '#81A1C1' '#B48EAD' '#8FBCBB' '#ECEFF4'
            )
            ;;
        dracula)
            bg='#282A36' fg='#F8F8F2' cursor='#F8F8F2'
            font='FiraCode Nerd Font Mono 11'
            transparency=7
            palette=(
                '#21222C' '#FF5555' '#50FA7B' '#F1FA8C'
                '#BD93F9' '#FF79C6' '#8BE9FD' '#F8F8F2'
                '#6272A4' '#FF6E6E' '#69FF94' '#FFFFA5'
                '#D6ACFF' '#FF92DF' '#A4FFFF' '#FFFFFF'
            )
            ;;
        gruvbox)
            bg='#282828' fg='#EBDBB2' cursor='#EBDBB2'
            font='Hack 11'
            transparency=0
            palette=(
                '#282828' '#CC241D' '#98971A' '#D79921'
                '#458588' '#B16286' '#689D6A' '#A89984'
                '#928374' '#FB4934' '#B8BB26' '#FABD2F'
                '#83A598' '#D3869B' '#8EC07C' '#EBDBB2'
            )
            ;;
        catppuccin)
            bg='#1E1E2E' fg='#CDD6F4' cursor='#F5E0DC'
            font='FiraCode Nerd Font Mono 11'
            transparency=6
            palette=(
                '#45475A' '#F38BA8' '#A6E3A1' '#F9E2AF'
                '#89B4FA' '#F5C2E7' '#94E2D5' '#BAC2DE'
                '#585B70' '#F38BA8' '#A6E3A1' '#F9E2AF'
                '#89B4FA' '#F5C2E7' '#94E2D5' '#A6ADC8'
            )
            ;;
        solarized)
            bg='#002B36' fg='#839496' cursor='#93A1A1'
            font='FiraCode Nerd Font Mono 11'
            transparency=0
            palette=(
                '#073642' '#DC322F' '#859900' '#B58900'
                '#268BD2' '#D33682' '#2AA198' '#EEE8D5'
                '#002B36' '#CB4B16' '#586E75' '#657B83'
                '#839496' '#6C71C4' '#93A1A1' '#FDF6E3'
            )
            ;;
        synthwave)
            bg='#2B213A' fg='#E0DEF4' cursor='#FF7EDB'
            font='Hack 11'
            transparency=14
            palette=(
                '#1E1633' '#FE4450' '#72F1B8' '#FEDE5D'
                '#36F9F6' '#FF7EDB' '#36F9F6' '#F0E8D6'
                '#403353' '#FE4450' '#72F1B8' '#FEDE5D'
                '#36F9F6' '#FF7EDB' '#36F9F6' '#FFFFFF'
            )
            ;;
        ocean)
            bg='#1B2B34' fg='#D8DEE9' cursor='#6699CC'
            font='FiraCode Nerd Font Mono 11'
            transparency=10
            palette=(
                '#1B2B34' '#EC5F67' '#99C794' '#FAC863'
                '#6699CC' '#C594C5' '#5FB3B3' '#C0C5CE'
                '#65737E' '#EC5F67' '#99C794' '#FAC863'
                '#6699CC' '#C594C5' '#5FB3B3' '#D8DEE9'
            )
            ;;
        rose-pine)
            bg='#191724' fg='#E0DEF4' cursor='#EBBCBA'
            font='FiraCode Nerd Font Mono 11'
            transparency=5
            palette=(
                '#26233A' '#EB6F92' '#31748F' '#F6C177'
                '#9CCFD8' '#C4A7E7' '#EBBCBA' '#E0DEF4'
                '#6E6A86' '#EB6F92' '#31748F' '#F6C177'
                '#9CCFD8' '#C4A7E7' '#EBBCBA' '#E0DEF4'
            )
            ;;
        monokai)
            bg='#272822' fg='#F8F8F2' cursor='#F8F8F0'
            font='FiraCode Nerd Font Mono 11'
            transparency=0
            palette=(
                '#272822' '#F92672' '#A6E22E' '#FD971F'
                '#66D9EF' '#AE81FF' '#A1EFE4' '#F8F8F2'
                '#75715E' '#F92672' '#A6E22E' '#FD971F'
                '#66D9EF' '#AE81FF' '#A1EFE4' '#F9F8F5'
            )
            ;;
        one-dark)
            bg='#282C34' fg='#ABB2BF' cursor='#528BFF'
            font='FiraCode Nerd Font Mono 11'
            transparency=5
            palette=(
                '#282C34' '#E06C75' '#98C379' '#E5C07B'
                '#61AFEF' '#C678DD' '#56B6C2' '#ABB2BF'
                '#5C6370' '#E06C75' '#98C379' '#E5C07B'
                '#61AFEF' '#C678DD' '#56B6C2' '#FFFFFF'
            )
            ;;
        material)
            bg='#263238' fg='#EEFFFF' cursor='#FFCC00'
            font='FiraCode Nerd Font Mono 11'
            transparency=5
            palette=(
                '#263238' '#F07178' '#C3E88D' '#FFCB6B'
                '#82AAFF' '#C792EA' '#89DDFF' '#EEFFFF'
                '#546E7A' '#F07178' '#C3E88D' '#FFCB6B'
                '#82AAFF' '#C792EA' '#89DDFF' '#FFFFFF'
            )
            ;;
        kanagawa)
            bg='#1F1F28' fg='#DCD7BA' cursor='#C8C093'
            font='FiraCode Nerd Font Mono 11'
            transparency=3
            palette=(
                '#16161D' '#C34043' '#76946A' '#DCA561'
                '#7E9CD8' '#957FB8' '#7FB4CA' '#DCD7BA'
                '#727169' '#E82424' '#98BB6C' '#E6C384'
                '#7FB4CA' '#938AA9' '#A3D4D5' '#C8C093'
            )
            ;;
        everforest)
            bg='#2D353B' fg='#D3C6AA' cursor='#A7C080'
            font='FiraCode Nerd Font Mono 11'
            transparency=4
            palette=(
                '#343F44' '#E67E80' '#A7C080' '#DBBC7F'
                '#7FBBB3' '#D699B6' '#83C092' '#D3C6AA'
                '#859289' '#E67E80' '#A7C080' '#DBBC7F'
                '#7FBBB3' '#D699B6' '#83C092' '#D3C6AA'
            )
            ;;
        ayu-dark)
            bg='#0A0E14' fg='#B3B1AD' cursor='#E6B450'
            font='FiraCode Nerd Font Mono 11'
            transparency=3
            palette=(
                '#01060E' '#F07178' '#AAD94C' '#E6B450'
                '#59C2FF' '#D2A6FF' '#95E6CB' '#B3B1AD'
                '#686868' '#F07178' '#AAD94C' '#E6B450'
                '#59C2FF' '#D2A6FF' '#95E6CB' '#FAFAFA'
            )
            ;;
        palenight)
            bg='#292D3E' fg='#A6ACCD' cursor='#FFCB6B'
            font='FiraCode Nerd Font Mono 12'
            transparency=8
            palette=(
                '#292D3E' '#F07178' '#C3E88D' '#FFCB6B'
                '#82AAFF' '#C792EA' '#89DDFF' '#A6ACCD'
                '#676E95' '#F07178' '#C3E88D' '#FFCB6B'
                '#82AAFF' '#C792EA' '#89DDFF' '#FFFFFF'
            )
            ;;
        horizon)
            bg='#1C1E26' fg='#D5D8DA' cursor='#E95678'
            font='FiraCode Nerd Font Mono 11'
            transparency=6
            palette=(
                '#1C1E26' '#E95678' '#29D398' '#FAB795'
                '#26BBD9' '#EE64AC' '#59E3E3' '#D5D8DA'
                '#6C6F93' '#E95678' '#29D398' '#FAB795'
                '#26BBD9' '#EE64AC' '#59E3E3' '#FFFFFF'
            )
            ;;
        moonlight)
            bg='#1E2030' fg='#C8D3F5' cursor='#FF966C'
            font='FiraCode Nerd Font Mono 11'
            transparency=7
            palette=(
                '#1E2030' '#FF757F' '#C3E88D' '#FFC777'
                '#82AAFF' '#C099FF' '#86E1FC' '#C8D3F5'
                '#444A73' '#FF757F' '#C3E88D' '#FFC777'
                '#82AAFF' '#C099FF' '#86E1FC' '#D8DEE9'
            )
            ;;
        iceberg)
            bg='#161821' fg='#C6C8D1' cursor='#D2D4DE'
            font='FiraCode Nerd Font Mono 11'
            transparency=0
            palette=(
                '#1E2132' '#E27878' '#B4BE82' '#E2A478'
                '#84A0C6' '#A093C7' '#89B8C2' '#C6C8D1'
                '#6B7089' '#E98989' '#C0CA8E' '#E9B189'
                '#91ACD1' '#ADA0D3' '#95C4CE' '#D2D4DE'
            )
            ;;
        sonokai)
            bg='#2C2E34' fg='#E2E2E3' cursor='#E2E2E3'
            font='FiraCode Nerd Font Mono 11'
            transparency=5
            palette=(
                '#2C2E34' '#FC5D7C' '#9ED072' '#E7C664'
                '#76CCE0' '#B39DF3' '#F39660' '#E2E2E3'
                '#7F8490' '#FC5D7C' '#9ED072' '#E7C664'
                '#76CCE0' '#B39DF3' '#F39660' '#E2E2E3'
            )
            ;;
        github-dark)
            bg='#0D1117' fg='#C9D1D9' cursor='#58A6FF'
            font='FiraCode Nerd Font Mono 11'
            transparency=0
            palette=(
                '#0D1117' '#FF7B72' '#7EE787' '#D29922'
                '#58A6FF' '#BC8CFF' '#39D2E0' '#C9D1D9'
                '#484F58' '#FF7B72' '#7EE787' '#D29922'
                '#58A6FF' '#BC8CFF' '#39D2E0' '#F0F6FC'
            )
            ;;
        nightowl)
            bg='#011627' fg='#D6DEEB' cursor='#80A4C2'
            font='FiraCode Nerd Font Mono 11'
            transparency=8
            palette=(
                '#011627' '#EF5350' '#22DA6E' '#ADDB67'
                '#82AAFF' '#C792EA' '#7FDBCA' '#D6DEEB'
                '#5C7E88' '#EF5350' '#22DA6E' '#ADDB67'
                '#82AAFF' '#C792EA' '#7FDBCA' '#FFFFFF'
            )
            ;;
        fairy-floss)
            bg='#5A5475' fg='#F8F8F2' cursor='#FFB8D1'
            font='Hack 11'
            transparency=10
            palette=(
                '#5A5475' '#FF857F' '#C2FFDF' '#E6C000'
                '#C5A3FF' '#FFB8D1' '#C2FFDF' '#F8F8F2'
                '#796E8A' '#FF857F' '#C2FFDF' '#FFF352'
                '#C5A3FF' '#FFB8D1' '#C2FFDF' '#FFFFFF'
            )
            ;;
        aurora)
            bg='#07090F' fg='#ECEFF4' cursor='#88C0D0'
            font='FiraCode Nerd Font Mono 11'
            transparency=15
            palette=(
                '#07090F' '#BF616A' '#A3BE8C' '#EBCB8B'
                '#5E81AC' '#B48EAD' '#8FBCBB' '#ECEFF4'
                '#4C566A' '#D08770' '#A3BE8C' '#EBCB8B'
                '#81A1C1' '#B48EAD' '#88C0D0' '#ECEFF4'
            )
            ;;
        ember)
            bg='#1A1110' fg='#D4BE98' cursor='#FF6D3A'
            font='Hack 11'
            transparency=0
            palette=(
                '#1A1110' '#CC3E28' '#869A3A' '#D4943A'
                '#4E7DA6' '#B26286' '#7C9081' '#D4BE98'
                '#5B4D4D' '#FF6D3A' '#A3BE5B' '#FFB454'
                '#6E98C3' '#D699B6' '#99C0AB' '#F2E5BC'
            )
            ;;
        midnight)
            bg='#0B0E14' fg='#B8C4D0' cursor='#5CCFE6'
            font='FiraCode Nerd Font Mono 11'
            transparency=5
            palette=(
                '#0B0E14' '#D95468' '#8BD49C' '#EBBF83'
                '#539AFC' '#B877DB' '#5CCFE6' '#B8C4D0'
                '#3D4455' '#D95468' '#8BD49C' '#EBBF83'
                '#539AFC' '#B877DB' '#5CCFE6' '#E6E6E6'
            )
            ;;
        matrix)
            bg='#0A0A0A' fg='#00FF41' cursor='#00FF41'
            font='Hack 11'
            transparency=18
            palette=(
                '#0A0A0A' '#FF0033' '#00FF41' '#FFFC00'
                '#00AAFF' '#FF00FF' '#00FF9C' '#CCCCCC'
                '#333333' '#FF3366' '#33FF66' '#FFFC33'
                '#33BBFF' '#FF33FF' '#33FFBB' '#FFFFFF'
            )
            ;;
        retrowave)
            bg='#1A1A2E' fg='#F4F4F4' cursor='#FF6EC7'
            font='Hack 11'
            transparency=12
            palette=(
                '#1A1A2E' '#FF2E63' '#06FF72' '#FFDF00'
                '#0096FF' '#E0AAFF' '#06D6A0' '#F4F4F4'
                '#3C3C5A' '#FF5C8A' '#08FF86' '#FFE433'
                '#33AAFF' '#E8BBFF' '#33DFB3' '#FFFFFF'
            )
            ;;
        forest)
            bg='#1B2218' fg='#C9D1C9' cursor='#8FBE6E'
            font='FiraCode Nerd Font Mono 11'
            transparency=6
            palette=(
                '#1B2218' '#CC6666' '#8FBE6E' '#D4AA5D'
                '#6B8F71' '#A87DB6' '#5F9EA0' '#C9D1C9'
                '#4A5748' '#CC7777' '#A4D48B' '#E0BC72'
                '#7DA687' '#BB95C7' '#72B3B5' '#DEE5DE'
            )
            ;;
        poimandres)
            bg='#1B1E28' fg='#A6ACCD' cursor='#5DE4C7'
            font='FiraCode Nerd Font Mono 11'
            transparency=7
            palette=(
                '#1B1E28' '#D0679D' '#5DE4C7' '#FFFAC2'
                '#ADD7FF' '#91B4D5' '#89DDFF' '#A6ACCD'
                '#767C9D' '#D0679D' '#5DE4C7' '#FFFAC2'
                '#ADD7FF' '#91B4D5' '#89DDFF' '#E4F0FB'
            )
            ;;
        vesper)
            bg='#101010' fg='#B7B7B7' cursor='#FFC799'
            font='Hack 11'
            transparency=0
            palette=(
                '#101010' '#F5A191' '#90B99F' '#E6B99D'
                '#ACA1CF' '#E29ECA' '#EA83A5' '#B7B7B7'
                '#555555' '#FF8080' '#A8D4B1' '#FFC799'
                '#B9AEDA' '#EBB2D8' '#F199B5' '#DEDEDE'
            )
            ;;
        oxocarbon)
            bg='#161616' fg='#F2F4F8' cursor='#78A9FF'
            font='FiraCode Nerd Font Mono 11'
            transparency=3
            palette=(
                '#161616' '#EE5396' '#42BE65' '#FFE97B'
                '#78A9FF' '#BE95FF' '#08BDBA' '#F2F4F8'
                '#525252' '#EE5396' '#42BE65' '#FFE97B'
                '#78A9FF' '#BE95FF' '#08BDBA' '#FFFFFF'
            )
            ;;
        laserwave)
            bg='#27212E' fg='#ECEFF1' cursor='#FF52BF'
            font='Hack 11'
            transparency=10
            palette=(
                '#27212E' '#F62B5A' '#47E0A0' '#FFE261'
                '#40B4C4' '#FF52BF' '#40B4C4' '#ECEFF1'
                '#7B6995' '#F62B5A' '#47E0A0' '#FFE261'
                '#40B4C4' '#FF52BF' '#B4DEFF' '#FFFFFF'
            )
            ;;
        cobalt)
            bg='#132738' fg='#FFFFFF' cursor='#00AAFF'
            font='FiraCode Nerd Font Mono 11'
            transparency=5
            palette=(
                '#132738' '#FF0055' '#3AD900' '#FFC600'
                '#00AAFF' '#CC66FF' '#00CCCC' '#FFFFFF'
                '#0050A4' '#FF3388' '#55FF55' '#FFDD00'
                '#55BBFF' '#DD88FF' '#55DDDD' '#FFFFFF'
            )
            ;;
        noctis)
            bg='#0C1B21' fg='#B2CACD' cursor='#49E9A6'
            font='FiraCode Nerd Font Mono 11'
            transparency=10
            palette=(
                '#0C1B21' '#E66767' '#16B673' '#D5971A'
                '#7060EB' '#C167D9' '#49E9A6' '#B2CACD'
                '#5B858B' '#E66767' '#49E9A6' '#ECD28B'
                '#8B78E6' '#D8A5E0' '#7EEABB' '#CBE3E7'
            )
            ;;
        andromeda)
            bg='#23262E' fg='#D5CED9' cursor='#EE5D43'
            font='FiraCode Nerd Font Mono 11'
            transparency=8
            palette=(
                '#23262E' '#FC644D' '#00E8C6' '#FFE66D'
                '#7CB7FF' '#C74DED' '#00E8C6' '#D5CED9'
                '#665B77' '#FC644D' '#00E8C6' '#FFE66D'
                '#7CB7FF' '#C74DED' '#46D9FF' '#F7F7F8'
            )
            ;;
        shades-of-purple)
            bg='#1E1E3F' fg='#FAFAFA' cursor='#FAD000'
            font='Hack 12'
            transparency=8
            palette=(
                '#1E1E3F' '#EC3A37' '#80CBC4' '#FAD000'
                '#7796FC' '#A599E9' '#80CBC4' '#FAFAFA'
                '#4D21AF' '#FF5370' '#A5E2D3' '#FFFC7E'
                '#9AADEA' '#C9B4F0' '#A5E2D3' '#FFFFFF'
            )
            ;;
        copper)
            bg='#1C1210' fg='#C8A882' cursor='#E08A53'
            font='Hack 11'
            transparency=0
            palette=(
                '#1C1210' '#C75646' '#8EB33B' '#D0B03C'
                '#4E7DA6' '#B26286' '#72B3B5' '#C8A882'
                '#5B4D3D' '#E09690' '#CDEE69' '#E0C36D'
                '#7EB5D6' '#D19FB5' '#9ACBCF' '#F2E5BC'
            )
            ;;
        vitesse)
            bg='#121212' fg='#DBD7CA' cursor='#4D9375'
            font='FiraCode Nerd Font Mono 11'
            transparency=0
            palette=(
                '#121212' '#CB7676' '#4D9375' '#B8A965'
                '#6394BF' '#A37ACC' '#5EAAB5' '#DBD7CA'
                '#4C4F52' '#CB7676' '#4D9375' '#B8A965'
                '#6394BF' '#A37ACC' '#5EAAB5' '#E8E6DF'
            )
            ;;

        # ── Light themes ─────────────────────────────────────────

        paper)
            bg='#FFFDF5' fg='#3B3228' cursor='#3B3228'
            font='FiraCode Nerd Font Mono 11'
            transparency=0
            palette=(
                '#3B3228' '#E66868' '#8DA101' '#DFA000'
                '#3A94C5' '#A855B1' '#4C9A91' '#D3C6AA'
                '#939F91' '#E66868' '#8DA101' '#DFA000'
                '#3A94C5' '#A855B1' '#4C9A91' '#3B3228'
            )
            ;;
        snow)
            bg='#E8EDF2' fg='#2E3440' cursor='#5E81AC'
            font='FiraCode Nerd Font Mono 11'
            transparency=0
            palette=(
                '#2E3440' '#BF616A' '#5BA37F' '#C08B30'
                '#5E81AC' '#8B639A' '#4C8C8C' '#4C566A'
                '#677389' '#BF616A' '#5BA37F' '#C08B30'
                '#5E81AC' '#8B639A' '#4C8C8C' '#2E3440'
            )
            ;;
        latte)
            bg='#EFF1F5' fg='#4C4F69' cursor='#7287FD'
            font='FiraCode Nerd Font Mono 11'
            transparency=0
            palette=(
                '#5C5F77' '#D20F39' '#40A02B' '#DF8E1D'
                '#1E66F5' '#8839EF' '#209FB5' '#4C4F69'
                '#9CA0B0' '#D20F39' '#40A02B' '#DF8E1D'
                '#1E66F5' '#8839EF' '#209FB5' '#4C4F69'
            )
            ;;
        github-light)
            bg='#FFFFFF' fg='#24292F' cursor='#0969DA'
            font='FiraCode Nerd Font Mono 11'
            transparency=0
            palette=(
                '#24292F' '#CF222E' '#1A7F37' '#953800'
                '#0969DA' '#8250DF' '#1B7C83' '#57606A'
                '#6E7781' '#CF222E' '#1A7F37' '#953800'
                '#0969DA' '#8250DF' '#1B7C83' '#24292F'
            )
            ;;
        ivory)
            bg='#FAEBD7' fg='#3C3226' cursor='#8B6914'
            font='Hack 11'
            transparency=0
            palette=(
                '#3C3226' '#A03030' '#4A6B3C' '#8B6914'
                '#3A5F8A' '#7B5B7B' '#4A7A7A' '#6B5B4E'
                '#9E8E7E' '#A03030' '#4A6B3C' '#8B6914'
                '#3A5F8A' '#7B5B7B' '#4A7A7A' '#3C3226'
            )
            ;;
        *)
            return 1
            ;;
    esac

    # Apply colors via OSC escape sequences (affects only this terminal window)
    printf '\033]11;%s\007' "$bg"       # background
    printf '\033]10;%s\007' "$fg"       # foreground
    printf '\033]12;%s\007' "$cursor"   # cursor

    # Set the 16-color palette (colors 0-15)
    local i
    for i in {0..15}; do
        printf '\033]4;%d;%s\007' "$i" "${palette[$i]}"
    done

    # Apply font + transparency via dconf (gnome-terminal only)
    local profile
    profile="$(dconf read /org/gnome/terminal/legacy/profiles:/default 2>/dev/null | tr -d "'")"
    if [[ -n "$profile" ]]; then
        local dconf_path="/org/gnome/terminal/legacy/profiles:/:${profile}"
        dconf write "${dconf_path}/font" "'${font}'" 2>/dev/null
        dconf write "${dconf_path}/use-system-font" "false" 2>/dev/null
        if [[ "$transparency" -gt 0 ]]; then
            dconf write "${dconf_path}/use-transparent-background" "true" 2>/dev/null
            dconf write "${dconf_path}/background-transparency-percent" "${transparency}" 2>/dev/null
        else
            dconf write "${dconf_path}/use-transparent-background" "false" 2>/dev/null
        fi
    fi
}
