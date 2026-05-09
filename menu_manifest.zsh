#!/bin/zsh
# menu_manifest.zsh - HImageTools 功能清單配置 (V5.0 插件化自動版)
# 格式：唯一ID | 父節點ID | 標題 | 描述 | 動作類型:參數

IMG_MENU_DATA=(
    # ==========================================
    # --- 頂層目錄 (ParentID 為 0) ---
    # ==========================================
    "artify_root | 0 | 🎨 藝術濾鏡 | 100+ 種專業藝術化風格 | folder"
    "rembg_root  | 0 | ✂️ 智能去背 | AI 智慧識別與指定色去背 | folder"
    "basic_root  | 0 | 🛠️ 基礎工具 | 縮放、轉檔、剪裁、旋轉、壓縮 | folder"
    "sys_root    | 0 | 🧹 系統維護 | 清理快取、查看當前配置 | folder"

    # ==========================================
    # --- 1. 藝術濾鏡頂級門類 ---
    # ==========================================
    "cat_illust  | artify_root | 🎨 專業插畫 (Illustration) | 手繪彩繪、商務插畫、馬克筆 | folder"
    "cat_cartoon | artify_root | 🎭 漫畫動漫 (Cartoon) | 日系動漫、美系漫畫、線稿 | folder"
    "cat_classic | artify_root | 🖼️ 經典繪畫 (Classic) | 水彩系列、油畫、素描 | folder"
    "cat_vintage | artify_root | 🎞️ 復古時光 (Vintage) | 復古底片、棕褐、Lomo、夜景 | folder"
    "cat_modern  | artify_root | ✨ 現代藝術 (Modern) | 普普、像素、雙色調 | folder"
    "cat_etching | artify_root | 🏛️ 材質蝕刻 (Etching) | 紙雕、石雕、金雕 | folder"
    "cat_effects | artify_root | 🔮 特殊特效 (Effects) | 暗角、漩渦、色散 | folder"
)

# @menu: sys_clean   | sys_root | 🧹 清理 processed | 移除所有處理後的圖片 | cmd:rm -rf processed/*.png processed/*.jpg processed/*.webp
# @menu: sys_info    | sys_root | ⚙️ 診斷資訊 | 查看環境與匹配模式 | cmd:img-sys-info

# --- 輔助函數 ---
img-sys-info() {
    echo -e "\033[1;36m--- HImageTools 系統診斷 ---\033[0m"
    echo "📂 當前工作路徑: $(pwd)"
    echo "🖼️ 圖片匹配模式: $_IMG_PATTERN"
    local plugin_count=${#IMG_MENU_DATA[@]}
    echo "🔌 已加載插件項: $plugin_count"
    echo "--------------------------------"
}
