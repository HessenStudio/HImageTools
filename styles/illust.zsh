#!/bin/zsh
# styles/illust.zsh - 清新水彩插圖風格模組 (Fred's Logic 融合版 V9.0)

_img_artify_illust() {
    local f=$1 output=$2 style=$3
    local sub_style=${style#*:}
    [[ "$sub_style" == "$style" ]] && sub_style="standard"

    local W H
    W=$(magick identify -format "%w" "$f")
    H=$(magick identify -format "%h" "$f")

    # --- 動態縮放係數 (以 1200px 為基準) ---
    local scale=$(magick identify -format "%[fx:(w+h)/2400]" "$f")
    [[ "$scale" == "0" ]] && scale=1 # 防止極小圖片報錯

    # --- 核心參數 (動態縮放版) ---
    local base_smooth=10
    local smoothing=$(magick identify -format "%[fx:round($base_smooth * $scale)]" "$f")
    local median_size=$(magick identify -format "%[fx:round(3 * $scale)]" "$f")
    [[ $median_size -lt 1 ]] && median_size=1

    local edge_gain=5
    local mixing=55
    local contrast=6
    local saturation=145

    case "$sub_style" in
        soft)     smoothing=$(magick identify -format "%[fx:round(14 * $scale)]" "$f"); edge_gain=4; mixing=40 ;;
        detailed) smoothing=$(magick identify -format "%[fx:round(6 * $scale)]" "$f");  edge_gain=6; mixing=65 ;;
    esac

    local tmp_dir=$(mktemp -d -t illust_XXXXXXXX)
    local paper="$tmp_dir/paper.png"
    local wc_core="$tmp_dir/wc_core.png"

    # =========================================================================
    # STEP 1：生成高品質水彩紙紋理 (縮放 blur 以保持顆粒感)
    # =========================================================================
    local paper_blur=$(magick identify -format "%[fx:1.5 * $scale]" "$f")
    magick -size "${W}x${H}" xc:"rgb(250,248,242)" \
        -attenuate 0.05 +noise Gaussian \
        -blur 0x${paper_blur} -level 80%,100% \
        "$paper"

    # =========================================================================
    # STEP 2-4：核心水彩處理 (使用動態參數)
    # =========================================================================
    magick "$f" -auto-orient \
        -statistic Median ${median_size}x${median_size} \
        -sigmoidal-contrast ${contrast}x50% \
        -modulate 100,"$saturation",100 \
        -mean-shift ${smoothing}x${smoothing}+15% \
        \( -clone 0 -define convolve:scale='!' \
           -define morphology:compose=Lighten \
           -morphology Convolve 'Sobel:>' \
           -negate -evaluate pow "$edge_gain" \) \
        \( -clone 0 -clone 1 -compose luminize -composite \) \
        -delete 1 \
        -define compose:args="$mixing" -compose blend -composite \
        "$wc_core"

    # =========================================================================
    # STEP 5：紙張合成與最終色彩校正
    # =========================================================================
    local us_radius=$(magick identify -format "%[fx:1.0 * $scale]" "$f")
    magick "$paper" "$wc_core" -compose Multiply -composite \
        -brightness-contrast -2x8 \
        -gamma 0.95 \
        -unsharp 0x${us_radius}+0.5+0.02 \
        "$tmp_dir/final_base.png"


    # =========================================================================
    # STEP 6：添加裝飾性水彩噴濺 (插畫感提升)
    # =========================================================================
    local splatter_cmd=( magick "$tmp_dir/final_base.png" )
    # 使用固定隨機種子確保風格穩定
    RANDOM=42
    for i in {1..10}; do
        local bx=$(( RANDOM % W ))
        local by=$(( RANDOM % H ))
        local br=$(( 1 + RANDOM % 3 ))
        local opacity=$(( 15 + RANDOM % 25 ))
        splatter_cmd+=( -fill "rgba(100,130,180,0.$opacity)" -draw "circle $bx,$by $((bx+br)),$((by+br))" )
    done

    # 輸出最終圖片
    "${splatter_cmd[@]}" -quality 95 "$output"

    rm -rf "$tmp_dir"
}