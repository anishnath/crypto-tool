#!/usr/bin/env python3
"""
generate_worksheet_metadata.py — scans every worksheet JSON under
src/main/webapp/worksheet/math/<category>/<file>.json and emits a
single index file the worksheet pages (and front-end lookups) can use
to discover what worksheets exist, how many problems each one has,
which question types it covers, and the difficulty distribution.

Run after EVERY generator change:

    python3 generate_worksheet_metadata.py

Output:
    src/main/webapp/worksheet/math/worksheet-index.json   (global)
    src/main/webapp/worksheet/math/<cat>/_meta.json       (per-category)

Both files are deterministic — same generator inputs → same metadata.
The per-category file is useful for pages that only need one topic's
info (e.g. /math/algebra/index.jsp can fetch _meta.json without pulling
the full global index).

Convention enforced:
  - Each problem must have `type` and `difficulty` keys (basic / medium /
    hard / scholar).  Counted into per-worksheet histograms.
  - SymPy verification is the generator's responsibility — this script
    only audits the OUTPUT counts and flags suspicious imbalances
    (e.g. a difficulty tier with 0 problems, or a type with <5 instances
    suggesting variant exhaustion).
"""

from __future__ import annotations

import json
import os
import sys
from collections import Counter
from datetime import datetime, timezone

REPO_ROOT      = os.path.dirname(os.path.abspath(__file__))
WORKSHEET_ROOT = os.path.join(REPO_ROOT, "src", "main", "webapp", "worksheet", "math")
GLOBAL_INDEX   = os.path.join(WORKSHEET_ROOT, "worksheet-index.json")

# Difficulty tiers in canonical order.  Used both for sorting the
# histograms and for warning when a tier is missing.
DIFF_ORDER = ["basic", "medium", "hard", "scholar"]

# Warn when a single type has fewer than this many instances — usually
# means the generator's variant pool is exhausted (dedup on q_latex).
LOW_VARIETY_THRESHOLD = 5


def scan_worksheet(path: str) -> dict | None:
    """Read one worksheet JSON and return its metadata blob.  Returns
    None if the file is malformed."""
    try:
        with open(path, encoding="utf-8") as f:
            d = json.load(f)
    except (json.JSONDecodeError, OSError) as e:
        print(f"  ⚠ skipping {path}: {e}", file=sys.stderr)
        return None

    questions = d.get("questions") or []
    types     = Counter(q.get("type", "unknown") for q in questions)
    diffs     = Counter(q.get("difficulty", "unknown") for q in questions)
    figures   = sum(1 for q in questions if q.get("figure_svg"))

    # Order types by count desc; difficulties by canonical tier order.
    types_sorted = dict(sorted(types.items(), key=lambda kv: (-kv[1], kv[0])))
    diffs_sorted = {d: diffs.get(d, 0) for d in DIFF_ORDER}
    # Add any non-canonical difficulties at the end.
    for k, v in diffs.items():
        if k not in diffs_sorted:
            diffs_sorted[k] = v

    warnings = []
    for tier in DIFF_ORDER:
        if diffs_sorted.get(tier, 0) == 0 and questions:
            warnings.append(f"no '{tier}' problems")
    low_variety = [t for t, c in types.items() if c < LOW_VARIETY_THRESHOLD]
    if low_variety:
        warnings.append(f"low-variety types ({len(low_variety)}): "
                        + ", ".join(sorted(low_variety)[:5])
                        + (" …" if len(low_variety) > 5 else ""))

    return {
        "topic":         d.get("topic") or os.path.basename(path).replace(".json", ""),
        "description":   d.get("description", ""),
        "total":         len(questions),
        "type_count":    len(types),
        "types":         types_sorted,
        "difficulty":    diffs_sorted,
        "has_figures":   figures,
        "size_bytes":    os.path.getsize(path),
        "warnings":      warnings,
    }


def scan_category(cat_dir: str, cat_name: str) -> dict:
    """Scan all worksheet files in one category directory."""
    worksheets = []
    for fn in sorted(os.listdir(cat_dir)):
        if not fn.endswith(".json"):  continue
        if fn.startswith("_"):        continue   # _meta.json etc.
        if "_sample" in fn:           continue   # *_sample.json — skip preview banks

        path = os.path.join(cat_dir, fn)
        entry = scan_worksheet(path)
        if entry is None:
            continue

        entry["file"] = fn
        entry["url"]  = f"/worksheet/math/{cat_name}/{fn}"
        worksheets.append(entry)

    return {
        "name":             cat_name,
        "worksheet_count":  len(worksheets),
        "total_questions":  sum(w["total"] for w in worksheets),
        "worksheets":       worksheets,
    }


def main():
    if not os.path.isdir(WORKSHEET_ROOT):
        print(f"FATAL: {WORKSHEET_ROOT} not found", file=sys.stderr)
        sys.exit(1)

    categories = {}
    for cat_name in sorted(os.listdir(WORKSHEET_ROOT)):
        cat_dir = os.path.join(WORKSHEET_ROOT, cat_name)
        if not os.path.isdir(cat_dir):
            continue
        cat_meta = scan_category(cat_dir, cat_name)
        if not cat_meta["worksheets"]:
            continue
        categories[cat_name] = cat_meta

        # Per-category mini-index for fast lookups by topic-specific pages.
        per_cat_path = os.path.join(cat_dir, "_meta.json")
        with open(per_cat_path, "w", encoding="utf-8") as f:
            json.dump(cat_meta, f, indent=2, ensure_ascii=False)

    index = {
        "generated_at":      datetime.now(timezone.utc).isoformat(),
        "schema_version":    1,
        "total_categories":  len(categories),
        "total_worksheets":  sum(c["worksheet_count"] for c in categories.values()),
        "total_questions":   sum(c["total_questions"] for c in categories.values()),
        "categories":        categories,
    }

    with open(GLOBAL_INDEX, "w", encoding="utf-8") as f:
        json.dump(index, f, indent=2, ensure_ascii=False)

    # ── Console summary ──────────────────────────────────────────────
    print(f"Wrote {os.path.relpath(GLOBAL_INDEX, REPO_ROOT)}")
    print(f"  {index['total_categories']} categories  "
          f"·  {index['total_worksheets']} worksheets  "
          f"·  {index['total_questions']:,} questions")
    print()
    for cat_name, cat_meta in categories.items():
        print(f"  {cat_name}/  ({cat_meta['worksheet_count']} sheets, "
              f"{cat_meta['total_questions']:,} questions)")
        for w in cat_meta["worksheets"]:
            kb = w["size_bytes"] / 1024
            warn = (" ⚠ " + "; ".join(w["warnings"])) if w["warnings"] else ""
            print(f"    {w['file']:48s}  "
                  f"{w['total']:>5}q  "
                  f"{w['type_count']:>2}t  "
                  f"{kb:>6.0f}KB"
                  f"{warn}")


if __name__ == "__main__":
    main()
