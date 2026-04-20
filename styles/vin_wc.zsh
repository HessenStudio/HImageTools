#!/bin/zsh
# styles/vin_wc.zsh - 復古水彩混合風格模組 (M4 終極穩定版 + 極限手撕邊緣)

_img_artify_vin_wc() {
    local f=$1 output=$2 style=$3
    local sub_style=${style#*:}
    
    # 獲取寬高
    local img_w=$(magick identify -auto-orient -format "%w" "$f")
    local img_h=$(magick identify -auto-orient -format "%h" "$f")
    
    # 基礎參數初始化
    local mod="100,80,100" b_val="3.0" n_val="0.10" e_val="0.5" l_gamma="0.8"
    local paper_color="#fdfaf0" 
    local edge_roughness=15      # 大幅提升基礎磨損
    local erosion_depth=3       # 侵蝕深度
    
    case "$sub_style" in
        decay)
            mod="100,45,100"; b_val="4.5"; n_val="0.28"; e_val="0.8"
            paper_color="#e0d5c0"; edge_roughness=35; erosion_depth=5 ;;
        heavy)
            mod="70,160,100"; b_val="6.5"; n_val="0.50"; e_val="1.2"
            edge_roughness=25; erosion_depth=3 ;;
        vibrant)
            mod="105,185,100"; b_val="2.0"; n_val="0.05"; e_val="0.3"; l_gamma="1.2"
            edge_roughness=10; erosion_depth=2 ;;
        antique)
            mod="90,75,100"; b_val="4.0"; n_val="0.45"; e_val="1.5"; l_gamma="0.6" 
            paper_color="#dccca3"; edge_roughness=55; erosion_depth=8 ;; # 極致殘破侵蝕
    esac

    local tmp_dir=$(mktemp -d -t im_render_XXXXXXXX)
    local artwork="$tmp_dir/artwork.png"
    local mask="$tmp_dir/mask.png"
    local paper="$tmp_dir/paper.png"

    echo "🔥 正在執行極限手撕渲染 (風格: ${sub_style:-standard}): $f"

    local -a im_opt
    im_opt=( -limit memory 1GiB -limit map 2GiB)

    # 1. 準備畫作主體
    magick "${im_opt[@]}" "$f" -auto-orient -alpha off -colorspace sRGB -modulate $mod -contrast-stretch 1%x1% \
        \( +clone -gaussian-blur 0x${b_val} -statistic Median 3x3 \) \
        \( -clone 0 -colorspace gray -edge 1 -negate -gamma $l_gamma -normalize \) \
        -delete 0 -compose multiply -composite "$artwork"

    if [[ "$sub_style" == "antique" ]]; then
        magick "${im_opt[@]}" "$artwork" -sepia-tone 80% -modulate 100,105,100 "$artwork"
    fi

    # 2. 生成「極限侵蝕」手撕邊遮罩 (核心優化)
    # 優化點：bx/by 大幅縮減到幾乎為零，讓磨損直接發生在邊緣
    local bx=$((edge_roughness / 2))
    local by=$((edge_roughness / 2))
    
    magick "${im_opt[@]}" -size "${img_w}x${img_h}" xc:black \
        -fill white -draw "rectangle $bx,$by $((img_w-bx)),$((img_h-by))" \
        -spread $((edge_roughness * erosion_depth)) \
        -blur 0x$((edge_roughness / 4)) \
        -threshold 50% \
        -spread $((edge_roughness / 3)) \
        -blur 0x1 -threshold 50% \
        -blur 0x1 "$mask"

    # 3. 準備底紙背景 (磨損後露出的底部)
    magick "${im_opt[@]}" -size "${img_w}x${img_h}" xc:"$paper_color" "$paper"

    # 4. 最終物理合成
    magick "${im_opt[@]}" "$paper" "$artwork" "$mask" -composite "$output"

    # 5. 注入最後的紙張質感
    magick "${im_opt[@]}" "$output" \
        \( +clone -colorspace gray +noise Gaussian -attenuate ${n_val} -emboss ${e_val} \) \
        -compose overlay -composite \
        -quality 92 "$output"

    rm -rf "$tmp_dir"
}
