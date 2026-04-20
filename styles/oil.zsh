#!/bin/zsh
# styles/oil.zsh - 專業油畫風格模組 (Ultimate V15.0 - The Masterpiece Edition)

_img_artify_oil() {
    local f=$1 output=$2 style=$3
    local sub_style=${style#*:}
    [[ "$sub_style" == "$style" ]] && sub_style="classical"

    case "$sub_style" in
        classical|realism) _oil_classical "$f" "$output" ;;
        impressionist|impressionism) _oil_impressionist "$f" "$output" ;;
        expressionist|expressionism) _oil_expressionist "$f" "$output" ;;
        abstract) _oil_abstract "$f" "$output" ;;
        impasto|thick) _oil_impasto "$f" "$output" ;;
        renaissance|master) _oil_renaissance "$f" "$output" ;;
        standard) _oil_standard "$f" "$output" ;;
        *) _oil_classical "$f" "$output" ;;
    esac
}

# --- 核心工具函數 ---

# 獲取物理畫布紋理
_get_oil_canvas() {
    local w=$1 h=$2 density=${3:-0.5}
    local canvas=$(mktemp).png
    magick -size "${w}x${h}" xc:white \
        +noise Attic -colorspace gray \
        -attenuate "$density" -blur 0x0.5 \
        -emboss 0x1 -contrast-stretch 1%x1% \
        -modulate 100,0,100 "$canvas"
    echo "$canvas"
}

# --- 1. 古典寫實 (Classical Realism) ---
# 技術點：高調形體雕塑 (High-key Sculpting) + 明亮罩染 (Bright Glazing) + 結構骨架
_oil_classical() {
    local f=$1 output=$2
    
    # 1. 基礎重構：提升初始亮度與飽和度
    # 2. 結構線：稍微減弱結構線的黑度，使其與亮部融合
    # 3. 強力建模：保持 S 型曲線，但將重心向亮部偏移
    magick "$f" -auto-orient \
        -modulate 110,115,100 -gamma 1.05 \
        -statistic Median 7x7 -bilateral-blur 0x20 -paint 3 \
        \( +clone -colorspace gray -edge 2 -negate -threshold 85% -morphology Dilate Disk:1.2 \
           -fill "#3d2b1f" -opaque black -transparent white \) \
        -compose multiply -composite \
        \( +clone -colorspace gray -negate -edge 1 -blur 0x2 -shade 135x45 -auto-level -function polynomial "0.4,0" \) \
        -compose overlay -composite \
        \( +clone -blur 0x15 -modulate 105,125,100 \) \
        -compose softlight -composite \
        -sigmoidal-contrast 6,55% \
        -unsharp 0x3 -brightness-contrast 5x0 -quality 96 "$output"
}

# --- 2. 印象派 (Impressionism) ---
# 技術點：可見點彩筆觸 + 色彩飽和爆發
_oil_impressionist() {
    local f=$1 output=$2
    local tmp_dir=$(mktemp -d)
    
    # 1. 色彩解構：增強飽和度與對比
    magick "$f" -auto-orient -modulate 100,150,100 -contrast-stretch 1%x1% "$tmp_dir/colors.png"
    
    # 2. 模擬點彩筆觸：使用 Mode 濾波 + 噪點偏移
    magick "$tmp_dir/colors.png" \
        -attenuate 0.3 +noise Gaussian \
        -statistic Mode 7 -paint 4 "$tmp_dir/strokes.png"
        
    # 3. 疊加高光亮感
    magick "$tmp_dir/strokes.png" \
        \( +clone -colorspace gray -edge 1 -negate -threshold 90% -blur 0x2 -shade 120x30 -auto-level \) \
        -compose overlay -composite -quality 92 "$output"
        
    rm -rf "$tmp_dir"
}

# --- 3. 表現主義 (Expressionism) ---
# 技術點：強烈黑塊 (Spot Blacks) + 誇張色彩偏移
_oil_expressionist() {
    local f=$1 output=$2
    local tmp_dir=$(mktemp -d)
    
    # 1. 強烈色彩基底
    magick "$f" -auto-orient -modulate 110,180,105 -posterize 12 -statistic Median 3 "$tmp_dir/base.png"
    
    # 2. 提取「情感勾邊」：粗獷的黑色線條
    magick "$f" -auto-orient -colorspace gray -canny 0x2+5%+15% -negate -threshold 90% \
        -morphology Dilate Disk:1.5 -transparent white "$tmp_dir/lines.png"
        
    # 3. 合成：色彩 + 線條 + 粗糙質地
    magick "$tmp_dir/base.png" "$tmp_dir/lines.png" -compose multiply -composite \
        -attenuate 0.1 +noise Gaussian -emboss 0x1 "$output"
        
    rm -rf "$tmp_dir"
}

# --- 4. 抽象藝術 (Abstract Oil) ---
# 技術點：連通域區域聚合 (Connected Components) + 幾何化
_oil_abstract() {
    local f=$1 output=$2
    local tmp_dir=$(mktemp -d)
    
    # 1. 強力預平滑 + 降維：這是防止物件過多的關鍵
    # 使用 7x7 中值濾波先抹除 90% 的細碎噪點
    magick "$f" -auto-orient -resize "1024x1024>" \
        -statistic Median 7x7 \
        -bilateral-blur 0x15 "$tmp_dir/pre.png"

    # 2. 簡化影像為大塊色塊
    # 提高面積閾值 (area-threshold) 以強制聚合
    magick "$tmp_dir/pre.png" \
        +dither -colors 12 \
        -define connected-components:area-threshold=1500 \
        -define connected-components:mean-color=true \
        -connected-components 4 "$tmp_dir/flat.png"
        
    # 3. 增加抽象邊緣反光
    magick "$tmp_dir/flat.png" \
        \( +clone -colorspace gray -canny 0x1+10%+30% -blur 0x2 -shade 135x40 -auto-level \) \
        -compose screen -composite -quality 92 "$output"
        
    rm -rf "$tmp_dir"
}

# --- 5. 厚塗法 (Impasto) ---
# 技術點：極限物理高度圖 (Height Map) + 筆觸堆疊
_oil_impasto() {
    local f=$1 output=$2
    local tmp_dir=$(mktemp -d)
    
    # 1. 生成大筆觸色彩層
    magick "$f" -auto-orient -statistic Mode 9 -paint 6 -modulate 100,120,100 "$tmp_dir/paint.png"
    
    # 2. 生成厚度圖 (關鍵：多層邊緣疊加)
    magick "$tmp_dir/paint.png" -colorspace gray \
        \( +clone -blur 0x1 -shade 135x30 -auto-level \) \
        \( -clone 0 -edge 2 -blur 0x2 -shade 45x30 -auto-level \) \
        -delete 0 -compose overlay -composite "$tmp_dir/height.png"
        
    # 3. 合成：將色彩與高度圖結合，並增強高光反光
    magick "$tmp_dir/paint.png" "$tmp_dir/height.png" -compose hardlight -composite \
        -unsharp 0x2 -contrast-stretch 1%x1% "$output"
        
    rm -rf "$tmp_dir"
}

# --- 6. 文藝復興/大師風格 (Renaissance/Master) ---
# 技術點：重度油畫底稿 (Heavy Oil Base) + 裂紋咬色 (Patina Cracks) + 繪畫性光影 (Chiaroscuro)
_oil_renaissance() {
    local f=$1 output=$2

    # 1. 構建「重度油畫」底稿：大幅合併像素，消除照片的平滑感
    # 2. 注入繪畫性的明暗對比：使用 sigmoidal-contrast 替代遮罩，讓暗部自然沉澱
    # 3. 疊加筆觸立體感與裂紋質感
    magick "$f" -auto-orient \
        -modulate 100,125,100 \
        -bilateral-blur 0x12 -statistic Mode 9 -paint 5 \
        -sigmoidal-contrast 7,45% \
        \( +clone -colorspace gray -negate -edge 2 -blur 0x1 -shade 135x40 -auto-level -function polynomial "0.4,0" \) \
        -compose overlay -composite \
        \( +clone -colorspace gray +noise Random -virtual-pixel tile -motion-blur 0x5+45 -threshold 90% -negate -blur 0x1 -alpha set -channel A -evaluate multiply 0.1 +channel \) \
        -compose multiply -composite \
        -gamma 0.9 -modulate 95,90,100 -unsharp 0x3 -quality 95 "$output"
}


# --- 預設標準油畫 ---
_oil_standard() {
    local f=$1 output=$2
    magick "$f" -auto-orient \
        -colorspace sRGB -gamma 0.9 -modulate 100,95,100 \
        -blur 0x1.5 -statistic Mode 5 -paint 3 \
        \( +clone -attenuate 0.1 +noise Gaussian -emboss 0x0.8 \) \
        -compose overlay -composite "$output"
}
