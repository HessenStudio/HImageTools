#!/bin/zsh
# styles/pixelate.zsh - 專業像素藝術風格模組 (Pro Version)

_img_artify_pixelate() {
    local f=$1 output=$2 style=$3
    local sub_style=${style#*:}
    [[ "$sub_style" == "$style" ]] && sub_style="8bit"
    
    local scale_down=5%
    local scale_up=2000%
    
    [[ "$sub_style" == "8bit" ]] && { scale_down=12.5%; scale_up=800%; }
    [[ "$sub_style" == "16bit" ]] && { scale_down=6.25%; scale_up=1600%; }
    [[ "$sub_style" == "chunky" ]] && { scale_down=8%; scale_up=1250%; }
    [[ "$sub_style" == "fine" ]] && { scale_down=3%; scale_up=3333%; }

    magick "$f" -auto-orient \
        -scale "${scale_down}" \
        -scale "${scale_up}" \
        -quality 92 "$output"
}

_img_artify_mosaic() {
    local f=$1 output=$2 style=$3
    local sub_style=${style#*:}
    
    local tile_size=20
    [[ "$sub_style" == "fine" ]] && tile_size=10
    [[ "$sub_style" == "coarse" ]] && tile_size=40

    magick "$f" -auto-orient \
        -crop ${tile_size}x${tile_size} \
        -set label "%f" \
        +adjoin \
        -background black \
        -compose over \
        -flatten \
        -quality 92 "$output"
}

_img_artify_pixel_pattern() {
    local f=$1 output=$2 style=$3
    
    magick "$f" -auto-orient \
        -scale 4% \
        -scale 2500% \
        -brightness-contrast 10x5 \
        -quality 92 "$output"
}