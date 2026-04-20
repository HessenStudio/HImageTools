#!/bin/zsh
# artify_main.zsh - img-artify 總入口 (並行處理優化版)

# 內部任務分發函數 (帶強制預處理管線 V4.2)
_img_artify_dispatch() {
    local f=$1 output=$2 style=$3

    # --- 1. 強制預處理管線 (Pre-Optimization Pipeline) ---
    local tmp_work_dir=$(mktemp -d -t artify_pre_XXXXXXXX)
    local stem=$(basename "${f%.*}")
    local work_img="$tmp_work_dir/${stem}_work.mpc"
    
    # 優化策略：修正方向、縮放至 1920px (寬度優先)、強制 sRGB、8-bit 位深、移除元數據、轉為 MPC 高速格式
    magick "$f" -auto-orient -resize "1920x>" -colorspace sRGB -depth 8 -strip "$work_img"
    
    # --- 2. 路由至對應濾鏡 (使用優化後的 work_img) ---
    if [[ "$style" == oil* ]]; then
        _img_artify_oil "$work_img" "$output" "$style"
    elif [[ "$style" == sketch* ]]; then
        _img_artify_sketch "$work_img" "$output" "$style"
    elif [[ "$style" == charcoal* ]]; then
        _img_artify_charcoal "$work_img" "$output" "$style"
    elif [[ "$style" == watercolor* ]]; then
        _img_artify_watercolor "$work_img" "$output" "$style"
    elif [[ "$style" == vin-wc* ]]; then
        _img_artify_vin_wc "$work_img" "$output" "$style"
    elif [[ "$style" == lomo* ]]; then
        _img_artify_lomo "$work_img" "$output" "$style"
    elif [[ "$style" == vintage* ]]; then
        _img_artify_vintage "$work_img" "$output" "$style"
    elif [[ "$style" == cartoon* || "$style" == comic* || "$style" == anime* || "$style" == manga* || "$style" == serial* || "$style" == clear* ]]; then
        _img_artify_cartoon "$work_img" "$output" "$style"
    elif [[ "$style" == popart* ]]; then
        _img_artify_popart "$work_img" "$output" "$style" 
    elif [[ "$style" == marker* ]]; then
        _img_artify_marker "$work_img" "$output" "$style"
    elif [[ "$style" == illust* ]]; then
        _img_artify_illust "$work_img" "$output" "$style"
    elif [[ "$style" == handpaint* ]]; then
        _img_artify_handpaint "$work_img" "$output" "$style"
    elif [[ "$style" == etching* ]]; then
        _img_artify_etching "$work_img" "$output" "$style"
    elif [[ "$style" == abstract* ]]; then
        _img_artify_abstract "$work_img" "$output" "$style"
    elif [[ "$style" == pixelate* ]]; then
        _img_artify_pixelate "$work_img" "$output" "$style"
    elif [[ "$style" == mosaic* ]]; then
        _img_artify_mosaic "$work_img" "$output" "$style"
    elif [[ "$style" == duotone* ]]; then
        _img_artify_duotone "$work_img" "$output" "$style"
    elif [[ "$style" == tritone* ]]; then
        _img_artify_tritone "$work_img" "$output" "$style"
    elif [[ "$style" == sepia* ]]; then
        _img_artify_sepia "$work_img" "$output" "$style"
    elif [[ "$style" == antique* ]]; then
        _img_artify_antique "$work_img" "$output" "$style"
    elif [[ "$style" == aged-photo* ]]; then
        _img_artify_aged_photo "$work_img" "$output" "$style"
    elif [[ "$style" == night* ]]; then
        _img_artify_night "$work_img" "$output" "$style"
    elif [[ "$style" == neon* ]]; then
        _img_artify_neon "$work_img" "$output" "$style"
    elif [[ "$style" == twilight* ]]; then
        _img_artify_twilight "$work_img" "$output" "$style"
    elif [[ "$style" == vignette* ]]; then
        _img_artify_vignette "$work_img" "$output" "$style"
    elif [[ "$style" == solarize* ]]; then
        _img_artify_solarize "$work_img" "$output" "$style"
    elif [[ "$style" == swirl* ]]; then
        _img_artify_swirl "$work_img" "$output" "$style"
    elif [[ "$style" == monochrome* ]]; then
        _img_artify_monochrome "$work_img" "$output" "$style"
    elif [[ "$style" == emboss* ]]; then
        _img_artify_emboss "$work_img" "$output" "$style"
    elif [[ "$style" == posterize* ]]; then
        _img_artify_posterize "$work_img" "$output" "$style"
    elif [[ "$style" == edge* ]]; then
        _img_artify_edge "$work_img" "$output" "$style"
    elif [[ "$style" == invert ]]; then
        _img_artify_invert "$work_img" "$output" "$style"
    elif [[ "$style" == chromatic* ]]; then
        _img_artify_chromatic "$work_img" "$output" "$style"
    else
        _img_artify_misc "$work_img" "$output" "$style"
    fi

    # --- 3. 任務收尾：清理預處理臨時文件 ---
    rm -rf "$tmp_work_dir"
}

img-artify() {
    local style=$1
    local files=( $~_IMG_PATTERN )

    if [[ -z "$style" ]]; then
        # 直接進入旗艦級 V2.0 選單
        img-menu
        return $?
    fi

    if [[ "$style" == "-h" || "$style" == "--help" ]]; then
        echo "❌ 用法: img-artify <風格>[:子風格]"
        echo ""
        echo "🎨 專業藝術風格模組清單："
        echo ""
        echo "  【1. 漫畫插畫風格 (Cartoon & Illustration)】"
        echo "    cartoon:anime      - 日系動漫 (V6.3 淡墨版) [alias: manga, jp]"
        echo "    cartoon:comic      - 美系漫畫 (V12.0 鋼鐵時代版) [alias: us, hero]"
        echo "    cartoon:clear      - 歐系向量風格 (V10.0 Ligne Claire) [alias: eu, ligne]"
        echo "    cartoon:serial     - 連環畫風格 [alias: cn, ink]"
        echo "    cartoon:illust     - 商業插畫風格 [alias: graphic]"
        echo "    cartoon:noir       - 黑色電影/硬派黑白 [alias: bw]"
        echo "    cartoon:sketch     - 漫畫草稿 [alias: draft]"
        echo "    cartoon:outline    - 純線稿 [alias: line]"
        echo ""
        echo "  【2. 經典繪畫風格 (Classic Painting)】"
        echo "    oil[:classical|impressionist|expressionist|abstract|impasto|renaissance|standard] - 專業油畫系列 (預設: classical)"
        echo "      - classical: 古典寫實 (細緻光影) [alias: realism]"
        echo "      - impressionist: 印象派 (靈動筆觸) [alias: impressionism]"
        echo "      - expressionist: 表現主義 (強烈情感) [alias: expressionism]"
        echo "      - abstract: 抽象藝術 (形式解構)"
        echo "      - impasto: 厚塗法 (立體顏料質感) [alias: thick]"
        echo "      - renaissance: 文藝復興/大師風格 [alias: master]"
        echo "      - standard: 柔和標準油畫筆觸 (舊版預設)"
        echo "    watercolor[:wet|sketch|soft] - 水彩風格 (無子風格時為標準水彩)"
        echo "    sketch[:fine|heavy] - 素描風格 (無子風格時為標準素描)"
        echo "    charcoal[:heavy|grain] - 炭筆畫風格 (預設: standard)"
        echo "    vin-wc[:decay|heavy|vibrant|antique] - 復古水彩手撕邊 (終極版)"
        echo ""
        echo "  【3. 復古與底片風格 (Retro & Vintage)】"
        echo "    vintage[:standard|film|grain] - 經典復古底片 (預設: standard)"
        echo "    sepia[:light|heavy|faded] - 棕褐懷舊風格"
        echo "    antique            - 舊照片藝術化 (帶噪點)"
        echo "    aged-photo         - 老照片質感 (帶底紋)"
        echo "    lomo               - Lomo 隨拍風格"
        echo "    night[:dark|city|cyber|blue] - 夜景效果"
        echo "    neon               - 霓虹燈色彩效果"
        echo "    twilight           - 暮光/憂鬱色調"
        echo ""
        echo "  【4. 現代與普普藝術 (Modern & Pop Art)】"
        echo "    popart / popart:lichtenstein - 李希滕斯坦圓點網點 (預設) [alias: dots, classic]"
        echo "    popart:warhol       - 沃荷風格 (絲網印刷 2x2) [alias: screen, repeat]"
        echo "    popart:minimal      - 極簡普普 (大塊平塗) [alias: flat, simple]"
        echo "    popart:retro        - 50 年代廣告 (復古奶油色) [alias: advert, 50s]"
        echo "    popart:colorfield   - 色場普普 (大塊純色) [alias: field]"
        echo "    popart:collage      - 拼貼剪紙 [alias: cutout, craft]"
        echo "    popart:neon         - 霓虹普普 [alias: bright, glow]"
        echo "    popart:vintage      - 60 年代復古 [alias: 60s]"
        echo "    popart:striped      - 條紋/格紋疊加 [alias: pattern]"
        echo "    popart:comic        - 漫畫網點 [alias: halftone]"
        echo "    abstract[:geometric|fluid] - 抽象藝術風格"
        echo "    pixelate[:8bit|16bit|chunky|fine] - 像素藝術 (預設: 8bit)"
        echo "    mosaic[:fine|coarse] - 馬賽克拼貼"
        echo "    duotone[:warm|cool|neon|sepia2|ocean|forest|royal] - 雙色調 (預設: warm)"
        echo "    tritone            - 三色調質感"
        echo "    marker:<color>      - 馬克筆粗輪廓（完整色表請用 marker:palette 查看）"
        echo "    marker:palette      - 生成馬克筆顏色色卡（processed/marker_palette.png）"
        echo ""
        echo "  【5. 蝕刻與材質雕刻 (Etching & Materials)】"
        echo "    etching:paper      - 藝術素描/畫紙蝕刻 [default]"
        echo "    etching:stone      - 強化石壁雕刻 (粗糙岩石/深邃凹凸感)"
        echo "    etching:nanmu      - 沈木金雕 (深黑楠木底色 + #ffcc33 鎏金高光) [alias: wood]"
        echo "    etching:slate      - 黑石板蝕刻 (現代深色質感) [alias: dark]"
        echo ""
        echo "  【6. 特殊視覺效果 (Special Effects)】"
        echo "    vignette:<substyle> - 暗角/柔邊"
        echo "      - soft, heavy, light, retro-white, retro-sepia, retro-blue"
        echo "    swirl:<substyle>   - 漩渦扭曲"
        echo "      - strong, soft, subtle, reverse"
        echo "    solarize:<substyle> - 曝光過度效果"
        echo "      - standard, light, heavy"
        echo "    chromatic:<substyle> - 色散/抖音風格"
        echo "      - extreme, subtle"
        echo "    monochrome:<substyle> - 黑白點陣"
        echo "      - standard, high, soft"
        echo "    emboss:<substyle>     - 浮雕效果"
        echo "      - fine, heavy"
        echo "    posterize:<substyle>  - 色調分離"
        echo "      - standard, minimal, extreme"
        echo "    edge:<substyle>       - 邊緣提取"
        echo "      - fine, heavy"
        echo "    invert              - 負片/反相"
        return 1
    fi

    if [[ ${#files[@]} -eq 0 ]]; then echo "❌ 找不到圖片（支援：jpg/jpeg/png/webp/tiff）"; return 1; fi
    _img_batch_process

    # 局部關閉任務監視，防止打印 "done" 消息
    setopt local_options no_notify no_monitor

    local total=${#files[@]}
    local tmp_file=$(mktemp)

    echo "☕️ 正在後臺處理 ${total} 張圖片 (低優先級模式) ..."
    _img_show_progress 0 "$total" "隊列準備中..."

    local prefix=$(_img_style_to_prefix "$style")
    local -a _artify_outputs
    for f in "${files[@]}"; do
        _artify_outputs+=("$(_img_next_output_path "$prefix" "$(_img_stem_from_file "$f")" "png")")
    done

    local started=0
    local _k=1
    for f in "${files[@]}"; do
        local output="${_artify_outputs[_k]}"
        (( _k++ ))

        # 傳遞當前已啟動數，精確計算併發
        _img_wait_jobs "$tmp_file" "$total" "處理: $f" "$started"

        # 執行任務 (後臺執行，並在此更新完成標誌)
        {
            _img_artify_dispatch "$f" "$output" "$style"
            echo "." >> "$tmp_file"
        } &
        (( started++ ))
    done
    
    # 等待所有背景任務完成
    _img_wait_all "$tmp_file" "$total"

    _img_show_progress "$total" "$total" "處理完成！"
    echo ""
    rm "$tmp_file"
}
