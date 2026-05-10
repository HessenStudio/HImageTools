#!/bin/zsh
# artify_all.zsh - 一鍵生成全風格藝術畫廊 (V5.0 插件化版)

# @menu: art_all     | artify_root | 🚀 一鍵藝術化全家桶 | 自動生成 100+ 種全風格畫廊 | input:請輸入圖片目錄路徑:./:img-artify-all

img-artify-all() {
    local target_dir=${1:-.}
    # 移除末尾斜槓以避免 // 問題
    target_dir=${target_dir%/}
    local out_base="${target_dir}/artify_gallery"

    if [[ ! -d "$target_dir" ]]; then
        echo "❌ 目錄不存在: $target_dir"
        return 1
    fi

    # 1. 取得圖片清單
    local files=( ${target_dir}/*.(#i)(jpg|jpeg|png|webp|tiff) )
    # 排除 gallery 目錄內的東西
    files=(${files:#*artify_gallery*})

    if [[ ${#files[@]} -eq 0 ]]; then
        echo "❌ 在 $target_dir 中找不到圖片"
        return 1
    fi

    # 2. 取得所有風格 (從動態註冊器獲取)
    local -a artify_cmds
    artify_cmds=($(_img_get_all_artify_styles))

    if [[ ${#artify_cmds[@]} -eq 0 ]]; then
        echo "❌ 找不到任何已註冊的藝術風格。請確認已正確載入插件。"
        return 1
    fi

    echo "🎨 啟動一鍵藝術化全家桶！"
    echo "📦 目標: ${#files[@]} 張圖片 | 🎨 風格: ${#artify_cmds[@]} 種"
    echo "📂 輸出: $out_base"
    echo "-----------------------------------------------"

    mkdir -p "$out_base"
    mkdir -p "${out_base}/originals"

    local img_count=0
    for f in "${files[@]}"; do
        ((img_count++))
        local stem=$(basename "${f%.*}")
        local ext="${f##*.}"
        local img_out_dir="${out_base}/${stem}"
        mkdir -p "$img_out_dir"
        
        # 複製原圖到 originals 目錄以便網頁顯示對比
        cp "$f" "${out_base}/originals/${stem}.${ext}"
        
        echo "🖼️  [%d/%d] 正在渲染原圖: %s" "$img_count" "${#files[@]}" "$f"
        
        local style_count=0
        for style in "${artify_cmds[@]}"; do
            ((style_count++))
            local safe_style=${style//:/_}
            local output="${img_out_dir}/${safe_style}.png"
            
            # 跳過已存在的 (支援斷點續傳)
            if [[ -f "$output" ]]; then
                printf "\r   ├─ [%2d/%d] %-30s \033[0;90mSKIPPED\033[0m" "$style_count" "${#artify_cmds[@]}" "$style"
                continue
            fi

            printf "\r   ├─ [%2d/%d] %-30s " "$style_count" "${#artify_cmds[@]}" "$style"
            
            _img_artify_dispatch "$f" "$output" "$style" >/dev/null 2>&1
            
            if [[ -f "$output" ]]; then
                printf "\033[0;32mDONE\033[0m"
            else
                printf "\033[0;31mFAIL\033[0m"
            fi
        done
        echo "\n   └─ 該圖渲染完成。"
    done

    # 3. 生成畫廊頁面
    _img_generate_gallery_html "$out_base"
    
    echo "-----------------------------------------------"
    echo "✅ 一鍵藝術化完成！"
    echo "🌐 畫廊已生成: $out_base/index.html"
    echo "🚀 提示：你可以直接用瀏覽器打開該網頁挑選喜歡的風格。"
}

_img_generate_gallery_html() {
    local base=$1
    local html="${base}/index.html"
    local template="${_IMG_ROOT}/assets/gallery_template.html"

    if [[ ! -f "$template" ]]; then
        echo "❌ 找不到 HTML 模板: $template"
        return 1
    fi
    
    # 準備 JSON 數據
    local json_data="const artifyData = {"
    for d in "${base}"/*(/); do
        local stem=$(basename "$d")
        [[ "$stem" == "assets" || "$stem" == "originals" ]] && continue
        
        # 尋找對應的原圖文件
        local original_file=$(ls "${base}/originals/${stem}".* | head -n 1)
        local original_basename=$(basename "$original_file")
        
        json_data+="\"$stem\": { \"original\": \"originals/$original_basename\", \"styles\": ["
        for img in "$d"/*.png; do
            local style_name=$(basename "$img" .png)
            json_data+="\"$style_name\","
        done
        json_data=${json_data%?} 
        json_data+="] },"
    done
    json_data=${json_data%?}
    json_data+="};"

    # 讀取模板並替換佔位符
    # 使用 perl 進行穩健的替換，避免 shell 轉義問題
    perl -pe "s|/\* \{\{JSON_DATA\}\} \*/|$json_data|g" "$template" > "$html"
}
