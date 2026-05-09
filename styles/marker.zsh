#!/bin/zsh
# styles/marker.zsh - 馬克筆粗輪廓風格組（獨立模組）

# @menu: sub_marker  | cat_illust  | 🖊️ 馬克筆插畫 (Marker) | 56 色專業馬克筆手繪 | folder
# @menu: mk_pal      | sub_marker | 🎨 生成全色卡預覽 | 查看所有 56 種顏色 | cmd:img-artify marker:palette
# @menu: mk_grp_gray | sub_marker | 🪙 基礎與灰階 (Basic) | | folder
# @menu: mk_grp_red  | sub_marker | 🍎 紅粉系列 (Red/Pink) | | folder
# @menu: mk_grp_yell | sub_marker | 🧀 黃橙大地 (Yellow/Brown) | | folder
# @menu: mk_grp_gree | sub_marker | 🍃 綠色系列 (Green) | | folder
# @menu: mk_grp_blue | sub_marker | 🌊 藍紫系列 (Blue/Purple) | | folder

# @menu: mk_black    | mk_grp_gray | 經典黑 (Black) | | cmd:img-artify marker:black
# @menu: mk_silver   | mk_grp_gray | 銀色 (Silver) | | cmd:img-artify marker:silver
# @menu: mk_gray     | mk_grp_gray | 灰色 (Gray) | | cmd:img-artify marker:gray
# @menu: mk_ash      | mk_grp_gray | 灰燼 (Ash Gray) | | cmd:img-artify marker:ash_gray
# @menu: mk_bgray    | mk_grp_gray | 藍灰 (Blue Gray) | | cmd:img-artify marker:blue_gray
# @menu: mk_linen    | mk_grp_gray | 亞麻 (Linen) | | cmd:img-artify marker:linen
# @menu: mk_red      | mk_grp_red | 鮮豔紅 (Red) | | cmd:img-artify marker:red
# @menu: mk_maroon   | mk_grp_red | 栗紅 (Maroon) | | cmd:img-artify marker:maroon
# @menu: mk_coral    | mk_grp_red | 珊瑚 (Coral) | | cmd:img-artify marker:coral
# @menu: mk_amaranth | mk_grp_red | 莧紫 (Amaranth) | | cmd:img-artify marker:amaranth
# @menu: mk_cerise   | mk_grp_red | 櫻桃 (Cerise) | | cmd:img-artify marker:cerise
# @menu: mk_hpink    | mk_grp_red | 艷粉 (Hot Pink) | | cmd:img-artify marker:hot_pink
# @menu: mk_orchid   | mk_grp_red | 蘭花 (Orchid) | | cmd:img-artify marker:orchid
# @menu: mk_pink     | mk_grp_red | 粉紅 (Pink) | | cmd:img-artify marker:pink
# @menu: mk_rasp     | mk_grp_red | 覆盆子 (Raspberry) | | cmd:img-artify marker:raspberry
# @menu: mk_rose     | mk_grp_red | 玫瑰 (Rose) | | cmd:img-artify marker:rose
# @menu: mk_salmon   | mk_grp_red | 鮭魚 (Salmon) | | cmd:img-artify marker:salmon
# @menu: mk_scarlet  | mk_grp_red | 猩紅 (Scarlet) | | cmd:img-artify marker:scarlet
# @menu: mk_yellow   | mk_grp_yell | 活力黃 (Yellow) | | cmd:img-artify marker:yellow
# @menu: mk_orange   | mk_grp_yell | 活力橘 (Orange) | | cmd:img-artify marker:orange
# @menu: mk_mango    | mk_grp_yell | 芒果 (Mango) | | cmd:img-artify marker:mango
# @menu: mk_amber    | mk_grp_yell | 琥珀 (Amber) | | cmd:img-artify marker:amber
# @menu: mk_brass    | mk_grp_yell | 黃銅 (Brass) | | cmd:img-artify marker:brass
# @menu: mk_bronze   | mk_grp_yell | 青銅 (Bronze) | | cmd:img-artify marker:bronze
# @menu: mk_brown    | mk_grp_yell | 褐色 (Brown) | | cmd:img-artify marker:brown
# @menu: mk_buff     | mk_grp_yell | 米色 (Buff) | | cmd:img-artify marker:buff
# @menu: mk_coffee   | mk_grp_yell | 咖啡 (Coffee) | | cmd:img-artify marker:coffee
# @menu: mk_pear     | mk_grp_yell | 梨色 (Pear) | | cmd:img-artify marker:pear
# @menu: mk_lime     | mk_grp_gree | 萊姆 (Lime) | | cmd:img-artify marker:lime
# @menu: mk_green    | mk_grp_gree | 森林綠 (Green) | | cmd:img-artify marker:green
# @menu: mk_olive    | mk_grp_gree | 橄欖 (Olive) | | cmd:img-artify marker:olive
# @menu: mk_bgreen   | mk_grp_gree | 亮綠 (Bright Green) | | cmd:img-artify marker:bright_green
# @menu: mk_jade     | mk_grp_gree | 翡翠 (Jade) | | cmd:img-artify marker:jade
# @menu: mk_sage     | mk_grp_gree | 鼠尾草 (Sage Green) | | cmd:img-artify marker:sage_green
# @menu: mk_celadon  | mk_grp_gree | 青瓷 (Celadon) | | cmd:img-artify marker:celadon
# @menu: mk_chart    | mk_grp_gree | 查特酒 (Chartreuse) | | cmd:img-artify marker:chartreuse
# @menu: mk_grass    | mk_grp_gree | 草原綠 (Grass Green) | | cmd:img-artify marker:grass_green
# @menu: mk_neon     | mk_grp_gree | 霓虹綠 (Neon Green) | | cmd:img-artify marker:neon_green
# @menu: mk_pista    | mk_grp_gree | 開心果 (Pistachio) | | cmd:img-artify marker:pistachio
# @menu: mk_virid    | mk_grp_gree | 翠綠 (Viridian) | | cmd:img-artify marker:viridian
# @menu: mk_blue     | mk_grp_blue | 經典藍 (Blue) | | cmd:img-artify marker:blue
# @menu: mk_navy     | mk_grp_blue | 海軍藍 (Navy) | | cmd:img-artify marker:navy
# @menu: mk_aqua     | mk_grp_blue | 水藍 (Aqua) | | cmd:img-artify marker:aqua
# @menu: mk_teal     | mk_grp_blue | 藍綠 (Teal) | | cmd:img-artify marker:teal
# @menu: mk_cadet    | mk_grp_blue | 軍校藍 (Cadet Blue) | | cmd:img-artify marker:cadet_blue
# @menu: mk_cyan     | mk_grp_blue | 青色 (Cyan) | | cmd:img-artify marker:cyan
# @menu: mk_denim    | mk_grp_blue | 丹寧 (Denim) | | cmd:img-artify marker:denim
# @menu: mk_iris     | mk_grp_blue | 鳶尾 (Iris) | | cmd:img-artify marker:iris
# @menu: mk_robin    | mk_grp_blue | 知更鳥蛋 (Robin Egg Blue) | | cmd:img-artify marker:robin_egg_blue
# @menu: mk_turq     | mk_grp_blue | 綠松石 (Turquoise) | | cmd:img-artify marker:turquoise
# @menu: mk_ama      | mk_grp_blue | 海藍寶 (Aquamarine) | | cmd:img-artify marker:aquamarine
# @menu: mk_verdi    | mk_grp_blue | 銅綠 (Verdigris) | | cmd:img-artify marker:verdigris
# @menu: mk_fuchs    | mk_grp_blue | 品紅 (Fuchsia) | | cmd:img-artify marker:fuchsia
# @menu: mk_purple   | mk_grp_blue | 紫色 (Purple) | | cmd:img-artify marker:purple
# @menu: mk_plum     | mk_grp_blue | 梅紫 (Plum) | | cmd:img-artify marker:plum

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
