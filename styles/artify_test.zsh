#!/bin/zsh
# styles/artify_test.zsh - 一鍵風格自檢工具

img-artify-test() {
    local out_base="./style_test_report"
    
    # 1. 準備環境
    [[ -d "$out_base" ]] && rm -rf "$out_base"
    mkdir -p "$out_base"
    
    local test_source="${out_base}/test_source.png"
    magick logo: -resize 800x "$test_source"
    
    # 2. 獲取所有風格
    local manifest="${_IMG_ROOT}/menu_manifest.zsh"
    local -a artify_cmds
    artify_cmds=($(grep "cmd:img-artify" "$manifest" | sed -E 's/.*cmd:img-artify ([^"]+).*/\1/'))

    echo "🧪 啟動一鍵風格自檢..."
    echo "📊 風格總數: ${#artify_cmds[@]} 種"
    echo "📂 輸出目錄: $out_base"
    echo "-----------------------------------------------"

    local count=0
    for style in "${artify_cmds[@]}"; do
        ((count++))
        local safe_style=${style//:/_}
        local output="${out_base}/${safe_style}.png"
        
        printf "\r   [%2d/%d] 測試風格: %-30s " "$count" "${#artify_cmds[@]}" "$style"
        
        _img_artify_dispatch "$test_source" "$output" "$style" >/dev/null 2>&1
        
        if [[ -f "$output" ]]; then
            printf "\033[0;32mPASS\033[0m"
        else
            printf "\033[0;31mFAIL\033[0m"
        fi
    done

    # 3. 生成簡化版 HTML 預覽
    _img_generate_gallery_html "$out_base"
    
    echo "\n-----------------------------------------------"
    echo "✅ 自檢完成！"
    echo "🌐 測試報告已生成: $out_base/index.html"
    rm "$test_source"
}
