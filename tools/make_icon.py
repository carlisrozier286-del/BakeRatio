#!/usr/bin/env python3
"""Bake Ratio 图标：麦棕底 + 米色麦穗（小尺寸辨识度高）。"""
import math
import pathlib

from PIL import Image, ImageDraw

S = 4096
OUT = 1024
DST = pathlib.Path("/home/xykj211/BakeRatio/BakeRatio/Resources/Assets.xcassets/AppIcon.appiconset/AppIcon.png")

TOP = (206, 165, 112)
BOT = (120, 70, 22)
CREAM = (250, 244, 233)

img = Image.new("RGB", (S, S), TOP)
d = ImageDraw.Draw(img)
for y in range(S):
    t = y / (S - 1)
    d.line([(0, y), (S, y)],
           fill=(int(TOP[0] + (BOT[0] - TOP[0]) * t),
                 int(TOP[1] + (BOT[1] - TOP[1]) * t),
                 int(TOP[2] + (BOT[2] - TOP[2]) * t)))

cx = S / 2
top = S * 0.17
bottom = S * 0.87
# 主茎
d.line([(cx, top + S * 0.10), (cx, bottom)], fill=CREAM, width=int(S * 0.020))

# 麦粒：沿茎交替排列，越往上越小
grains = 5
for i in range(grains):
    k = i / (grains - 1)                 # 0 上 → 1 下
    y = top + S * 0.10 + (bottom - top - S * 0.20) * k * 0.72
    gw = S * (0.105 - 0.020 * k)
    gh = S * (0.062 - 0.010 * k)
    angle = -32

    for side in (-1, 1):
        grain = Image.new("RGBA", (int(gw * 2.4), int(gh * 2.4)), (0, 0, 0, 0))
        gd = ImageDraw.Draw(grain)
        gd.ellipse([grain.width * 0.5 - gw / 2, grain.height * 0.5 - gh / 2,
                    grain.width * 0.5 + gw / 2, grain.height * 0.5 + gh / 2],
                   fill=CREAM)
        grain = grain.rotate(angle * side, expand=False, resample=Image.BICUBIC)
        px = cx + side * (gw * 0.62) - grain.width / 2
        py = y - grain.height / 2
        img.paste(grain, (int(px), int(py)), grain)

# 顶端一粒（竖直）
gw, gh = S * 0.075, S * 0.115
tip = Image.new("RGBA", (int(gw * 2.4), int(gh * 2.4)), (0, 0, 0, 0))
td = ImageDraw.Draw(tip)
td.ellipse([tip.width * 0.5 - gw / 2, tip.height * 0.5 - gh / 2,
            tip.width * 0.5 + gw / 2, tip.height * 0.5 + gh / 2], fill=CREAM)
img.paste(tip, (int(cx - tip.width / 2), int(top - tip.height * 0.28)), tip)

img = img.resize((OUT, OUT), Image.LANCZOS)
DST.parent.mkdir(parents=True, exist_ok=True)
img.save(DST, "PNG")
print("saved", DST, img.size, img.mode)
