# 🖼️ ImageMagickTools

> 基於 **ImageMagick 7** 與可選 **rembg** 的模組化 **Zsh** 工具集：批量圖片處理與藝術風格濾鏡，預設輸出至 `./processed/`。

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![ImageMagick](https://img.shields.io/badge/ImageMagick-7.x-blue.svg)](https://imagemagick.org/)
[![Shell](https://img.shields.io/badge/Shell-Zsh-orange.svg)](https://www.zsh.org/)

**English documentation:** [README.en.md](README.en.md)

---

## ✨ 特點

- **批量並行**：依機器記憶體自動調整併發（可透過環境變數覆寫）。
- **資源守護**：限制 Magick 執行緒與記憶體、低優先級 `nice`，並在可用 RAM 過低時嘗試中止任務。
- **風格路由一致**：統一使用 `img-artify <主風格>[:子風格]`；不寫子風格時由各模組的預設子風格處理。
- **AI 去背（可選）**：`img-ai-rembg` 呼叫本機 `rembg`（逐張序列處理）。

---

## 🚀 快速開始

### 依賴

- **ImageMagick 7+**
  ```bash
  brew install imagemagick
  ```
- **rembg**（僅 AI 去背需要）
  ```bash
  pip install rembg
  ```

### 載入

```bash
git clone https://github.com/<你的帳號>/ImageMagickTools.git
cd ImageMagickTools
source ./loader.sh
```

建議將 `source /path/to/ImageMagickTools/loader.sh` 寫入 `~/.zshrc`。

### 指令格式約定

| 類型 | 格式 | 說明 |
|------|------|------|
| 基礎處理 | `img-<動作> [參數…]` | 處理當前目錄符合副檔名的圖片（見下節）。 |
| 藝術濾鏡 | `img-artify <主風格>[:子風格]` | 子風格可省略，省略時使用該主風格文檔標示的 **[default]**。 |
| 說明 | `img-artify`（無參數） | 在終端列印完整風格清單。 |

**輸入副檔名（不分大小寫）**：`jpg`、`jpeg`、`png`、`webp`、`tiff`。

---

## 📋 速查表

| 想做什麼 | 完整指令 |
|----------|----------|
| 日系動漫感 | `img-artify cartoon:anime` |
| 古典油畫（預設） | `img-artify oil` 或 `img-artify oil:classical` |
| 舊版「標準油畫」筆觸 | `img-artify oil:standard` |
| 沃荷式拼貼 | `img-artify popart:warhol` |
| 沈木金雕 | `img-artify etching:nanmu` |
| 一鍵生成全風格畫廊 | `img-artify-all` |
| 一鍵濾鏡效能自檢 | `img-artify-test` |
| AI 去背 | `img-ai-rembg` |
| 無損 WebP | `img-lossless webp` |

---

## 🚀 核心進階功能

### 1. 一鍵藝術化全家桶 (Artify All-in-One)
這是本工具集最強大的功能，能將指定目錄下的所有圖片自動套用項目中 **100+ 種藝術風格**，並生成精美的互動式畫廊。
- **指令**：`img-artify-all [目錄]` （若不輸入則預設為當前目錄 `./`）
- **輸出**：在目標目錄下建立 `artify_gallery/` 資料夾，內含每張原圖的風格子目錄。
- **畫廊特性**：Master-Detail 側邊欄導航、九宮格佈局、全屏燈箱、斷點續傳。

### 2. 一鍵風格自檢 (Style Self-Test)
主要用於安裝後的環境驗證或開發調試，使用系統內建 Logo 自動驗證所有濾鏡。
- **指令**：`img-artify-test`
- **輸出**：生成 `style_test_report/` 資料夾與預覽報告。
- **價值**：快速確認哪些濾鏡在當前環境下執行成功（標註 PASS/FAIL）。

---

## 🛠️ 基礎工具（批量）

輸出目錄：`./processed/`（不存在則自動建立）。

| 指令 | 說明 | 完整指令 |
|------|------|----------|
| `img-resize [寬度]` | 依寬度縮放，維持比例 | `img-resize 1920` |
| `img-to-png` | 轉 PNG | `img-to-png` |
| `img-to-jpg` | 轉 JPG | `img-to-jpg` |
| `img-to-webp` | 轉 WebP（品質約 80） | `img-to-webp` |
| `img-lossless [png\|webp]` | 無損壓縮 | `img-lossless webp` |
| `img-crop <geometry>` | 幾何裁切 | `img-crop 1080x1080+0+0` |
| `img-rotate [角度]` | 順時針旋轉 | `img-rotate 90` |
| `img-optimize [品質]` | 降低 JPG 體積（優化品質） | `img-optimize 75` |
| `img-to-gif [delay] [名稱]` | 目錄內圖片合成 GIF | `img-to-gif 20 my_anim` |
| `img-rembg [顏色] [fuzz]` | 依色去背 | `img-rembg white 10%` |
| `img-ai-rembg` | AI 去背（需 `rembg`） | `img-ai-rembg` |

---

## 🎨 `img-artify` 風格一覽

約定：**[default]** 表示只輸入主風格（例如 `img-artify oil`）時使用的子風格。別名欄表示可代替子風格關鍵字。**完整指令**可直接複製到終端使用（請先 `source loader.sh` 並在含圖片的目錄下執行）。

### 1. 漫畫與插畫

**插畫與線稿 — `cartoon`**

| 子風格 | 別名 | 完整指令 | 說明 |
|--------|------|----------|------|
| **anime** [default] | manga, jp | `img-artify cartoon` 或 `img-artify cartoon:anime` | 日系動漫（淡墨網點） |
| comic | us, hero | `img-artify cartoon:comic` | 美系英雄漫畫 |
| clear | eu, ligne | `img-artify cartoon:clear` | 歐系 ligne claire |
| serial | cn, ink | `img-artify cartoon:serial` | 連環畫／宣紙墨線 |
| illust | graphic | `img-artify cartoon:illust` | 商業插畫式簡化 |
| noir | bw | `img-artify cartoon:noir` | 高對比黑白 |
| sketch | draft | `img-artify cartoon:sketch` | 漫畫草稿感 |
| outline | line | `img-artify cartoon:outline` | 純線稿 |

**手繪彩繪 — `handpaint`**（結構墨線與色塊填充）

| 子風格 | 完整指令 | 說明 |
|--------|----------|------|
| **標準** [default] | `img-artify handpaint` | 結構清晰，色塊均勻 |
| vibrant | `img-artify handpaint:vibrant` | 高飽和，強對比 |
| soft | `img-artify handpaint:soft` | 灰墨線，淡色調 |
| heavy | `img-artify handpaint:heavy` | 強墨線，濃郁感 |

**馬克筆插畫 — `marker`**（模擬 56 色專業馬克筆）

| 子風格 | 範例指令 | 說明 |
|--------|----------|------|
| **palette** | `img-artify marker:palette` | 生成 56 色全色卡預覽 |
| <顏色名稱> | `img-artify marker:red` | 使用指定色系渲染（支援 red, blue, green, mango, coffee 等 56 種） |

---

### 2. 經典繪畫

**油畫 — `oil`**

| 子風格 | 別名 | 完整指令 | 說明 |
|--------|------|----------|------|
| **classical** [default] | realism | `img-artify oil` 或 `img-artify oil:classical` | 古典寫實 |
| impressionist | impressionism | `img-artify oil:impressionist` | 印象派筆觸 |
| expressionist | expressionism | `img-artify oil:expressionist` | 表現主義 |
| abstract | — | `img-artify oil:abstract` | 抽象色塊 |
| impasto | thick | `img-artify oil:impasto` | 厚塗 |
| renaissance | master | `img-artify oil:renaissance` | 文藝復興／大師感 |
| standard | — | `img-artify oil:standard` | 較柔和的標準油畫（舊版預設行為） |

**水彩 — `watercolor` / `illust`**

| 引擎系列 | 子風格 | 完整指令 | 說明 |
|----------|--------|----------|------|
| **Series A (清新)** | **standard** [default] | `img-artify illust` | 平衡渲染與積墨 |
| | soft | `img-artify illust:soft` | 強渲染，低飽和 |
| | detailed | `img-artify illust:detailed` | 強化積墨細節 |
| **Series B (傳統)** | **standard** [default] | `img-artify watercolor` | 經典水彩質感 |
| | wet | `img-artify watercolor:wet` | 濕畫法，渲染強烈 |
| | sketch | `img-artify watercolor:sketch` | 帶鉛筆底線感 |
| | soft | `img-artify watercolor:soft` | 柔和擴散感 |


**素描 — `sketch`**（無子風格 = 標準素描）

| 子風格 | 完整指令 | 說明 |
|--------|----------|------|
| **標準** [default] | `img-artify sketch` | 標準素描 |
| fine | `img-artify sketch:fine` | 較細膩 |
| heavy | `img-artify sketch:heavy` | 較粗重 |

**炭筆 — `charcoal`**（無子風格 = 標準炭筆）

| 子風格 | 完整指令 | 說明 |
|--------|----------|------|
| **標準** [default] | `img-artify charcoal` | 標準炭筆 |
| heavy | `img-artify charcoal:heavy` | 更重、顆粒更粗 |
| grain | `img-artify charcoal:grain` | 強調顆粒噪點 |

**復古水彩手撕邊 — `vin-wc`**（無子風格 = 預設參數）

| 子風格 | 完整指令 | 說明 |
|--------|----------|------|
| **預設** [default] | `img-artify vin-wc` | 預設手撕邊與紙感 |
| decay | `img-artify vin-wc:decay` | 褪色、破損感 |
| heavy | `img-artify vin-wc:heavy` | 高飽和、重手撕邊 |
| vibrant | `img-artify vin-wc:vibrant` | 鮮豔、邊緣較乾淨 |
| antique | `img-artify vin-wc:antique` | 泛黃老紙、強侵蝕邊 |

---

### 3. 復古與底片

**復古底片 — `vintage`**

| 子風格 | 完整指令 | 說明 |
|--------|----------|------|
| **standard** [default] | `img-artify vintage` 或 `img-artify vintage:standard` | 褪色、顆粒、刮痕、纖維質感 |
| film | `img-artify vintage:film` | 偏「沖印／交叉沖片」色調與對比 |
| grain | `img-artify vintage:grain` | 強化銀鹽顆粒與刮痕可見度 |

**棕褐色 — `sepia`**（無子風格 = 標準棕褐）

| 子風格 | 完整指令 | 說明 |
|--------|----------|------|
| **標準** [default] | `img-artify sepia` | 標準棕褐 |
| light | `img-artify sepia:light` | 較淺 |
| heavy | `img-artify sepia:heavy` | 較深、對比強 |
| vintage | `img-artify sepia:vintage` | 復古照片調 |
| faded | `img-artify sepia:faded` | 褪色感 |

**其它（無子風格）**

| 主風格 | 完整指令 | 說明 |
|--------|----------|------|
| antique | `img-artify antique` | 舊照片＋噪點疊加 |
| aged-photo | `img-artify aged-photo` | 老照片＋紙紋柔光 |
| lomo | `img-artify lomo` | Lomo 式暗角與對比 |

**夜景 — `night`**（無子風格 = 一般夜景壓暗）

| 子風格 | 完整指令 | 說明 |
|--------|----------|------|
| **標準** [default] | `img-artify night` | 一般夜景壓暗 |
| dark | `img-artify night:dark` | 更暗 |
| city | `img-artify night:city` | 都市夜景調 |
| cyber | `img-artify night:cyber` | 賽博冷色 |
| blue | `img-artify night:blue` | 藍調夜景 |

**單一效果（無子風格）**

| 主風格 | 完整指令 | 說明 |
|--------|----------|------|
| neon | `img-artify neon` | 霓虹色濃縮對比 |
| twilight | `img-artify twilight` | 暮光／憂鬱色調 |

---

### 4. 現代與普普

**普普 — `popart`**

| 子風格 | 別名 | 完整指令 | 說明 |
|--------|------|----------|------|
| **lichtenstein** [default] | dots, classic | `img-artify popart` 或 `img-artify popart:lichtenstein` | 網點＋漫畫輪廓 |
| warhol | screen, repeat | `img-artify popart:warhol` | 2×2 色版拼貼 |
| minimal | flat, simple | `img-artify popart:minimal` | 大色塊平塗 |
| contour | outline, wire | `img-artify popart:contour` | 輪廓／線性解構 |
| retro | advert, 50s | `img-artify popart:retro` | 50 年代廣告奶油色 |
| colorfield | field | `img-artify popart:colorfield` | 色塊場 |
| collage | cutout, craft | `img-artify popart:collage` | 剪紙拼貼感 |
| neon | bright, glow | `img-artify popart:neon` | 霓虹普普 |
| vintage | 60s | `img-artify popart:vintage` | 60 年代復古顆粒 |
| striped | pattern | `img-artify popart:striped` | 條紋／格紋疊加 |
| comic | halftone | `img-artify popart:comic` | 漫畫半色調網點 |

**抽象（獨立主風格）— `abstract`**

| 子風格 | 完整指令 | 說明 |
|--------|----------|------|
| **預設** [default] | `img-artify abstract` | 未指定子風格時與未識別子風格均回退為普普網點鏈 |
| geometric | `img-artify abstract:geometric` | 幾何像素化放大 |
| fluid | `img-artify abstract:fluid` | 流動變形 |

**像素 — `pixelate`**

| 子風格 | 完整指令 | 說明 |
|--------|----------|------|
| **8bit** [default] | `img-artify pixelate` 或 `img-artify pixelate:8bit` | 粗像素（紅白機感） |
| 16bit | `img-artify pixelate:16bit` | 較細像素 |
| chunky | `img-artify pixelate:chunky` | 中粗塊 |
| fine | `img-artify pixelate:fine` | 較細 |

**馬賽克 — `mosaic`**

| 子風格 | 完整指令 | 說明 |
|--------|----------|------|
| **預設** [default] | `img-artify mosaic` | 中等塊大小 |
| fine | `img-artify mosaic:fine` | 較細塊 |
| coarse | `img-artify mosaic:coarse` | 較粗塊 |

**雙色調 — `duotone`**

| 子風格 | 完整指令 | 說明 |
|--------|----------|------|
| **warm** [default] | `img-artify duotone` 或 `img-artify duotone:warm` | 暖色雙色 |
| cool | `img-artify duotone:cool` | 冷色 |
| neon | `img-artify duotone:neon` | 螢光感 |
| sepia2 | `img-artify duotone:sepia2` | 棕褐雙色 |
| ocean | `img-artify duotone:ocean` | 海洋藍 |
| forest | `img-artify duotone:forest` | 森林綠 |
| royal | `img-artify duotone:royal` | 紫＋金 |

**三色調 — `tritone`**

| 子風格 | 完整指令 | 說明 |
|--------|----------|------|
| （無子風格） | `img-artify tritone` | 三色調分離質感 |

---

### 5. 蝕刻與材質 — `etching`

| 子風格 | 別名 | 完整指令 | 說明 |
|--------|------|----------|------|
| **paper** [default] | — | `img-artify etching` 或 `img-artify etching:paper` | 畫紙蝕刻、淺底 |
| stone | — | `img-artify etching:stone` | 石壁凹凸 |
| nanmu | wood | `img-artify etching:nanmu` | 沈木金雕高光 |
| slate | dark | `img-artify etching:slate` | 黑石板冷灰調 |

---

### 6. 特殊效果

| 主風格 | 子風格 | 完整指令 | 說明 |
|--------|--------|----------|------|
| **vignette** | **soft** [default] | `img-artify vignette:soft` | 標準柔和暗角 |
| | heavy / light | `img-artify vignette:heavy` | 重度 / 輕微暗角 |
| | retro-white | `img-artify vignette:retro-white` | 白色柔邊暗角 |
| | retro-sepia | `img-artify vignette:retro-sepia` | 復古褐調暗角 |
| | retro-blue | `img-artify vignette:retro-blue` | 深藍夜色暗角 |
| **swirl** | **strong** [default] | `img-artify swirl:strong` | 強烈旋渦扭曲 |
| | soft / subtle | `img-artify swirl:soft` | 較弱 / 微旋渦 |
| | reverse | `img-artify swirl:reverse` | 反向旋渦 |
| **solarize** | **standard** [default] | `img-artify solarize` | 標準 50% 曝光過度 |
| | light / heavy | `img-artify solarize:light` | 30% / 70% 曝光程度 |
| **chromatic** | **standard** [default] | `img-artify chromatic` | 標準 RGB 色散 (3px) |
| | extreme / subtle | `img-artify chromatic:extreme` | 強力 (6px) / 微弱 (1px) 色散 |
| **monochrome**| **standard** [default] | `img-artify monochrome` | 基礎黑白點陣 |
| | high / soft | `img-artify monochrome:high` | 高對比 / 柔和對比點陣 |
| **emboss** | **fine** [default] | `img-artify emboss:fine` | 細膩浮雕 |
| | heavy | `img-artify emboss:heavy` | 粗獷重浮雕 |
| **posterize** | **standard** [default] | `img-artify posterize` | 4 階色調分離 |
| | minimal / extreme | `img-artify posterize:minimal` | 8 階 (細膩) / 2 階 (極端) |
| **edge** | **fine** [default] | `img-artify edge:fine` | 細邊緣提取 |
| | heavy | `img-artify edge:heavy` | 粗邊緣提取 |
| **invert** | — | `img-artify invert` | 負片反相 |

---

## 🖥️ 終端選單導航系統

本專案內建一套強大的互動式選單導航引擎，方便用戶在不記憶指令的情況下快速瀏覽與套用 100+ 種風格。

- **導航引擎 (`interactive_menu.zsh`)**：支援 TUI 鍵盤操作（↑/↓ 切換，Enter 確認，ESC 返回），具備層級式的麵包屑導航。
- **選單配置 (`menu_manifest.zsh`)**：採用結構化的資料清單管理，定義了所有的父子節點、描述、圖示以及對應的底層執行指令。
- **快速啟動**：在終端輸入 `img-menu` 或直接輸入不帶參數的 `img-artify` 即可進入。

---

## ⚙️ 環境變數與效能

腳本會設定（或你可自行覆寫）：

- `MAGICK_THREAD_LIMIT`、`MAGICK_MEMORY_LIMIT`、`MAGICK_MAP_LIMIT`、`MAGICK_AREA_LIMIT`
- `IMAGE_SAFE_RAM_LIMIT`：可用記憶體佔比低於此閾值時觸發中止（預設約 3%）。
- `IMAGE_MAX_JOBS`：手動指定併發數；未設定時依總記憶體自動選擇（8GB 及以下偏保守）。

---

## 📁 專案結構（摘）

```
ImageMagickTools/
  loader.sh          # 入口：依序 source 各模組
  config.zsh         # 共用設定與併發／守護邏輯
  basic.zsh          # 縮放、轉檔、裁切、GIF
  rembg.zsh          # 色鍵去背、AI 去背
  styles/*.zsh       # 各風格實作與 img-artify 路由
```

執行 `img-artify` 無參數時列印的清單與上表一致；若發現遺漏以原始碼 `styles/artify_main.zsh` 內建說明為準。

---

## 📜 授權

[MIT License](LICENSE)

Copyright © 2026 ImageMagickTools 貢獻者

---

## ❤️ 致謝

- [ImageMagick](https://imagemagick.org/)
- [rembg](https://github.com/danielgatis/rembg)
- [Google Gemini CLI](https://github.com/google/gemini-cli) - 協助代碼架構優化與風格演進
