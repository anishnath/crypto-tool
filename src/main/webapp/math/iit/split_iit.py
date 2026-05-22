#!/usr/bin/env python3
"""
split_iit.py — process the two JEE source files into shards usable by
the same engine pattern as math/amc/ and math/olympiad/.

Two source files, two output buckets:
  · jee_mains_2025.json   →  bucket "jee-2025-paper"    (250 Qs, 10 shifts × 25)
  · jee-neet.json         →  bucket "jee-practice"      (4,515 Qs, historical pool)

Pipeline differences vs split_olympiad.py:
  · jee-neet.json is HTML-flavored — strip <br>/<p>/entities BEFORE the
    LaTeX clean_text pipeline.
  · The MCQ choices live in different shapes:
      jee_mains_2025: inline "(1) … (2) … (3) … (4) …" in the question text
      jee-neet:        embedded JSON-string "Options: [{...}]" after the prompt
    Both get parsed into a structured `ch` array on the way out, and the
    raw choice block is removed from the displayed problem.
  · External CDN images (<img src="https://…">) in jee-neet are downloaded
    to data/img/ and replaced with the {{IMG:hash}} marker the front-end
    already understands.

Cleanup helpers are intentionally inlined (rather than imported from
split_amc.py / split_olympiad.py) so each pipeline is self-contained.
If you change a cleanup rule in one place, update all three.
"""

import json, re, os, sys, time, hashlib, random, subprocess, shutil
import urllib.request, urllib.error, html as html_mod
from pathlib import Path

SRC_MAINS_2025 = Path('/Users/anish/git/crypto-tool/src/main/webapp/math/iit/jee_mains_2025.json')
SRC_NEET       = Path('/Users/anish/git/crypto-tool/src/main/webapp/math/iit/jee-neet.json')
OUT_DIR        = Path('/Users/anish/git/crypto-tool/src/main/webapp/math/iit/data')
DGM_DIR        = OUT_DIR / 'dgm'   # created in case any [asy] sneaks in
IMG_DIR        = OUT_DIR / 'img'
ASY_LIB_DIR    = Path('/Users/anish/git/crypto-tool/src/main/webapp/math/amc/asy')

SHARD_SIZE         = 200          # smaller buckets, smaller shards = faster first load
RANDOM_SEED        = 19           # deterministic shuffle for jee-practice
ASY_TIMEOUT        = 20
MAX_SOLUTION_BYTES = 50_000

BUCKET_2025     = 'jee-2025-paper'
BUCKET_PRACTICE = 'jee-practice'

# ──────────────────────────────────────────────────────────────────────
# HTML → text strip (for jee-neet.json's HTML-flavored fields)
# ──────────────────────────────────────────────────────────────────────
def html_to_text(s):
    if not s:
        return s
    # <br>, <br/>, <br /> → newline
    s = re.sub(r'<br\s*/?>', '\n', s, flags=re.I)
    # <p>...</p> → wrap with blank lines
    s = re.sub(r'</p\s*>', '\n\n', s, flags=re.I)
    s = re.sub(r'<p\s*[^>]*>', '', s, flags=re.I)
    # Strip remaining tags but keep their text content (other than <img>,
    # which we leave intact for the image substitution pass downstream).
    # First protect <img> by stashing them out before strip.
    img_re = re.compile(r'<img[^>]*?src=["\']([^"\']+)["\'][^>]*/?>', re.I)
    img_urls = []
    def stash_img(m):
        img_urls.append(m.group(1))
        return f'\x00IMG{len(img_urls)-1}\x00'
    s = img_re.sub(stash_img, s)
    # Strip every other tag now
    s = re.sub(r'<[^>]+>', '', s)
    # Decode HTML entities (&amp; &lt; &gt; &quot; &nbsp; …)
    s = html_mod.unescape(s)
    # Restore <img> tags as plain URLs surrounded by spaces so the image
    # substitution pass downstream picks them up.
    for idx, url in enumerate(img_urls):
        s = s.replace(f'\x00IMG{idx}\x00', f' {url} ')
    # Collapse 3+ blank lines to 2
    s = re.sub(r'\n{3,}', '\n\n', s)
    return s.strip()

# ──────────────────────────────────────────────────────────────────────
# Choice parsers — one per source format
# ──────────────────────────────────────────────────────────────────────

# jee_mains_2025: choices inline in the question text as
#    "...prompt...\n\n(1) X  \n(2) Y  \n(3) Z  \n(4) W"
# We split on the FIRST (1) marker and parse forward.
JEE_MAINS_CHOICE_SPLIT = re.compile(
    r'\(\s*([1-4])\s*\)\s*(.*?)(?=\(\s*[1-4]\s*\)|\Z)',
    re.DOTALL,
)
JEE_MAINS_FIRST_CHOICE = re.compile(r'\(\s*1\s*\)')

def parse_jee_mains_choices(question_text):
    """Returns (stripped_question, choices_dict, choice_keys) where
       choices_dict is {'A':'X','B':'Y','C':'Z','D':'W'} and
       choice_keys is the order present ('ABCD' for 4-choice).
       If no choice block is found, returns (question_text, {}, '')."""
    m = JEE_MAINS_FIRST_CHOICE.search(question_text)
    if not m:
        return question_text, {}, ''
    head = question_text[:m.start()].rstrip()
    tail = question_text[m.start():]
    choices = {}
    LETTERS = {'1': 'A', '2': 'B', '3': 'C', '4': 'D'}
    for ms in JEE_MAINS_CHOICE_SPLIT.finditer(tail):
        digit = ms.group(1)
        content = ms.group(2).strip()
        # Trim trailing whitespace that scraped through (e.g. double-space)
        content = re.sub(r'\s+', ' ', content)
        if digit in LETTERS:
            choices[LETTERS[digit]] = content
    keys = ''.join(L for L in 'ABCD' if L in choices)
    return head, choices, keys

# jee-neet: choices in an embedded JSON-array string after "Options:"
JEE_NEET_OPTIONS_RE = re.compile(r'Options:\s*(\[.*?\])', re.DOTALL)

def parse_jee_neet_choices(question_text):
    """Extracts the embedded Options JSON. Returns (stripped_question,
       choices_dict, choice_keys). If JSON-parse fails the raw text is
       returned with no choices."""
    m = JEE_NEET_OPTIONS_RE.search(question_text)
    if not m:
        return question_text, {}, ''
    head = question_text[:m.start()].rstrip()
    # The JSON-string sometimes uses double backslashes (escaped LaTeX) —
    # json.loads handles them correctly since they're already JSON-encoded.
    try:
        opts = json.loads(m.group(1))
    except (json.JSONDecodeError, ValueError):
        # Some entries have malformed JSON; fall back to a best-effort regex
        opts = []
        for sub in re.finditer(
            r'"identifier"\s*:\s*"([A-E])"\s*,\s*"content"\s*:\s*"((?:[^"\\]|\\.)*)"',
            m.group(1),
        ):
            opts.append({'identifier': sub.group(1),
                         'content':    sub.group(2).encode().decode('unicode_escape', errors='replace')})
    choices = {}
    for o in opts:
        if isinstance(o, dict) and 'identifier' in o and 'content' in o:
            L = str(o['identifier']).strip().upper()
            if L in 'ABCDE':
                choices[L] = str(o.get('content', '')).strip()
    keys = ''.join(L for L in 'ABCDE' if L in choices)
    return head, choices, keys

# ──────────────────────────────────────────────────────────────────────
# Boxed extractor (rarely used in these sources but kept for symmetry)
# ──────────────────────────────────────────────────────────────────────
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

# ──────────────────────────────────────────────────────────────────────
# Cleanup pipeline — mirror of split_olympiad.py. Keep in sync if you
# change rules in one place.
# ──────────────────────────────────────────────────────────────────────
AOPS_SHORTCUTS = [
    (re.compile(r'\\plus(?![a-zA-Z])'),   '+'),
    (re.compile(r'\\minus(?![a-zA-Z])'),  '-'),
    (re.compile(r'\\equals(?![a-zA-Z])'), '='),
    (re.compile(r'\\equal(?![a-zA-Z])'),  '='),
    (re.compile(r'\\divide(?![a-zA-Z])'), r'\\div'),
]
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
    if gs_path: env['GS'] = gs_path
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
        except OSError: pass
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
            'User-Agent': 'Mozilla/5.0 (split_iit.py image fetcher)'
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

# ──────────────────────────────────────────────────────────────────────
# Plain-TeX → KaTeX conversions. The JEE source data is loaded with
# plain-TeX constructs (\matrix{...}, \cr, \int_\limits) that KaTeX
# doesn't natively parse — convert to LaTeX equivalents.
# ──────────────────────────────────────────────────────────────────────

def _balanced_brace_replace(s, opener, replacement_fn):
    """For each `opener` (must end in `{`), find the matching `}` accounting
       for nested braces and call replacement_fn(content) for the body."""
    out = []
    i = 0
    while i < len(s):
        idx = s.find(opener, i)
        if idx < 0:
            out.append(s[i:])
            break
        out.append(s[i:idx])
        depth = 1
        j = idx + len(opener)
        start = j
        while j < len(s) and depth > 0:
            c = s[j]
            if c == '{':
                depth += 1
            elif c == '}':
                depth -= 1
            j += 1
        if depth == 0:
            out.append(replacement_fn(s[start:j-1]))
            i = j
        else:
            # Unbalanced — bail without modifying further
            out.append(s[idx:])
            break
    return ''.join(out)

# Map of plain-TeX env names → LaTeX env names KaTeX supports.
PLAIN_TEX_ENVS = [
    ('pmatrix', 'pmatrix'),
    ('bmatrix', 'bmatrix'),
    ('Bmatrix', 'Bmatrix'),
    ('vmatrix', 'vmatrix'),
    ('Vmatrix', 'Vmatrix'),
    ('matrix',  'matrix'),
    ('cases',   'cases'),
    ('eqalign', 'aligned'),
    ('displaylines', 'gathered'),
]

PLAIN_TEX_LIMITS_RE = re.compile(r'\\(int|sum|prod|oint|iint|iiint|coprod|bigcap|bigcup|bigvee|bigwedge|bigoplus|bigotimes|bigodot|biguplus|bigsqcup)_\\limits')
PLAIN_TEX_CR_RE = re.compile(r'\\cr(?![a-zA-Z])')
# Plain-TeX \root n \of X — n is a number or {expr}; X is balanced-brace
# expression or single token. Pulled out into its own walker because the
# X can be deeply nested (e.g. \root 5 \of {{2^{(x - 2){{\log }_2}3}}}).
PLAIN_TEX_ROOT_HEAD_RE = re.compile(r'\\root\s*(\d+|\{[^{}]*\})\s*\\of\s*')

def fix_plain_tex_root(s):
    if not s or '\\root' not in s:
        return s
    out = []
    i = 0
    while i < len(s):
        m = PLAIN_TEX_ROOT_HEAD_RE.search(s, i)
        if not m:
            out.append(s[i:])
            break
        out.append(s[i:m.start()])
        n = m.group(1).strip('{}')
        j = m.end()
        if j < len(s) and s[j] == '{':
            # Balanced-brace radicand
            depth = 1; k = j + 1
            while k < len(s) and depth > 0:
                if s[k] == '{':   depth += 1
                elif s[k] == '}': depth -= 1
                k += 1
            if depth == 0:
                x = s[j+1:k-1]
                out.append('\\sqrt[' + n + ']{' + x + '}')
                i = k
            else:
                out.append(s[m.start():])
                break
        else:
            # Single-token radicand — take until whitespace, brace, or backslash
            k = j
            while k < len(s) and s[k] not in ' \t\n\\{}':
                k += 1
            x = s[j:k]
            out.append('\\sqrt[' + n + ']{' + x + '}')
            i = k
    return ''.join(out)

# Convert mid-sentence $$X$$ → $X$ — the jee-neet source uses $$ for
# everything (including inline math), which renders as display blocks
# and breaks sentences across lines. Detect inline use by checking that
# neither immediate adjacent char is a newline.
DOUBLE_DOLLAR_INLINE_RE = re.compile(r'\$\$([^$\n]+?)\$\$')

# Repair the source-data pattern where an inline-math segment was closed
# prematurely right before an env: `$X$\begin{Y}…\end{Y}$$`. After the
# rest of the pipeline this leaves a bare env with mismatched delimiters.
# Merge the two math segments into a single `$$X \begin{Y}…\end{Y}$$`.
MERGE_ORPHAN_ENV_RE = re.compile(
    r'\$([^$\n]+?)\$\s*\$*\s*'                                          # $X$ + maybe extra $
    r'(\\begin\{[A-Za-z]+\*?\}.*?\\end\{[A-Za-z]+\*?\})'                # \begin{Y}…\end{Y}
    r'\s*\$+',                                                          # trailing $$ (any count)
    re.DOTALL
)

def merge_orphan_inline_env(s):
    if not s or '\\begin{' not in s:
        return s
    return MERGE_ORPHAN_ENV_RE.sub(r'$$\1 \2$$', s)

# Collapse single newlines and multi-space runs inside paragraphs.
# AoPS/examgoal scraped source often line-breaks mid-sentence (e.g.
# `{x\n$\in$ N\n$\le$ x\n$\le$ 17}`) and uses double-spaces — both render
# as literal whitespace under CSS `white-space: pre-wrap`, breaking
# sentences across lines. We collapse single \n → space and runs of 2+
# spaces → 1 space within each paragraph (paragraphs are still separated
# by blank lines).
def collapse_intra_paragraph_whitespace(s):
    if not s:
        return s
    # Collapse 3+ blank-line runs to a single paragraph break first.
    s = re.sub(r'\n{3,}', '\n\n', s)
    paras = re.split(r'\n{2,}', s)
    paras = [re.sub(r'\n', ' ', p)  for p in paras]
    paras = [re.sub(r' {2,}', ' ', p) for p in paras]
    # Drop empty paragraphs that resulted from runs of whitespace.
    paras = [p for p in paras if p.strip()]
    return '\n\n'.join(paras).strip()

def fix_inline_displaymath(s):
    if not s or '$$' not in s:
        return s
    out = []
    last = 0
    for m in DOUBLE_DOLLAR_INLINE_RE.finditer(s):
        out.append(s[last:m.start()])
        content = m.group(1)
        before = s[m.start() - 1] if m.start() > 0 else '\n'
        after  = s[m.end()] if m.end() < len(s) else '\n'
        # Math environments (cases/aligned/matrix/etc.) are inherently
        # block-level. Don't squash them to inline even if the source put
        # text on the same line.
        has_env = '\\begin{' in content
        is_inline = (before != '\n' or after != '\n') and not has_env
        if is_inline:
            out.append('$' + content + '$')
        else:
            out.append(m.group(0))
        last = m.end()
    out.append(s[last:])
    return ''.join(out)

def fix_plain_tex(s):
    """Convert plain-TeX constructs to LaTeX so KaTeX can render them."""
    if not s:
        return s
    # \matrix{X}, \pmatrix{X}, \cases{X}, \eqalign{X}, … →
    #   \begin{matrix}X\end{matrix} etc.
    for plain_name, latex_name in PLAIN_TEX_ENVS:
        opener = '\\' + plain_name + '{'
        if opener in s:
            s = _balanced_brace_replace(
                s, opener,
                lambda content, env=latex_name:
                    '\\begin{' + env + '} ' + content + ' \\end{' + env + '}'
            )
    # \cr (plain-TeX row separator) → \\ (LaTeX)
    s = PLAIN_TEX_CR_RE.sub(r'\\\\', s)
    # \int_\limits / \sum_\limits / etc. → \int\limits_ / \sum\limits_
    # KaTeX expects the \limits modifier BEFORE the subscript.
    s = PLAIN_TEX_LIMITS_RE.sub(r'\\\1\\limits_', s)
    # \root n \of X → \sqrt[n]{X}
    s = fix_plain_tex_root(s)
    return s

def strip_inner_dollars_in_math_envs(s):
    if not s or '\\begin{' not in s:
        return s
    def _strip(m):
        return m.group(1).replace('$', '')
    return MATH_ENV_BLOCK_RE.sub(_strip, s)

def clean_text(s):
    """Same shape as the olympiad / amc clean_text — kept inline so this
       script doesn't depend on the sibling pipelines."""
    if not s:
        return s
    s = s.replace(r'\[', '$$').replace(r'\]', '$$')
    s = s.replace(r'\(', '$').replace(r'\)', '$')
    s = ALIGN_ENV_RE.sub(r'$$\1$$', s)
    s = re.sub(r'\${4,}', '$$', s)
    # Repair the `$X$\begin{Y}…\end{Y}$$` source-mistake AFTER the env-wrap.
    # By this point that pattern reads as `$X$$$\begin{Y}…\end{Y}$$`
    # (3 dollars between, 2 trailing) which the regex below merges into
    # one clean display block.
    s = merge_orphan_inline_env(s)
    for pat, repl in AOPS_SHORTCUTS:
        s = pat.sub(repl, s)
    s = LATEX_MACRO_DEFS_RE.sub('', s)
    s = fix_text_nobrace(s)
    s = fix_plain_tex(s)
    # Convert mid-sentence $$X$$ to inline $X$ AFTER plain-TeX cleanup
    # so the conversion doesn't fight with display-math constructs.
    s = fix_inline_displaymath(s)
    s = fix_tabular(s)
    s = strip_inner_dollars_in_math_envs(s)
    if 'http' in s:
        s = substitute_images(s)
    if '[asy]' in s.lower():
        s = substitute_asy(s)
    # Final pass: collapse single newlines and multi-spaces within paragraphs.
    # Paragraph breaks (\n\n) are preserved.
    s = collapse_intra_paragraph_whitespace(s)
    return s

# ──────────────────────────────────────────────────────────────────────
# Record builders
# ──────────────────────────────────────────────────────────────────────
def build_jee_2025_record(idx, src):
    """Map one jee_mains_2025.json entry to a shard record."""
    qtext = src.get('Question Text', '').replace('\r\n', '\n')
    correct = src.get('Correct Option')
    shift   = src.get('Shift Name', '')
    qnum    = src.get('Question Number')

    # Parse the inline (1)(2)(3)(4) choice block out of the question text.
    head, choices, keys = parse_jee_mains_choices(qtext)

    # Decide format: Correct Option in {1..4} → MCQ; anything else → numerical
    is_mcq = isinstance(correct, int) and 1 <= correct <= 4 and len(keys) > 0
    if not is_mcq and isinstance(correct, str) and correct.isdigit() and 1 <= int(correct) <= 4 and len(keys) > 0:
        correct = int(correct)
        is_mcq  = True

    rec = {
        'i':  idx,
        'p':  clean_text(head),
        'sh': shift,
        'qn': qnum,
        # No prewritten solution exists in the 2025 source.
        'sol': '',
    }
    if is_mcq:
        # Map Correct Option 1..4 → letter A..D
        L = chr(ord('A') + int(correct) - 1)
        rec['fmt'] = 'mcq'
        rec['ch']  = [clean_text(choices.get(K, '')) for K in keys]
        rec['chk'] = keys
        rec['a']   = L
    else:
        # Numerical type: the Correct Option IS the integer answer
        rec['fmt'] = 'free'
        rec['a']   = str(correct).strip()
        rec['t']   = 'int'
    return rec

def build_jee_neet_record(idx, src):
    """Map one jee-neet.json entry to a shard record."""
    q_raw = src.get('question', '')
    a_raw = src.get('answer',   '')

    # HTML strip both fields BEFORE LaTeX cleanup. The jee-neet source
    # is HTML-flavored (<br>, <p>, &amp; …).
    q_html = html_to_text(q_raw)
    a_html = html_to_text(a_raw)

    # Extract the answer leader: either ["A"] / ["B"] / … OR a bare integer
    # then the rest of the field is the explanation.
    a_letter = None
    a_int    = None
    explanation = a_html
    m = re.match(r'^\s*\[\s*"([A-E])"\s*\]\s*\n*', a_html)
    if m:
        a_letter = m.group(1)
        explanation = a_html[m.end():]
    else:
        # Numerical: bare integer prefix
        m2 = re.match(r'^\s*(-?\d+(?:\.\d+)?)\s*\n', a_html)
        if m2:
            a_int = m2.group(1)
            explanation = a_html[m2.end():]
    # Drop a leading "Explanation:" label if present.
    explanation = re.sub(r'^\s*Explanation\s*:\s*\n*', '', explanation, count=1, flags=re.I)

    # Parse choices out of the question (Options: [...] block).
    head, choices, keys = parse_jee_neet_choices(q_html)

    rec = {
        'i':   idx,
        'p':   clean_text(head),
        'sol': clean_text(explanation),
    }
    if a_letter and len(keys) > 0:
        rec['fmt'] = 'mcq'
        rec['ch']  = [clean_text(choices.get(K, '')) for K in keys]
        rec['chk'] = keys
        rec['a']   = a_letter
    elif a_int is not None:
        rec['fmt'] = 'free'
        rec['a']   = a_int
        rec['t']   = 'int' if '.' not in a_int else 'expr'
    else:
        # Couldn't classify — keep as free with empty answer; engine will
        # show "no checkable answer, read the walkthrough" UI.
        rec['fmt'] = 'free'
        rec['a']   = ''
    return rec

# ──────────────────────────────────────────────────────────────────────
# Main
# ──────────────────────────────────────────────────────────────────────
def main():
    t0 = time.time()
    OUT_DIR.mkdir(parents=True, exist_ok=True)
    (OUT_DIR / 'q').mkdir(exist_ok=True)
    (OUT_DIR / 's').mkdir(exist_ok=True)
    DGM_DIR.mkdir(exist_ok=True)
    IMG_DIR.mkdir(exist_ok=True)

    if not shutil.which('asy'):
        print("  NOTE: `asy` not in PATH (no [asy] expected in these sources but kept for safety).", flush=True)

    # ── Source 1: jee_mains_2025.json ──────────────────────────────
    print(f"Loading {SRC_MAINS_2025.name} …", flush=True)
    with open(SRC_MAINS_2025) as f:
        raw_2025 = json.load(f)
    print(f"  {len(raw_2025):,} records", flush=True)

    records_2025 = [build_jee_2025_record(i, r) for i, r in enumerate(raw_2025)]
    mcq_2025  = sum(1 for r in records_2025 if r['fmt'] == 'mcq')
    free_2025 = sum(1 for r in records_2025 if r['fmt'] == 'free')

    # ── Source 2: jee-neet.json ────────────────────────────────────
    print(f"Loading {SRC_NEET.name} …", flush=True)
    with open(SRC_NEET) as f:
        raw_neet = json.load(f)
    print(f"  {len(raw_neet):,} records", flush=True)

    records_neet = []
    for i, r in enumerate(raw_neet):
        # Skip catastrophically large records
        if len(r.get('answer', '')) > MAX_SOLUTION_BYTES:
            continue
        records_neet.append(build_jee_neet_record(i, r))

    mcq_neet  = sum(1 for r in records_neet if r['fmt'] == 'mcq')
    free_neet = sum(1 for r in records_neet if r['fmt'] == 'free' and r.get('a'))
    no_ans_neet = sum(1 for r in records_neet if not r.get('a'))

    print(f"\n=== Classification ===")
    print(f"  jee-2025-paper:   {len(records_2025):,}  (mcq={mcq_2025}, free={free_2025})")
    print(f"  jee-practice:     {len(records_neet):,}  (mcq={mcq_neet}, free={free_neet}, no-answer={no_ans_neet})")

    # Shuffle the practice pool deterministically. The 2025 set keeps its
    # original (shift, question_number) order so future shift-wise pages
    # can slice cleanly by shard offset.
    rng = random.Random(RANDOM_SEED)
    rng.shuffle(records_neet)

    # ── Write shards ───────────────────────────────────────────────
    meta = {
        'version': 1,
        'generated_at': time.strftime('%Y-%m-%dT%H:%M:%S'),
        'shard_size': SHARD_SIZE,
        'total': len(records_2025) + len(records_neet),
        'buckets': {},
    }

    total_q_bytes = 0
    total_s_bytes = 0

    def write_bucket(bucket_name, recs):
        nonlocal total_q_bytes, total_s_bytes
        n = len(recs)
        nshards = (n + SHARD_SIZE - 1) // SHARD_SIZE
        q_shards, s_shards = [], []
        for sh in range(nshards):
            chunk = recs[sh*SHARD_SIZE : (sh+1)*SHARD_SIZE]
            q_data, s_data = [], []
            for r in chunk:
                qid = f"{bucket_name}-{r['i']:06d}"
                qrec = {'id': qid, 'fmt': r['fmt'], 'p': r['p'], 'a': r.get('a','')}
                if r['fmt'] == 'mcq':
                    qrec['ch']  = r.get('ch', [])
                    qrec['chk'] = r.get('chk', '')
                else:
                    if r.get('t'):
                        qrec['t'] = r['t']
                # 2025 shift / question-number metadata
                if r.get('sh'): qrec['sh'] = r['sh']
                if r.get('qn') is not None: qrec['qn'] = r['qn']
                q_data.append(qrec)
                s_data.append({'id': qid, 'sol': r.get('sol', '')})
            q_path = OUT_DIR / 'q' / f"{bucket_name}-{sh:03d}.json"
            s_path = OUT_DIR / 's' / f"{bucket_name}-{sh:03d}.json"
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
        meta['buckets'][bucket_name] = {
            'count': n,
            'shard_count': nshards,
            'q_shards': q_shards,
            's_shards': s_shards,
        }

    # 2025 paper: write one shard per shift so a JEE mock can load just
    # its own 25 questions. Also emit a `shifts` index in meta.json
    # mapping each shift to its shard + slug.
    # Inline helper: convert "JEE Main 2025 (22 Jan Shift 1)" → "22-jan-shift-1".
    def shift_slug(shift_name):
        s = (shift_name or '').lower()
        s = re.sub(r'^jee main \d{4}\s*\(?\s*', '', s)   # strip prefix
        s = s.rstrip(')').strip()
        s = re.sub(r'[^a-z0-9]+', '-', s).strip('-')
        return s or 'unknown'

    def write_2025_by_shift(recs, meta_):
        nonlocal total_q_bytes, total_s_bytes
        # Group records by shift while preserving original order.
        from collections import OrderedDict
        groups = OrderedDict()
        for r in recs:
            sh = r.get('sh') or 'unknown'
            groups.setdefault(sh, []).append(r)
        # Order each shift's questions by question number.
        for sh, lst in groups.items():
            lst.sort(key=lambda x: x.get('qn') or 0)

        shifts_meta = []
        q_shards, s_shards = [], []
        for sh_name, lst in groups.items():
            slug = shift_slug(sh_name)
            q_name = f"{BUCKET_2025}-{slug}.json"
            s_name = f"{BUCKET_2025}-{slug}.json"
            q_data, s_data = [], []
            for r in lst:
                qid = f"{BUCKET_2025}-{r['i']:06d}"
                qrec = {'id': qid, 'fmt': r['fmt'], 'p': r['p'], 'a': r.get('a','')}
                if r['fmt'] == 'mcq':
                    qrec['ch']  = r.get('ch', [])
                    qrec['chk'] = r.get('chk', '')
                else:
                    if r.get('t'):
                        qrec['t'] = r['t']
                if r.get('sh'): qrec['sh'] = r['sh']
                if r.get('qn') is not None: qrec['qn'] = r['qn']
                q_data.append(qrec)
                s_data.append({'id': qid, 'sol': r.get('sol', '')})
            q_path = OUT_DIR / 'q' / q_name
            s_path = OUT_DIR / 's' / s_name
            with open(q_path, 'w') as f:
                json.dump(q_data, f, ensure_ascii=False, separators=(',', ':'))
            with open(s_path, 'w') as f:
                json.dump(s_data, f, ensure_ascii=False, separators=(',', ':'))
            q_sz = q_path.stat().st_size
            s_sz = s_path.stat().st_size
            total_q_bytes += q_sz
            total_s_bytes += s_sz
            q_shards.append({'f': q_name, 'n': len(q_data), 'b': q_sz})
            s_shards.append({'f': s_name, 'n': len(s_data), 'b': s_sz})
            shifts_meta.append({'name': sh_name, 'slug': slug,
                                'q': q_name, 's': s_name, 'n': len(q_data)})

        meta_['buckets'][BUCKET_2025] = {
            'count': len(recs),
            'shard_count': len(shifts_meta),
            'shifts': shifts_meta,         # ← unique to this bucket; key for shift-wise mocks
            'q_shards': q_shards,
            's_shards': s_shards,
        }

    write_2025_by_shift(records_2025, meta)
    write_bucket(BUCKET_PRACTICE, records_neet)

    meta_path = OUT_DIR / 'meta.json'
    with open(meta_path, 'w') as f:
        json.dump(meta, f, ensure_ascii=False, indent=2)

    # ── Reporting ──────────────────────────────────────────────────
    print(f"\n=== Output ===")
    print(f"  meta.json:           {meta_path.stat().st_size:>10,} bytes")
    print(f"  question shards:     {total_q_bytes:>10,} bytes  ({total_q_bytes/1024/1024:.1f} MB)")
    print(f"  solution shards:     {total_s_bytes:>10,} bytes  ({total_s_bytes/1024/1024:.1f} MB)")
    for bk, info in meta['buckets'].items():
        print(f"  {bk}: {info['count']:,} records in {info['shard_count']} shards")

    print(f"\n=== Remote figures ===")
    print(f"  image refs seen:     {_img_stats['total']:,}")
    print(f"  downloaded OK:       {_img_stats['ok']:,}")
    print(f"  cached (skipped):    {_img_stats['cached']:,}")
    print(f"  failed → fallback:   {_img_stats['fail']:,}")
    img_files = [f for f in IMG_DIR.glob('*') if f.is_file() and not f.name.startswith('.')]
    img_bytes = sum(f.stat().st_size for f in img_files)
    print(f"  images on disk:      {len(img_files):,} files, {img_bytes/1024/1024:.1f} MB")

    if _asy_stats['total']:
        print(f"\n=== Asymptote (unexpected — these sources should have none) ===")
        print(f"  blocks seen:         {_asy_stats['total']:,}")
        print(f"  rendered OK:         {_asy_stats['ok']:,}")
        print(f"  failed:              {_asy_stats['fail']:,}")

    print(f"\n  Total elapsed: {time.time()-t0:.1f}s")


if __name__ == '__main__':
    main()
