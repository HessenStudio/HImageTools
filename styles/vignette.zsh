#!/bin/zsh
# styles/vignette.zsh - 專業暗角效果風格模組 (Pro Version)

_img_artify_vignette() {
    local f=$1 output=$2 style=$3
    
    # 解析格式 主風格:子風格 (例如 vignette:soft 或 vignette:retro-sepia)
    local sub_style=${style#*:}
    [[ "$sub_style" == "$style" ]] && sub_style="soft"
    
    local intensity=0x25 softness=40%
    local bg_color="black"
    
    case "$sub_style" in
        heavy) intensity=0x40; softness=50% ;;
        light) intensity=0x15; softness=25% ;;
        soft)  intensity=0x25; softness=40% ;;
        # 擴充子風格使用 - 分隔
        retro-white) bg_color="white"; intensity=0x18; softness=35% ;;
        retro-sepia|color) bg_color="#2a1a0a"; intensity=0x28; softness=45% ;;
        retro-blue)  bg_color="#000022"; intensity=0x30; softness=50% ;;
        white) bg_color="white"; intensity=0x18; ;;
        *)     intensity=0x25; softness=40% ;;
    esac

    magick "$f" -auto-orient \
        -background "${bg_color}" \
        -vignette ${intensity} \
        -quality 92 "$output"
}

_img_artify_lomo() {
    local f=$1 output=$2 style=$3
    
    magick "$f" -auto-orient \
        -colorspace sRGB \
        -modulate 110,120,100 \
        -contrast-stretch 3%x3% \
        -size "%[w]x%[h]" radial-gradient:black-transparent \
        -gamma 1.8 \
        -compose multiply -composite \
        -quality 92 "$output"
}
