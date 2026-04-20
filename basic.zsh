#!/bin/zsh
# basic.zsh - 基礎格式轉換與處理工具 (V4.5 安全路徑與全進度條版)

# 內部輔助：獲取安全輸出路徑 (解決帶路徑文件問題)
_img_basic_get_out() {
    local f=$1 ext=$2
    local stem=$(basename "${f%.*}")
    echo "./processed/${stem}.${ext}"
}

# 1. 批量縮放
img-resize() {
    local width=${1:-1920}
    local files=( $~_IMG_PATTERN )
    [[ ${#files[@]} -eq 0 ]] && { echo "❌ 找不到圖片"; return 1; }
    _img_batch_process
    
    local total=${#files[@]}
    local tmp_file=$(mktemp)
    
    echo "☕️ 正在後臺縮放 ${total} 張圖片 (寬度: ${width}px) ..."
    local started=0
    for f in "${files[@]}"; do
        local out=$(_img_basic_get_out "$f" "png")
        _img_wait_jobs "$tmp_file" "$total" "正在縮放: $f" "$started"
        {
            magick "$f" -auto-orient -resize "${width}x" "$out" >/dev/null 2>&1
            echo "." >> "$tmp_file"
        } &
        (( started++ ))
    done

    _img_wait_all "$tmp_file" "$total"
    _img_show_progress "$total" "$total" "縮放完成！"
    echo "" && rm "$tmp_file"
}

# 2. 批量轉 PNG
img-to-png() {
    local files=( $~_IMG_PATTERN )
    [[ ${#files[@]} -eq 0 ]] && { echo "❌ 找不到圖片"; return 1; }
    _img_batch_process
    local total=${#files[@]}
    local tmp_file=$(mktemp)
    
    echo "☕️ 正在後臺轉換 ${total} 張圖片為 PNG ..."
    local started=0
    for f in "${files[@]}"; do
        local out=$(_img_basic_get_out "$f" "png")
        _img_wait_jobs "$tmp_file" "$total" "正在轉換: $f" "$started"
        {
            magick "$f" -auto-orient "$out" >/dev/null 2>&1
            echo "." >> "$tmp_file"
        } &
        (( started++ ))
    done
    _img_wait_all "$tmp_file" "$total"
    _img_show_progress "$total" "$total" "轉換完成！"
    echo "" && rm "$tmp_file"
}

# 3. 批量轉 JPG
img-to-jpg() {
    local files=( $~_IMG_PATTERN )
    [[ ${#files[@]} -eq 0 ]] && { echo "❌ 找不到圖片"; return 1; }
    _img_batch_process
    local total=${#files[@]}
    local tmp_file=$(mktemp)
    
    echo "☕️ 正在後臺轉換 ${total} 張圖片為 JPG ..."
    local started=0
    for f in "${files[@]}"; do
        local out=$(_img_basic_get_out "$f" "jpg")
        _img_wait_jobs "$tmp_file" "$total" "正在轉換: $f" "$started"
        {
            magick "$f" -auto-orient "$out" >/dev/null 2>&1
            echo "." >> "$tmp_file"
        } &
        (( started++ ))
    done
    _img_wait_all "$tmp_file" "$total"
    _img_show_progress "$total" "$total" "轉換完成！"
    echo "" && rm "$tmp_file"
}

# 4. 批量轉 WebP
img-to-webp() {
    local files=( $~_IMG_PATTERN )
    [[ ${#files[@]} -eq 0 ]] && { echo "❌ 找不到圖片"; return 1; }
    _img_batch_process
    local total=${#files[@]}
    local tmp_file=$(mktemp)
    
    echo "☕️ 正在後臺轉換 ${total} 張圖片為 WebP ..."
    local started=0
    for f in "${files[@]}"; do
        local out=$(_img_basic_get_out "$f" "webp")
        _img_wait_jobs "$tmp_file" "$total" "正在轉換: $f" "$started"
        {
            magick "$f" -auto-orient -quality 80 -define webp:method=6 "$out" >/dev/null 2>&1
            echo "." >> "$tmp_file"
        } &
        (( started++ ))
    done
    _img_wait_all "$tmp_file" "$total"
    _img_show_progress "$total" "$total" "轉換完成！"
    echo "" && rm "$tmp_file"
}

# 5. 批量無損壓縮
img-lossless() {
    local fmt=${1:-png}
    local files=( $~_IMG_PATTERN )
    [[ ${#files[@]} -eq 0 ]] && { echo "❌ 找不到圖片"; return 1; }
    _img_batch_process
    local total=${#files[@]}
    local tmp_file=$(mktemp)
    
    echo "☕️ 正在後臺無損壓縮 ${total} 張圖片 (${fmt}) ..."
    local started=0
    for f in "${files[@]}"; do
        local out=$(_img_basic_get_out "$f" "$fmt")
        _img_wait_jobs "$tmp_file" "$total" "正在壓縮: $f" "$started"
        {
            if [[ "$fmt" == "webp" ]]; then
                magick "$f" -auto-orient -define webp:lossless=true "$out" >/dev/null 2>&1
            else
                magick "$f" -auto-orient -define png:compression-level=9 "$out" >/dev/null 2>&1
            fi
            echo "." >> "$tmp_file"
        } &
        (( started++ ))
    done
    _img_wait_all "$tmp_file" "$total"
    _img_show_progress "$total" "$total" "壓縮完成！"
    echo "" && rm "$tmp_file"
}

# 6. 批量剪裁
img-crop() {
    local geometry=$1
    local files=( $~_IMG_PATTERN )
    [[ -z "$geometry" || ${#files[@]} -eq 0 ]] && { echo "❌ 用法: img-crop <geometry>（例: 1080x1080+0+0）"; return 1; }
    _img_batch_process
    local total=${#files[@]}
    local tmp_file=$(mktemp)
    
    echo "☕️ 正在後臺剪裁 ${total} 張圖片 (${geometry}) ..."
    local started=0
    for f in "${files[@]}"; do
        local out=$(_img_basic_get_out "$f" "png")
        _img_wait_jobs "$tmp_file" "$total" "正在剪裁: $f" "$started"
        {
            magick "$f" -auto-orient -gravity NorthWest -crop "$geometry" +repage "$out" >/dev/null 2>&1
            echo "." >> "$tmp_file"
        } &
        (( started++ ))
    done
    _img_wait_all "$tmp_file" "$total"
    _img_show_progress "$total" "$total" "剪裁完成！"
    echo "" && rm "$tmp_file"
}

# 7. 合併圖片為 GIF
img-to-gif() {
    local delay=${1:-20}
    local name=${2:-animation}
    local files=( $~_IMG_PATTERN )
    [[ ${#files[@]} -eq 0 ]] && { echo "❌ 找不到圖片"; return 1; }
    echo "🎞️ 正在生成 GIF: ${name}.gif (延遲: ${delay}) ..."
    local -a gif_frames
    for x in "${files[@]}"; do
        gif_frames+=( \( "$x" -auto-orient \) )
    done
    magick -delay "$delay" -loop 0 "${gif_frames[@]}" "${name}.gif"
    echo "✅ GIF 生成完成！"
}

# 8. 批量旋轉
img-rotate() {
    local angle=${1:-90}
    local files=( $~_IMG_PATTERN )
    [[ ${#files[@]} -eq 0 ]] && { echo "❌ 找不到圖片"; return 1; }
    _img_batch_process
    local total=${#files[@]}
    local tmp_file=$(mktemp)
    
    echo "☕️ 正在旋轉 ${total} 張圖片 (${angle}°) ..."
    local started=0
    for f in "${files[@]}"; do
        local out=$(_img_basic_get_out "$f" "png")
        _img_wait_jobs "$tmp_file" "$total" "正在旋轉: $f" "$started"
        {
            magick "$f" -auto-orient -rotate "$angle" "$out" >/dev/null 2>&1
            echo "." >> "$tmp_file"
        } &
        (( started++ ))
    done
    _img_wait_all "$tmp_file" "$total"
    _img_show_progress "$total" "$total" "旋轉完成！"
    echo "" && rm "$tmp_file"
}

# 9. 批量優化質量 (降低體積)
img-optimize() {
    local quality=${1:-75}
    local files=( $~_IMG_PATTERN )
    [[ ${#files[@]} -eq 0 ]] && { echo "❌ 找不到圖片"; return 1; }
    _img_batch_process
    local total=${#files[@]}
    local tmp_file=$(mktemp)
    
    echo "☕️ 正在優化 ${total} 張圖片質量為 ${quality} ..."
    local started=0
    for f in "${files[@]}"; do
        local out=$(_img_basic_get_out "$f" "jpg")
        _img_wait_jobs "$tmp_file" "$total" "正在優化: $f" "$started"
        {
            magick "$f" -auto-orient -quality "$quality" "$out" >/dev/null 2>&1
            echo "." >> "$tmp_file"
        } &
        (( started++ ))
    done
    _img_wait_all "$tmp_file" "$total"
    _img_show_progress "$total" "$total" "優化完成！"
    echo "" && rm "$tmp_file"
}
