#!/bin/zsh
# styles/sketch.zsh - 素描與炭筆風格模組 (M4 Optimized)

_img_artify_sketch() {
    local f=$1 output=$2 style=$3
    local sub_style=${style#*:}
    [[ "$sub_style" == "$style" ]] && sub_style="standard"

    local blur=2.8 noise=0.08 line_th=80 morph="Diamond:1" bc="0x15"
    case "$sub_style" in
        fine)  blur=1.5 noise=0.04 line_th=86 morph="Diamond:0.8" bc="0x12" ;;
        heavy) blur=4.8 noise=0.18 line_th=72 morph="Disk:1.5" bc="5x28" ;;
        standard|*) ;;
    esac

    local tmp_dir
    tmp_dir=$(mktemp -d -t sketch_XXXXXXXX)
    local base="$tmp_dir/base.png"
    local dodge="$tmp_dir/dodge.png"
    local lines="$tmp_dir/lines.png"
    local paper="$tmp_dir/paper.png"
    local size
    size=$(magick identify -auto-orient -format "%wx%h" "$f")

    magick "$f" -auto-orient -colorspace gray -contrast-stretch 0.8%x0.8% "$base"
    magick "$base" \( +clone -negate -gaussian-blur 0x${blur} \) \
        -compose colordodge -composite -normalize -brightness-contrast "$bc" "$dodge"
    magick "$base" -canny 0x1+7%+20% -negate -threshold "${line_th}%" \
        -morphology Dilate "$morph" -fill "#303030" -opaque black -transparent white "$lines"
    magick -size "$size" xc:"#f2efe7" \
        \( +clone -colorspace gray +noise Gaussian -attenuate "${noise}" -emboss 0x0.8 \) \
        -compose overlay -composite "$paper"

    magick "$paper" "$dodge" -compose multiply -define compose:args=82 -composite \
        "$lines" -compose over -composite -quality 92 "$output"
    rm -rf "$tmp_dir"
}

_img_artify_charcoal() {
    local f=$1 output=$2 style=$3
    local sub_style=${style#*:}
    [[ "$sub_style" == "$style" ]] && sub_style="standard"

    # 木炭风格：面主导、线辅助（避免铅笔细描与全黑）
    local mass_blur=6.0 levels=5 line_edge=2.6 line_th=84 line_dilate="Disk:4.8" grain=0.07 paper_tint="#f6f2e8" tone_mix="72,28"
    case "$sub_style" in
        heavy) mass_blur=7.5 levels=4 line_edge=3.2 line_th=80 line_dilate="Disk:6.8" grain=0.09 paper_tint="#f4f0e4" tone_mix="68,32" ;;
        grain) mass_blur=5.6 levels=5 line_edge=2.4 line_th=86 line_dilate="Disk:4.2" grain=0.18 paper_tint="#f7f3ea" tone_mix="74,26" ;;
        standard|*) ;;
    esac

    local tmp_dir
    tmp_dir=$(mktemp -d -t charcoal_XXXXXXXX)
    local base="$tmp_dir/base.png"
    local mass="$tmp_dir/mass.png"
    local lines="$tmp_dir/lines.png"
    local paper="$tmp_dir/paper.png"
    local merged="$tmp_dir/merged.png"
    local size
    size=$(magick identify -auto-orient -format "%wx%h" "$f")

    # 1) 去细节，得到木炭“面”基础
    magick "$f" -auto-orient -colorspace gray -contrast-stretch 1%x1% "$base"
    magick "$base" \
        -resize "1600x1600>" -statistic Median 9x9 -bilateral-blur 0x16 \
        -gaussian-blur 0x${mass_blur} -resize "$size!" \
        +dither -posterize "$levels" \
        -brightness-contrast 8x6 -level 18%,96% "$mass"

    # 2) 超粗结构线（白底黑线），避免细腻铅笔感
    magick "$base" -edge "$line_edge" -negate -threshold "${line_th}%" \
        -morphology Dilate "$line_dilate" \
        -morphology Close Disk:2.4 \
        -background white -alpha remove -alpha off "$lines"

    # 4) 米白纸底纹
    magick -size "$size" xc:"$paper_tint" \
        \( +clone -colorspace gray +noise Gaussian -attenuate 0.07 -emboss 0x0.6 \) \
        -compose overlay -composite "$paper"

    # 4) 先把炭块“铺”到纸上（blend，防止压黑）
    magick "$paper" "$mass" -compose blend -define compose:args="$tone_mix" -composite "$merged"
    # 5) 再叠粗线（multiply 白底线图，稳定且可控）
    magick "$merged" "$lines" -compose multiply -composite "$merged"
    # 6) 炭粉颗粒与最后亮度保护
    magick "$merged" \
        \( +clone +noise Random -threshold 68% -negate -blur 0x0.5 -evaluate multiply "$grain" \) \
        -compose softlight -composite \
        -brightness-contrast 6x12 -level 2%,97% \
        -quality 92 "$output"

    rm -rf "$tmp_dir"
}
