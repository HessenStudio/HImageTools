#!/bin/zsh
# styles/popart.zsh - 專業普普藝術風格模組 (Ultimate Version 修正版)

_img_artify_popart() {
    local f=$1 output=$2 style=$3
    local sub_style=${style#*:}
    
    case "$sub_style" in
        lichtenstein|dots|classic)
            _popart_lichtenstein "$f" "$output" ;;
        warhol|screen|repeat)
            _popart_warhol "$f" "$output" ;;
        minimal|flat|simple)
            _popart_minimal "$f" "$output" ;;
        collage|cutout|craft)
            _popart_collage "$f" "$output" ;;
        retro|advert|50s)
            _popart_retro "$f" "$output" ;;
        colorfield|field)
            _popart_colorfield "$f" "$output" ;;
        neon|bright|glow)
            _popart_neon "$f" "$output" ;;
        vintage|60s)
            _popart_vintage "$f" "$output" ;;
        striped|pattern)
            _popart_striped "$f" "$output" ;;
        comic|halftone)
            _popart_comic "$f" "$output" ;;
        *)
            _popart_lichtenstein "$f" "$output" ;;
    esac
}

# --- 1. 李希滕斯坦經典風格 (Classic Lichtenstein) ---
_popart_lichtenstein() {
    local f=$1 output=$2
    local tmp_dir=$(mktemp -d -t popart_lichtenstein_XXXXXXXX)
    local img_w img_h
    read img_w img_h < <(magick identify -auto-orient -format "%w %h" "$f")
    
    local outline="$tmp_dir/outline.png"
    magick "$f" -auto-orient -colorspace gray -canny 0x1+15%+40% -negate -threshold 90% -transparent white \
        -morphology Dilate Disk:1.5 -fill black -opaque white "$outline"
    
    local dots="$tmp_dir/dots.png"
    magick -size "${img_w}x${img_h}" xc:white \
        \( -clone 0 -fx "floor(j/8)%2 && floor(i/8)%2 ? 0.2 : 1" \) \
        -compose over -composite "$dots"
    
    local colors="$tmp_dir/colors.png"
    magick "$f" -auto-orient -modulate 115,180,100 -contrast-stretch 1%x1% -colors 16 +dither "$colors"
    
    magick "$colors" "$dots" -compose multiply -composite \
        "$outline" -compose multiply -composite \
        -brightness-contrast 5x10 -quality 92 "$output"
    
    rm -rf "$tmp_dir"
}

# --- 2. 沃荷風格 (Warhol Style) ---
_popart_warhol() {
    local f=$1 output=$2
    local tmp_dir=$(mktemp -d -t popart_warhol_XXXXXXXX)
    local img_w img_h
    read img_w img_h < <(magick identify -auto-orient -format "%w %h" "$f")
    
    local v1="$tmp_dir/v1.png"
    local v2="$tmp_dir/v2.png"
    local v3="$tmp_dir/v3.png"
    local v4="$tmp_dir/v4.png"
    
    magick "$f" -auto-orient -colors 8 +dither "$v1"
    magick "$f" -auto-orient -modulate 100,200,80 -colors 6 +dither "$v2"
    magick "$f" -auto-orient -modulate 90,180,100 -fill "#ff3366" -tint 100 -colors 6 +dither "$v3"
    magick "$f" -auto-orient -modulate 80,150,200 -fill "#3366ff" -tint 100 -colors 6 +dither "$v4"
    
    local hw=$((img_w / 2)) hh=$((img_h / 2))
    magick \( "$v1" -resize ${hw}x${hh}\! \) \( "$v2" -resize ${hw}x${hh}\! \) +append "$tmp_dir/top.png"
    magick \( "$v3" -resize ${hw}x${hh}\! \) \( "$v4" -resize ${hw}x${hh}\! \) +append "$tmp_dir/bot.png"
    magick "$tmp_dir/top.png" "$tmp_dir/bot.png" -append -quality 92 "$output"
    
    rm -rf "$tmp_dir"
}

# --- 3. 極簡普普 (Minimal Pop) ---
_popart_minimal() {
    local f=$1 output=$2
    local w=$(magick identify -auto-orient -format "%w" "$f")
    local threshold=$(( w / 10 ))

    magick "$f" -auto-orient -colorspace sRGB -auto-level -gamma 1.2 -modulate 115,180,100 \
        -statistic Median 5x5 -bilateral-blur 0x12 +dither -colors 8 \
        -define connected-components:area-threshold=$threshold \
        -define connected-components:mean-color=true -connected-components 4 \
        -morphology Smooth Disk:2 -brightness-contrast 5x10 -quality 92 "$output"
}

# --- 4. 復古廣告風格 (Retro Advertising) ---
_popart_retro() {
    local f=$1 output=$2
    magick "$f" -auto-orient -colorspace sRGB -modulate 105,130,105 -contrast-stretch 1%x1% -colors 12 +dither -gamma 1.1 \
        \( +clone -sparse-color barycentric "0,0 #f4e4c1 100%,0% #e8d4a8 50%,100% #d4c090" \) \
        -compose softlight -composite -quality 92 "$output"
}

# --- 5. 色場普普 (Color Field Pop) ---
_popart_colorfield() {
    local f=$1 output=$2
    magick "$f" -auto-orient -colorspace sRGB -modulate 120,170,105 -contrast-stretch 3%x3% -colors 5 +dither \
        -morphology Smooth Disk:3 -brightness-contrast 10x15 -quality 92 "$output"
}

# --- 6. 拼貼/剪紙風格 (Collage/Cut-out) ---
_popart_collage() {
    local f=$1 output=$2
    local tmp_dir=$(mktemp -d -t collage_v21_XXXXXXXX)
    local w h
    read w h < <(magick identify -auto-orient -format "%w %h" "$f")
    local threshold=$(( w / 12 ))

    magick "$f" -auto-orient -auto-level -modulate 115,200,100 -gamma 1.1 -statistic Median 11x11 \
        +dither -colors 8 -define connected-components:area-threshold=$threshold \
        -define connected-components:mean-color=true -connected-components 4 \
        -morphology Smooth Disk:2 "$tmp_dir/pieces.png"

    magick "$tmp_dir/pieces.png" -colorspace gray -edge 3 -threshold 10% -fill white -opaque white -transparent black "$tmp_dir/white_border.png"

    magick -size "${w}x${h}" xc:"#f0ede4" \
        \( \( "$tmp_dir/pieces.png" "$tmp_dir/white_border.png" -compose screen -composite \) \
           \( +clone -background black -shadow 60x10+10+10 \) +swap -background none -layers flatten \) \
        -compose over -composite \
        \( +clone -fill white -colorize 100% +noise Gaussian -attenuate 0.1 -emboss 1 \) \
        -compose overlay -composite -quality 95 "$output"

    rm -rf "$tmp_dir"
}

# --- 7. 霓虹普普 (Neon Pop) ---
_popart_neon() {
    local f=$1 output=$2
    magick "$f" -auto-orient -colorspace sRGB -modulate 130,200,120 -contrast-stretch 1%x1% -colors 8 +dither \
        \( +clone -fill "#ff00ff" -colorize 30% -gamma 1.3 \) \
        -compose overlay -composite -brightness-contrast 5x15 -quality 92 "$output"
}

# --- 8. 60年代復古 (Vintage 60s) ---
_popart_vintage() {
    local f=$1 output=$2
    magick "$f" -auto-orient -colorspace sRGB -modulate 95,120,100 -contrast-stretch 2%x2% -colors 10 +dither \
        -attenuate 0.15 +noise Gaussian -gamma 1.15 -quality 92 "$output"
}

# --- 9. 条纹/格子图案 (Striped Pattern) ---
_popart_striped() {
    local f=$1 output=$2
    local w h
    read w h < <(magick identify -auto-orient -format "%w %h" "$f")
    magick "$f" -auto-orient -colorspace sRGB -modulate 110,150,105 -colors 8 +dither \
        \( -size 1x2 xc:white xc:black -append -write mpr:stripe +delete -size "${w}x${h}" tile:mpr:stripe \) \
        -compose overlay -composite -quality 92 "$output"
}

# --- 10. 漫畫網點風格 (Comic Halftone) ---
_popart_comic() {
    local f=$1 output=$2
    local tmp_dir=$(mktemp -d -t popart_comic_XXXXXXXX)
    local w h
    read w h < <(magick identify -auto-orient -format "%w %h" "$f")
    
    magick "$f" -auto-orient -modulate 115,175,105 -contrast-stretch 1%x1% -colors 8 +dither "$tmp_dir/colors.png"
    magick -size "${w}x${h}" xc:white -fx "floor(j/6)%2 && floor(i/6)%2 ? 0.15 : 1" "$tmp_dir/dots.png"
    magick "$f" -auto-orient -colorspace gray -edge 1.5 -negate -threshold 88% -morphology Dilate Disk:1 "$tmp_dir/lines.png"
    
    magick "$tmp_dir/colors.png" "$tmp_dir/dots.png" -compose multiply -composite \
        "$tmp_dir/lines.png" -compose multiply -composite \
        -brightness-contrast 3x8 -quality 92 "$output"
    
    rm -rf "$tmp_dir"
}

# --- Abstract art ---
_img_artify_abstract() {
    local f=$1 output=$2 style=$3
    local sub_style=${style#*:}
    case "$sub_style" in
        geometric) _popart_geometric "$f" "$output" ;;
        fluid) _popart_fluid "$f" "$output" ;;
        *) _popart_lichtenstein "$f" "$output" ;;
    esac
}

_popart_geometric() {
    local f=$1 output=$2
    magick "$f" -auto-orient -colorspace sRGB -colors 6 +dither -scale 20% -scale 500% -contrast-stretch 2%x2% -quality 92 "$output"
}

_popart_fluid() {
    local f=$1 output=$2
    magick "$f" -auto-orient -colorspace sRGB -modulate 115,160,105 -colors 8 +dither \
        -blur 0x2 -swirl 40 -implode 0.3 -swirl -20 -quality 92 "$output"
}
