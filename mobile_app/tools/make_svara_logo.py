from pathlib import Path

from PIL import Image


SRC = Path(r"C:\Users\IdeaPad\Downloads\SVARA (1).png")
OUT = Path(r"F:\Development\Projects\svara_app\assets\images\svara_logo_exact.png")


def main() -> None:
    im = Image.open(SRC).convert("RGBA")
    px = im.load()
    width, height = im.size
    teal = (45, 190, 176)
    safe_bg = (243, 251, 247)

    alpha = Image.new("L", (width, height), 0)
    ap = alpha.load()
    min_x, min_y, max_x, max_y = width, height, -1, -1

    for y in range(height):
        for x in range(width):
            r, g, b, _ = px[x, y]
            diff = max(255 - r, 255 - g, 255 - b)
            greenish = g > 105 and b > 85 and r < 190 and g > r + 18
            value = 0
            if greenish or diff > 18:
                value = max(0, min(255, int((diff - 8) * 2.6)))
                if greenish:
                    value = max(value, 150)

            ap[x, y] = value
            if value > 18:
                min_x = min(min_x, x)
                min_y = min(min_y, y)
                max_x = max(max_x, x)
                max_y = max(max_y, y)

    if max_x < 0:
        raise RuntimeError("Logo pixels not found.")

    padding = int(max(max_x - min_x + 1, max_y - min_y + 1) * 0.045)
    min_x = max(0, min_x - padding)
    min_y = max(0, min_y - padding)
    max_x = min(width - 1, max_x + padding)
    max_y = min(height - 1, max_y + padding)

    crop_width = max_x - min_x + 1
    crop_height = max_y - min_y + 1
    result = Image.new("RGBA", (crop_width, crop_height), (*safe_bg, 0))
    rp = result.load()

    for y in range(crop_height):
        for x in range(crop_width):
            value = ap[min_x + x, min_y + y]
            if value:
                rp[x, y] = (*teal, value)
            else:
                rp[x, y] = (*safe_bg, 0)

    max_side = 1024
    if max(result.size) > max_side:
        scale = max_side / max(result.size)
        resized_size = (
            round(result.width * scale),
            round(result.height * scale),
        )
        result = result.resize(resized_size, Image.Resampling.LANCZOS)

    OUT.parent.mkdir(parents=True, exist_ok=True)
    result.save(OUT, optimize=True)
    print(f"{OUT} {result.size} {OUT.stat().st_size}")


if __name__ == "__main__":
    main()
