# Terminal Roulette

A random terminal theme on every new shell. 45 hand-crafted themes that change **everything** - background, text color, cursor, 16-color palette, font, transparency, and prompt - not just your PS1.

Every time you open a terminal, you get a completely different look. Switch manually with `theme <name>`, or let fate decide.

![tokyo-night](screenshots/tokyo-night.png)

## What it changes

Most terminal "themes" only touch your prompt colors. Terminal Roulette changes the full stack:

- **Background color** - the entire terminal window
- **Foreground color** - all text you type and see
- **Cursor color** - your blinking cursor
- **16-color palette** - affects `ls`, `git diff`, syntax highlighting, everything
- **Font** - switches between fonts per theme (FiraCode Nerd Font, Hack, etc.)
- **Transparency** - per-theme transparency levels (0-18%)
- **Starship prompt** - unique prompt layout, symbols, and colors per theme

Each terminal window gets its own independent colors via OSC escape sequences.

## Themes

### Dark

| | | |
|---|---|---|
| ![tokyo-night](screenshots/tokyo-night.png) **tokyo-night** | ![cyberpunk](screenshots/cyberpunk.png) **cyberpunk** | ![dracula](screenshots/dracula.png) **dracula** |
| ![nord](screenshots/nord.png) **nord** | ![gruvbox](screenshots/gruvbox.png) **gruvbox** | ![catppuccin](screenshots/catppuccin.png) **catppuccin** |
| ![monokai](screenshots/monokai.png) **monokai** | ![one-dark](screenshots/one-dark.png) **one-dark** | ![material](screenshots/material.png) **material** |
| ![kanagawa](screenshots/kanagawa.png) **kanagawa** | ![everforest](screenshots/everforest.png) **everforest** | ![rose-pine](screenshots/rose-pine.png) **rose-pine** |
| ![solarized](screenshots/solarized.png) **solarized** | ![synthwave](screenshots/synthwave.png) **synthwave** | ![ocean](screenshots/ocean.png) **ocean** |
| ![horizon](screenshots/horizon.png) **horizon** | ![moonlight](screenshots/moonlight.png) **moonlight** | ![nightowl](screenshots/nightowl.png) **nightowl** |
| ![cobalt](screenshots/cobalt.png) **cobalt** | ![andromeda](screenshots/andromeda.png) **andromeda** | ![shades-of-purple](screenshots/shades-of-purple.png) **shades-of-purple** |

### Neon / Retro

| | | |
|---|---|---|
| ![matrix](screenshots/matrix.png) **matrix** | ![retrowave](screenshots/retrowave.png) **retrowave** | ![laserwave](screenshots/laserwave.png) **laserwave** |
| ![aurora](screenshots/aurora.png) **aurora** | ![fairy-floss](screenshots/fairy-floss.png) **fairy-floss** | ![midnight](screenshots/midnight.png) **midnight** |

### Minimal / Warm

| | | |
|---|---|---|
| ![ayu-dark](screenshots/ayu-dark.png) **ayu-dark** | ![palenight](screenshots/palenight.png) **palenight** | ![iceberg](screenshots/iceberg.png) **iceberg** |
| ![sonokai](screenshots/sonokai.png) **sonokai** | ![github-dark](screenshots/github-dark.png) **github-dark** | ![poimandres](screenshots/poimandres.png) **poimandres** |
| ![vesper](screenshots/vesper.png) **vesper** | ![oxocarbon](screenshots/oxocarbon.png) **oxocarbon** | ![vitesse](screenshots/vitesse.png) **vitesse** |
| ![ember](screenshots/ember.png) **ember** | ![copper](screenshots/copper.png) **copper** | ![forest](screenshots/forest.png) **forest** |
| ![noctis](screenshots/noctis.png) **noctis** | | |

### Light

| | | |
|---|---|---|
| ![paper](screenshots/paper.png) **paper** | ![snow](screenshots/snow.png) **snow** | ![latte](screenshots/latte.png) **latte** |
| ![github-light](screenshots/github-light.png) **github-light** | ![ivory](screenshots/ivory.png) **ivory** | |

## Install

```bash
git clone https://github.com/jakobrichert/terminal-roulette.git
cd terminal-roulette
bash install.sh
```

Then open a new terminal.

### Requirements

- **Bash** (4.0+)
- **[Starship](https://starship.rs)** prompt (installed automatically if missing)
- **GNOME Terminal** or any terminal supporting OSC color sequences
- A **[Nerd Font](https://www.nerdfonts.com)** (recommended: FiraCode Nerd Font or Hack)

## Usage

```bash
theme                  # list all 45 themes
theme <name>           # switch to a specific theme
theme random           # pick a new random theme
theme preview          # cycle through all themes (2s each)
terminal-roulette-ui   # open the web theme manager
```

Every new terminal window automatically picks a random theme.

## Theme Manager UI

A web-based theme manager for creating, editing, and managing themes visually.

```bash
terminal-roulette-ui
```

![theme-manager-ui](screenshots/theme-manager-ui.png)

This opens a local web UI at `http://localhost:8378` with:

- **Theme browser** — grid view of all themes with live color previews
- **Theme creator** — visual editor with color pickers for background, foreground, cursor, 16-color palette, font, and transparency, plus a live terminal preview
- **Favorites** — star themes to build a favorites list; optionally restrict random rotation to favorites only
- **Lock theme** — force a specific theme on every new terminal (no more random)

## How it works

1. On shell startup, a random `.toml` theme is selected from `~/.config/starship-themes/`
2. **OSC escape sequences** set background, foreground, cursor, and palette colors (per-window, so each terminal is independent)
3. **dconf** updates the GNOME Terminal profile for font and transparency
4. **Starship** renders the prompt with the theme's colors, symbols, and layout

Each theme has two parts:
- A **Starship `.toml`** file defining the prompt appearance (colors, symbols, layout)
- A **terminal color entry** in `terminal-colors.sh` defining the terminal itself (background, foreground, cursor, palette, font, transparency)

## Customization

### Edit a theme

Theme files live in `~/.config/starship-themes/`. Each `.toml` file controls the Starship prompt, and `terminal-colors.sh` controls the terminal colors.

### Add a new theme

1. Create `~/.config/starship-themes/mytheme.toml` (copy an existing one as a starting point)
2. Add a `mytheme)` entry to `terminal-colors.sh` with your background, foreground, cursor, font, transparency, and palette colors
3. It's automatically available via `theme mytheme`

### Disable random on startup

Use the theme manager UI to lock a theme, or add this to your `~/.bashrc` before the themeshift source line:

```bash
export STARSHIP_THEME_NAME="tokyo-night"
```

## Uninstall

```bash
cd terminal-roulette
bash uninstall.sh
```

## License

MIT
