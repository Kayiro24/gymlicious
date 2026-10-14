"""Reference implementation of ADR 0004; regenerates layout_test_vectors.json."""
import datetime
import json
import math
from pathlib import Path

GAP, ASPECT, MIN_COLS, MAX_COLS = 0.3, 0.8, 10, 31


def days_in_year(year):
    return 366 if (year % 4 == 0 and year % 100 != 0) or year % 400 == 0 else 365


def continuous(n, width, height):
    best = None
    for c in range(MIN_COLS, MAX_COLS + 1):
        rows = math.ceil(n / c)
        w = min(width / (c + (c - 1) * GAP), height / (rows + (rows - 1) * GAP) * ASPECT)
        if best is None or w > best[0] + 1e-9:
            best = (w, c, rows)
    w, c, rows = best
    h, gap = w / ASPECT, GAP * w
    x0 = (width - (c * w + (c - 1) * gap)) / 2
    y0 = (height - (rows * h + (rows - 1) * gap)) / 2
    rects = [[x0 + (i % c) * (w + gap), y0 + (i // c) * (h + gap), w, h] for i in range(n)]
    return {"columns": c, "rows": rows, "cellWidth": w, "rects": rects}


def months(year, width, height):
    best = None
    for bc, br in ((3, 4), (4, 3)):
        w = min(width / (bc * (7 + 6 * GAP) + (bc - 1)),
                height / (br * (7 / ASPECT + 6 * GAP) + (br - 1)))
        if best is None or w > best[0] + 1e-9:
            best = (w, bc, br)
    w, bc, br = best
    h, gap = w / ASPECT, GAP * w
    block_w, block_h = 7 * w + 6 * gap, 7 * h + 6 * gap
    total_w, total_h = bc * block_w + (bc - 1) * w, br * block_h + (br - 1) * w
    x0, y0 = (width - total_w) / 2, (height - total_h) / 2
    rects = []
    for m in range(12):
        bx = x0 + (m % bc) * (block_w + w)
        by = y0 + (m // bc) * (block_h + w)
        first = datetime.date(year, m + 1, 1)
        days = (datetime.date(year + (m == 11), (m + 1) % 12 + 1, 1) - first).days
        for d in range(days):
            index = first.isoweekday() - 1 + d
            rects.append([bx + (index % 7) * (w + gap), by + (1 + index // 7) * (h + gap), w, h])
    return {"blockColumns": bc, "blockRows": br, "cellWidth": w, "rects": rects}


CASES = [
    ("continuous", 2026, 360, 520), ("continuous", 2028, 360, 520),
    ("continuous", 2026, 1080, 1700), ("continuous", 2026, 800, 400),
    ("continuous", 2028, 1200, 1200), ("continuous", 2026, 300, 1000),
    ("months", 2026, 360, 520), ("months", 2028, 360, 520),
    ("months", 2026, 1080, 1700), ("months", 2026, 900, 500),
]
SAMPLE = [0, 1, 30, 31, 58, 59, 180, 364, 365]

cases = []
for layout, year, width, height in CASES:
    n = days_in_year(year)
    result = continuous(n, width, height) if layout == "continuous" else months(year, width, height)
    rects = result.pop("rects")
    result["dayCount"] = n
    result["samples"] = {str(i): [round(v, 6) for v in rects[i]] for i in SAMPLE if i < n}
    cases.append({"layout": layout, "year": year, "width": width, "height": height, "expected": result})

out = Path(__file__).with_name("layout_test_vectors.json")
out.write_text(json.dumps({"gapRatio": GAP, "aspect": ASPECT, "cases": cases}, indent=2) + "\n", encoding="utf-8", newline="\n")
print(f"wrote {len(cases)} cases")
