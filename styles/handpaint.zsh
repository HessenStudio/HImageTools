#!/bin/zsh
# styles/handpaint.zsh - 手繪插畫風格模組 (Series C: Fred's Logic 強化版)

_img_artify_handpaint() {
    local f=$1 output=$2 style=$3
    local sub_style=${style#*:}
    [[ "$sub_style" == "$style" ]] && sub_style="standard"

    local W H
    W=$(magick identify -format "%w" "$f")
    H=$(magick identify -format "%h" "$f")
    local scale=$(magick identify -format "%[fx:(w+h)/2400]" "$f")
    [[ "$scale" == "0" ]] && scale=1

    # --- 核心參數設計 (融合 Fred's 算法參數) ---
    local smoothing=18   # 色塊平滑度
    local edge_gain=5    # 墨線強度 (Fred's gain)
    local line_mix=0.65  # 線條融合度
    local contrast=6
    local saturation=150
    local line_method="sobel" # sobel 或 dodge

    case "$sub_style" in
        vibrant) # 鮮豔鋼筆淡彩 (強墨線)
            smoothing=$(magick identify -format "%[fx:round(15 * $scale)]" "$f")
            edge_gain=6; line_mix=0.75; contrast=8; saturation=170; line_method="sobel" ;;
        soft)    # 柔和鉛筆彩繪 (基於 Fred's sketch.sh 的 ColorDodge 線條)
            smoothing=$(magick identify -format "%[fx:round(22 * $scale)]" "$f")
            edge_gain=3; line_mix=0.5; contrast=4; saturation=120; line_method="dodge" ;;
        heavy)   # 厚重藝術 (重墨線)
            smoothing=$(magick identify -format "%[fx:round(12 * $scale)]" "$f")
            edge_gain=8; line_mix=0.85; contrast=10; saturation=160; line_method="sobel" ;;
        standard|*)
            smoothing=$(magick identify -format "%[fx:round(18 * $scale)]" "$f")
            line_method="sobel"
            ;;
    esac

    local tmp_dir=$(mktemp -d -t handpaint_XXXXXXXX)
    local paper="$tmp_dir/paper.png"
    local color_layer="$tmp_dir/color.png"
    local line_layer="$tmp_dir/lines.png"

    # 1. 生成紙張 (增加壓紋感)
    local paper_blur=$(magick identify -format "%[fx:1.2 * $scale]" "$f")
    magick -size "${W}x${H}" xc:"rgb(250,248,242)" \
        -attenuate 0.05 +noise Gaussian -blur 0x${paper_blur} -level 80%,100% "$paper"

    # 2. 提取結構線條 (Fred's 精華邏輯)
    if [[ "$line_method" == "sobel" ]]; then
        # 參考 Fred's sketcher.sh：Sobel 卷積產生具有壓感的墨線
        magick "$f" -auto-orient -colorspace Gray \
            \( -clone 0 -define convolve:scale='!' \
               -define morphology:compose=Lighten \
               -morphology Convolve 'Sobel:>' \
               -negate -evaluate pow "$edge_gain" \) \
            -delete 0 -transparent white "$line_layer"
    else
        # 參考 Fred's sketch.sh：ColorDodge 產生類似鉛筆稿的柔和線條
        local blur_s=$(magick identify -format "%[fx:2.5 * $scale]" "$f")
        magick "$f" -auto-orient -colorspace Gray \
            \( +clone -negate -blur 0x${blur_s} \) \
            -compose colordodge -composite -normalize \
            -level 30%,100% -transparent white "$line_layer"
    fi

    # 3. 處理抽象色彩塊 (Mean-Shift 簡化)
    local median_s=$(magick identify -format "%[fx:round(3 * $scale)]" "$f")
    magick "$f" -auto-orient \
        -statistic Median ${median_s}x${median_s} \
        -sigmoidal-contrast ${contrast}x50% \
        -modulate 100,"$saturation",100 \
        -mean-shift ${smoothing}x${smoothing}+15% \
        "$color_layer"

    # 4. 多層合成 (紙張 x 色彩 + 線條)
    magick "$paper" "$color_layer" -compose Multiply -composite \
        -brightness-contrast -2x5 -gamma 0.95 \
        "$tmp_dir/base.png"

    # 疊加墨線層 (Multiply 確保線條與色彩自然融合)
    magick "$tmp_dir/base.png" "$line_layer" \
        -compose Multiply -define compose:args="$line_mix" -composite \
        -unsharp 0x$(magick identify -format "%[fx:0.8 * $scale]" "$f")+0.5+0 \
        -quality 95 "$output"

    rm -rf "$tmp_dir"
}
