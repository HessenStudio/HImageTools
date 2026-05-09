#!/bin/zsh
# styles/night.zsh - 專業夜景效果風格模組 (Pro Version)

# @menu: sub_nit_grp | cat_vintage | 🌃 專業夜景 | 城市、藍調、賽博朋克 | folder
# @menu: nit_std     | sub_nit_grp | 標準夜景 | 經典夜間氛圍 | cmd:img-artify night
# @menu: nit_drk     | sub_nit_grp | 極暗夜晚 | 深邃的暗部細節 | cmd:img-artify night:dark
# @menu: nit_cty     | sub_nit_grp | 城市燈火 | 強化燈光感 | cmd:img-artify night:city
# @menu: nit_cyb     | sub_nit_grp | 賽博朋克 | 藍紫霓虹質感 | cmd:img-artify night:cyber
# @menu: nit_blu     | sub_nit_grp | 冷調藍夜 | 憂鬱的藍色基調 | cmd:img-artify night:blue
# @menu: art_neon    | sub_nit_grp | 🌈 霓虹效果 | 螢光色彩與發光 | cmd:img-artify neon
# @menu: art_twi     | sub_nit_grp | 🌆 暮光效果 | 憂鬱的黃昏色調 | cmd:img-artify twilight

_img_artify_night() {
    local f=$1 output=$2 style=$3
    local sub_style=${style#*:}
    
    local mod="70,40,100" fill_color="#000040" bc="-20x-10" gamma_val=0.8
    
    [[ "$sub_style" == "dark" ]] && { mod="50,30,100"; fill_color="#000020"; bc="-30x-20"; }
    [[ "$sub_style" == "city" ]] && { mod="60,35,100"; fill_color="#000030"; bc="-25x-15"; gamma_val=0.7; }
    [[ "$sub_style" == "cyber" ]] && { mod="80,25,110"; fill_color="#001040"; bc="-15x-5"; gamma_val=0.9; }
    [[ "$sub_style" == "blue" ]] && { mod="65,45,100"; fill_color="#001050"; bc="-20x-10"; gamma_val=0.75; }

    magick "$f" -auto-orient \
        -modulate ${mod} \
        -fill "${fill_color}" -tint 100 \
        -brightness-contrast ${bc} \
        -gamma ${gamma_val} \
        -quality 92 "$output"
}

_img_artify_neon() {
    local f=$1 output=$2 style=$3
    
    magick "$f" -auto-orient \
        -colorspace sRGB \
        -colors 16 \
        -modulate 120,80,120 \
        -contrast-stretch 2%x2% \
        -quality 92 "$output"
}

_img_artify_twilight() {
    local f=$1 output=$2 style=$3
    
    magick "$f" -auto-orient \
        -colorspace sRGB \
        -modulate 85,60,90 \
        -fill "#1a1030" -tint 80 \
        -brightness-contrast -10x5 \
        -gamma 0.85 \
        -quality 92 "$output"
}