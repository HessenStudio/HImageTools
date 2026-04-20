#!/bin/zsh
# styles/night.zsh - 專業夜景效果風格模組 (Pro Version)

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