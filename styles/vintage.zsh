#!/bin/zsh
# styles/vintage.zsh - 專業復古與時光印記模組 (Ultimate V22.0 - Constant Visual Scale)

_img_artify_vintage() {
    local f=$1 output=$2 style=$3
    local sub_style=${style#*:}
    [[ "$sub_style" == "$style" ]] && sub_style="standard"

    local grain_atten=2.0 grain_alpha_pct=25 scratch_multiply=0.25
    local scratch_th_vertical=99.2 scratch_th_horizontal=99.6 scratch_blur_v=20 scratch_blur_h=10
    local extra_grain_boost=1.3
    local grain_base_w=1200
    local base_modulate="100,65,100"
    local base_matrix="0.85 0.15 0 0.15 0.85 0 0 0.15 0.75"
    local base_gamma=0.9
    local final_sigmoid="6,45%" final_modulate="95,95,100"

    case "$sub_style" in
        grain)
            grain_atten=2.8 grain_alpha_pct=14 scratch_multiply=0.78
            scratch_th_vertical=99.15 scratch_th_horizontal=99.4
            scratch_blur_v=24 scratch_blur_h=12
            extra_grain_boost=1.0
            grain_base_w=420
            final_sigmoid="8,50%" final_modulate="89,93,100" ;;
        film)
            base_modulate="98,72,108"
            base_matrix="0.9 0.12 0.05 0.08 0.82 0.12 0.05 0.1 0.78"
            base_gamma=0.88
            final_sigmoid="7,48%" final_modulate="92,98,102" scratch_multiply=0.3 ;;
        standard|*) ;;
    esac

    local tmp_dir=$(mktemp -d)
    local w=$(magick identify -auto-orient -format "%[fx:w]" "$f")
    local h=$(magick identify -auto-orient -format "%[fx:h]" "$f")
    local size="${w}x${h}"

    local base_w=$grain_base_w
    local base_h=$(magick identify -auto-orient -format "%[fx:int($h*($base_w/$w))]" "$f")
    local base_size="${base_w}x${base_h}"

    magick "$f" -auto-orient -modulate "$base_modulate" \
        -color-matrix "$base_matrix" \
        -gamma "$base_gamma" -contrast-stretch 1%x1% "$tmp_dir/base.png"

    magick -size "$base_size" xc:gray +noise Gaussian -attenuate "$grain_atten" \
        -sample "$size!" -modulate 100,0,100 \
        -alpha set -channel A -evaluate set "${grain_alpha_pct}%" +channel "$tmp_dir/grain.png"

    magick -size "$base_size" plasma:fractal -colorspace gray \
        -emboss 1.5 -contrast-stretch 5%x5% \
        -sample "$size!" -modulate 100,0,100 \
        -alpha set -channel A -evaluate set 20% +channel "$tmp_dir/texture.png"

    magick -size "$base_size" xc:transparent \
        \( +clone +noise Random -threshold ${scratch_th_vertical}% -negate -motion-blur 0x${scratch_blur_v}+90 \) \
        \( +clone +noise Random -threshold ${scratch_th_horizontal}% -negate -motion-blur 0x${scratch_blur_h}+0 \) \
        -compose screen -composite \
        -sample "$size!" -alpha set -channel A -evaluate multiply "$scratch_multiply" +channel "$tmp_dir/scratches.png"

    magick "$tmp_dir/base.png" \
        "$tmp_dir/grain.png" -compose overlay -composite \
        "$tmp_dir/texture.png" -compose overlay -composite \
        "$tmp_dir/scratches.png" -compose multiply -composite \
        \( "$tmp_dir/grain.png" -channel A -evaluate multiply "$extra_grain_boost" +channel \) -compose over -composite \
        -sigmoidal-contrast "$final_sigmoid" \
        -modulate "$final_modulate" -unsharp 0x2 -quality 95 "$output"

    rm -rf "$tmp_dir"
}

