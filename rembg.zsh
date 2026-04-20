#!/bin/zsh
# rembg.zsh - 背景移除工具集 (背景靜默優化版)

# 8. 批量去除背景 (ImageMagick 版本)
img-rembg() {
    local color=${1:-white}
    local fuzz=${2:-10%}
    local files=( $~_IMG_PATTERN )
    if [[ ${#files[@]} -eq 0 ]]; then echo "❌ 找不到圖片（支援：jpg/jpeg/png/webp/tiff）"; return 1; fi
    _img_batch_process
    
    local total=${#files[@]}
    local tmp_file=$(mktemp)
    
    echo "☕️ 正在後臺移除背景 ${total} 張圖片 (低優先級模式) ..."
    
    local started=0
    for f in "${files[@]}"; do
        local output="./processed/${f%.*}.png"

        # 使用計數器同步併發
        _img_wait_jobs "$tmp_file" "$total" "正在去背: $f" "$started"

        {
            magick "$f" -auto-orient -fuzz "$fuzz" -transparent "$color" "$output" >/dev/null 2>&1
            echo "." >> "$tmp_file"
        } &
        (( started++ ))
    done

    _img_wait_all "$tmp_file" "$total"
    _img_show_progress "$total" "$total" "完成！"
    echo ""
    rm "$tmp_file"
}

# 9. [AI 高級去背] 使用 rembg 進行智慧識別 (批量處理)
img-ai-rembg() {
    local files=( $~_IMG_PATTERN )
    if [[ ${#files[@]} -eq 0 ]]; then echo "❌ 找不到圖片（支援：jpg/jpeg/png/webp/tiff）"; return 1; fi
    
    _img_batch_process
    local total=${#files[@]}
    local count=0
    
    echo "🧠 正在使用 AI 模型進行去背處理 (${total} 張圖片) ..."
    echo "☕️ 採用低優先級背景模式 (nice -n 19)"

    for f in "${files[@]}"; do
        count=$((count + 1))
        _img_show_progress "$((count-1))" "$total" "AI 正在處理: $f"

        local out="./processed/${f%.*}.png"
        local tmp_in
        tmp_in=$(mktemp -t im_ai_rembg.XXXXXX)
        magick "$f" -auto-orient "$tmp_in" >/dev/null 2>&1

        # 使用 nice -n 19 運行 AI 模型，確保不搶奪開發工具資源（輸入已按 EXIF 矯正方向）
        if nice -n 19 rembg i "$tmp_in" "$out" >/dev/null 2>&1; then
            :
        else
            echo "\n❌ 失敗: $f (請檢查 rembg 指令是否安裝)"
        fi
        rm -f "$tmp_in"
    done
    
    _img_stop_watchdog
    wait
    _img_show_progress "$total" "$total" "AI 處理完成！"
    echo ""
}
