#!/bin/zsh
# styles/etching.zsh - 蝕刻與材質雕刻風格模組 (V5.6 精確修正版)

_img_artify_etching() {
    local f=$1 output=$2 style=$3
    local sub_style=${style#*:}
    [[ "$sub_style" == "$style" ]] && sub_style="paper"
    
    local tmp_dir=$(mktemp -d -t etching_v56_XXXXXXXX)
    local w h
    read w h < <(magick identify -auto-orient -format "%w %h" "$f")
    local size="${w}x${h}"
    local threshold=$(( w / 15 ))

    # =========================================================================
    # STEP 1: 基礎特徵提取 (通用)
    # =========================================================================

    # 1.1 簡化底圖 (用於光影參考)
    magick "$f" -auto-orient -auto-level -modulate 100,150,100 \
        -statistic Median 7x7 \
        +dither -colors 8 \
        -define connected-components:area-threshold=$threshold \
        -define connected-components:mean-color=true \
        -connected-components 4 \
        -morphology Smooth Disk:1.5 "$tmp_dir/flat.png"

    # 1.2 提取標準線條 (用於 Stone, Paper 等風格)
    magick "$f" -auto-orient -colorspace gray \
        -canny 0x1+5%+15% -negate -threshold 90% \
        -morphology Dilate Disk:1.2 "$tmp_dir/lines.png"

    # 1.3 提取標準光影 (用於 Stone, Paper 等風格)
    magick "$tmp_dir/flat.png" -colorspace gray \
        -morphology Edge Diamond:1 -negate -blur 0x5 \
        -shade 135x45 -auto-level -sigmoidal-contrast 5,50% "$tmp_dir/shadows.png"

    # =========================================================================
    # STEP 2: 根據風格分發合成邏輯
    # =========================================================================

    if [[ "$sub_style" == "slate" || "$sub_style" == "dark" ]]; then
        # 【黑石蝕刻】 完美還原參考圖視覺：極高反差 + 強顆粒感
        
        # 2.1 建立強顆粒石材底層 (深色且帶有微小石粉質點)
        local slate_base="$tmp_dir/slate.png"
        magick -size "$size" xc:"#080808" \
            +noise Random -attenuate 0.15 \
            -colorspace gray -brightness-contrast -5x0 "$slate_base"

        # 2.2 提取「高光深度蝕刻區」 (Fills)
        # 使用 contrast-stretch 確保對比度推到極限
        local eng_mass="$tmp_dir/eng_mass.png"
        magick "$f" -auto-orient -colorspace gray \
            -contrast-stretch 1%x1% \
            -threshold 60% "$eng_mass"

        # 2.3 提取「銳利輪廓刻線」 (Lines)
        local eng_lines="$tmp_dir/eng_lines.png"
        magick "$f" -auto-orient -colorspace gray \
            -canny 0x1+10%+30% -threshold 15% "$eng_lines"

        # 2.4 最終合成 (Screen 疊加模式讓白色浮現於黑石上)
        magick "$slate_base" \
            "$eng_mass" -compose screen -composite \
            "$eng_lines" -compose screen -composite \
            -quality 95 "$output"
            
    elif [[ "$sub_style" == "stone" ]]; then
        # 【強化石雕】 還原 V5.2 邏輯
        magick -size "$size" xc:"#666666" \
            "$tmp_dir/shadows.png" -compose multiply -composite \
            \( "$tmp_dir/lines.png" -evaluate multiply 1.2 \) -compose multiply -composite \
            \( +clone -colorspace gray +noise Gaussian -attenuate 0.5 -emboss 2.0 \) -compose overlay -composite \
            -brightness-contrast 10x20 -quality 95 "$output"

    elif [[ "$sub_style" == "nanmu" || "$sub_style" == "wood" ]]; then
        # 【沈木金雕】 還原 V5.2 邏輯
        local wood_base="$tmp_dir/wood_base.png"
        local nanmu_h="$tmp_dir/nanmu_h.png"
        local wood_3d="$tmp_dir/wood_3d.png"
        
        magick -size "$size" xc:"#261a0d" \
            \( +clone +noise Random -virtual-pixel tile -motion-blur 0x100+90 -auto-level -evaluate multiply 0.4 \) \
            -compose overlay -composite "$wood_base"

        magick "$f" -auto-orient -colorspace gray -negate -auto-level -gamma 1.4 \
            \( +clone -blur 0x1 \) \( +clone -blur 0x18 \) -delete 0 -average "$nanmu_h"

        magick "$nanmu_h" -shade 135x45 -auto-level -brightness-contrast 15x45 "$wood_3d"

        magick "$wood_base" \
            "$wood_3d" -compose overlay -composite \
            \( "$wood_3d" -threshold 72% -blur 0x4 -fill "#ffcc33" -tint 100 -evaluate multiply 1.2 \) -compose screen -composite \
            \( "$nanmu_h" -edge 2 -blur 0x1 -negate -evaluate multiply 0.5 \) -compose multiply -composite \
            -brightness-contrast 10x20 -quality 95 "$output"

    else
        # 【畫紙蝕刻】 還原 V5.2 邏輯
        magick -size "$size" xc:"#f0ede4" \
            "$tmp_dir/shadows.png" -compose multiply -composite \
            "$tmp_dir/lines.png" -compose multiply -composite \
            \( +clone -colorspace gray +noise Gaussian -attenuate 0.15 -emboss 1 \) -compose overlay -composite \
            -brightness-contrast 5x10 -quality 95 "$output"
    fi

    rm -rf "$tmp_dir"
}
