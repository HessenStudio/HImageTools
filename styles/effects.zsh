#!/bin/zsh
# styles/effects.zsh - 其他特殊效果風格模組 (Pro Version)

# @menu: sub_fx_grp  | cat_effects | 🔮 更多特效 | 漩渦、曝光、浮雕 | folder
# @menu: fx_swl      | sub_fx_grp | 🌀 漩渦扭曲 | 扭曲中心區域 | cmd:img-artify swirl:strong
# @menu: fx_swl_s    | sub_fx_grp | 🌀 輕微漩渦 | | cmd:img-artify swirl:soft
# @menu: fx_swl_r    | sub_fx_grp | 🌀 反向漩渦 | | cmd:img-artify swirl:reverse
# @menu: fx_sol      | sub_fx_grp | ☀️ 曝光過度 | 藝術化曝光效果 | cmd:img-artify solarize
# @menu: fx_sol_l    | sub_fx_grp | ☀️ 輕度曝光 | | cmd:img-artify solarize:light
# @menu: fx_emb      | sub_fx_grp | 🖼️ 浮雕效果 | 提取立體質感 | cmd:img-artify emboss:fine
# @menu: fx_emb_h    | sub_fx_grp | 🖼️ 重度浮雕 | | cmd:img-artify emboss:heavy
# @menu: fx_pos      | sub_fx_grp | 🎭 色調分離 | 簡化色彩層次 | cmd:img-artify posterize
# @menu: fx_pos_e    | sub_fx_grp | 🎭 極限分離 | | cmd:img-artify posterize:extreme
# @menu: fx_edg      | sub_fx_grp | 🖋️ 邊緣提取 | 僅保留輪廓 | cmd:img-artify edge:fine
# @menu: fx_inv      | sub_fx_grp | 🎞️ 負片反相 | | cmd:img-artify invert
# @menu: fx_mon      | sub_fx_grp | 🏁 黑白點陣 | | cmd:img-artify monochrome
# @menu: fx_mon_h    | sub_fx_grp | 🏁 高對比點陣 | | cmd:img-artify monochrome:high
# @menu: fx_chr_e    | sub_fx_grp | 🌈 強力色散 | | cmd:img-artify chromatic:extreme
# @menu: art_chr     | cat_effects | 🌈 色散抖音 | 經典 RGB 偏移效果 | cmd:img-artify chromatic

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
