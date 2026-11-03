#!/usr/bin/env python3
"""从 ApiaryLog 的构建配置与自检脚本派生 Bake Ratio 版本（只改名字与 bundle id）。"""
import pathlib

SRC = pathlib.Path("/home/xykj211/ApiaryLog")
DST = pathlib.Path("/home/xykj211/BakeRatio")

pairs = [
    ("codemagic.yaml", "codemagic.yaml"),
    ("tools/selfcheck.py", "tools/selfcheck.py"),
]

for src_rel, dst_rel in pairs:
    text = (SRC / src_rel).read_text()
    text = text.replace("ApiaryLog", "BakeRatio").replace("com.example.apiarylog", "com.example.bakeratio")
    (DST / dst_rel).parent.mkdir(parents=True, exist_ok=True)
    (DST / dst_rel).write_text(text)
    print("生成", dst_rel)
