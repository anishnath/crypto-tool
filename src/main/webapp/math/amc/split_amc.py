#!/usr/bin/env python3
"""
Split amc_aime.json (217MB, 66178 items) into question + solution shards
indexed by meta.json. Drops the `messages` duplicate field, extracts the
final \\boxed{...} answer, parses MCQ choices and normalizes the answer
to a letter (A-E) where possible.
"""

import json, re, os, sys, time, hashlib, random, subprocess, shutil
from pathlib import Path

SRC = Path('/Users/anish/git/crypto-tool/src/main/webapp/math/amc/amc_aime.json')
OUT_DIR = Path('/Users/anish/git/crypto-tool/src/main/webapp/math/amc/data')
DGM_DIR = OUT_DIR / 'dgm'
# Asymptote include path for olympiad.asy / cse5.asy (real AoPS packages).
# Kept outside data/dgm/ so the committed dgm/ contains only generated SVG.
ASY_LIB_DIR = Path('/Users/anish/git/crypto-tool/src/main/webapp/math/amc/asy')
SHARD_SIZE = 500
RANDOM_SEED = 7  # deterministic shuffle for reproducible chunks
ASY_TIMEOUT = 20  # seconds; AoPS diagrams should compile fast

# ── Asymptote diagram pre-rendering ─────────────────────────────────────
# AMC/AIME problems often embed [asy]…[/asy] vector-graphics blocks.
# KaTeX can't render Asymptote; we shell out to the `asy` binary at
# generation time and store one SVG per unique block under data/dgm/.
# The block is replaced in the stored text with the marker {{DGM:<hash>}}
# which the front-end substitutes into an <img> after HTML-escaping the
# surrounding prose.
ASY_BLOCK_RE = re.compile(r'\[asy\](.*?)\[/asy\]', re.DOTALL | re.IGNORECASE)
_asy_stats = {'total': 0, 'ok': 0, 'fail': 0, 'cached': 0}
_asy_cache = {}   # hash → marker-or-fallback string
_asy_fail_errs = []   # collected stderr from failed compiles for inspection

def _asy_available():
    return shutil.which('asy') is not None

def render_asy(asy_src: str) -> str:
    """Compile one [asy] block to SVG, return the in-text marker to embed.
       Falls back to a visible '(diagram unavailable)' string on failure."""
    _asy_stats['total'] += 1
    h = hashlib.sha1(asy_src.encode('utf-8')).hexdigest()[:16]

    # Cache within this run + on-disk cache so reruns skip work.
    if h in _asy_cache:
        _asy_stats['cached'] += 1
        return _asy_cache[h]

    out_svg = DGM_DIR / f'{h}.svg'
    if out_svg.exists() and out_svg.stat().st_size > 0:
        _asy_stats['cached'] += 1
        marker = f'{{{{DGM:{h}}}}}'
        _asy_cache[h] = marker
        return marker

    # AoPS Wiki auto-imports olympiad + cse5 in its sandbox; we resolve
    # them via ASYMPTOTE_DIR pointing at math/amc/asy/ (real packages).
    # The trailing helpers patch a couple of common overloads that the
    # packages lack — kept inline so the downloaded packages stay pristine.
    prelude = (
        'settings.outformat="svg";\n'
        'defaultpen(linewidth(0.7));\n'
        'import geometry;\n'
        'import graph;\n'
        'import markers;\n'
        'import olympiad;\n'
        'import cse5;\n'
        # Inline helpers patching overloads that stray AMC blocks call
        # but neither olympiad nor cse5 provides:
        'void dot(real x, real y, pen p=currentpen) { dot((x,y), p); }\n'
    )
    tmp_asy = DGM_DIR / f'{h}.asy'
    tmp_asy.write_text(prelude + asy_src, encoding='utf-8')

    err_text = ''
    # Asymptote needs an explicit GS env var to find Ghostscript on macOS
    # when not in the default search path, plus ASYMPTOTE_DIR so it can
    # resolve `import olympiad;` / `import cse5;` from math/amc/asy/.
    env = os.environ.copy()
    gs_path = shutil.which('gs')
    if gs_path:
        env['GS'] = gs_path
    if ASY_LIB_DIR.exists():
        existing = env.get('ASYMPTOTE_DIR', '')
        env['ASYMPTOTE_DIR'] = str(ASY_LIB_DIR) + (':' + existing if existing else '')
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

    # Always clean up the .asy temp file and any intermediate .pdf asy
    # leaves behind when GS-conversion stalls — keep only the .svg output.
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
        # Best-effort: drop any partial SVG to avoid serving a broken file.
        try:
            if out_svg.exists() and out_svg.stat().st_size == 0:
                out_svg.unlink()
        except OSError:
            pass
        marker = '(diagram unavailable)'

    _asy_cache[h] = marker
    return marker

def substitute_asy(s: str) -> str:
    if not s or '[asy]' not in s.lower():
        return s
    return ASY_BLOCK_RE.sub(lambda m: render_asy(m.group(1)), s)

# ── Remote image download / caching ─────────────────────────────────────
# Some AMC/AIME problems reference figures via remote URLs (AoPS-hosted
# .png/.jpg).  We download them to data/img/ at generation time so the
# emulator can show diagrams without leaning on AoPS's CDN.
IMG_DIR = OUT_DIR / 'img'
_img_stats = {'total': 0, 'ok': 0, 'cached': 0, 'fail': 0}
_img_cache = {}   # url → marker-or-fallback

import urllib.request, urllib.error

def download_image(url: str) -> str:
    _img_stats['total'] += 1
    if url in _img_cache:
        _img_stats['cached'] += 1
        return _img_cache[url]

    # Hash by URL so the same remote asset maps to one local file.
    h = hashlib.sha1(url.encode('utf-8')).hexdigest()[:16]
    ext = os.path.splitext(url.split('?', 1)[0])[1].lower()
    if ext not in ('.png', '.jpg', '.jpeg', '.gif', '.svg', '.webp'):
        ext = '.png'  # fallback; rare
    out_path = IMG_DIR / f'{h}{ext}'

    if out_path.exists() and out_path.stat().st_size > 0:
        _img_stats['cached'] += 1
        marker = f'{{{{IMG:{h}{ext}}}}}'
        _img_cache[url] = marker
        return marker

    try:
        req = urllib.request.Request(url, headers={
            'User-Agent': 'Mozilla/5.0 (split_amc.py image fetcher)'
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

def substitute_images(s: str) -> str:
    if not s:
        return s
    # 1) Markdown image embed ![alt](url) → marker
    s = IMG_MD_INLINE.sub(lambda m: download_image(m.group(1)), s)
    # 2) Markdown link pointing at image [label](url-ending-in-img-ext)
    #    Replace the whole [label](url) with the local marker (drop the label
    #    since the image itself conveys the figure).
    s = re.sub(
        r'\[([^\]]*)\]\((https?://[^)\s]+\.(?:png|jpe?g|gif|svg|webp))\)',
        lambda m: download_image(m.group(2)),
        s, flags=re.I,
    )
    # 3) Bare URL not inside a markdown link
    s = IMG_BARE_URL.sub(lambda m: download_image(m.group(1)), s)
    return s

# ── Tabular → array conversion ──────────────────────────────────────────
def fix_tabular(s: str) -> str:
    if not s or '\\begin{tabular}' not in s:
        return s
    def _repl(m):
        cols = m.group(1)
        body = m.group(2)
        return r'$$\begin{array}{' + cols + r'}' + body + r'\end{array}$$'
    return TABULAR_RE.sub(_repl, s)

# ── Brace-fix for malformed \textXYZ (no opening brace) ─────────────────
def fix_text_nobrace(s: str) -> str:
    if not s or '\\text' not in s:
        return s
    return TEXT_NOBRACE_RE.sub(r'\\text{\1}', s)

# --- Text cleanup: normalize LaTeX delimiters to $ / $$ so the JS-side
#     KaTeX renderer (which only recognizes $-style math) picks them up. ---
#
# Why this matters:
#   AoPS-style solution text mixes \[ … \] (display) and \( … \) (inline)
#   delimiters, plus the occasional \begin{align}, \begin{cases}, etc.
#   The exam-engine.js renderMath() only splits on $ / $$.  Without this
#   normalization, ~2.1k display-math blocks per shard render as raw
#   backslash-bracket text inside review-mode solutions.
ALIGN_ENV_RE = re.compile(
    r'(\\begin\{(?:align\*?|aligned|cases|equation\*?|gather\*?|gathered|multline\*?)\}'
    r'.*?'
    r'\\end\{(?:align\*?|aligned|cases|equation\*?|gather\*?|gathered|multline\*?)\})',
    re.DOTALL,
)

# AoPS-wiki LaTeX shortcuts that aren't real LaTeX and trip KaTeX with
# "Error compiling LaTeX. Unknown error_msg".  Mapped to plain operators
# or their real LaTeX equivalent.  The (?![a-zA-Z]) lookahead avoids
# eating legitimate longer-name commands that happen to share a prefix.
# Order: \equals before \equal so the longer name wins first.
AOPS_SHORTCUTS = [
    (re.compile(r'\\plus(?![a-zA-Z])'),   '+'),
    (re.compile(r'\\minus(?![a-zA-Z])'),  '-'),
    (re.compile(r'\\equals(?![a-zA-Z])'), '='),
    (re.compile(r'\\equal(?![a-zA-Z])'),  '='),
    (re.compile(r'\\divide(?![a-zA-Z])'), r'\\div'),
]

# KaTeX doesn't support \renewcommand / \newcommand / \providecommand /
# \DeclareMathOperator. Strip them so they don't break the surrounding
# math block (e.g. \renewcommand{\arraystretch}{1.5} before a matrix).
LATEX_MACRO_DEFS_RE = re.compile(
    r'\\(?:renewcommand|newcommand|providecommand|DeclareMathOperator\*?)'
    r'\s*\{[^{}]*\}\s*(?:\[[^\]]*\])?\s*\{[^{}]*\}'
)

# \text followed directly by lowercase letters (no brace) — broken in the
# source (e.g. \textnoneofthese instead of \text{none of these}).  Wrap
# the trailing letters in braces so KaTeX renders them as text. We can't
# reliably restore the missing spaces, but at least the user sees
# "noneofthese" in text mode instead of a literal "textnoneofthese".
# Negative lookahead avoids real LaTeX commands like \textbf, \textit, etc.
TEXT_NOBRACE_RE = re.compile(
    r'\\text(?!(?:bf|it|rm|sf|sl|sc|tt|md|up|color|style|width|height|normal|subscript|superscript)\b)'
    r'([a-z]{3,})\b'
)

# \begin{tabular}[pos]{cols} … \end{tabular} → $$\begin{array}{cols}…\end{array}$$
# KaTeX doesn't support tabular but does support array; the markup is
# otherwise compatible (& separators, \\ row breaks, \hline).
TABULAR_RE = re.compile(
    r'\\begin\{tabular\}\s*(?:\[[^\]]*\])?\s*\{([^}]*)\}'
    r'(.*?)'
    r'\\end\{tabular\}',
    re.DOTALL,
)

# Math envs where inner `$` delimiters are a scraping artifact — they
# wrap cell contents even though the env is already in math mode.
# KaTeX chokes on the orphan $ inside the array; we strip them after
# the env is wrapped in $$.
MATH_ENV_NAMES_PAT = (
    r'(?:array|tabular|aligned|align\*?|cases|equation\*?|gather\*?|gathered'
    r'|multline\*?|matrix|pmatrix|bmatrix|vmatrix|Bmatrix|Vmatrix|smallmatrix)'
)
MATH_ENV_BLOCK_RE = re.compile(
    r'(\\begin\{' + MATH_ENV_NAMES_PAT + r'\}'
    r'(?:\s*(?:\[[^\]]*\])?\s*\{[^{}]*\})?'
    r'.*?'
    r'\\end\{' + MATH_ENV_NAMES_PAT + r'\})',
    re.DOTALL,
)

def strip_inner_dollars_in_math_envs(s):
    """Strip stray `$` inside math environment bodies — scraping artifact
       that breaks KaTeX (env is already in math mode)."""
    if not s or '\\begin{' not in s:
        return s
    def _strip(m):
        return m.group(1).replace('$', '')
    return MATH_ENV_BLOCK_RE.sub(_strip, s)

# Markdown image embeds + image-target links — for downloading remote
# assets to data/img/ at generation time.
IMG_MD_INLINE = re.compile(r'!\[[^\]]*\]\((https?://[^)\s]+\.(?:png|jpe?g|gif|svg|webp))\)', re.I)
IMG_BARE_URL  = re.compile(r'(?<![\[(])(https?://[^\s)\]]+\.(?:png|jpe?g|gif|svg|webp))', re.I)

def clean_text(s: str) -> str:
    """Normalize alt-delimiter LaTeX to $ / $$ so the front-end renderer picks it up."""
    if not s:
        return s
    # \[ … \] (display) → $$ … $$ ; \( … \) (inline) → $ … $.
    # Pairwise replacement is safe — opener and closer alternate in source.
    s = s.replace(r'\[', '$$').replace(r'\]', '$$')
    s = s.replace(r'\(', '$').replace(r'\)', '$')
    # Wrap math environments so KaTeX sees them inside $$ display mode.
    s = ALIGN_ENV_RE.sub(r'$$\1$$', s)
    # Collapse accidental $$$$ runs that the wrap can produce when an
    # environment was already inside a \[ … \] block (now $$).
    s = re.sub(r'\${4,}', '$$', s)
    # Strip AoPS-wiki LaTeX shortcuts that KaTeX doesn't recognize.
    for pat, repl in AOPS_SHORTCUTS:
        s = pat.sub(repl, s)
    # Strip \renewcommand / \newcommand definitions KaTeX can't parse.
    s = LATEX_MACRO_DEFS_RE.sub('', s)
    # Fix malformed \textXYZ (no opening brace) → \text{XYZ}.
    s = fix_text_nobrace(s)
    # Convert tabular environments to array so KaTeX can render them.
    s = fix_tabular(s)
    # Strip stray `$` inside math environment bodies (array, aligned, …).
    s = strip_inner_dollars_in_math_envs(s)
    # Download remote figure images and replace with {{IMG:hash}} markers.
    if 'http' in s:
        s = substitute_images(s)
    # Pre-render [asy] diagrams to SVG (shells out to the `asy` binary).
    # Substitution returns a {{DGM:<hash>}} marker the front-end swaps for an
    # <img> tag.  Slow op (a few seconds per unique diagram), but cached by
    # SHA-1 so reruns + duplicate blocks skip the work.
    if '[asy]' in s.lower():
        s = substitute_asy(s)
    return s

# Normalize a free-response answer string. AMC items that were misclassified
# as AIME (because detect_mcq missed the choice block) sometimes end up here
# with values like '\text{A}' or '\textbf{(C)}'. Pull out the letter.
ANSWER_LETTER_RE = re.compile(
    r'^\\(?:textbf|text|mathrm)\s*\{\s*\(?\s*([A-E])\s*\)?\s*\}\s*$'
)

def normalize_free_answer(a: str) -> str:
    """If the free-response answer is actually a wrapped MCQ letter, return
       just the letter — otherwise return the cleaned input."""
    if not a:
        return a
    m = ANSWER_LETTER_RE.match(a.strip())
    if m:
        return m.group(1)
    return a

# --- Boxed extractor (last balanced \boxed{...}) ---
def extract_boxed(s: str):
    idx = s.rfind('\\boxed{')
    if idx < 0:
        return None
    i = idx + 7
    depth = 1
    start = i
    while i < len(s) and depth > 0:
        c = s[i]
        if c == '{':
            depth += 1
        elif c == '}':
            depth -= 1
        i += 1
    return s[start:i-1] if depth == 0 else None

# --- MCQ detection in problem ---
MCQ_LATEX_CHOICE = re.compile(
    r'\\(?:textbf|text|mathrm)\s*\{\s*\(?([A-E])\)?\s*\}'
)
MCQ_LINE_CHOICE = re.compile(
    r'(?m)^\s*([A-E])\)\s+'
)

def detect_mcq(problem: str) -> bool:
    return bool(MCQ_LATEX_CHOICE.search(problem) or MCQ_LINE_CHOICE.search(problem))

# --- Parse choices: returns dict {letter: choice_text} ---
def parse_choices(problem: str) -> dict:
    """
    Splits the problem text on choice markers like \textbf{(A)}, A), \text{(A)} etc.
    Returns a dict {'A': '...', 'B': '...', ...}. Best-effort — missing letters return empty.
    """
    # Find all choice marker positions
    markers = []  # list of (position, letter, marker_length)
    for m in MCQ_LATEX_CHOICE.finditer(problem):
        markers.append((m.start(), m.group(1), m.end()))
    if not markers:
        for m in MCQ_LINE_CHOICE.finditer(problem):
            markers.append((m.start(), m.group(1), m.end()))
    if not markers:
        return {}

    # Dedupe (sometimes \textbf{(A)} appears twice if there are sub-clauses)
    seen_letters = {}
    for pos, letter, end in markers:
        if letter not in seen_letters:
            seen_letters[letter] = (pos, end)

    sorted_markers = sorted(seen_letters.items(), key=lambda x: x[1][0])
    choices = {}
    for i, (letter, (pos, end)) in enumerate(sorted_markers):
        next_pos = sorted_markers[i+1][1][0] if i + 1 < len(sorted_markers) else len(problem)
        text = problem[end:next_pos]
        # Trim trailing \qquad / whitespace / $ / line breaks
        text = re.sub(r'\\qquad\s*$', '', text)
        text = re.sub(r'\\quad\s*$', '', text)
        text = text.strip().rstrip('$').strip()
        text = text.lstrip('\\').strip()  # strip leading \  from \ 3
        # Strip a leading "\ " that LaTeX uses after \textbf{(A)}
        if text.startswith('\\ '):
            text = text[2:].strip()
        choices[letter] = text
    return choices

# --- Normalize answer text for matching ---
def norm_for_match(s: str) -> str:
    if not s:
        return ''
    s = s.strip()
    # Strip leading/trailing $
    s = s.strip('$').strip()
    # Strip common LaTeX wrappers
    s = re.sub(r'^\\text(?:bf|rm|tt)?\{', '', s)
    s = s.rstrip('}').strip()
    # Collapse whitespace
    s = re.sub(r'\s+', ' ', s)
    # Strip outer ( )
    s = s.strip()
    return s.lower()

# --- Boxed → letter ---
LETTER_IN_BOXED = re.compile(
    r'\\(?:textbf|text|mathrm)\s*\{\s*\(?([A-E])\)?\s*\}|^\(?([A-E])\)?\s*$|\\text\{([A-E])\}'
)

def boxed_to_letter(boxed: str, choices: dict):
    """
    Resolve boxed answer to a letter. Tries:
    1) Explicit letter marker in boxed (\textbf{(D)}, (D), D)
    2) Match boxed value against choices values
    """
    if boxed is None:
        return None
    b = boxed.strip()
    # 1) explicit letter marker
    m = LETTER_IN_BOXED.search(b)
    if m:
        for g in m.groups():
            if g:
                return g
    # 2) match against choices
    if choices:
        b_norm = norm_for_match(b)
        # Drop a leading "\textbf{(L)}\ " if the boxed includes both the marker and value
        b_clean = re.sub(r'\\(?:textbf|text|mathrm)\s*\{\s*\(?[A-E]\)?\s*\}\s*\\?\s*', '', b).strip()
        b_clean_norm = norm_for_match(b_clean)
        for letter, ctext in choices.items():
            cnorm = norm_for_match(ctext)
            if cnorm and (cnorm == b_norm or cnorm == b_clean_norm):
                return letter
            # Looser: digits-only equality
            if re.fullmatch(r'-?\d+(?:\.\d+)?', cnorm or '') and cnorm == b_norm:
                return letter
    return None

# --- Bucket assignment ---
def bucket_of(item):
    src = item.get('source')
    prob = item.get('problem', '')
    is_mcq = detect_mcq(prob)
    if src == 'amc_aime':
        return 'amc-real' if is_mcq else 'aime-real'
    return 'practice'

# --- Main ---
def main():
    t0 = time.time()
    print(f"Loading {SRC} ...", flush=True)
    with open(SRC) as f:
        data = json.load(f)
    print(f"  loaded {len(data):,} items in {time.time()-t0:.1f}s", flush=True)

    OUT_DIR.mkdir(parents=True, exist_ok=True)
    (OUT_DIR / 'q').mkdir(exist_ok=True)
    (OUT_DIR / 's').mkdir(exist_ok=True)
    DGM_DIR.mkdir(exist_ok=True)
    IMG_DIR.mkdir(exist_ok=True)
    if not _asy_available():
        print("  WARNING: `asy` binary not found in PATH — [asy] blocks will fall back to "
              "'(diagram unavailable)'.  Install via MacTeX or `apt install asymptote`.", flush=True)

    # Pass 1: classify + extract
    buckets = {'amc-real': [], 'aime-real': [], 'practice': []}
    stats = {'mcq_letter_clean': 0, 'mcq_letter_from_choices': 0,
             'mcq_no_answer': 0, 'free_int': 0, 'free_other': 0, 'no_boxed': 0}

    for idx, item in enumerate(data):
        prob = item.get('problem', '')
        sol = item.get('solution', '')
        src = item.get('source', '?')
        boxed = extract_boxed(sol)            # extract from raw sol (boxed regex expects \boxed{} intact)
        is_mcq = detect_mcq(prob)             # detection also expects raw \textbf{(A)} markers
        bk = bucket_of(item)

        # Normalize math delimiters AFTER detection/extraction so we don't
        # break the regexes above, but BEFORE storing in the shard so the
        # front-end gets clean $-delimited LaTeX.
        prob_clean = clean_text(prob)
        sol_clean  = clean_text(sol)

        record = {
            'i': idx,
            'src': 'r' if src == 'amc_aime' else 's',
            'p': prob_clean,
            'sol': sol_clean,
        }

        if is_mcq:
            # parse_choices needs the raw problem so its \textbf{(A)} regex
            # boundaries still match — clean each choice text after parsing.
            choices = parse_choices(prob)
            letter = boxed_to_letter(boxed, choices) if boxed else None
            record['fmt'] = 'mcq'
            if choices:
                record['ch']  = [clean_text(choices.get(L, '')) for L in 'ABCDE' if L in choices]
                record['chk'] = ''.join(L for L in 'ABCDE' if L in choices)
            else:
                record['ch']  = []
                record['chk'] = ''
            if letter:
                record['a'] = letter
                if LETTER_IN_BOXED.search(boxed or ''):
                    stats['mcq_letter_clean'] += 1
                else:
                    stats['mcq_letter_from_choices'] += 1
            else:
                record['a'] = ''
                stats['mcq_no_answer'] += 1
        else:
            record['fmt'] = 'free'
            if boxed:
                stripped = boxed.strip()
                # Try as integer first
                m = re.fullmatch(r'-?\d{1,4}', stripped)
                if m:
                    record['a'] = stripped     # integer: nothing to clean
                    record['a_type'] = 'int'
                    stats['free_int'] += 1
                else:
                    cleaned = normalize_free_answer(clean_text(stripped))
                    record['a'] = cleaned
                    record['a_type'] = 'expr'
                    stats['free_other'] += 1
            else:
                record['a'] = ''
                stats['no_boxed'] += 1

        buckets[bk].append(record)

    print(f"\n=== Classification ===")
    print(f"  MCQ letter (explicit):       {stats['mcq_letter_clean']:,}")
    print(f"  MCQ letter (from choices):   {stats['mcq_letter_from_choices']:,}")
    print(f"  MCQ no clean answer:         {stats['mcq_no_answer']:,}")
    print(f"  Free-response integer:       {stats['free_int']:,}")
    print(f"  Free-response expression:    {stats['free_other']:,}")
    print(f"  No boxed at all:             {stats['no_boxed']:,}")
    print()
    print(f"=== Bucket counts ===")
    for bk, items in buckets.items():
        print(f"  {bk}: {len(items):,}")

    # Shuffle (deterministic) for random sampling in tests
    rng = random.Random(RANDOM_SEED)
    for bk in buckets:
        rng.shuffle(buckets[bk])

    # Filter out items without a usable answer for testing
    # (keep all, but mark testable=False if no answer)
    # Better: drop untestable ones from chunks to keep payload tight
    pre_drop = {bk: len(v) for bk, v in buckets.items()}
    for bk in buckets:
        buckets[bk] = [r for r in buckets[bk] if r['a']]
    print(f"\n=== After dropping items with no answer ===")
    for bk, items in buckets.items():
        dropped = pre_drop[bk] - len(items)
        print(f"  {bk}: {len(items):,} (dropped {dropped:,})")

    # Write shards
    meta = {
        'version': 1,
        'generated_at': time.strftime('%Y-%m-%dT%H:%M:%S'),
        'shard_size': SHARD_SIZE,
        'total': sum(len(v) for v in buckets.values()),
        'buckets': {}
    }

    total_q_bytes = 0
    total_s_bytes = 0
    for bk, items in buckets.items():
        n = len(items)
        nshards = (n + SHARD_SIZE - 1) // SHARD_SIZE
        q_shards = []
        s_shards = []
        for sh in range(nshards):
            chunk = items[sh*SHARD_SIZE : (sh+1)*SHARD_SIZE]
            # Question shard: strip 'sol'
            q_data = []
            s_data = []
            for r in chunk:
                qid = f"{bk}-{r['i']:06d}"
                qrec = {'id': qid, 'fmt': r['fmt'], 'p': r['p'], 'a': r['a']}
                if r['fmt'] == 'mcq':
                    qrec['ch'] = r['ch']
                    qrec['chk'] = r['chk']
                else:
                    qrec['t'] = r.get('a_type', 'int')
                q_data.append(qrec)
                s_data.append({'id': qid, 'sol': r['sol']})
            q_path = OUT_DIR / 'q' / f"{bk}-{sh:03d}.json"
            s_path = OUT_DIR / 's' / f"{bk}-{sh:03d}.json"
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

        meta['buckets'][bk] = {
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
    print(f"  total chunks:        {sum(b['shard_count'] for b in meta['buckets'].values())}")
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
    img_files = list(IMG_DIR.glob('*')) if IMG_DIR.exists() else []
    img_files = [f for f in img_files if f.is_file() and not f.name.startswith('.')]
    img_bytes = sum(f.stat().st_size for f in img_files)
    print(f"  images on disk:      {len(img_files):,} files, {img_bytes/1024:.1f} KB")

    # Dump compiler stderr from failed renders so we can extend the
    # olympiad.asy stub.  Deduped first-line of each error, plus a full
    # log for deep inspection.
    if _asy_fail_errs:
        log_path = DGM_DIR / '_failures.log'
        with open(log_path, 'w') as f:
            for h, err in _asy_fail_errs:
                f.write(f'=== {h} ===\n{err}\n\n')
        # Frequency table of distinct first-error-line tokens
        from collections import Counter
        first_lines = Counter()
        for h, err in _asy_fail_errs:
            for ln in err.splitlines():
                ln = ln.strip()
                if 'error' in ln.lower() or 'no matching' in ln.lower():
                    # Strip leading file path so we can group similar errors
                    ln = re.sub(r'^.*?\.asy:\s*\d+\.\d+:\s*', '', ln)
                    first_lines[ln[:160]] += 1
                    break
        print(f"\n=== Failure breakdown (top reasons) ===")
        for ln, c in first_lines.most_common(20):
            print(f"  {c:>3}x  {ln}")
        print(f"  full log: {log_path}")
    print(f"\n  Total elapsed: {time.time()-t0:.1f}s")

if __name__ == '__main__':
    main()
