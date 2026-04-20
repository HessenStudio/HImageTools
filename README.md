# 🖼️ HImageTools

> A modular **Zsh** toolkit for batch image processing and artistic filters, powered by **ImageMagick 7** and optional **rembg**. Outputs go to `./processed/` by default.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![ImageMagick](https://img.shields.io/badge/ImageMagick-7.x-blue.svg)](https://imagemagick.org/)
[![Shell](https://img.shields.io/badge/Shell-Zsh-orange.svg)](https://www.zsh.org/)

**English** | [繁體中文](README.zh-tw.md)

---

## ✨ Highlights

- **Parallel batches** with concurrency tuned from installed RAM (overridable via environment variables).
- **Resource guardrails**: Magick thread/memory limits, low priority (`nice`), and a watchdog that tries to stop jobs when free RAM is critically low.
- **Consistent CLI**: all art filters use `img-artify <style>[:substyle]`; omitting `:substyle` uses each module’s documented **[default]**.
- **Optional AI cutout**: `img-ai-rembg` runs local `rembg` (one image at a time, sequentially).

---

## 🚀 Quick start

### Requirements

- **ImageMagick 7+**
  ```bash
  brew install imagemagick
  ```
- **rembg** (only for AI cutout)
  ```bash
  pip install rembg
  ```

### Load the toolkit

```bash
git clone https://github.com/<you>/HImageTools.git
cd HImageTools
source ./loader.sh
```

Add `source /path/to/HImageTools/loader.sh` to `~/.zshrc` if you want it permanently.

### Command conventions

| Kind | Form | Notes |
|------|------|--------|
| Utilities | `img-<action> [args…]` | Operates on images in the current directory (see extensions below). |
| Art filters | `img-artify <style>[:substyle]` | Substyle optional; **[default]** applies when omitted. |
| Built-in help | `img-artify` with no args | Prints the full style list in the terminal. |

**Input extensions (case-insensitive):** `jpg`, `jpeg`, `png`, `webp`, `tiff`.

---

## 📋 Cheat sheet

| Goal | Full command |
|------|----------------|
| Anime / manga look | `img-artify cartoon:anime` |
| Classical oil (default) | `img-artify oil` or `img-artify oil:classical` |
| Older “standard oil” look | `img-artify oil:standard` |
| Warhol-style grid | `img-artify popart:warhol` |
| Wood + gold relief | `img-artify etching:nanmu` |
| Full-style gallery | `img-artify-all` |
| Style self-test | `img-artify-test` |
| AI background removal | `img-ai-rembg` |
| Lossless WebP | `img-lossless webp` |

---

## 🚀 Core Advanced Features

### 1. One-Click Artify All-in-One
Our most powerful feature. Automatically applies **100+ artistic styles** to all images in a directory and generates a professional interactive gallery.
- **Command**: `img-artify-all [directory]` (defaults to `./`)
- **Output**: Creates an `artify_gallery/` folder with subdirectories for each source image.
- **Gallery**: Master-Detail sidebar navigation, grid layout, lightbox, and resume support.
![Gallery screenshot](./assets/previews/previews.webp)

### 2. Style Self-Test
Designed for environment verification or development debugging. Runs all filters on the built-in system logo.
- **Command**: `img-artify-test`
- **Output**: Generates a `style_test_report/` folder with a PASS/FAIL report.
- **Benefit**: Quickly identify which filters are working correctly in your current setup.

---

---

## 🛠️ Batch utilities

All write under `./processed/` (created if missing).

| Command | Description | Full command |
|---------|-------------|--------------|
| `img-resize [width]` | Resize by width, keep aspect | `img-resize 1920` |
| `img-to-png` | Convert to PNG | `img-to-png` |
| `img-to-jpg` | Convert to JPG | `img-to-jpg` |
| `img-to-webp` | WebP (~quality 80) | `img-to-webp` |
| `img-lossless [png\|webp]` | Lossless compression | `img-lossless webp` |
| `img-crop <geometry>` | Crop by geometry | `img-crop 1080x1080+0+0` |
| `img-rotate [angle]` | Rotate clockwise | `img-rotate 90` |
| `img-optimize [quality]` | Optimize JPG quality/size | `img-optimize 75` |
| `img-to-gif [delay] [name]` | Build GIF from images | `img-to-gif 20 my_anim` |
| `img-rembg [color] [fuzz]` | Chroma-style removal | `img-rembg white 10%` |
| `img-ai-rembg` | AI cutout (needs `rembg`) | `img-ai-rembg` |

---

## 🎨 `img-artify` reference

**[default]** = substyle used when you pass only the main style (e.g. `img-artify oil`). **Aliases** can replace the substyle keyword. **Full command** cells are copy-paste ready (after `source loader.sh`, from a directory that contains images).

### 1. Cartoon & illustration

**Comics & Outlines — `cartoon`**

| Substyle | Aliases | Full command | Notes |
|----------|---------|--------------|--------|
| **anime** [default] | manga, jp | `img-artify cartoon` or `img-artify cartoon:anime` | Japanese manga / screen tone |
| comic | us, hero | `img-artify cartoon:comic` | US superhero ink |
| clear | eu, ligne | `img-artify cartoon:clear` | European ligne claire |
| serial | cn, ink | `img-artify cartoon:serial` | Serial / ink-wash board |
| illust | graphic | `img-artify cartoon:illust` | Commercial simplified illustration |
| noir | bw | `img-artify cartoon:noir` | Hard black & white |
| sketch | draft | `img-artify cartoon:sketch` | Draft / pencil feel |
| outline | line | `img-artify cartoon:outline` | Line art only |

**Hand-Painted — `handpaint`** (Ink outlines with color fills)

| Substyle | Full command | Notes |
|----------|--------------|--------|
| **standard** [default] | `img-artify handpaint` | Balanced outlines and colors |
| vibrant | `img-artify handpaint:vibrant` | Saturated, high contrast |
| soft | `img-artify handpaint:soft` | Gray ink, muted tones |
| heavy | `img-artify handpaint:heavy` | Bold ink, rich texture |

**Marker Illustration — `marker`** (Simulated 56-color markers)

| Substyle | Example Command | Notes |
|----------|-----------------|--------|
| **palette** | `img-artify marker:palette` | Generate a 56-color palette preview |
| <color_name> | `img-artify marker:red` | Render with specific ink (supports 56 colors including red, blue, green, etc.) |

---

### 2. Classic painting

**Oil — `oil`**

| Substyle | Aliases | Full command | Notes |
|----------|---------|--------------|--------|
| **classical** [default] | realism | `img-artify oil` or `img-artify oil:classical` | Classical realism |
| impressionist | impressionism | `img-artify oil:impressionist` | Impressionist strokes |
| expressionist | expressionism | `img-artify oil:expressionist` | Expressionist color |
| abstract | — | `img-artify oil:abstract` | Abstract blocks |
| impasto | thick | `img-artify oil:impasto` | Thick paint |
| renaissance | master | `img-artify oil:renaissance` | Old-master mood |
| standard | — | `img-artify oil:standard` | Softer generic oil (previous default) |

**Watercolor — `watercolor` / `illust`**

| Engine | Substyle | Full command | Notes |
|--------|----------|--------------|--------|
| **Series A (Modern)** | **standard** [default] | `img-artify illust` | Balanced bloom and ink-stains |
| | soft | `img-artify illust:soft` | High bloom, low saturation |
| | detailed | `img-artify illust:detailed` | Enhanced stain details |
| **Series B (Classic)** | **standard** [default] | `img-artify watercolor` | Traditional watercolor feel |
| | wet | `img-artify watercolor:wet` | Wet-on-wet, strong bleeding |
| | sketch | `img-artify watercolor:sketch` | Pencil under-drawing feel |
| | soft | `img-artify watercolor:soft` | Soft diffusion feel |

**Sketch — `sketch`** (no substyle = standard)

| Substyle | Full command | Notes |
|----------|--------------|--------|
| **standard** [default] | `img-artify sketch` | Standard sketch |
| fine | `img-artify sketch:fine` | Finer detail |
| heavy | `img-artify sketch:heavy` | Bolder strokes |

**Charcoal — `charcoal`** (no substyle = standard)

| Substyle | Full command | Notes |
|----------|--------------|--------|
| **standard** [default] | `img-artify charcoal` | Standard charcoal |
| heavy | `img-artify charcoal:heavy` | Stronger, rougher |
| grain | `img-artify charcoal:grain` | Extra grain |

**Vintage watercolor + torn edge — `vin-wc`** (no substyle = default mix)

| Substyle | Full command | Notes |
|----------|--------------|--------|
| **default** [default] | `img-artify vin-wc` | Default torn-edge look |
| decay | `img-artify vin-wc:decay` | Faded, damaged |
| heavy | `img-artify vin-wc:heavy` | Saturated, strong edge |
| vibrant | `img-artify vin-wc:vibrant` | Clean, vivid |
| antique | `img-artify vin-wc:antique` | Yellowed paper, heavy wear |

---

### 3. Retro & film

**Vintage — `vintage`**

| Substyle | Full command | Notes |
|----------|--------------|--------|
| **standard** [default] | `img-artify vintage` or `img-artify vintage:standard` | Fade, grain, scratches, fiber texture |
| film | `img-artify vintage:film` | Stronger “processed film” color & contrast |
| grain | `img-artify vintage:grain` | Heavier grain / scratches |

**Sepia — `sepia`** (no substyle = standard sepia)

| Substyle | Full command | Notes |
|----------|--------------|--------|
| **standard** [default] | `img-artify sepia` | Standard sepia |
| light | `img-artify sepia:light` | Lighter |
| heavy | `img-artify sepia:heavy` | Deeper, punchier |
| vintage | `img-artify sepia:vintage` | Vintage photo |
| faded | `img-artify sepia:faded` | Faded look |

**Single-style presets (no substyle)**

| Style | Full command | Notes |
|-------|--------------|--------|
| antique | `img-artify antique` | Aged photo + noise overlay |
| aged-photo | `img-artify aged-photo` | Old photo + paper soft-light |
| lomo | `img-artify lomo` | Lomo-style vignette & contrast |

**Night — `night`** (no substyle = generic night darkening)

| Substyle | Full command | Notes |
|----------|--------------|--------|
| **standard** [default] | `img-artify night` | Generic night darkening |
| dark | `img-artify night:dark` | Darker |
| city | `img-artify night:city` | City night |
| cyber | `img-artify night:cyber` | Cyberpunk cool |
| blue | `img-artify night:blue` | Blue night |

**Single-effect styles (no substyle)**

| Style | Full command | Notes |
|-------|--------------|--------|
| neon | `img-artify neon` | Saturated neon look |
| twilight | `img-artify twilight` | Twilight / moody tones |

---

### 4. Modern & pop art

**Pop art — `popart`**

| Substyle | Aliases | Full command | Notes |
|----------|---------|--------------|--------|
| **lichtenstein** [default] | dots, classic | `img-artify popart` or `img-artify popart:lichtenstein` | Ben-Day dots + outlines |
| warhol | screen, repeat | `img-artify popart:warhol` | 2×2 color panels |
| minimal | flat, simple | `img-artify popart:minimal` | Big flat shapes |
| contour | outline, wire | `img-artify popart:contour` | Contour / wire look |
| retro | advert, 50s | `img-artify popart:retro` | 1950s ad cream tones |
| colorfield | field | `img-artify popart:colorfield` | Color-field blocks |
| collage | cutout, craft | `img-artify popart:collage` | Paper collage |
| neon | bright, glow | `img-artify popart:neon` | Neon pop |
| vintage | 60s | `img-artify popart:vintage` | 1960s grain |
| striped | pattern | `img-artify popart:striped` | Striped overlay |
| comic | halftone | `img-artify popart:comic` | Comic halftone |

**Abstract (top-level) — `abstract`**

| Substyle | Full command | Notes |
|----------|--------------|--------|
| **default** [default] | `img-artify abstract` | Unknown substyles fall back to the pop-art dot pipeline |
| geometric | `img-artify abstract:geometric` | Pixel-scale blocks |
| fluid | `img-artify abstract:fluid` | Liquify-style warp |

**Pixelate — `pixelate`**

| Substyle | Full command | Notes |
|----------|--------------|--------|
| **8bit** [default] | `img-artify pixelate` or `img-artify pixelate:8bit` | Chunky pixels |
| 16bit | `img-artify pixelate:16bit` | Finer pixels |
| chunky | `img-artify pixelate:chunky` | Medium blocks |
| fine | `img-artify pixelate:fine` | Finer blocks |

**Mosaic — `mosaic`**

| Substyle | Full command | Notes |
|----------|--------------|--------|
| **default** [default] | `img-artify mosaic` | Medium tiles |
| fine | `img-artify mosaic:fine` | Smaller tiles |
| coarse | `img-artify mosaic:coarse` | Larger tiles |

**Duotone — `duotone`**

| Substyle | Full command | Notes |
|----------|--------------|--------|
| **warm** [default] | `img-artify duotone` or `img-artify duotone:warm` | Warm pair |
| cool | `img-artify duotone:cool` | Cool pair |
| neon | `img-artify duotone:neon` | Neon pair |
| sepia2 | `img-artify duotone:sepia2` | Sepia duo |
| ocean | `img-artify duotone:ocean` | Ocean blues |
| forest | `img-artify duotone:forest` | Forest greens |
| royal | `img-artify duotone:royal` | Purple & gold |

**Tritone — `tritone`**

| Substyle | Full command | Notes |
|----------|--------------|--------|
| (none) | `img-artify tritone` | Three-tone separation |

---

### 5. Etching & materials — `etching`

| Substyle | Aliases | Full command | Notes |
|----------|---------|--------------|--------|
| **paper** [default] | — | `img-artify etching` or `img-artify etching:paper` | Paper etching, light ground |
| stone | — | `img-artify etching:stone` | Stone relief |
| nanmu | wood | `img-artify etching:nanmu` | Dark wood + gold highlights |
| slate | dark | `img-artify etching:slate` | Slate gray plate |

---

### 6. Special effects

| Style | Substyle | Full command | Notes |
|-------|----------|--------------|--------|
| **vignette** | **soft** [default] | `img-artify vignette:soft` | Standard soft vignette |
| | heavy / light | `img-artify vignette:heavy` | Strong / Subtle darkening |
| | retro-white | `img-artify vignette:retro-white` | White-soft edges |
| | retro-sepia | `img-artify vignette:retro-sepia` | Vintage brown-tinted vignette |
| | retro-blue | `img-artify vignette:retro-blue` | Dark blue night-tinted vignette |
| **swirl** | **strong** [default] | `img-artify swirl:strong` | Strong center-swirl twist |
| | soft / subtle | `img-artify swirl:soft` | Gentle / Minor twist |
| | reverse | `img-artify swirl:reverse` | Anti-clockwise twirl |
| **solarize** | **standard** [default] | `img-artify solarize` | Standard 50% solarization |
| | light / heavy | `img-artify solarize:light` | 30% / 70% intensity |
| **chromatic** | **standard** [default] | `img-artify chromatic` | Standard RGB shift (3px) |
| | extreme / subtle | `img-artify chromatic:extreme` | Heavy (6px) / Fine (1px) shift |
| **monochrome**| **standard** [default] | `img-artify monochrome` | Basic black & white screen-tone |
| | high / soft | `img-artify monochrome:high` | High contrast / Softened halftone |
| **emboss** | **fine** [default] | `img-artify emboss:fine` | Subtle 3D relief |
| | heavy | `img-artify emboss:heavy` | Strong sculptural relief |
| **posterize** | **standard** [default] | `img-artify posterize` | 4-level color separation |
| | minimal / extreme | `img-artify posterize:minimal` | 8-level (fine) / 2-level (extreme) |
| **edge** | **fine** [default] | `img-artify edge:fine` | Fine edge extraction |
| | heavy | `img-artify edge:heavy` | Bold edge extraction |
| **invert** | — | `img-artify invert` | Negative / Invert colors |

---

## 🖥️ Terminal Menu Navigation System

A powerful interactive TUI navigation engine is built-in, allowing users to browse and apply 100+ styles without memorizing commands.

- **Navigation Engine (`interactive_menu.zsh`)**: Supports full keyboard navigation (↑/↓ to scroll, Enter to select, ESC to go back) with hierarchical breadcrumbs.
- **Menu Manifest (`menu_manifest.zsh`)**: A structured data list managing nodes, icons, descriptions, and their underlying CLI command mappings.
- **Quick Launch**: Simply type `img-menu` or run `img-artify` without arguments to enter the menu.

---

## ⚙️ Environment

Notable variables (you may override before sourcing):

- Magick limits: `MAGICK_THREAD_LIMIT`, `MAGICK_MEMORY_LIMIT`, `MAGICK_MAP_LIMIT`, `MAGICK_AREA_LIMIT`
- `IMAGE_SAFE_RAM_LIMIT` — abort threshold based on free-RAM percentage (default ~3%).
- `IMAGE_MAX_JOBS` — manual concurrency; if unset, chosen from total RAM (conservative on ≤8 GB).

---

## 📁 Layout

```
HImageTools/
  loader.sh
  config.zsh
  basic.zsh
  rembg.zsh
  styles/*.zsh
```

The on-disk help from `img-artify` (no args) should match this file; if anything diverges, treat `styles/artify_main.zsh` as the source of truth for the embedded list.

---

## 📜 License

[MIT License](LICENSE)

Copyright © 2026 HImageTools contributors

---

## ❤️ Credits

- [ImageMagick](https://imagemagick.org/)
- [rembg](https://github.com/danielgatis/rembg)
- [Google Gemini CLI](https://github.com/google/gemini-cli) - Assistance with architecture optimization and style evolution.
