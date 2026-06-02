#!/usr/bin/env python3
"""
split_olympiad.py — process olympiad-math-stepwise-solutions-llama3-20k.json
into shards usable by the math/amc emulator engine.

Pipeline:
  1. Read the source file (Llama-3 SFT chat-template format).
  2. Extract (problem, solution) per record via the user/assistant headers.
  3. Drop parse failures and rare oversize records (>50 KB solution).
  4. Apply the same clean_text pipeline as split_amc.py:
       - normalize \[..\] / \(..\) / align-env LaTeX delimiters
       - strip AoPS shortcuts (\plus, \minus, etc.)
       - fix malformed \textXYZ (no brace)
       - convert tabular -> array
       - download remote images to data/img/
       - pre-render [asy] blocks via local `asy` -> data/dgm/{hash}.svg
  5. Shuffle deterministically (seed=11) and write shards (250 records each)
     to data/q/ and data/s/, plus meta.json.

The cleanup helpers are inlined (not imported from split_amc.py) so this
script is self-contained and the two pipelines can diverge if needed.
If you change a cleanup rule in one place, update the other.
"""

import json, re, os, sys, time, hashlib, random, subprocess, shutil
import urllib.request, urllib.error
from pathlib import Path

SRC = Path('/Users/anish/git/crypto-tool/src/main/webapp/math/olympiad/olympiad-math-stepwise-solutions-llama3-20k.json')
OUT_DIR = Path('/Users/anish/git/crypto-tool/src/main/webapp/math/olympiad/data')
DGM_DIR = OUT_DIR / 'dgm'
IMG_DIR = OUT_DIR / 'img'
# Reuse the AMC project's olympiad.asy / cse5.asy packages — they live one
# directory over and the data dir doesn't need its own copy.
ASY_LIB_DIR = Path('/Users/anish/git/crypto-tool/src/main/webapp/math/amc/asy')

SHARD_SIZE         = 250          # smaller than AMC's 500 for faster first load
RANDOM_SEED        = 11           # deterministic shuffle for reproducible chunks
ASY_TIMEOUT        = 20           # seconds per [asy] compile
MAX_SOLUTION_BYTES = 50_000       # one 542 KB outlier exists; cap at 50 KB
BUCKET             = 'olympiad-stepwise'

# ── Llama-3 chat-template extraction ────────────────────────────────────
LLAMA3_USER_RE = re.compile(
    r'<\|start_header_id\|>user<\|end_header_id\|>\s*(.*?)<\|eot_id\|>',
    re.DOTALL,
)
LLAMA3_ASST_RE = re.compile(
    r'<\|start_header_id\|>assistant<\|end_header_id\|>\s*(.*?)(?:<\|eot_id\|>|$)',
    re.DOTALL,
)

def parse_llama3_record(text):
    """Return (problem, solution) or (None, None) if either turn is missing."""
    um = LLAMA3_USER_RE.search(text)
    am = LLAMA3_ASST_RE.search(text)
    if not um or not am:
        return None, None
    return um.group(1).strip(), am.group(1).strip()

# ── \boxed{...} extractor (last balanced one) ───────────────────────────
def extract_boxed(s):
    idx = s.rfind('\\boxed{')
    if idx < 0:
        return None
    i = idx + 7
    depth = 1
    start = i
    while i < len(s) and depth > 0:
        c = s[i]
        if c == '{': depth += 1
        elif c == '}': depth -= 1
        i += 1
    return s[start:i-1] if depth == 0 else None

# ── Cleanup pipeline (mirror of split_amc.py — keep in sync!) ───────────
AOPS_SHORTCUTS = [
    (re.compile(r'\\plus(?![a-zA-Z])'),   '+'),
    (re.compile(r'\\minus(?![a-zA-Z])'),  '-'),
    (re.compile(r'\\equals(?![a-zA-Z])'), '='),
    (re.compile(r'\\equal(?![a-zA-Z])'),  '='),
    (re.compile(r'\\divide(?![a-zA-Z])'), r'\\div'),
]

# KaTeX doesn't support \renewcommand / \newcommand / \providecommand /
# \DeclareMathOperator. They appear inline in some olympiad sources
# (e.g. \renewcommand{\arraystretch}{1.5} around matrices) and silently
# break the entire math block. Strip them — the layout-tweaking is a
# minor cosmetic loss but the matrix below still renders.
LATEX_MACRO_DEFS_RE = re.compile(
    r'\\(?:renewcommand|newcommand|providecommand|DeclareMathOperator\*?)'
    r'\s*\{[^{}]*\}\s*(?:\[[^\]]*\])?\s*\{[^{}]*\}'
)
TEXT_NOBRACE_RE = re.compile(
    r'\\text(?!(?:bf|it|rm|sf|sl|sc|tt|md|up|color|style|width|height|normal|subscript|superscript)\b)'
    r'([a-z]{3,})\b'
)
ALIGN_ENV_RE = re.compile(
    r'(\\begin\{(?:align\*?|aligned|cases|equation\*?|gather\*?|gathered|multline\*?)\}'
    r'.*?'
    r'\\end\{(?:align\*?|aligned|cases|equation\*?|gather\*?|gathered|multline\*?)\})',
    re.DOTALL,
)
TABULAR_RE = re.compile(
    r'\\begin\{tabular\}\s*(?:\[[^\]]*\])?\s*\{([^}]*)\}'
    r'(.*?)'
    r'\\end\{tabular\}',
    re.DOTALL,
)

# Math environments where stray $ delimiters inside the body are a
# scraping artifact (the AoPS-source format wraps cell contents in $...$
# even though the outer env is already math mode). KaTeX errors out on
# the orphan $ inside the array. We strip them after the env is wrapped
# in $$.
MATH_ENV_NAMES_PAT = (
    r'(?:array|tabular|aligned|align\*?|cases|equation\*?|gather\*?|gathered'
    r'|multline\*?|matrix|pmatrix|bmatrix|vmatrix|Bmatrix|Vmatrix|smallmatrix)'
)
MATH_ENV_BLOCK_RE = re.compile(
    r'(\\begin\{' + MATH_ENV_NAMES_PAT + r'\}'
    r'(?:\s*(?:\[[^\]]*\])?\s*\{[^{}]*\})?'   # optional [pos] or {colspec}
    r'.*?'
    r'\\end\{' + MATH_ENV_NAMES_PAT + r'\})',
    re.DOTALL,
)

def strip_inner_dollars_in_math_envs(s):
    """Strip stray `$` inside math environment bodies — they came from
       scraping artifacts and break KaTeX's parser since the env is
       already math mode."""
    if not s or '\\begin{' not in s:
        return s
    def _strip(m):
        return m.group(1).replace('$', '')
    return MATH_ENV_BLOCK_RE.sub(_strip, s)
ASY_BLOCK_RE   = re.compile(r'\[asy\](.*?)\[/asy\]', re.DOTALL | re.IGNORECASE)
IMG_MD_INLINE  = re.compile(r'!\[[^\]]*\]\((https?://[^)\s]+\.(?:png|jpe?g|gif|svg|webp))\)', re.I)
IMG_BARE_URL   = re.compile(r'(?<![\[(])(https?://[^\s)\]]+\.(?:png|jpe?g|gif|svg|webp))', re.I)

_asy_stats     = {'total': 0, 'ok': 0, 'fail': 0, 'cached': 0}
_asy_cache     = {}
_asy_fail_errs = []
_img_stats     = {'total': 0, 'ok': 0, 'cached': 0, 'fail': 0}
_img_cache     = {}

def render_asy(asy_src):
    _asy_stats['total'] += 1
    h = hashlib.sha1(asy_src.encode('utf-8')).hexdigest()[:16]
    if h in _asy_cache:
        _asy_stats['cached'] += 1
        return _asy_cache[h]
    out_svg = DGM_DIR / f'{h}.svg'
    if out_svg.exists() and out_svg.stat().st_size > 0:
        _asy_stats['cached'] += 1
        marker = f'{{{{DGM:{h}}}}}'
        _asy_cache[h] = marker
        return marker

    prelude = (
        'settings.outformat="svg";\n'
        'defaultpen(linewidth(0.7));\n'
        'import geometry;\n'
        'import graph;\n'
        'import markers;\n'
        'import olympiad;\n'
        'import cse5;\n'
        'void dot(real x, real y, pen p=currentpen) { dot((x,y), p); }\n'
    )
    tmp_asy = DGM_DIR / f'{h}.asy'
    tmp_asy.write_text(prelude + asy_src, encoding='utf-8')

    env = os.environ.copy()
    gs_path = shutil.which('gs')
    if gs_path:
        env['GS'] = gs_path
    if ASY_LIB_DIR.exists():
        existing = env.get('ASYMPTOTE_DIR', '')
        env['ASYMPTOTE_DIR'] = str(ASY_LIB_DIR) + (':' + existing if existing else '')

    err_text = ''
    try:
        proc = subprocess.run(
            ['asy', '-f', 'svg', '-noprc', '-o', str(out_svg.with_suffix('')), str(tmp_asy)],
            capture_output=True, timeout=ASY_TIMEOUT, text=True, cwd=str(DGM_DIR),
            env=env,
        )
        ok = (proc.returncode == 0 and out_svg.exists() and out_svg.stat().st_size > 0)
        if not ok:
            err_text = (proc.stderr or '') + (proc.stdout or '')
    except (subprocess.TimeoutExpired, FileNotFoundError, OSError) as e:
        ok = False
        err_text = f'subprocess error: {e!r}'

    try: tmp_asy.unlink()
    except OSError: pass
    leftover_pdf = DGM_DIR / f'{h}_.pdf'
    if leftover_pdf.exists():
        try: leftover_pdf.unlink()
        except OSError: pass

    if ok:
        _asy_stats['ok'] += 1
        marker = f'{{{{DGM:{h}}}}}'
    else:
        _asy_stats['fail'] += 1
        _asy_fail_errs.append((h, err_text[:1200]))
        try:
            if out_svg.exists() and out_svg.stat().st_size == 0:
                out_svg.unlink()
        except OSError:
            pass
        marker = '(diagram unavailable)'

    _asy_cache[h] = marker
    return marker

def substitute_asy(s):
    if not s or '[asy]' not in s.lower():
        return s
    return ASY_BLOCK_RE.sub(lambda m: render_asy(m.group(1)), s)

def download_image(url):
    _img_stats['total'] += 1
    if url in _img_cache:
        _img_stats['cached'] += 1
        return _img_cache[url]
    h = hashlib.sha1(url.encode('utf-8')).hexdigest()[:16]
    ext = os.path.splitext(url.split('?', 1)[0])[1].lower()
    if ext not in ('.png', '.jpg', '.jpeg', '.gif', '.svg', '.webp'):
        ext = '.png'
    out_path = IMG_DIR / f'{h}{ext}'
    if out_path.exists() and out_path.stat().st_size > 0:
        _img_stats['cached'] += 1
        marker = f'{{{{IMG:{h}{ext}}}}}'
        _img_cache[url] = marker
        return marker
    try:
        req = urllib.request.Request(url, headers={
            'User-Agent': 'Mozilla/5.0 (split_olympiad.py image fetcher)'
        })
        with urllib.request.urlopen(req, timeout=15) as resp:
            data = resp.read()
        if len(data) < 50:
            raise ValueError(f'image too small ({len(data)} bytes)')
        out_path.write_bytes(data)
        _img_stats['ok'] += 1
        marker = f'{{{{IMG:{h}{ext}}}}}'
    except (urllib.error.URLError, ValueError, TimeoutError, OSError):
        _img_stats['fail'] += 1
        marker = '(figure unavailable)'
    _img_cache[url] = marker
    return marker

def substitute_images(s):
    if not s:
        return s
    s = IMG_MD_INLINE.sub(lambda m: download_image(m.group(1)), s)
    s = re.sub(
        r'\[([^\]]*)\]\((https?://[^)\s]+\.(?:png|jpe?g|gif|svg|webp))\)',
        lambda m: download_image(m.group(2)),
        s, flags=re.I,
    )
    s = IMG_BARE_URL.sub(lambda m: download_image(m.group(1)), s)
    return s

def fix_tabular(s):
    if not s or '\\begin{tabular}' not in s:
        return s
    def _repl(m):
        return r'$$\begin{array}{' + m.group(1) + r'}' + m.group(2) + r'\end{array}$$'
    return TABULAR_RE.sub(_repl, s)

def fix_text_nobrace(s):
    if not s or '\\text' not in s:
        return s
    return TEXT_NOBRACE_RE.sub(r'\\text{\1}', s)

# ── Plain-TeX → KaTeX (mirror of split_iit.py — keep in sync) ───────────
def _balanced_brace_replace(s, opener, replacement_fn):
    out = []
    i = 0
    while i < len(s):
        idx = s.find(opener, i)
        if idx < 0: out.append(s[i:]); break
        out.append(s[i:idx])
        depth = 1; j = idx + len(opener); start = j
        while j < len(s) and depth > 0:
            c = s[j]
            if c == '{': depth += 1
            elif c == '}': depth -= 1
            j += 1
        if depth == 0:
            out.append(replacement_fn(s[start:j-1])); i = j
        else:
            out.append(s[idx:]); break
    return ''.join(out)

PLAIN_TEX_ENVS = [
    ('pmatrix', 'pmatrix'), ('bmatrix', 'bmatrix'),
    ('Bmatrix', 'Bmatrix'), ('vmatrix', 'vmatrix'),
    ('Vmatrix', 'Vmatrix'), ('matrix',  'matrix'),
    ('cases',   'cases'),   ('eqalign', 'aligned'),
    ('displaylines', 'gathered'),
]
PLAIN_TEX_LIMITS_RE = re.compile(r'\\(int|sum|prod|oint|iint|iiint|coprod|bigcap|bigcup|bigvee|bigwedge|bigoplus|bigotimes|bigodot|biguplus|bigsqcup)_\\limits')
PLAIN_TEX_CR_RE     = re.compile(r'\\cr(?![a-zA-Z])')
PLAIN_TEX_ROOT_HEAD_RE = re.compile(r'\\root\s*(\d+|\{[^{}]*\})\s*\\of\s*')

def fix_plain_tex_root(s):
    if not s or '\\root' not in s: return s
    out = []; i = 0
    while i < len(s):
        m = PLAIN_TEX_ROOT_HEAD_RE.search(s, i)
        if not m: out.append(s[i:]); break
        out.append(s[i:m.start()])
        n = m.group(1).strip('{}'); j = m.end()
        if j < len(s) and s[j] == '{':
            depth = 1; k = j + 1
            while k < len(s) and depth > 0:
                if s[k] == '{': depth += 1
                elif s[k] == '}': depth -= 1
                k += 1
            if depth == 0:
                out.append('\\sqrt[' + n + ']{' + s[j+1:k-1] + '}'); i = k
            else:
                out.append(s[m.start():]); break
        else:
            k = j
            while k < len(s) and s[k] not in ' \t\n\\{}': k += 1
            out.append('\\sqrt[' + n + ']{' + s[j:k] + '}'); i = k
    return ''.join(out)

DOUBLE_DOLLAR_INLINE_RE = re.compile(r'\$\$([^$\n]+?)\$\$')

MERGE_ORPHAN_ENV_RE = re.compile(
    r'\$([^$\n]+?)\$\s*\$*\s*'
    r'(\\begin\{[A-Za-z]+\*?\}.*?\\end\{[A-Za-z]+\*?\})'
    r'\s*\$+',
    re.DOTALL
)
def merge_orphan_inline_env(s):
    if not s or '\\begin{' not in s: return s
    return MERGE_ORPHAN_ENV_RE.sub(r'$$\1 \2$$', s)

def collapse_intra_paragraph_whitespace(s):
    if not s: return s
    s = re.sub(r'\n{3,}', '\n\n', s)
    paras = re.split(r'\n{2,}', s)
    paras = [re.sub(r'\n', ' ', p)  for p in paras]
    paras = [re.sub(r' {2,}', ' ', p) for p in paras]
    paras = [p for p in paras if p.strip()]
    return '\n\n'.join(paras).strip()

def fix_inline_displaymath(s):
    if not s or '$$' not in s: return s
    out = []; last = 0
    for m in DOUBLE_DOLLAR_INLINE_RE.finditer(s):
        out.append(s[last:m.start()])
        content = m.group(1)
        before = s[m.start() - 1] if m.start() > 0 else '\n'
        after  = s[m.end()] if m.end() < len(s) else '\n'
        has_env = '\\begin{' in content
        if (before != '\n' or after != '\n') and not has_env:
            out.append('$' + content + '$')
        else:
            out.append(m.group(0))
        last = m.end()
    out.append(s[last:])
    return ''.join(out)

def fix_plain_tex(s):
    if not s: return s
    for plain_name, latex_name in PLAIN_TEX_ENVS:
        opener = '\\' + plain_name + '{'
        if opener in s:
            s = _balanced_brace_replace(
                s, opener,
                lambda content, env=latex_name:
                    '\\begin{' + env + '} ' + content + ' \\end{' + env + '}'
            )
    s = PLAIN_TEX_CR_RE.sub(r'\\\\', s)
    s = PLAIN_TEX_LIMITS_RE.sub(r'\\\1\\limits_', s)
    s = fix_plain_tex_root(s)
    return s

def clean_text(s):
    if not s:
        return s
    s = s.replace(r'\[', '$$').replace(r'\]', '$$')
    s = s.replace(r'\(', '$').replace(r'\)', '$')
    s = ALIGN_ENV_RE.sub(r'$$\1$$', s)
    s = re.sub(r'\${4,}', '$$', s)
    # Repair `$X$$$\begin{Y}…\end{Y}$$` orphan-inline-then-env source mistakes.
    s = merge_orphan_inline_env(s)
    for pat, repl in AOPS_SHORTCUTS:
        s = pat.sub(repl, s)
    s = LATEX_MACRO_DEFS_RE.sub('', s)
    s = fix_text_nobrace(s)
    s = fix_plain_tex(s)
    s = fix_inline_displaymath(s)
    s = fix_tabular(s)
    s = strip_inner_dollars_in_math_envs(s)
    if 'http' in s:
        s = substitute_images(s)
    if '[asy]' in s.lower():
        s = substitute_asy(s)
    s = collapse_intra_paragraph_whitespace(s)
    return s

# ── Main ────────────────────────────────────────────────────────────────
def main():
    t0 = time.time()
    print(f"Loading {SRC} ...", flush=True)
    with open(SRC) as f:
        data = json.load(f)
    print(f"  loaded {len(data):,} Llama-3 records in {time.time()-t0:.1f}s", flush=True)

    OUT_DIR.mkdir(parents=True, exist_ok=True)
    (OUT_DIR / 'q').mkdir(exist_ok=True)
    (OUT_DIR / 's').mkdir(exist_ok=True)
    DGM_DIR.mkdir(exist_ok=True)
    IMG_DIR.mkdir(exist_ok=True)

    if not shutil.which('asy'):
        print("  WARNING: `asy` not in PATH — [asy] blocks will fall back to '(diagram unavailable)'.", flush=True)

    # Pass 1: parse, classify, clean
    records = []
    stats = {
        'parse_fail': 0, 'oversize_dropped': 0,
        'has_answer': 0, 'no_answer': 0,
        'has_int_answer': 0, 'has_expr_answer': 0,
    }

    for idx, item in enumerate(data):
        text = item.get('text', '')
        problem_raw, solution_raw = parse_llama3_record(text)
        if not problem_raw or not solution_raw:
            stats['parse_fail'] += 1
            continue
        if len(solution_raw) > MAX_SOLUTION_BYTES:
            stats['oversize_dropped'] += 1
            continue

        # Extract boxed answer from RAW solution before cleanup (regex
        # expects raw backslash sequences).
        boxed = extract_boxed(solution_raw)

        problem  = clean_text(problem_raw)
        solution = clean_text(solution_raw)

        record = {
            'i':   idx,
            'fmt': 'free',          # olympiad-stepwise is free-response
            'p':   problem,
            'sol': solution,
        }

        if boxed:
            cleaned = boxed.strip()
            if re.fullmatch(r'-?\d{1,4}', cleaned):
                record['a'] = cleaned
                record['t'] = 'int'
                stats['has_int_answer'] += 1
            else:
                record['a'] = clean_text(cleaned)
                record['t'] = 'expr'
                stats['has_expr_answer'] += 1
            stats['has_answer'] += 1
        else:
            record['a'] = ''
            record['t'] = ''
            stats['no_answer'] += 1

        records.append(record)

    print(f"\n=== Classification ===")
    print(f"  parsed records:              {len(records):,}")
    print(f"  parse failures:              {stats['parse_fail']:,}")
    print(f"  oversize dropped (>50 KB):   {stats['oversize_dropped']:,}")
    print(f"  has boxed answer:            {stats['has_answer']:,}")
    print(f"    integer:                   {stats['has_int_answer']:,}")
    print(f"    expression:                {stats['has_expr_answer']:,}")
    print(f"  no boxed answer:             {stats['no_answer']:,}")

    # Shuffle deterministically for reproducible sharding.
    rng = random.Random(RANDOM_SEED)
    rng.shuffle(records)

    # Write shards
    meta = {
        'version': 1,
        'generated_at': time.strftime('%Y-%m-%dT%H:%M:%S'),
        'shard_size': SHARD_SIZE,
        'total': len(records),
        'buckets': {},
    }
    n = len(records)
    nshards = (n + SHARD_SIZE - 1) // SHARD_SIZE
    q_shards = []
    s_shards = []
    total_q_bytes = 0
    total_s_bytes = 0

    for sh in range(nshards):
        chunk = records[sh*SHARD_SIZE : (sh+1)*SHARD_SIZE]
        q_data = []
        s_data = []
        for r in chunk:
            qid = f"{BUCKET}-{r['i']:06d}"
            qrec = {'id': qid, 'fmt': r['fmt'], 'p': r['p'], 'a': r['a']}
            if r.get('t'):
                qrec['t'] = r['t']
            q_data.append(qrec)
            s_data.append({'id': qid, 'sol': r['sol']})
        q_path = OUT_DIR / 'q' / f"{BUCKET}-{sh:03d}.json"
        s_path = OUT_DIR / 's' / f"{BUCKET}-{sh:03d}.json"
        with open(q_path, 'w') as f:
            json.dump(q_data, f, ensure_ascii=False, separators=(',', ':'))
        with open(s_path, 'w') as f:
            json.dump(s_data, f, ensure_ascii=False, separators=(',', ':'))
        q_sz = q_path.stat().st_size
        s_sz = s_path.stat().st_size
        total_q_bytes += q_sz
        total_s_bytes += s_sz
        q_shards.append({'f': q_path.name, 'n': len(q_data), 'b': q_sz})
        s_shards.append({'f': s_path.name, 'n': len(s_data), 'b': s_sz})

    meta['buckets'][BUCKET] = {
        'count': n,
        'shard_count': nshards,
        'q_shards': q_shards,
        's_shards': s_shards,
    }

    meta_path = OUT_DIR / 'meta.json'
    with open(meta_path, 'w') as f:
        json.dump(meta, f, ensure_ascii=False, indent=2)

    print(f"\n=== Output ===")
    print(f"  meta.json:           {meta_path.stat().st_size:>10,} bytes")
    print(f"  question shards:     {total_q_bytes:>10,} bytes  ({total_q_bytes/1024/1024:.1f} MB)")
    print(f"  solution shards:     {total_s_bytes:>10,} bytes  ({total_s_bytes/1024/1024:.1f} MB)")
    print(f"  total chunks:        {nshards}")

    print(f"\n=== Asymptote diagrams ===")
    print(f"  [asy] blocks seen:   {_asy_stats['total']:,}")
    print(f"  rendered OK:         {_asy_stats['ok']:,}")
    print(f"  cached (skipped):    {_asy_stats['cached']:,}")
    print(f"  failed → fallback:   {_asy_stats['fail']:,}")
    dgm_files = list(DGM_DIR.glob('*.svg')) if DGM_DIR.exists() else []
    dgm_bytes = sum(f.stat().st_size for f in dgm_files)
    print(f"  SVGs on disk:        {len(dgm_files):,} files, {dgm_bytes/1024:.1f} KB")

    print(f"\n=== Remote figures ===")
    print(f"  image refs seen:     {_img_stats['total']:,}")
    print(f"  downloaded OK:       {_img_stats['ok']:,}")
    print(f"  cached (skipped):    {_img_stats['cached']:,}")
    print(f"  failed → fallback:   {_img_stats['fail']:,}")
    img_files = [f for f in IMG_DIR.glob('*') if f.is_file() and not f.name.startswith('.')]
    img_bytes = sum(f.stat().st_size for f in img_files)
    print(f"  images on disk:      {len(img_files):,} files, {img_bytes/1024:.1f} KB")

    if _asy_fail_errs:
        log_path = DGM_DIR / '_failures.log'
        with open(log_path, 'w') as f:
            for h, err in _asy_fail_errs:
                f.write(f'=== {h} ===\n{err}\n\n')
        print(f"  asy failure log: {log_path}")

    print(f"\n  Total elapsed: {time.time()-t0:.1f}s")


if __name__ == '__main__':
    main()
