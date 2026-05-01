import cv2
import numpy as np
import sys

def get_ink_lines(img_gray, is_fine=False):
    """提取清晰且連續的輪廓線條"""
    # 1. 使用中值濾波減少細碎噪點
    blurred = cv2.medianBlur(img_gray, 3)
    
    # 2. 自適應閾值：fine 風格使用更大的 block size 以獲得更長更連貫的線條
    block_size = 15 if is_fine else 11
    adaptive = cv2.adaptiveThreshold(
        blurred, 255, cv2.ADAPTIVE_THRESH_GAUSSIAN_C, 
        cv2.THRESH_BINARY, block_size, 2
    )
    
    # 3. XDoG 提取藝術輪廓
    sigma = 0.4 if is_fine else 0.5
    k = 1.6
    tau = 0.98
    epsilon = 0.1
    phi = 10.0
    
    g1 = cv2.GaussianBlur(img_gray.astype(float), (0, 0), sigma)
    g2 = cv2.GaussianBlur(img_gray.astype(float), (0, 0), sigma * k)
    
    xdog = g1 - tau * g2
    xdog = np.where(xdog < epsilon, 1.0, 1.0 + phi * np.tanh(xdog))
    xdog = (xdog * 255).clip(0, 255).astype(np.uint8)
    _, xdog_bin = cv2.threshold(xdog, 127, 255, cv2.THRESH_BINARY)
    
    # 4. 合併兩者
    combined = cv2.bitwise_and(adaptive, xdog_bin)
    
    # 5. 線條粗細控制
    # 注意：墨水是 0 (黑色)，背景是 255 (白色)
    # 膨脹 (Dilate) 黑色區域會使線條變粗，侵蝕 (Erode) 黑色區域會使線條變細
    # OpenCV 的 erode/dilate 默認作用於高亮 (255) 區域
    if is_fine:
        # Fine 風格：使用 Dilate (作用於 255) 來縮減黑色線條
        kernel = np.ones((2, 2), np.uint8)
        combined = cv2.dilate(combined, kernel, iterations=1) 
    else:
        # Standard 風格：使用 Erode (作用於 255) 來加粗黑色線條
        kernel = np.ones((2, 2), np.uint8)
        combined = cv2.erode(combined, kernel, iterations=1)
    
    return combined

def generate_hatch_texture(rows, cols, angle, spacing):
    """生成乾淨、連貫的平行線紋理"""
    texture = np.full((rows, cols), 255, dtype=np.uint8)
    
    # 旋轉中心
    center = (cols // 2, rows // 2)
    m = cv2.getRotationMatrix2D(center, angle, 1.0)
    
    # 繪製更細的線條 (thickness=1)
    size = int(np.sqrt(rows**2 + cols**2))
    line_texture = np.full((size * 2, size * 2), 255, dtype=np.uint8)
    for y in range(0, line_texture.shape[0], spacing):
        cv2.line(line_texture, (0, y), (line_texture.shape[1], y), 0, 1, cv2.LINE_AA)
    
    # 旋轉並裁剪
    rotated = cv2.warpAffine(line_texture, m, (line_texture.shape[1], line_texture.shape[0]))
    
    y_start = (rotated.shape[0] - rows) // 2
    x_start = (rotated.shape[1] - cols) // 2
    texture = rotated[y_start:y_start+rows, x_start:x_start+cols]
    
    return texture

def create_ballpoint_art(input_path, output_path, sub_style="notebook"):
    # 1. 讀取影像
    img = cv2.imread(input_path)
    if img is None: return
    
    gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
    rows, cols = gray.shape

    is_fine = (sub_style == "fine")
    hatch_spacing = 5 if is_fine else 7
    
    # 2. 提取連貫輪廓
    lines = get_ink_lines(gray, is_fine)

    # 3. 處理陰影區域 (去噪，避免點狀分佈)
    inv_gray = cv2.bitwise_not(gray)
    # 強力平滑，確保遮罩邊緣連貫，不產生碎點
    inv_gray_smooth = cv2.bilateralFilter(inv_gray, 9, 75, 75)
    
    # 4. 生成乾淨的排線層
    hatch1 = generate_hatch_texture(rows, cols, 45, hatch_spacing)
    hatch2 = generate_hatch_texture(rows, cols, 135, hatch_spacing)
    
    # 遮罩閾值調整
    _, mask1 = cv2.threshold(inv_gray_smooth, 80, 255, cv2.THRESH_BINARY)
    _, mask2 = cv2.threshold(inv_gray_smooth, 160, 255, cv2.THRESH_BINARY)
    
    # 應用遮罩
    ink_hatch1 = cv2.bitwise_or(hatch1, cv2.bitwise_not(mask1))
    ink_hatch2 = cv2.bitwise_or(hatch2, cv2.bitwise_not(mask2))
    
    # 5. 合成：優先保留線條
    final_ink = cv2.bitwise_and(lines, ink_hatch1)
    final_ink = cv2.bitwise_and(final_ink, ink_hatch2)

    # 6. 色彩合成
    ink_color = np.array([156, 69, 26], dtype=np.uint8) # 深藍
    paper_color = np.array([242, 250, 255], dtype=np.uint8) # 紙張
    
    result = np.full((rows, cols, 3), paper_color, dtype=np.uint8)
    ink_mask = final_ink.astype(float) / 255.0
    
    for ch in range(3):
        chan_data = ink_color[ch] + (paper_color[ch] - ink_color[ch]) * ink_mask
        result[:, :, ch] = chan_data.astype(np.uint8)

    # 7. 紙張質感 (Fine 風格減少雜訊)
    if not is_fine:
        noise = np.random.randint(-4, 4, (rows, cols, 3)).astype(np.int16)
        result = np.clip(result.astype(np.int16) + noise, 0, 255).astype(np.uint8)

    cv2.imwrite(output_path, result)

if __name__ == "__main__":
    if len(sys.argv) >= 3:
        sub = sys.argv[3] if len(sys.argv) > 3 else "notebook"
        create_ballpoint_art(sys.argv[1], sys.argv[2], sub)
