#!/bin/zsh
# config.zsh - ImageMagick 工具集全局配置與通用函數

# 啟用擴展通配符並關閉背景任務通知
setopt extended_glob
setopt no_monitor
setopt no_notify

# --- 🚀 背景靜默處理設置 (針對 20MB-200MB 大圖優化) ---
# 1. 限制單個進程僅使用 1 個線程，確保不影響開發/設計任務的 CPU 響應
export MAGICK_THREAD_LIMIT=2
# 2. 嚴格限制 RAM 佔用，超出部分自動轉向硬碟緩存 (慢但安全)
export MAGICK_MEMORY_LIMIT=1GiB
export MAGICK_MAP_LIMIT=2GiB
export MAGICK_AREA_LIMIT=512MiB
# 3. 使用低優先級模式運行 (nice 19)，確保 UI 與開發工具永遠優先
magick() {
    nice -n 19 command magick "$@"
}
# -----------------------------------------------------

# --- 🛡️ 資源守護門檻 (Resource Watchdog) ---
export IMAGE_SAFE_RAM_LIMIT=3   # 降低門檻至 3%，增加容錯，防止過於敏感
export _WATCHDOG_PID=0

# 獲取更精確的 macOS 可用內存 (MB)
_img_get_available_mem() {
    # 獲取系統統計數據
    local vm_stats=$(vm_stat)
    local page_size=$(sysctl -n hw.pagesize)

    # 提取各項頁數 (free, inactive, purgeable)
    local free_p=$(echo "$vm_stats" | awk '/Pages free/ {print $3}' | tr -d '.')
    local inactive_p=$(echo "$vm_stats" | awk '/Pages inactive/ {print $3}' | tr -d '.')
    local purgeable_p=$(echo "$vm_stats" | awk '/Pages purgeable/ {print $3}' | tr -d '.')

    # 可用內存 = 自由頁 + 非活躍頁 + 可清除頁
    # 在 macOS 中，inactive 和 purgeable 在壓力下會被回收，算作可用
    local total_available_pages=$(( free_p + inactive_p + purgeable_p ))
    echo $(( total_available_pages * page_size / 1024 / 1024 ))
}

# 資源監控核心邏輯
_img_resource_monitor() {
    local parent_pid=$1
    local total_mem=$(sysctl -n hw.memsize | awk '{print $1 / 1024 / 1024}')

    while true; do
        local available_mem=$(_img_get_available_mem)
        local free_percent=$(( available_mem * 100 / total_mem ))

        if [[ $free_percent -lt $IMAGE_SAFE_RAM_LIMIT ]]; then
            echo -e "\n\n\033[1;33m⚠️  系統內存極低 (僅剩 ${free_percent}%)，正在嘗試安全中止任務...\033[0m"

            # 先嘗試溫和殺死所有 magick 子進程 (SIGTERM)
            pkill -TERM -P $parent_pid
            killall -TERM magick 2>/dev/null

            # 通知父進程中止 (發送 SIGUSR1，父進程需捕獲)
            kill -USR1 $parent_pid 2>/dev/null

            # 等待 2 秒，如果不奏效再發送 SIGINT
            sleep 2
            kill -INT $parent_pid 2>/dev/null

            exit 1
        fi
        sleep 3 # 稍微增加掃描間隔，減少監控本身的開銷
    done
}

# 啟動守護進程
_img_start_watchdog() {
    # 設置父進程捕獲 USR1 信號以優雅退出
    trap "_img_handle_interrupt" USR1 INT TERM

    _img_resource_monitor $$ &
    _WATCHDOG_PID=$!
}

# 處理中斷的統一入口
_img_handle_interrupt() {
    echo -e "\n\033[1;31m🛑 任務已中止。正在清理殘留進程...\033[0m"
    _img_stop_watchdog

    # 殺死當前進程組中的所有子任務
    local pgid=$(ps -o pgid= -p $$ | tr -d ' ')
    [[ -n "$pgid" ]] && kill -TERM -$pgid 2>/dev/null

    # 強制重置終端狀態，防止假死
    stty sane 2>/dev/null
    echo -e "\033[0m"
    exit 1
}

# 關閉守護進程
_img_stop_watchdog() {
    if [[ $_WATCHDOG_PID -ne 0 ]]; then
        kill -TERM $_WATCHDOG_PID 2>/dev/null
        wait $_WATCHDOG_PID 2>/dev/null
    fi
    _WATCHDOG_PID=0
}
# ---------------------------------------

# 自動創建輸出目錄並啟動監控
_img_batch_process() {
    local target_dir="processed"
    [[ ! -d "$target_dir" ]] && mkdir -p "$target_dir"

    # 設置陷阱以確保腳本結束（正常或異常）時關閉監控
    trap "_img_stop_watchdog" EXIT
    _img_start_watchdog
}

# 獲取當前目錄下所有圖片 (不區分大小寫，安全處理空格)
_IMG_PATTERN="(#i)*.(jpg|jpeg|png|webp|tiff)(N)"

# 資源平衡機制：根據 RAM 總量自動決定併發數
# 雖然 nice 19 限制了 CPU，但內存是硬性指標
_img_get_dynamic_jobs() {
    local total_mem_gb=$(sysctl -n hw.memsize | awk '{print int($1 / 1024 / 1024 / 1024)}')
    if [[ $total_mem_gb -le 8 ]]; then
        echo 1 # 8GB 或以下僅開啟單線程串行，最安全
    elif [[ $total_mem_gb -le 16 ]]; then
        echo 2 # 16GB 開啟 2 併發
    else
        echo 4 # 32GB+ 可開啟 4 併發
    fi
}

MAX_JOBS=${IMAGE_MAX_JOBS:-$(_img_get_dynamic_jobs)}

# 顯示批量處理進度
_img_show_progress() {
    local current=$1
    local total=$2
    local msg=${3:-正在處理中...}
    # 增加內存狀態顯示，讓用戶心中有數
    local mem=$(_img_get_available_mem)
    printf "\r☕️ 處理中 %d/%d | 剩餘內存: %dMB | %s\033[K" "$current" "$total" "$mem" "$msg"
}


# 任務隊列管理 (無狀態計數器版：解決 Zsh jobs 表更新不准確的問題)
_img_wait_jobs() {
    local tmp_file=$1
    local total=$2
    local msg=$3
    local started_count=$4 # 傳入當前已分派的任務總數
    
    while true; do
        local completed_count=$(wc -l < "$tmp_file")
        # 當前運行中 = 已分派 - 已完成
        local running=$(( started_count - completed_count ))
        
        # 如果運行中的任務少於併發限制，則准許啟動新任務
        if [[ $running -lt $MAX_JOBS ]]; then
            break
        fi
        
        _img_show_progress "$completed_count" "$total" "$msg (併發滿載中)"
        sleep 0.5
    done
}

_img_wait_all() {
    local tmp_file=$1
    local total=$2
    local completed=0
    
    # 嚴格等待：直到完成數等於總數
    while [[ $completed -lt $total ]]; do
        completed=$(wc -l < "$tmp_file")
        _img_show_progress "$completed" "$total" "正在收尾 (等待最後任務)..."
        [[ $completed -ge $total ]] && break
        sleep 0.5
    done
    
    # 物理等待所有子進程退出
    wait
    _img_stop_watchdog
}

# --- 輸出命名（img-artify）與 EXIF 方向 ---
# 風格參數轉文件名前綴：子風格以冒號連接時改為單下劃線（例 oil:classical -> oil_classical；無子風格則為 oil）
_img_style_to_prefix() {
    local s=$1
    s=${s//:/_}
    s=${s//[^a-zA-Z0-9_-]/_}
    while [[ "$s" == *__* ]]; do s=${s//__/_}; done
    s=${s#_}
    s=${s%_}
    [[ -z "$s" ]] && s="artify"
    print -r -- "$s"
}

# 原圖主檔名 + 副檔名（點改為 _），避免同目錄 photo.jpg / photo.png 輸出撞名
_img_stem_from_file() {
    local base=${1:t}
    base=${base//./_}
    [[ -z "$base" ]] && base="image"
    print -r -- "$base"
}

# processed/ 下唯一路徑：prefix_stem.ext，已存在則 prefix_stem_2.ext、_3 …
_img_next_output_path() {
    local prefix=$1 stem=$2 ext=${3:-png} dir=${4:-processed}
    [[ -d "$dir" ]] || mkdir -p "$dir"
    local base="${dir}/${prefix}_${stem}.${ext}"
    if [[ ! -e "$base" ]]; then
        print -r -- "$base"
        return
    fi
    local n=2
    while [[ -e "${dir}/${prefix}_${stem}_${n}.${ext}" ]]; do
        ((n++))
    done
    print -r -- "${dir}/${prefix}_${stem}_${n}.${ext}"
}

