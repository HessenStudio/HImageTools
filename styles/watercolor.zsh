#!/bin/zsh
# styles/watercolor.zsh - 標準水彩風格模組 (M4 Optimized)

_img_artify_watercolor() {
    local f=$1 output=$2 style=$3
    local sub_style=${style#*:}
    [[ "$sub_style" == "$style" ]] && sub_style="standard"

    local tmp_dir
    tmp_dir=$(mktemp -d -t watercolor_XXXXXXXX)
    local base="$tmp_dir/base.png"
    local flat="$tmp_dir/flat.png"
    local wash="$tmp_dir/wash.png"
    local bleed="$tmp_dir/bleed.png"
    local edges="$tmp_dir/edges.png"
    local paper="$tmp_dir/paper.png"
    local merged="$tmp_dir/merged.png"
    local size
    size=$(magick identify -auto-orient -format "%wx%h" "$f")

    local sat=110 gamma=0.98 blur_main=4.0 bilateral="0x18" paint=2 colors=24 edge_th=86 edge_blur=1.1 bleed_blur=2.2 paper_tint="#f6f1e7"
    case "$sub_style" in
        wet)
            sat=126 gamma=0.96 blur_main=5.6 bilateral="0x24" paint=3 colors=18 edge_th=80 edge_blur=1.6 bleed_blur=3.8 paper_tint="#f3eee2"
            ;;
        sketch)
            sat=105 gamma=0.99 blur_main=3.0 bilateral="0x12" paint=1 colors=28 edge_th=72 edge_blur=0.7 bleed_blur=1.4 paper_tint="#f7f3ea"
            ;;
        soft)
            sat=100 gamma=1.02 blur_main=6.2 bilateral="0x28" paint=3 colors=20 edge_th=92 edge_blur=1.7 bleed_blur=3.2 paper_tint="#f8f4ec"
            ;;
        standard|*)
            ;;
    esac

    # 1) 先去照片感：降细节 + 色块化
    magick "$f" -auto-orient -colorspace sRGB \
        -modulate 103,${sat},100 -gamma "$gamma" -contrast-stretch 0.7%x0.7% \
        -resize "1400x1400>" -statistic Median 5x5 -blur 0x"$blur_main" \
        -bilateral-blur "$bilateral" -paint "$paint" "$base"

    magick "$base" +dither -colors "$colors" -resize "$size!" "$flat"

    # 2) 水渍扩散层（主观感受：颜料在纸面扩开）
    magick "$flat" -blur 0x"$bleed_blur" -morphology Smooth Disk:1.3 "$bleed"
    magick "$bleed" -colorspace sRGB -modulate 101,112,100 "$wash"

    # 3) 轮廓线只作为轻辅层，避免“仅轮廓+原图”
    magick "$flat" -colorspace gray -canny 0x0.8+4%+12% -negate \
        -blur 0x"$edge_blur" -threshold "${edge_th}%" \
        -fill "#6f7580" -opaque black -transparent white "$edges"

    # 4) 纸纹
    magick -size "$size" xc:"$paper_tint" \
        \( +clone -colorspace gray +noise Gaussian -attenuate 0.12 -emboss 0x0.9 \) \
        -compose overlay -composite "$paper"

    # 5) 纸纹 × 水彩主体 + 轻轮廓增强
    magick "$paper" "$wash" -compose multiply -composite "$merged"
    if [[ "$sub_style" == "sketch" ]]; then
        magick "$merged" "$edges" -compose multiply -composite -quality 92 "$output"
    elif [[ "$sub_style" == "soft" ]]; then
        magick "$merged" -quality 92 "$output"
    else
        magick "$merged" "$edges" -compose over -define compose:args=35 -composite \
            -quality 92 "$output"
    fi

    rm -rf "$tmp_dir"
}
