#!/bin/zsh
# styles/cartoon.zsh - 漫畫/卡通風格模組 (Ultimate V12.0 - The Iron Age Edition)

# @menu: art_anime   | cat_cartoon | 🇯🇵 日系動漫 | V6.3 淡墨版效果 | cmd:img-artify cartoon:anime
# @menu: art_comic   | cat_cartoon | 🇺🇸 美系漫畫 | 鋼鐵時代風格 | cmd:img-artify cartoon:comic
# @menu: art_serial  | cat_cartoon | 📜 中式連環畫 | 復古白描筆法 | cmd:img-artify cartoon:serial
# @menu: art_noir    | cat_cartoon | 🎬 黑色電影 | 硬派高對比黑白 | cmd:img-artify cartoon:noir
# @menu: art_sketch  | cat_cartoon | ✏️ 漫畫草稿 | 手繪鉛筆底稿 | cmd:img-artify cartoon:sketch
# @menu: art_outline | cat_cartoon | 🖋️ 純線稿 | 邊緣細線提取 | cmd:img-artify cartoon:outline

_img_artify_cartoon() {
    local f=$1 output=$2 style=$3
    local sub_style=${style#*:}
    
    case "$sub_style" in
        anime|manga|jp)
            _cartoon_manga_bw "$f" "$output" ;;
        comic|us|hero)
            _cartoon_comic_us "$f" "$output" ;;
        clear|eu|ligne)
            _cartoon_clear_eu "$f" "$output" ;;
        serial|cn|ink)
            _cartoon_serial "$f" "$output" ;;
        illust|graphic)
            _cartoon_illust "$f" "$output" ;;
        noir|bw)
            _cartoon_noir "$f" "$output" ;;
        sketch|draft)
            _cartoon_sketch "$f" "$output" ;;
        outline|line)
            _cartoon_outline "$f" "$output" ;;
        *)
            _cartoon_manga_bw "$f" "$output" ;;
    esac
}

# --- 核心工具函數 ---

_get_canny_lines() {
    local f=$1 radius=${2:-0x1} low=${3:-10%} high=${4:-30%} thickness=${5:-1} color=${6:-black}
    local lines=$(mktemp -t canny_lines_XXXXXX).png
    magick "$f" -auto-orient -colorspace gray -canny ${radius}+${low}+${high} -negate -threshold 95% -transparent white -fill "${color}" -opaque black -morphology Dilate Diamond:${thickness} "$lines"
    echo "$lines"
}

# --- 1. 日系漫畫：淡墨版 (Japanese Manga v6.3) ---
_cartoon_manga_bw() {
    local f=$1 output=$2
    local tmp_dir=$(mktemp -d -t manga_v63_XXXXXXXX)
    local lines=$(_get_canny_lines "$f" 0x1 5% 15% 1 "#222222")
    local base="$tmp_dir/base.png"
    magick "$f" -auto-orient -colorspace gray -gamma 1.5 -statistic Median 3x3 -contrast-stretch 0.3%x0.3% "$base"
    local screentone="$tmp_dir/tone.png"
    magick "$base" -distort SRT 45 -ordered-dither h8x8a -distort SRT -45 -fill "#555555" -opaque black -transparent white "$screentone"
    local shadows="$tmp_dir/shadows.png"
    magick "$base" -threshold 8% -transparent white -fill "#444444" -opaque black "$shadows"
    local highlights="$tmp_dir/highlights.png"
    magick "$base" -threshold 65% "$highlights"
    magick -size "$(magick identify -auto-orient -format "%wx%h" "$f")" xc:white "$shadows" -compose over -composite "$screentone" -compose multiply -composite "$lines" -compose multiply -composite "$highlights" -compose over -composite -quality 92 "$output"
    rm -rf "$tmp_dir"
    rm -f "$lines"
}

# --- 2. 美系英雄漫畫：硬核墨跡版 (American Comic V12.0 - The Iron Age) ---
# 核心優化：極限對比度 + 硬核黑塊渲染 (Spot Blacks) + CMYK 英雄色調
_cartoon_comic_us() {
    local f=$1 output=$2
    local tmp_dir=$(mktemp -d -t comic_v12_XXXXXXXX)
    
    # 1. 結構化去照片化底圖 (Structural De-photo)
    # 使用大半徑 Median + 飽和度爆發 + 強力對比度拉伸
    local colors="$tmp_dir/colors.png"
    magick "$f" -auto-orient \
        -statistic Median 7x7 \
        -modulate 110,200,100 \
        -contrast-stretch 2%x2% \
        -posterize 4 \
        -gamma 1.1 "$colors"
    
    # 2. 提取「硬核黑塊」陰影 (Spot Blacks)
    # 這是展現肌肉與立體感的關鍵：將 25% 以下的暗部轉化為塊狀墨跡
    local shadows="$tmp_dir/shadows.png"
    magick "$f" -auto-orient -colorspace gray -gamma 0.7 -threshold 25% -negate -transparent white "$shadows"
    
    # 3. 勾邊：極具張力的雙層墨線
    # 外部輪廓線
    local lines_outer=$(mktemp -t outer_XXXXXX).png
    magick "$f" -auto-orient -colorspace gray -canny 0x1+10%+30% -negate -threshold 95% -transparent white -morphology Dilate Disk:2.5 "$lines_outer"
    # 內部肌肉紋理線
    local lines_inner=$(mktemp -t inner_XXXXXX).png
    magick "$f" -auto-orient -colorspace gray -canny 0x0.5+5%+15% -negate -threshold 90% -transparent white -morphology Dilate Diamond:1 "$lines_inner"
    
    # 4. 最終分層渲染
    # [CMYK色彩層] -> [中度透明黑塊 shadows Multiply 70%] -> [內部細線 Multiply] -> [外部粗輪廓 Multiply]
    magick "$colors" \
        \( "$shadows" -channel A -evaluate multiply 0.7 +channel \) -compose multiply -composite \
        "$lines_inner" -compose multiply -composite \
        "$lines_outer" -compose multiply -composite \
        -brightness-contrast 10x15 \
        -quality 92 "$output"
    
    rm -rf "$tmp_dir"
    rm -f "$lines_outer" "$lines_inner"
}

# --- 3. 歐系漫畫：向量插畫風格 (European Ligne Claire v10.0) ---
_cartoon_clear_eu() {
    local f=$1 output=$2
    local tmp_dir=$(mktemp -d -t clear_v10_XXXXXXXX)
    local lines="$tmp_dir/lines.png"
    magick "$f" -auto-orient -colorspace gray -canny 0x1+10%+30% -negate -threshold 95% -transparent white -blur 0x0.5 -threshold 50% -morphology Close Diamond:2 "$lines"
    local colors="$tmp_dir/colors.png"
    magick "$f" -auto-orient -bilateral-blur 0x7 -modulate 115,140,100 -gamma 1.25 -colors 16 +dither "$colors"
    magick "$colors" "$lines" -compose multiply -composite -adaptive-sharpen 0x3 -quality 92 "$output"
    rm -rf "$tmp_dir"
}

# --- 其他輔助風格 ---
_cartoon_serial() {
    local f=$1 output=$2
    local tmp_dir=$(mktemp -d -t serial_v6_XXXXXXXX)
    local size
    size=$(magick identify -auto-orient -format "%wx%h" "$f")
    local base="$tmp_dir/base_color.png"
    local ink="$tmp_dir/ink_lines.png"
    local paper="$tmp_dir/paper.png"
    local final_base="$tmp_dir/final_base.png"

    # 1) 先做彩色漫畫底圖（保證有內容）
    magick "$f" -auto-orient \
        -modulate 102,78,100 \
        -contrast-stretch 1%x1% \
        -statistic Median 5x5 \
        +dither -colors 12 \
        -gamma 1.02 "$base"

    # 2) 墨線（黑線白底）
    magick "$base" -colorspace gray \
        -canny 0x1+6%+18% -negate \
        -threshold 72% \
        -morphology Dilate Disk:1.1 \
        -background white -alpha remove -alpha off "$ink"

    # 3) 宣紙底紋
    magick -size "$size" xc:"#f6efdf" \
        \( +clone -colorspace gray +noise Gaussian -attenuate 0.10 -emboss 0x0.7 \) \
        -compose overlay -composite "$paper"

    # 4) 宣紙化 + 墨線覆蓋
    magick "$paper" "$base" -compose multiply -composite \
        -modulate 100,92,100 \
        -brightness-contrast -2x6 "$final_base"
    magick "$final_base" "$ink" -compose multiply -composite -quality 92 "$output"

    rm -rf "$tmp_dir"
}

_cartoon_illust() {
    local f=$1 output=$2
    local tmp_dir=$(mktemp -d -t illust_v5_XXXXXXXX)
    
    # 1. 降維與極限平滑 (Scale & Smooth)：
    # 限制處理尺寸以保證風景大圖不卡死，並使用強力濾波磨平紋理
    local orig_size=$(magick identify -auto-orient -format "%wx%h" "$f")
    local base="$tmp_dir/base.png"
    magick "$f" -auto-orient -resize "1280x1280>" \
        -bilateral-blur 0x12 \
        -modulate 105,170,100 "$base"
        
    # 2. 向量化區域聚合 (Fast Vector Flattening)：
    # 使用連通域分析 (Connected Components) 強行抹除面積小於 500px 的瑣碎細節
    # 這是實現「極致簡潔」且「不卡頓」的核心
    local flat="$tmp_dir/flat.png"
    magick "$base" \
        +dither -colors 8 \
        -define connected-components:area-threshold=500 \
        -define connected-components:mean-color=true \
        -connected-components 4 \
        -morphology Smooth Disk:1.5 "$flat"
    
    # 3. 鋼筆曲線勾邊 (Vector Strokes)：僅提取大型色塊的交界
    local lines="$tmp_dir/lines.png"
    magick "$flat" -colorspace gray \
        -edge 1 -negate -threshold 90% -transparent white \
        -morphology Smooth Disk:1.5 \
        -blur 0x0.5 -threshold 50% "$lines"
        
    # 4. 最終合成：還原原始尺寸，確保構圖一致
    magick "$flat" \
        "$lines" -compose multiply -composite \
        -resize "$orig_size!" \
        -quality 92 "$output"
        
    rm -rf "$tmp_dir"
}

_cartoon_noir() {
    local f=$1 output=$2
    magick "$f" -auto-orient -colorspace gray -contrast-stretch 10%x10% -threshold 45% -quality 92 "$output"
}

_cartoon_sketch() {
    local f=$1 output=$2
    local tmp_dir
    tmp_dir=$(mktemp -d -t cartoon_sketch_XXXXXXXX)
    local base_gray="$tmp_dir/base_gray.png"
    local sketch_base="$tmp_dir/sketch_base.png"
    local line_boost="$tmp_dir/line_boost.png"
    local paper="$tmp_dir/paper.png"
    local size
    size=$(magick identify -auto-orient -format "%wx%h" "$f")

    # 1) 灰度底圖（純黑白基礎）
    magick "$f" -auto-orient -colorspace gray -contrast-stretch 0.8%x0.8% "$base_gray"

    # 2) 主草圖（Color Dodge）：這一層保證不會空白
    magick "$base_gray" \
        \( +clone -negate -gaussian-blur 0x6 \) \
        -compose colordodge -composite \
        -level 16%,98% -gamma 0.96 \
        -brightness-contrast 0x8 "$sketch_base"

    # 3) 線條增強（只作輔助，不再作為唯一內容層）
    magick "$base_gray" \
        -canny 0x1+4%+12% -negate -threshold 78% \
        -morphology Dilate Diamond:0.4 \
        -background white -alpha remove -alpha off "$line_boost"

    # 4) 紙張底紋（淺灰白）
    magick -size "$size" xc:"#f5f5f2" \
        \( +clone -colorspace gray +noise Gaussian -attenuate 0.08 -emboss 0x0.6 \) \
        -compose overlay -composite "$paper"

    # 5) 合成：紙紋 × 主草圖，再疊加線條
    magick "$paper" "$sketch_base" -compose multiply -composite \
        "$line_boost" -compose multiply -composite \
        -brightness-contrast 1x10 \
        -quality 92 "$output"

    rm -rf "$tmp_dir"
}

_cartoon_outline() {
    local f=$1 output=$2
    # 純線稿：追求極致乾淨的黑白二值線條
    # 1. 預處理平滑 -> 2. 邊緣提取 -> 3. 二值化 -> 4. 形態學優化 (去噪)
    magick "$f" -auto-orient -colorspace gray \
        -statistic Median 3x3 \
        -canny 0x1+10%+30% \
        -negate \
        -threshold 95% \
        -morphology Open Disk:1 \
        -background white -flatten \
        -quality 92 "$output"
}
