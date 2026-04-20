#!/bin/zsh
# styles/sepia.zsh - 專業棕褐懷舊風格模組 (Pro Version)

_img_artify_sepia() {
    local f=$1 output=$2 style=$3
    local sub_style=${style#*:}

    local tmp_dir
    tmp_dir=$(mktemp -d -t sepia_XXXXXXXX)
    local base="$tmp_dir/base.png"
    local paper="$tmp_dir/paper.png"
    local size
    size=$(magick identify -auto-orient -format "%wx%h" "$f")

    case "$sub_style" in
        light)
            magick "$f" -auto-orient -sepia-tone 62% -modulate 102,100,100 \
                -brightness-contrast 0x6 "$base"
            ;;
        heavy)
            magick "$f" -auto-orient -sepia-tone 95% -modulate 98,138,100 \
                -brightness-contrast 12x22 "$base"
            ;;
        faded)
            # 輕泛黃 + 全色域褪色，不是單純棕色化
            magick "$f" -auto-orient -modulate 105,52,100 -gamma 1.05 \
                -color-matrix "0.86 0.09 0.05 0.06 0.82 0.06 0.04 0.08 0.80" \
                -brightness-contrast -4x3 "$base"
            magick -size "$size" xc:"#f3ead7" \
                \( +clone -colorspace gray +noise Gaussian -attenuate 0.05 \) \
                -compose overlay -composite "$paper"
            magick "$base" "$paper" -compose softlight -composite "$base"
            ;;
        *)
            magick "$f" -auto-orient -sepia-tone 80% -modulate 100,120,100 \
                -brightness-contrast 5x10 "$base"
            ;;
    esac

    magick "$base" -quality 92 "$output"
    rm -rf "$tmp_dir"
}

_img_artify_antique() {
    local f=$1 output=$2 style=$3
    # antique：老照片本体处理 + 明显噪点 + 边缘微黄 + 轻褶皱
    local w h
    w=$(magick identify -auto-orient -format "%w" "$f")
    h=$(magick identify -auto-orient -format "%h" "$f")
    local tmpdir
    tmpdir=$(mktemp -d -t antique_XXXXXXXX)
    local base="$tmpdir/base.png"
    local noise="$tmpdir/noise.png"
    local edge_mask="$tmpdir/edge_mask.png"
    local edge_yellow="$tmpdir/edge_yellow.png"
    local wrinkle="$tmpdir/wrinkle.png"

    # 1) 先做老照片基调（本体变化）
    magick "$f" -auto-orient -colorspace sRGB \
        -modulate 100,40,100 \
        -color-matrix "0.93 0.05 0.03 0.04 0.90 0.04 0.03 0.05 0.88" \
        -gamma 1.16 \
        -contrast-stretch 2%x2% \
        -brightness-contrast 3x-8 \
        -level 16%,95% \
        -statistic Median 2x2 \
        -blur 0x0.3 "$base"

    # 2) 明显噪点（作用于图像本体）
    magick -size ${w}x${h} xc:gray +noise Gaussian -attenuate 1.6 \
        -modulate 100,0,100 "$noise"
    magick "$base" "$noise" -compose overlay -define compose:args=36 -composite "$base"

    # 3) 旧相册发霉边缘：小面积随机斑块，仅在四周零散分布
    # 先做边缘权重（越靠边越强），再叠加低覆盖率随机斑块
    magick -size ${w}x${h} radial-gradient:white-black \
        -level 34%,100% -blur 0x10 "$edge_mask"
    magick -size ${w}x${h} plasma:fractal -colorspace gray \
        -contrast-stretch 30%x30% -threshold 82% -blur 0x1.2 \
        -morphology Open Disk:1.2 \
        "$edge_mask" -compose multiply -composite \
        -alpha set -channel A -evaluate multiply 0.16 +channel "$edge_mask"
    magick -size ${w}x${h} xc:"#c9ad72" \
        "$edge_mask" -alpha off -compose copyopacity -composite "$edge_yellow"
    magick "$base" "$edge_yellow" -compose over -composite "$base"

    # 4) 褶皱纹理（可见级）：定向折痕 + 颗粒压纹
    magick -size ${w}x${h} plasma:fractal -colorspace gray \
        \( +clone -motion-blur 0x24+38 \) \
        \( +clone -motion-blur 0x16+122 \) \
        -delete 0 -compose overlay -composite \
        -emboss 0x2.0 -contrast-stretch 5%x5% \
        -alpha set -channel A -evaluate set 34% +channel "$wrinkle"
    magick "$base" "$wrinkle" -compose hardlight -composite \
        -quality 92 "$output"

    rm -rf "$tmpdir"
}

_img_artify_aged_photo() {
    local f=$1 output=$2 style=$3
    
    local img_w=$(magick identify -auto-orient -format "%w" "$f")
    local img_h=$(magick identify -auto-orient -format "%h" "$f")
    
    # aged-photo：老相纸风格，偏灰褐并带纸纹，不走重黄调
    magick "$f" -auto-orient \
        -modulate 97,64,100 \
        -color-matrix "0.90 0.06 0.03 0.05 0.86 0.04 0.03 0.05 0.84" \
        -contrast-stretch 1.5%x1.5% \
        \( -size ${img_w}x${img_h} xc:"#e3dccf" -attenuate 0.10 +noise Gaussian -emboss 0x0.7 \) \
        -compose softlight -composite \
        -brightness-contrast -1x4 \
        -quality 92 "$output"
}