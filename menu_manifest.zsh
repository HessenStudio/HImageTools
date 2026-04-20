#!/bin/zsh
# menu_manifest.zsh - ImageMagickTools 功能清單配置 (V4.5 終極完全版)
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
    "art_all     | artify_root | 🚀 一鍵藝術化全家桶 | 自動生成 100+ 種全風格畫廊 | input:請輸入圖片目錄路徑:./:img-artify-all"
    "cat_illust  | artify_root | 🎨 專業插畫 (Illustration) | 手繪彩繪、商務插畫、馬克筆 | folder"
    "cat_cartoon | artify_root | 🎭 漫畫動漫 (Cartoon) | 日系動漫、美系漫畫、線稿 | folder"
    "cat_classic | artify_root | 🖼️ 經典繪畫 (Classic) | 水彩系列、油畫、素描 | folder"
    "cat_vintage | artify_root | 🎞️ 復古時光 (Vintage) | 復古底片、棕褐、Lomo、夜景 | folder"
    "cat_modern  | artify_root | ✨ 現代藝術 (Modern) | 普普、像素、雙色調 | folder"
    "cat_etching | artify_root | 🏛️ 材質蝕刻 (Etching) | 紙雕、石雕、金雕 | folder"
    "cat_effects | artify_root | 🔮 特殊特效 (Effects) | 暗角、漩渦、色散 | folder"

    # ==========================================
    # --- 1.1 專業插畫系列 ---
    # ==========================================
    "sub_hp_grp  | cat_illust  | 🖍️ 手繪彩繪 (Hand-Painted) | 結構墨線與色塊填充 | folder"
    "sub_marker  | cat_illust  | 🖊️ 馬克筆插畫 (Marker) | 56 色專業馬克筆手繪 | folder"
    "art_illust  | cat_illust  | 🏢 商務插畫 | 簡潔扁平化商務風格 | cmd:img-artify cartoon:illust"
    "art_clear   | cat_illust  | 🇪🇺 歐式插畫 | Ligne Claire 極簡線條感 | cmd:img-artify cartoon:clear"
    
    # --- 1.1.1 手繪彩繪細項 ---
    "hp_std      | sub_hp_grp | 標準手繪 | 結構清晰，色塊均勻 | cmd:img-artify handpaint"
    "hp_vib      | sub_hp_grp | 鮮豔插畫 | 高飽和，強對比 | cmd:img-artify handpaint:vibrant"
    "hp_soft     | sub_hp_grp | 清新淡雅 | 灰墨線，淡色調 | cmd:img-artify handpaint:soft"
    "hp_hvy      | sub_hp_grp | 厚重藝術 | 強墨線，濃郁感 | cmd:img-artify handpaint:heavy"

    # --- 1.1.2 馬克筆色系分組 (56色補完) ---
    "mk_pal      | sub_marker | 🎨 生成全色卡預覽 | 查看所有 56 種顏色 | cmd:img-artify marker:palette"
    "mk_grp_gray | sub_marker | 🪙 基礎與灰階 (Basic) | | folder"
    "mk_grp_red  | sub_marker | 🍎 紅粉系列 (Red/Pink) | | folder"
    "mk_grp_yell | sub_marker | 🧀 黃橙大地 (Yellow/Brown) | | folder"
    "mk_grp_gree | sub_marker | 🍃 綠色系列 (Green) | | folder"
    "mk_grp_blue | sub_marker | 🌊 藍紫系列 (Blue/Purple) | | folder"

    "mk_black    | mk_grp_gray | 經典黑 (Black) | | cmd:img-artify marker:black"
    "mk_silver   | mk_grp_gray | 銀色 (Silver) | | cmd:img-artify marker:silver"
    "mk_gray     | mk_grp_gray | 灰色 (Gray) | | cmd:img-artify marker:gray"
    "mk_ash      | mk_grp_gray | 灰燼 (Ash Gray) | | cmd:img-artify marker:ash_gray"
    "mk_bgray    | mk_grp_gray | 藍灰 (Blue Gray) | | cmd:img-artify marker:blue_gray"
    "mk_linen    | mk_grp_gray | 亞麻 (Linen) | | cmd:img-artify marker:linen"
    "mk_red      | mk_grp_red | 鮮豔紅 (Red) | | cmd:img-artify marker:red"
    "mk_maroon   | mk_grp_red | 栗紅 (Maroon) | | cmd:img-artify marker:maroon"
    "mk_coral    | mk_grp_red | 珊瑚 (Coral) | | cmd:img-artify marker:coral"
    "mk_amaranth | mk_grp_red | 莧紫 (Amaranth) | | cmd:img-artify marker:amaranth"
    "mk_cerise   | mk_grp_red | 櫻桃 (Cerise) | | cmd:img-artify marker:cerise"
    "mk_hpink    | mk_grp_red | 艷粉 (Hot Pink) | | cmd:img-artify marker:hot_pink"
    "mk_orchid   | mk_grp_red | 蘭花 (Orchid) | | cmd:img-artify marker:orchid"
    "mk_pink     | mk_grp_red | 粉紅 (Pink) | | cmd:img-artify marker:pink"
    "mk_rasp     | mk_grp_red | 覆盆子 (Raspberry) | | cmd:img-artify marker:raspberry"
    "mk_rose     | mk_grp_red | 玫瑰 (Rose) | | cmd:img-artify marker:rose"
    "mk_salmon   | mk_grp_red | 鮭魚 (Salmon) | | cmd:img-artify marker:salmon"
    "mk_scarlet  | mk_grp_red | 猩紅 (Scarlet) | | cmd:img-artify marker:scarlet"
    "mk_yellow   | mk_grp_yell | 活力黃 (Yellow) | | cmd:img-artify marker:yellow"
    "mk_orange   | mk_grp_yell | 活力橘 (Orange) | | cmd:img-artify marker:orange"
    "mk_mango    | mk_grp_yell | 芒果 (Mango) | | cmd:img-artify marker:mango"
    "mk_amber    | mk_grp_yell | 琥珀 (Amber) | | cmd:img-artify marker:amber"
    "mk_brass    | mk_grp_yell | 黃銅 (Brass) | | cmd:img-artify marker:brass"
    "mk_bronze   | mk_grp_yell | 青銅 (Bronze) | | cmd:img-artify marker:bronze"
    "mk_brown    | mk_grp_yell | 褐色 (Brown) | | cmd:img-artify marker:brown"
    "mk_buff     | mk_grp_yell | 米色 (Buff) | | cmd:img-artify marker:buff"
    "mk_coffee   | mk_grp_yell | 咖啡 (Coffee) | | cmd:img-artify marker:coffee"
    "mk_pear     | mk_grp_yell | 梨色 (Pear) | | cmd:img-artify marker:pear"
    "mk_lime     | mk_grp_gree | 萊姆 (Lime) | | cmd:img-artify marker:lime"
    "mk_green    | mk_grp_gree | 森林綠 (Green) | | cmd:img-artify marker:green"
    "mk_olive    | mk_grp_gree | 橄欖 (Olive) | | cmd:img-artify marker:olive"
    "mk_bgreen   | mk_grp_gree | 亮綠 (Bright Green) | | cmd:img-artify marker:bright_green"
    "mk_jade     | mk_grp_gree | 翡翠 (Jade) | | cmd:img-artify marker:jade"
    "mk_sage     | mk_grp_gree | 鼠尾草 (Sage Green) | | cmd:img-artify marker:sage_green"
    "mk_celadon  | mk_grp_gree | 青瓷 (Celadon) | | cmd:img-artify marker:celadon"
    "mk_chart    | mk_grp_gree | 查特酒 (Chartreuse) | | cmd:img-artify marker:chartreuse"
    "mk_grass    | mk_grp_gree | 草原綠 (Grass Green) | | cmd:img-artify marker:grass_green"
    "mk_neon     | mk_grp_gree | 霓虹綠 (Neon Green) | | cmd:img-artify marker:neon_green"
    "mk_pista    | mk_grp_gree | 開心果 (Pistachio) | | cmd:img-artify marker:pistachio"
    "mk_virid    | mk_grp_gree | 翠綠 (Viridian) | | cmd:img-artify marker:viridian"
    "mk_blue     | mk_grp_blue | 經典藍 (Blue) | | cmd:img-artify marker:blue"
    "mk_navy     | mk_grp_blue | 海軍藍 (Navy) | | cmd:img-artify marker:navy"
    "mk_aqua     | mk_grp_blue | 水藍 (Aqua) | | cmd:img-artify marker:aqua"
    "mk_teal     | mk_grp_blue | 藍綠 (Teal) | | cmd:img-artify marker:teal"
    "mk_cadet    | mk_grp_blue | 軍校藍 (Cadet Blue) | | cmd:img-artify marker:cadet_blue"
    "mk_cyan     | mk_grp_blue | 青色 (Cyan) | | cmd:img-artify marker:cyan"
    "mk_denim    | mk_grp_blue | 丹寧 (Denim) | | cmd:img-artify marker:denim"
    "mk_iris     | mk_grp_blue | 鳶尾 (Iris) | | cmd:img-artify marker:iris"
    "mk_robin    | mk_grp_blue | 知更鳥蛋 (Robin Egg Blue) | | cmd:img-artify marker:robin_egg_blue"
    "mk_turq     | mk_grp_blue | 綠松石 (Turquoise) | | cmd:img-artify marker:turquoise"
    "mk_ama      | mk_grp_blue | 海藍寶 (Aquamarine) | | cmd:img-artify marker:aquamarine"
    "mk_verdi    | mk_grp_blue | 銅綠 (Verdigris) | | cmd:img-artify marker:verdigris"
    "mk_fuchs    | mk_grp_blue | 品紅 (Fuchsia) | | cmd:img-artify marker:fuchsia"
    "mk_purple   | mk_grp_blue | 紫色 (Purple) | | cmd:img-artify marker:purple"
    "mk_plum     | mk_grp_blue | 梅紫 (Plum) | | cmd:img-artify marker:plum"

    # ==========================================
    # --- 1.2 漫畫動漫系列 ---
    # ==========================================
    "art_anime   | cat_cartoon | 🇯🇵 日系動漫 | V6.3 淡墨版效果 | cmd:img-artify cartoon:anime"
    "art_comic   | cat_cartoon | 🇺🇸 美系漫畫 | 鋼鐵時代風格 | cmd:img-artify cartoon:comic"
    "art_serial  | cat_cartoon | 📜 中式連環畫 | 復古白描筆法 | cmd:img-artify cartoon:serial"
    "art_noir    | cat_cartoon | 🎬 黑色電影 | 硬派高對比黑白 | cmd:img-artify cartoon:noir"
    "art_sketch  | cat_cartoon | ✏️ 漫畫草稿 | 手繪鉛筆底稿 | cmd:img-artify cartoon:sketch"
    "art_outline | cat_cartoon | 🖋️ 純線稿 | 邊緣細線提取 | cmd:img-artify cartoon:outline"

    # ==========================================
    # --- 1.3 經典繪畫系列 ---
    # ==========================================
    "sub_wc_grp  | cat_classic | 💧 水彩系列 (Watercolor) | 清新 vs 傳統雙引擎 | folder"
    "sub_oil     | cat_classic | 🖼️ 專業油畫 | 古典、印象、表現、厚塗 | folder"
    "sub_sk      | cat_classic | ✏️ 素描風格 | 精細、粗獷、標準 | folder"
    "sub_ch      | cat_classic | ✒️ 炭筆風格 | 標準、重墨、顆粒 | folder"

    # --- 1.3.1 水彩細項 ---
    "wc_type_a   | sub_wc_grp  | 🌿 清新水彩 (Series A) | 基於 Fred's 積墨邏輯 | folder"
    "wc_type_b   | sub_wc_grp  | 🎨 傳統水彩 (Series B) | 基於經典暈染濾鏡 | folder"
    "wc_std_a    | wc_type_a   | 標準清新 | 平衡渲染與積墨 | cmd:img-artify illust:standard"
    "wc_sft_a    | wc_type_a   | 柔和清新 | 強渲染，低飽和 | cmd:img-artify illust:soft"
    "wc_det_a    | wc_type_a   | 精細清新 | 強化積墨細節 | cmd:img-artify illust:detailed"
    "wc_std_b    | wc_type_b   | 標準傳統 | 經典水彩質感 | cmd:img-artify watercolor:standard"
    "wc_wet_b    | wc_type_b   | 濕畫法   | 渲染效果強烈 | cmd:img-artify watercolor:wet"
    "wc_sk_b     | wc_type_b   | 水彩草圖 | 帶鉛筆底線感 | cmd:img-artify watercolor:sketch"
    "wc_sft_b    | wc_type_b   | 柔和擴散 | 低飽和暈染感 | cmd:img-artify watercolor:soft"

    # --- 1.3.2 油畫細項 ---
    "oil_cls     | sub_oil | 古典寫實 | 細緻光影質感 | cmd:img-artify oil:classical"
    "oil_imp     | sub_oil | 印象派   | 靈動大師筆觸 | cmd:img-artify oil:impressionist"
    "oil_exp     | sub_oil | 表現主義 | 強烈情感色彩 | cmd:img-artify oil:expressionist"
    "oil_pst     | sub_oil | 厚塗法   | 立體顏料質感 | cmd:img-artify oil:impasto"
    "oil_abs     | sub_oil | 抽象油畫 | 形式解構與區域聚合 | cmd:img-artify oil:abstract"
    "oil_ren     | sub_oil | 文藝復興 | 大師底稿與裂紋質感 | cmd:img-artify oil:renaissance"
    "oil_std     | sub_oil | 標準油畫 | 平衡的繪畫感 | cmd:img-artify oil:standard"

    # --- 1.3.3 素描/炭筆 ---
    "sk_std      | sub_sk | 標準素描 | 經典鉛筆質感 | cmd:img-artify sketch"
    "sk_fine     | sub_sk | 精細素描 | 細膩線條描繪 | cmd:img-artify sketch:fine"
    "sk_hvy      | sub_sk | 粗獷素描 | 強力對比與重筆觸 | cmd:img-artify sketch:heavy"
    "ch_std      | sub_ch | 標準炭筆 | 炭條繪畫感 | cmd:img-artify charcoal"
    "ch_hvy      | sub_ch | 重墨炭筆 | 濃郁的黑白對比 | cmd:img-artify charcoal:heavy"
    "ch_grn      | sub_ch | 顆粒炭筆 | 強烈的炭粉質感 | cmd:img-artify charcoal:grain"

    # ==========================================
    # --- 1.4 復古時光系列 ---
    # ==========================================
    "sub_vwc_grp | cat_vintage | 📜 復古水彩 | 手撕邊與衰敗質感 | folder"
    "sub_vin_grp | cat_vintage | 🎞️ 復古底片 | 經典膠卷、噪點、痕跡 | folder"
    "sub_sep_grp | cat_vintage | 🎞️ 棕褐懷舊 | 多層次 Sepia 風格 | folder"
    "sub_nit_grp | cat_vintage | 🌃 專業夜景 | 城市、藍調、賽博朋克 | folder"
    "art_lomo    | cat_vintage | 📸 Lomo 隨拍 | 強暗角與鮮豔色彩 | cmd:img-artify lomo"

    # --- 1.4.1 復古水彩 (Vin-WC) ---
    "vwc_std     | sub_vwc_grp | 標準復古水彩 | 懷舊水彩質感 | cmd:img-artify vin-wc"
    "vwc_dec     | sub_vwc_grp | 衰敗侵蝕 | 極限手撕邊與褪色 | cmd:img-artify vin-wc:decay"
    "vwc_hvy     | sub_vwc_grp | 厚重復古 | 高對比與濃郁色調 | cmd:img-artify vin-wc:heavy"
    "vwc_vib     | sub_vwc_grp | 鮮豔復古 | 強化色彩的懷舊感 | cmd:img-artify vin-wc:vibrant"
    "vwc_ant     | sub_vwc_grp | 極致考古 | 極限殘破與羊皮紙質感 | cmd:img-artify vin-wc:antique"

    # --- 1.4.2 復古底片 ---
    "vin_std     | sub_vin_grp | 標準復古 | 膠片感與輕微噪點 | cmd:img-artify vintage"
    "vin_film    | sub_vin_grp | 經典膠卷 | 模擬真實底片色調 | cmd:img-artify vintage:film"
    "vin_grain   | sub_vin_grp | 強噪點底片 | 粗糙的顆粒質感 | cmd:img-artify vintage:grain"
    "art_ant     | sub_vin_grp | 🕰️ 舊照片 | 帶噪點、褶皺與發霉邊緣 | cmd:img-artify antique"
    "art_aged    | sub_vin_grp | 📜 老照片 | 偏灰褐的相紙質感 | cmd:img-artify aged-photo"

    # --- 1.4.3 棕褐系列 ---
    "sep_std     | sub_sep_grp | 標準棕褐 | 經典懷舊 Sepia | cmd:img-artify sepia"
    "sep_lit     | sub_sep_grp | 明亮棕褐 | 輕量級懷舊感 | cmd:img-artify sepia:light"
    "sep_hvy     | sub_sep_grp | 濃厚棕褐 | 強對比深褐色 | cmd:img-artify sepia:heavy"
    "sep_fad     | sub_sep_grp | 褪色泛黃 | 羊皮紙般的老舊感 | cmd:img-artify sepia:faded"

    # --- 1.4.4 夜景系列 ---
    "nit_std     | sub_nit_grp | 標準夜景 | 經典夜間氛圍 | cmd:img-artify night"
    "nit_drk     | sub_nit_grp | 極暗夜晚 | 深邃的暗部細節 | cmd:img-artify night:dark"
    "nit_cty     | sub_nit_grp | 城市燈火 | 強化燈光感 | cmd:img-artify night:city"
    "nit_cyb     | sub_nit_grp | 賽博朋克 | 藍紫霓虹質感 | cmd:img-artify night:cyber"
    "nit_blu     | sub_nit_grp | 冷調藍夜 | 憂鬱的藍色基調 | cmd:img-artify night:blue"
    "art_neon    | sub_nit_grp | 🌈 霓虹效果 | 螢光色彩與發光 | cmd:img-artify neon"
    "art_twi     | sub_nit_grp | 🌆 暮光效果 | 憂鬱的黃昏色調 | cmd:img-artify twilight"

    # ==========================================
    # --- 1.5 現代藝術系列 ---
    # ==========================================
    "sub_pop_grp | cat_modern | 🍭 普普藝術 (Pop Art) | 沃荷、李希滕斯坦 | folder"
    "art_pix     | cat_modern | 像素藝術 | 8-bit 遊戲感 | folder"
    "art_duo     | cat_modern | 雙色調   | 專業雙色調質感 | folder"

    # --- 1.5.1 普普藝術細項 ---
    "pop_lic     | sub_pop_grp | 李希滕斯坦 | 經典圓點網點與勾邊 | cmd:img-artify popart:lichtenstein"
    "pop_war     | sub_pop_grp | 沃荷絲網 | 2x2 重複圖案與偏移 | cmd:img-artify popart:warhol"
    "pop_min     | sub_pop_grp | 極簡普普 | 大面積平塗色塊 | cmd:img-artify popart:minimal"
    "pop_col     | sub_pop_grp | 拼貼剪紙 | 實體紙片疊加與投影 | cmd:img-artify popart:collage"
    "pop_ret     | sub_pop_grp | 50s 廣告 | 奶油色調與復古美學 | cmd:img-artify popart:retro"
    "pop_fld     | sub_pop_grp | 色場普普 | 大塊純色視覺衝擊 | cmd:img-artify popart:colorfield"
    "pop_neo     | sub_pop_grp | 霓虹普普 | 螢光色彩與發光 | cmd:img-artify popart:neon"
    "pop_vin     | sub_pop_grp | 60s 復古 | 柔和褪色顆粒感 | cmd:img-artify popart:vintage"
    "pop_str     | sub_pop_grp | 條紋格紋 | 圖案疊加效果 | cmd:img-artify popart:striped"
    "pop_com     | sub_pop_grp | 漫畫網點 | 網點圖案與勾邊 | cmd:img-artify popart:comic"
    "pop_geo     | sub_pop_grp | 幾何抽象 | 抽象形式解構 | cmd:img-artify abstract:geometric"
    "pop_flu     | sub_pop_grp | 流體抽象 | 液化與形式扭曲 | cmd:img-artify abstract:fluid"

    # --- 1.5.2 像素藝術細項 ---
    "pix_8bt     | art_pix | 8-Bit 經典 | 復古遊戲質感 | cmd:img-artify pixelate:8bit"
    "pix_16bt    | art_pix | 16-Bit 精細 | 較細膩的像素感 | cmd:img-artify pixelate:16bit"
    "pix_chk     | art_pix | 粗糙像素 | 誇張的大塊像素 | cmd:img-artify pixelate:chunky"

    # --- 1.5.3 雙色調細項 ---
    "duo_wrm     | art_duo | 溫暖色調 (Warm) | | cmd:img-artify duotone:warm"
    "duo_col     | art_duo | 冷峻色調 (Cool) | | cmd:img-artify duotone:cool"
    "duo_neo     | art_duo | 霓虹雙色 (Neon) | | cmd:img-artify duotone:neon"
    "duo_oce     | art_duo | 深海藍調 (Ocean) | | cmd:img-artify duotone:ocean"

    # ==========================================
    # --- 1.6 材質蝕刻系列 ---
    # ==========================================
    "etc_pap     | cat_etching | 🎨 畫紙蝕刻 | 白色線條原始效果 | cmd:img-artify etching:paper"
    "etc_sto     | cat_etching | 🗿 石雕強化 | 深邃的凹凸材質感 | cmd:img-artify etching:stone"
    "etc_sla     | cat_etching | 🌑 黑石蝕刻 | 現代深色石板質感 | cmd:img-artify etching:slate"
    "etc_nan     | cat_etching | 🔱 沈木金雕 | 深木色與金絲高光 | cmd:img-artify etching:nanmu"

    # ==========================================
    # --- 1.7 特殊特效系列 ---
    # ==========================================
    "sub_vig_grp | cat_effects | 🌑 暗角柔邊 (Vignette) | | folder"
    "sub_fx_grp  | cat_effects | 🔮 更多特效 | 漩渦、曝光、浮雕 | folder"
    "art_chr     | cat_effects | 🌈 色散抖音 | 經典 RGB 偏移效果 | cmd:img-artify chromatic"

    # --- 1.7.1 暗角細項 ---
    "vig_sft     | sub_vig_grp | 標準柔邊 | | cmd:img-artify vignette:soft"
    "vig_hvy     | sub_vig_grp | 重度暗角 | | cmd:img-artify vignette:heavy"
    "vig_lit     | sub_vig_grp | 輕微暗角 | | cmd:img-artify vignette:light"
    "vig_wht     | sub_vig_grp | 白色柔邊 | | cmd:img-artify vignette:retro-white"
    "vig_clr     | sub_vig_grp | 復古褐調暗角 | | cmd:img-artify vignette:retro-sepia"
    "vig_blu     | sub_vig_grp | 深藍夜色暗角 | | cmd:img-artify vignette:retro-blue"

    # --- 1.7.2 更多特效細項 ---
    "fx_swl      | sub_fx_grp | 🌀 漩渦扭曲 | 扭曲中心區域 | cmd:img-artify swirl:strong"
    "fx_swl_s    | sub_fx_grp | 🌀 輕微漩渦 | | cmd:img-artify swirl:soft"
    "fx_swl_r    | sub_fx_grp | 🌀 反向漩渦 | | cmd:img-artify swirl:reverse"
    "fx_sol      | sub_fx_grp | ☀️ 曝光過度 | 藝術化曝光效果 | cmd:img-artify solarize"
    "fx_sol_l    | sub_fx_grp | ☀️ 輕度曝光 | | cmd:img-artify solarize:light"
    "fx_emb      | sub_fx_grp | 🖼️ 浮雕效果 | 提取立體質感 | cmd:img-artify emboss:fine"
    "fx_emb_h    | sub_fx_grp | 🖼️ 重度浮雕 | | cmd:img-artify emboss:heavy"
    "fx_pos      | sub_fx_grp | 🎭 色調分離 | 簡化色彩層次 | cmd:img-artify posterize"
    "fx_pos_e    | sub_fx_grp | 🎭 極限分離 | | cmd:img-artify posterize:extreme"
    "fx_edg      | sub_fx_grp | 🖋️ 邊緣提取 | 僅保留輪廓 | cmd:img-artify edge:fine"
    "fx_inv      | sub_fx_grp | 🎞️ 負片反相 | | cmd:img-artify invert"
    "fx_mon      | sub_fx_grp | 🏁 黑白點陣 | | cmd:img-artify monochrome"
    "fx_mon_h    | sub_fx_grp | 🏁 高對比點陣 | | cmd:img-artify monochrome:high"
    "fx_chr_e    | sub_fx_grp | 🌈 強力色散 | | cmd:img-artify chromatic:extreme"

    # ==========================================
    # --- 2. 智能去背 ---
    # ==========================================
    "rem_ai      | rembg_root | 🧠 AI 智慧去背 | 自動識別主體 | cmd:img-ai-rembg"
    "rem_wht     | rembg_root | ✂️ 一鍵去白 | 移除白色背景 | cmd:img-rembg white 10%"
    "rem_blk     | rembg_root | ✂️ 一鍵去黑 | 移除黑色背景 | cmd:img-rembg black 10%"

    # ==========================================
    # --- 3. 基礎工具 ---
    # ==========================================
    "bas_grp_conv | basic_root | 🔄 格式轉換 | PNG, JPG, WebP | folder"
    "bas_grp_size | basic_root | 📐 尺寸與剪裁 | 縮放、剪裁、旋轉 | folder"
    "bas_grp_opt  | basic_root | ⚡️ 壓縮與優化 | 無損壓縮、質量優化 | folder"
    "bas_gif      | basic_root | 🎞️ 合併為 GIF | 將當前圖片序列化為動圖 | folder"

    "bas_png      | bas_grp_conv | 🖼️ 轉為 PNG | 標準無損格式 | cmd:img-to-png"
    "bas_jpg      | bas_grp_conv | 📷 轉為 JPG | 高壓縮通用格式 | cmd:img-to-jpg"
    "bas_webp     | bas_grp_conv | 🌐 轉為 WebP | 現代網路優化格式 | cmd:img-to-webp"
    "bas_res      | bas_grp_size | 📏 調整寬度 | 保持比例縮放 | input:請輸入寬度 (預設 1920):1920:img-resize"
    "bas_cro      | bas_grp_size | ✂️ 批量剪裁 | 需輸入幾何參數 | input:請輸入剪裁參數 (寬x高+X+Y):1080x1080+0+0:img-crop"
    "bas_rot      | bas_grp_size | 🔄 批量旋轉 | 順時針旋轉 | input:請輸入旋轉角度 (預設 90):90:img-rotate"
    "bas_opt      | bas_grp_opt | ⚡️ 質量優化 | 降低 JPG 體積 | input:請輸入目標質量 (1-100):75:img-optimize"
    "bas_ls_png   | bas_grp_opt | 💎 無損壓縮 (PNG) | 極限壓縮不損質 | cmd:img-lossless png"
    "bas_ls_web   | bas_grp_opt | 💎 無損壓縮 (WebP) | 極限壓縮不損質 | cmd:img-lossless webp"
    "bas_gif_run  | bas_gif | 🎬 開始生成 GIF | 依據輸入參數合併 | input:請輸入延遲/檔名 (delay:name):20:animation:img-to-gif"

    # ==========================================
    # --- 4. 系統維護 ---
    # ==========================================
    "sys_test    | sys_root | 🧪 一鍵風格自檢 | 驗證所有濾鏡並生成測試報告 | cmd:img-artify-test"
    "sys_clean   | sys_root | 🧹 清理 processed | 移除所有處理後的圖片 | cmd:rm -rf processed/*.png processed/*.jpg processed/*.webp"
    "sys_info    | sys_root | ⚙️ 診斷資訊 | 查看環境與匹配模式 | cmd:img-sys-info"
)

# --- 輔助函數 ---
img-sys-info() {
    echo "\033[1;36m--- ImageMagickTools 系統診斷 ---\033[0m"
    echo "📂 當前工作路徑: $(pwd)"
    echo "🖼️ 圖片匹配模式: $_IMG_PATTERN"
    echo "--------------------------------"
}
