#!/bin/zsh
# styles/marker.zsh - 馬克筆粗輪廓風格組（獨立模組）

_img_marker_get_ink_stroke() {
    local sub_style="${1:l}"
    # 將下劃線替換回空格，以確保相容性與正確匹配
    sub_style="${sub_style//_/ }"
    case "$sub_style" in
        black|default) echo "#111111 5.0" ;;
        silver) echo "#C0C0C0 5.0" ;;
        gray) echo "#808080 5.0" ;;
        red) echo "#FF0000 5.0" ;;
        maroon) echo "#800000 5.0" ;;
        yellow) echo "#FFFF00 5.4" ;;
        olive) echo "#808000 5.0" ;;
        lime) echo "#00FF00 5.0" ;;
        green) echo "#008000 5.0" ;;
        aqua) echo "#00FFFF 5.0" ;;
        teal) echo "#008080 5.0" ;;
        blue) echo "#0000FF 5.0" ;;
        navy) echo "#000080 5.0" ;;
        purple) echo "#800080 5.0" ;;
        fuchsia) echo "#FF00FF 5.0" ;;
        "blue green") echo "#088F8F 5.0" ;;
        "bright green") echo "#AAFF00 5.0" ;;
        "cadet blue") echo "#5F9EA0 5.0" ;;
        cyan) echo "#00FFFF 5.0" ;;
        denim) echo "#6F8FAF 5.0" ;;
        jade) echo "#00A36C 5.0" ;;
        iris) echo "#5D3FD3 5.0" ;;
        "robin egg blue") echo "#96DED1 5.0" ;;
        turquoise) echo "#40E0D0 5.0" ;;
        brass) echo "#E1C16E 5.0" ;;
        bronze) echo "#CD7F32 5.0" ;;
        brown) echo "#A52A2A 5.0" ;;
        buff) echo "#DAA06D 5.0" ;;
        orange) echo "#FFA500 5.0" ;;
        coffee) echo "#6F4E37 5.0" ;;
        "ash gray") echo "#B2BEB5 5.0" ;;
        "blue gray") echo "#7393B3 5.0" ;;
        "sage green") echo "#8A9A5B 5.0" ;;
        aquamarine) echo "#7FFFD4 5.0" ;;
        celadon) echo "#AFE1AF 5.0" ;;
        chartreuse) echo "#DFFF00 5.0" ;;
        "grass green") echo "#7CFC00 5.0" ;;
        "neon green") echo "#0FFF50 5.0" ;;
        pistachio) echo "#93C572 5.0" ;;
        verdigris) echo "#40B5AD 5.0" ;;
        viridian) echo "#40826D 5.0" ;;
        amber) echo "#FFBF00 5.0" ;;
        coral) echo "#FF7F50 5.0" ;;
        mango) echo "#F4BB44 5.0" ;;
        amaranth) echo "#9F2B68 5.0" ;;
        cerise) echo "#DE3163 5.0" ;;
        "hot pink") echo "#FF69B4 5.0" ;;
        orchid) echo "#DA70D6 5.0" ;;
        pink) echo "#FFC0CB 5.0" ;;
        plum) echo "#673147 5.0" ;;
        raspberry) echo "#E30B5D 5.0" ;;
        rose) echo "#F33A6A 5.0" ;;
        salmon) echo "#FA8072 5.0" ;;
        scarlet) echo "#FF2400 5.0" ;;
        linen) echo "#E9DCC9 5.0" ;;
        pear) echo "#C9CC3F 5.0" ;;
        *) echo "#111111 5.0" ;;
    esac
}

_img_marker_palette() {
    local target_dir="processed"
    [[ -d "$target_dir" ]] || mkdir -p "$target_dir"
    local out="$target_dir/marker_palette.png"
    
    local -a entries=(
        "black" "silver" "gray" "red" "maroon" "yellow" "olive" "lime" "green"
        "aqua" "teal" "blue" "navy" "purple" "fuchsia" "blue green" "bright green"
        "cadet blue" "cyan" "denim" "jade" "iris" "robin egg blue" "turquoise"
        "brass" "bronze" "brown" "buff" "orange" "coffee" "ash gray" "blue gray"
        "sage green" "aquamarine" "celadon" "chartreuse" "grass green" "neon green"
        "pistachio" "verdigris" "viridian" "amber" "coral" "mango" "amaranth"
        "cerise" "hot pink" "orchid" "pink" "plum" "raspberry" "rose" "salmon"
        "scarlet" "linen" "pear"
    )

    local cmd=( magick -size 600x86 xc:white )
    local i=0
    for name in "${entries[@]}"; do
        local resolved color
        resolved=$(_img_marker_get_ink_stroke "$name")
        color="${resolved%% *}"
        # 批量繪製指令：為每個顏色添加一組繪圖操作
        cmd+=(
            -fill "$color" -draw "rectangle 20,16 220,70"
            -fill "#1f1f1f" -font "/System/Library/Fonts/Supplemental/Arial.ttf" -pointsize 28 -annotate +250+55 "$name  $color"
            -write mpr:row -delete 0
        )
        ((i++))
    done

    # 重新讀取所有行並合併（模擬原本的 row_*.png -append）
    # 這裡使用一個更高效的單次 Pipe 寫法
    local final_cmd=( magick )
    for name in "${entries[@]}"; do
        local resolved color
        resolved=$(_img_marker_get_ink_stroke "$name")
        color="${resolved%% *}"
        final_cmd+=( \( -size 600x86 xc:white -fill "$color" -draw "rectangle 20,16 220,70" -fill "#1f1f1f" -font "/System/Library/Fonts/Supplemental/Arial.ttf" -pointsize 28 -annotate +250+55 "$name  $color" \) )
    done
    
    "${final_cmd[@]}" -append "$out"
    echo "✅ 馬克筆色卡已極速生成：$out"
}

_img_artify_marker() {
    local f=$1 output=$2 style=$3
    [[ -f "$f" ]] || { echo "❌ 錯誤：找不到檔案 $f"; return 1; }
    
    local sub_style=${style#*:}
    [[ "$sub_style" == "$style" ]] && sub_style="black"

    if [[ "$sub_style" == "palette" ]]; then
        _img_marker_palette
        return 0
    fi

    local resolved ink stroke
    resolved=$(_img_marker_get_ink_stroke "$sub_style")
    ink="${resolved%% *}"
    stroke="${resolved##* }"

    # 一次獲取寬高，減少 identify 調用
    local w h
    read w h < <(magick identify -auto-orient -format "%w %h" "$f")

    # 優化後的單管線處理：提邊 -> 膨脹 -> 墨水擴散質感 -> 上色 -> 合成到紋理紙張
    magick "$f" -auto-orient \
        \( +clone -colorspace gray -canny 0x1+8%+24% \
           -morphology Dilate Disk:${stroke} \
           -morphology Close Disk:2.2 \
           -spread 1 -blur 0x0.7 -threshold 50% \
           -write mpr:mask +delete \) \
        \( -size ${w}x${h} xc:"#FCFAF2" \
           \( +clone -colorspace gray +noise Gaussian -attenuate 0.3 \
              -emboss 0x0.5 -modulate 100,0,100 \) \
           -compose overlay -composite -write mpr:paper +delete \) \
        -delete 0 \
        -size ${w}x${h} xc:"$ink" \
        mpr:mask -alpha off -compose copyopacity -composite \
        mpr:paper +swap -compose over -composite \
        -quality 95 "$output"
}
