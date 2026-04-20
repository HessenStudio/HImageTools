#!/bin/zsh
# styles/duotone.zsh - 專業雙色調風格模組 (Pro Version)

_img_artify_duotone() {
    local f=$1 output=$2 style=$3
    local sub_style=${style#*:}
    [[ "$sub_style" == "$style" ]] && sub_style="warm"
    
    local color_dark="#2d3561" color_light="#c059b5"
    
    case "$sub_style" in
        warm)
            color_dark="#3d1a1a" color_light="#ff9966" ;;
        cool)
            color_dark="#1a2a3d" color_light="#66ccff" ;;
        neon)
            color_dark="#0d0221" color_light="#00ffaa" ;;
        sepia2)
            color_dark="#2b211e" color_light="#e6c9a8" ;;
        ocean)
            color_dark="#0a2342" color_light="#5dadec" ;;
        forest)
            color_dark="#1a332a" color_light="#7ec8a3" ;;
        royal)
            color_dark="#1a0a2e" color_light="#c9a227" ;;
    esac

    magick "$f" -auto-orient \
        -colorspace gray \
        -contrast-stretch 0 \
        -level-colors "${color_dark},${color_light}" \
        -quality 92 "$output"
}

_img_artify_tritone() {
    local f=$1 output=$2 style=$3
    local sub_style=${style#*:}
    
    magick "$f" -auto-orient \
        -colorspace sRGB \
        -fill "#1a1a2e" -colorize 30% \
        -colors 3 \
        -dither FloydSteinberg \
        -quality 92 "$output"
}