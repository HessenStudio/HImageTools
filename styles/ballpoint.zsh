#!/bin/zsh
# styles/ballpoint.zsh - 原子筆手繪風格模組 (Python + IM 混合增強版)

_img_artify_ballpoint() {
    local f=$1 output=$2 style=$3
    local sub_style=${style#*:}
    [[ "$sub_style" == "$style" ]] && sub_style="notebook"

    # 筆記本配色
    local line_color="#dbe8f4"
    local margin_color="#f8a8a8"
    
    local tmp_dir
    tmp_dir=$(mktemp -d -t ballpoint_XXXXXXXX)
    local py_art="$tmp_dir/py_art.png"
    local py_input="$tmp_dir/py_input.png"
    
    # 1. 轉換格式並調用 Python 核心
    magick "$f" -auto-orient "$py_input"
    python3 "$_IMG_ROOT/styles/ballpoint_art.py" "$py_input" "$py_art" "$sub_style"

    # 2. 如果 Python 生成失敗
    if [[ ! -f "$py_art" ]]; then
        echo "⚠️ Python art generation failed, falling back to IM..."
        magick "$py_input" -colorspace gray -canny 0x1+10%+30% -negate -fill "#2144a5" -opaque black "$py_art"
    fi

    # 3. 使用 ImageMagick 進行最終排版與背景疊加
    local size
    size=$(magick identify -format "%wx%h" "$py_art")
    local width=${size%x*}
    local height=${size#*x}

    local bc="5x10"
    [[ "$sub_style" == "fine" ]] && bc="8x15"

    magick "$py_art" \
        \( -size "$size" xc:none \
           \( -size "${width}x45" xc:none -fill "$line_color" -draw "line 0,44 $width,44" -write mpr:nline +delete \) \
           \( -size "$size" tile:mpr:nline \) -compose over -composite \
           -fill "$margin_color" -draw "line $((width*12/100)),0 $((width*12/100)),$height" \
           -fill "$margin_color" -draw "line $((width*12/100+2)),0 $((width*12/100+2)),$height" \
           -write mpr:paper +delete \) \
        mpr:paper +swap -compose multiply -composite \
        -brightness-contrast $bc -quality 95 "$output"

    rm -rf "$tmp_dir"
}
