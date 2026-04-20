#!/bin/zsh
# loader.sh - ImageMagick 工具集主加載器 (原子化模組版本)

# 1. 確保全局路徑變數 (絕對路徑)
export _IMG_ROOT="$(cd "$(dirname "$0")" && pwd)"

# 2. 加載基礎配置
source "$_IMG_ROOT/config.zsh"

# 3. 加載核心工具與去背工具
source "$_IMG_ROOT/basic.zsh"
source "$_IMG_ROOT/rembg.zsh"

# 4. 加載藝術風格模組
source "$_IMG_ROOT/styles/oil.zsh"
source "$_IMG_ROOT/styles/sketch.zsh"
source "$_IMG_ROOT/styles/watercolor.zsh"
source "$_IMG_ROOT/styles/vin_wc.zsh"
source "$_IMG_ROOT/styles/vintage.zsh"
source "$_IMG_ROOT/styles/etching.zsh"

# 5. 加載輕量風格模組
source "$_IMG_ROOT/styles/cartoon.zsh"
source "$_IMG_ROOT/styles/popart.zsh"
source "$_IMG_ROOT/styles/marker.zsh"
source "$_IMG_ROOT/styles/illust.zsh"
source "$_IMG_ROOT/styles/handpaint.zsh"
source "$_IMG_ROOT/styles/pixelate.zsh"

source "$_IMG_ROOT/styles/duotone.zsh"
source "$_IMG_ROOT/styles/sepia.zsh"
source "$_IMG_ROOT/styles/night.zsh"
source "$_IMG_ROOT/styles/vignette.zsh"
source "$_IMG_ROOT/styles/effects.zsh"
source "$_IMG_ROOT/styles/artify_all.zsh"
source "$_IMG_ROOT/styles/artify_test.zsh"

# 6. 加載交互選單引擎、功能清單與主入口
source "$_IMG_ROOT/interactive_menu.zsh"
source "$_IMG_ROOT/menu_manifest.zsh"
source "$_IMG_ROOT/artify_main.zsh"
source "$_IMG_ROOT/styles/misc.zsh"

echo "🖼️  ImageMagick 工具集 (V2.2 模組化旗艦版) 已加載完成"
echo "   輸入 img-artify 啟動全功能交互選單"