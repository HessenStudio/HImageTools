#!/bin/zsh
# interactive_menu.zsh - ImageMagickTools 宣告式選單引擎 (V3.0)

# 導覽棧：記錄當前路徑 (ID)
typeset -a _IMG_NAV_STACK
_IMG_NAV_STACK=("0")

_img_select_menu_v3() {
    local parent_id=$1
    local -a current_options=()
    local -a raw_actions=()
    
    # 1. 自動尋找子項目
    for entry in "${IMG_MENU_DATA[@]}"; do
        local id="${entry%%|*}"
        id="${id// /}" # 去除空格
        local data="${entry#*|}"
        local pid="${data%%|*}"
        pid="${pid// /}" # 去除空格
        
        if [[ "$pid" == "$parent_id" ]]; then
            local label_desc="${data#*|}"
            local label="${label_desc%%|*}"
            local desc_action="${label_desc#*|}"
            local desc="${desc_action%%|*}"
            local action="${desc_action#*|}"
            
            # 去除多餘空格
            label="${label#"${label%%[![:space:]]*}"}"
            label="${label%"${label##*[![:space:]]*}"}"
            desc="${desc#"${desc%%[![:space:]]*}"}"
            desc="${desc%"${desc##*[![:space:]]*}"}"
            action="${action#"${action%%[![:space:]]*}"}"
            action="${action%"${action##*[![:space:]]*}"}"

            current_options+=("$label|$desc")
            raw_actions+=("$id|$action")
        fi
    done

    # 2. 如果不是根目錄，自動添加返回鍵
    if [[ "$parent_id" != "0" ]]; then
        current_options=("⬅️ 返回上一層|Back" "${current_options[@]}")
        raw_actions=("back|pop" "${raw_actions[@]}")
    else
        current_options+=("❌ 退出選單|Exit")
        raw_actions+=("exit|quit")
    fi

    # 3. 呼叫底層渲染 (借用 V2.1 的渲染邏輯)
    _img_render_ui "功能導覽" "${current_options[@]}"
    local choice=$?
    
    # 處理返回或退出
    if [[ $choice -eq 0 ]]; then return 0; fi # ESC
    
    local selected_action_data="${raw_actions[choice]}"
    local selected_id="${selected_action_data%%|*}"
    local action="${selected_action_data#*|}"

    if [[ "$selected_id" == "back" ]]; then
        return 99 # 特殊代碼：返回
    elif [[ "$selected_id" == "exit" ]]; then
        return 0
    fi

    # 4. 執行動作
    if [[ "$action" == "folder" ]]; then
        _IMG_NAV_STACK+=("$selected_id")
        return 100 # 特殊代碼：進入文件夾
    elif [[ "$action" == cmd:* ]]; then
        local cmd="${action#cmd:}"
        eval "$cmd"
        return 101 # 特殊代碼：執行完畢
    elif [[ "$action" == input:* ]]; then
        local input_data="${action#input:}"
        local prompt="${input_data%%:*}"
        local remaining="${input_data#*:}"
        local default="${remaining%%:*}"
        local func="${remaining#*:}"
        
        local user_val
        vared -p "$prompt ($default): " -c user_val
        eval "$func \"${user_val:-$default}\""
        return 101
    fi
}

# 渲染核心 (V2.1 邏輯優化)
_img_render_ui() {
    local title=$1
    shift
    local options=("$@")
    local cur=0
    local total=${#options[@]}
    local key

    tput civis
    _draw() {
        echo "\r\n🎨 \033[1;36m$title\033[0m"
        local i=0
        for opt in "${options[@]}"; do
            local name="${opt%%|*}"
            local desc="${opt#*|}"
            if [[ $i -eq $cur ]]; then
                echo "  \033[1;33m➜ \033[1;37m$name\033[0m \033[0;90m$desc\033[0m"
            else
                echo "    \033[0;37m$name\033[0m \033[0;90m$desc\033[0m"
            fi
            ((i++))
        done
        echo "\n\033[0;90m(↑/↓ 切換，Enter 確認，ESC 返回)\033[0m"
    }
    _clear() { tput cuu $((total + 4)); tput ed; }

    _draw
    while true; do
        read -sk 1 key
        case "$key" in
            $'\e')
                read -t 0.05 -sk 2 key
                if [[ $? -ne 0 ]]; then _clear; tput cnorm; return 0; fi
                case "$key" in
                    '[A') ((cur = (cur - 1 + total) % total)) ;;
                    '[B') ((cur = (cur + 1) % total)) ;;
                esac ;;
            $'\n'|$'\r'|"") _clear; tput cnorm; return $((cur + 1)) ;;
            $'\x03') _clear; tput cnorm; exit 1 ;;
        esac
        _clear; _draw
    done
}

img-menu() {
    _IMG_NAV_STACK=("0")
    while true; do
        local current_pid="${_IMG_NAV_STACK[-1]}"
        _img_select_menu_v3 "$current_pid"
        local res=$?
        
        if [[ $res -eq 0 ]]; then # 退出
            if [[ ${#_IMG_NAV_STACK[@]} -le 1 ]]; then break; else _IMG_NAV_STACK[-1]=(); fi
        elif [[ $res -eq 99 ]]; then # 返回
            _IMG_NAV_STACK[-1]=()
            if [[ ${#_IMG_NAV_STACK[@]} -eq 0 ]]; then break; fi
        fi
    done
}
