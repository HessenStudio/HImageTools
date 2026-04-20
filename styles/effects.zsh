#!/bin/zsh
# styles/effects.zsh - 其他特殊效果風格模組 (Pro Version)

_img_artify_solarize() {
    local f=$1 output=$2 style=$3
    local sub_style=${style#*:}
    local threshold=50%
    [[ "$sub_style" == "light" ]] && threshold=30%
    [[ "$sub_style" == "heavy" ]] && threshold=70%

    magick "$f" -auto-orient -solarize ${threshold} -quality 92 "$output"
}

_img_artify_swirl() {
    local f=$1 output=$2 style=$3
    local sub_style=${style#*:}
    local degrees=90
    [[ "$sub_style" == "soft" ]] && degrees=45
    [[ "$sub_style" == "strong" ]] && degrees=150
    [[ "$sub_style" == "subtle" ]] && degrees=30
    [[ "$sub_style" == "reverse" ]] && degrees=-90

    magick "$f" -auto-orient -swirl ${degrees} -quality 92 "$output"
}

_img_artify_monochrome() {
    local f=$1 output=$2 style=$3
    local sub_style=${style#*:}
    magick "$f" -auto-orient -monochrome "$output"
    [[ "$sub_style" == "high" ]] && magick "$output" -brightness-contrast 10x20 "$output"
    [[ "$sub_style" == "soft" ]] && magick "$output" -brightness-contrast -5x-10 "$output"
}

_img_artify_emboss() {
    local f=$1 output=$2 style=$3
    local sub_style=${style#*:}
    local radius=2
    [[ "$sub_style" == "fine" ]] && radius=1
    [[ "$sub_style" == "heavy" ]] && radius=4
    magick "$f" -auto-orient -emboss ${radius} -quality 92 "$output"
}

_img_artify_posterize() {
    local f=$1 output=$2 style=$3
    local sub_style=${style#*:}
    local levels=4
    [[ "$sub_style" == "minimal" ]] && levels=8
    [[ "$sub_style" == "extreme" ]] && levels=2
    magick "$f" -auto-orient +dither -posterize ${levels} -quality 92 "$output"
}

_img_artify_edge() {
    local f=$1 output=$2 style=$3
    local sub_style=${style#*:}
    local radius=2
    [[ "$sub_style" == "fine" ]] && radius=1
    [[ "$sub_style" == "heavy" ]] && radius=3
    magick "$f" -auto-orient -edge ${radius} -quality 92 "$output"
}

_img_artify_invert() {
    local f=$1 output=$2
    magick "$f" -auto-orient -negate -quality 92 "$output"
}

_img_artify_chromatic() {
    local f=$1 output=$2 style=$3
    local sub_style=${style#*:}
    local offset=3
    [[ "$sub_style" == "extreme" ]] && offset=6
    [[ "$sub_style" == "subtle" ]] && offset=1

    magick "$f" -auto-orient \
        \( +clone -roll +${offset}+0 -channel R -evaluate set 0 \) \
        \( +clone -roll -${offset}+0 -channel B -evaluate set 255 \) \
        -compose over -composite \
        -quality 92 "$output"
}
