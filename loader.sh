#!/bin/zsh
# loader.sh - HImageTools 藝術工具集主加載器 (原子化模組版本)

# 1. 確保全局路徑變數 (絕對路徑)
export _IMG_ROOT="$(cd "$(dirname "$0")" && pwd)"

# 2. 加載基礎配置
source "$_IMG_ROOT/config.zsh"

# 3. 加載核心工具與去背工具
source "$_IMG_ROOT/basic.zsh"
source "$_IMG_ROOT/rembg.zsh"

# 4. 全自動加載藝術風格模組 (動態發現)
for f in "$_IMG_ROOT"/styles/*.zsh(N); do
    source "$f"
done

# 5. 加載交互選單引擎與主入口
source "$_IMG_ROOT/interactive_menu.zsh"
source "$_IMG_ROOT/config.zsh" # 再次加載以確保覆蓋
source "$_IMG_ROOT/menu_manifest.zsh"
source "$_IMG_ROOT/artify_all.zsh"
source "$_IMG_ROOT/artify_test.zsh"
source "$_IMG_ROOT/artify_main.zsh"

# 6. 啟動插件註冊掃描
_img_registry_build_menu

echo "🖼️  HImageTools 藝術工具集 (V5.0 插件化自動版) 已加載完成"
echo "   輸入 img-artify 啟動全功能交互選單"