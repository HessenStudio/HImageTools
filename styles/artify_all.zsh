#!/bin/zsh
# styles/artify_all.zsh - 一鍵生成全風格藝術畫廊

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

    # 2. 取得所有風格
    local manifest="${_IMG_ROOT}/menu_manifest.zsh"
    if [[ ! -f "$manifest" ]]; then
        echo "❌ 找不到功能清單: $manifest"
        return 1
    fi

    local -a artify_cmds
    artify_cmds=($(grep "cmd:img-artify" "$manifest" | sed -E 's/.*cmd:img-artify ([^"]+).*/\1/'))

    echo "🎨 啟動一鍵藝術化全家桶！"
    echo "📦 目標: ${#files[@]} 張圖片 | 🎨 風格: ${#artify_cmds[@]} 種"
    echo "📂 輸出: $out_base"
    echo "-----------------------------------------------"

    mkdir -p "$out_base"

    local img_count=0
    for f in "${files[@]}"; do
        ((img_count++))
        local stem=$(basename "${f%.*}")
        local img_out_dir="${out_base}/${stem}"
        mkdir -p "$img_out_dir"
        
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
    
    # 準備 JSON 數據
    local json_data="const artifyData = {"
    for d in "${base}"/*(/); do
        local stem=$(basename "$d")
        [[ "$stem" == "assets" ]] && continue
        
        json_data+="\"$stem\": ["
        for img in "$d"/*.png; do
            local style_name=$(basename "$img" .png)
            json_data+="\"$style_name\","
        done
        json_data=${json_data%?} 
        json_data+="],"
    done
    json_data=${json_data%?}
    json_data+="};"

    cat <<EOF > "$html"
<!DOCTYPE html>
<html lang="zh-TW">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Artify Master Gallery</title>
    <style>
        :root { --bg: #050505; --sidebar: #0f0f0f; --card: #161616; --accent: #00d1ff; --text: #fff; --text-dim: #888; }
        * { box-sizing: border-box; }
        body { font-family: -apple-system, system-ui, sans-serif; background: var(--bg); color: var(--text); margin: 0; display: flex; height: 100vh; overflow: hidden; }
        
        /* Custom Scrollbar */
        ::-webkit-scrollbar { width: 6px; }
        ::-webkit-scrollbar-track { background: transparent; }
        ::-webkit-scrollbar-thumb { background: #333; border-radius: 10px; }
        ::-webkit-scrollbar-thumb:hover { background: var(--accent); }

        /* Sidebar: Master List */
        aside { width: 260px; background: var(--sidebar); border-right: 1px solid #222; display: flex; flex-direction: column; flex-shrink: 0; }
        aside header { padding: 25px 15px; border-bottom: 1px solid #222; }
        aside h1 { font-size: 18px; font-weight: 300; letter-spacing: 2px; color: var(--accent); margin: 0; }
        .master-list { flex: 1; overflow-y: auto; padding: 15px; }
        .master-item { margin-bottom: 15px; cursor: pointer; transition: 0.3s; border: 2px solid transparent; border-radius: 10px; overflow: hidden; position: relative; }
        .master-item:hover { transform: scale(1.02); }
        .master-item.active { border-color: var(--accent); box-shadow: 0 0 15px rgba(0,209,255,0.3); }
        .master-item img { width: 100%; height: 120px; object-fit: cover; display: block; opacity: 0.6; }
        .master-item.active img { opacity: 1; }
        .master-item .meta { position: absolute; bottom: 0; left: 0; right: 0; background: rgba(0,0,0,0.7); padding: 5px 10px; font-size: 11px; font-family: monospace; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }

        /* Main Content: Style Gallery */
        main { flex: 1; overflow-y: auto; padding: 40px; scroll-behavior: smooth; position: relative; }
        .gallery-header { margin-bottom: 40px; }
        .gallery-header h2 { font-size: 28px; font-weight: 300; margin: 0; display: flex; align-items: center; gap: 15px; }
        .gallery-header h2 span { font-size: 14px; color: var(--text-dim); border: 1px solid #333; padding: 2px 10px; border-radius: 20px; }
        
        .grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(280px, 1fr)); gap: 25px; animation: fadeIn 0.5s ease-out; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(10px); } to { opacity: 1; transform: translateY(0); } }

        /* Cards */
        .card { background: var(--card); border-radius: 12px; overflow: hidden; cursor: pointer; border: 1px solid #222; transition: 0.3s; }
        .card:hover { border-color: var(--accent); transform: scale(1.02); }
        .img-box { width: 100%; height: 200px; background: #000; overflow: hidden; }
        .img-box img { width: 100%; height: 100%; object-fit: cover; transition: 0.5s; }
        .card:hover .img-box img { object-fit: contain; }
        .info { padding: 12px; text-align: center; font-size: 12px; font-family: monospace; color: var(--text-dim); }

        /* Lightbox */
        #lightbox { position: fixed; inset: 0; background: rgba(0,0,0,0.95); z-index: 1000; display: none; flex-direction: column; align-items: center; justify-content: center; padding: 40px; cursor: zoom-out; }
        #lightbox img { max-width: 95%; max-height: 90vh; border-radius: 5px; box-shadow: 0 0 60px rgba(0,0,0,1); }
        #lightbox .caption { margin-top: 20px; color: var(--accent); font-family: monospace; letter-spacing: 1px; }

        @media (max-width: 800px) {
            body { flex-direction: column; }
            aside { width: 100%; height: 180px; border-right: none; border-bottom: 1px solid #222; }
            .master-list { display: flex; gap: 15px; padding-bottom: 10px; }
            .master-item { width: 140px; flex-shrink: 0; margin-bottom: 0; }
        }
    </style>
</head>
<body>

<aside>
    <header><h1>ARTIFY MASTER</h1></header>
    <div class="master-list" id="master-list"></div>
</aside>

<main id="gallery-container">
    <div class="gallery-header">
        <h2 id="current-title">Select an image <span id="current-count">0 Styles</span></h2>
    </div>
    <div id="style-grid" class="grid"></div>
</main>

<div id="lightbox" onclick="this.style.display='none'">
    <img id="lightbox-img">
    <div class="caption" id="lightbox-caption"></div>
</div>

<script>
    $json_data

    const masterList = document.getElementById('master-list');
    const styleGrid = document.getElementById('style-grid');
    const currentTitle = document.getElementById('current-title');
    const currentCount = document.getElementById('current-count');

    function init() {
        const stems = Object.keys(artifyData);
        if (stems.length === 0) return;

        stems.forEach((stem, index) => {
            const item = document.createElement('div');
            item.className = 'master-item' + (index === 0 ? ' active' : '');
            item.id = 'master-' + stem;
            const coverImg = stem + '/' + artifyData[stem][0] + '.png';
            item.innerHTML = \`
                <img src="\${coverImg}" loading="lazy">
                <div class="meta">\${stem}</div>
            \`;
            item.onclick = () => selectMaster(stem);
            masterList.appendChild(item);
        });

        // 默認選中第一個
        selectMaster(stems[0]);
    }

    function selectMaster(stem) {
        // 更新側邊欄狀態
        document.querySelectorAll('.master-item').forEach(el => el.classList.remove('active'));
        document.getElementById('master-' + stem).classList.add('active');

        // 更新標題
        currentTitle.firstChild.textContent = stem + ' ';
        currentCount.innerText = artifyData[stem].length + ' Styles';

        // 渲染網格
        styleGrid.innerHTML = '';
        artifyData[stem].forEach(style => {
            const card = document.createElement('div');
            card.className = 'card';
            const imgPath = stem + '/' + style + '.png';
            card.innerHTML = \`
                <div class="img-box"><img src="\${imgPath}" loading="lazy"></div>
                <div class="info">\${style}</div>
            \`;
            card.onclick = () => openLightbox(imgPath, style);
            styleGrid.appendChild(card);
        });
        
        document.getElementById('gallery-container').scrollTop = 0;
    }

    function openLightbox(src, title) {
        const lb = document.getElementById('lightbox');
        document.getElementById('lightbox-img').src = src;
        document.getElementById('lightbox-caption').innerText = title.toUpperCase();
        lb.style.display = 'flex';
    }

    init();
</script>

</body>
</html>
EOF
}


