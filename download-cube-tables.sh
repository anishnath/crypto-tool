#!/bin/bash

###############################################################################
# Cube Solver Lookup Table Downloader
#
# Downloads pre-computed pruning tables for the Rubik N×N solver
# (4×4 and 5×5 pure-Java pipelines) from the upstream S3 mirror.
#
# By default this script is IDEMPOTENT — files already present in the
# cache directory are skipped.  Re-running is safe.  Use --force to
# re-download everything (useful if a file is corrupt).
#
# Total disk required (after decompression):
#   4×4 only  → ~200 MB
#   4×4 + 5×5 → ~2.2 GB
#
# Usage:
#   ./download-cube-tables.sh                    # download missing files
#   ./download-cube-tables.sh --force            # re-download everything
#   ./download-cube-tables.sh --sizes 4          # only 4×4
#   ./download-cube-tables.sh --sizes 4,5        # both (default)
#   ./download-cube-tables.sh --cache-dir /var/cube-lookup-tables
#   ./download-cube-tables.sh --list             # show what would download
#   ./download-cube-tables.sh --help
#
# Default cache directory matches the JVM property fallback used by
# LookupTableLoader.java: ${HOME}/.cube-lookup-tables
###############################################################################

set -e

# ── Defaults ─────────────────────────────────────────────────────────
BASE_URL="${CUBE_LOOKUP_BASE_URL:-https://rubiks-cube-lookup-tables.s3.amazonaws.com}"
CACHE_DIR="${CUBE_LOOKUP_CACHE_DIR:-${HOME}/.cube-lookup-tables}"
SIZES="4,5"
FORCE=false
LIST_ONLY=false
QUIET=false

# Colors (no-op when piped or QUIET)
if [ -t 1 ]; then
    GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; BLUE='\033[0;34m'; NC='\033[0m'
else
    GREEN=''; YELLOW=''; RED=''; BLUE=''; NC=''
fi

log_info() { [ "$QUIET" = true ] || echo -e "${GREEN}[INFO]${NC}  $1"; }
log_skip() { [ "$QUIET" = true ] || echo -e "${BLUE}[SKIP]${NC}  $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC}  $1" >&2; }
log_err()  { echo -e "${RED}[ERROR]${NC} $1" >&2; }

usage() {
    sed -n '3,/^###/p' "$0" | sed 's/^# \?//' | head -n 30
}

# ── Argument parsing ─────────────────────────────────────────────────
while [[ $# -gt 0 ]]; do
    case "$1" in
        --force|-f)        FORCE=true; shift ;;
        --cache-dir)       CACHE_DIR="$2"; shift 2 ;;
        --sizes)           SIZES="$2"; shift 2 ;;
        --base-url)        BASE_URL="$2"; shift 2 ;;
        --list)            LIST_ONLY=true; shift ;;
        --quiet|-q)        QUIET=true; shift ;;
        --help|-h)         usage; exit 0 ;;
        *) log_err "Unknown option: $1"; usage; exit 1 ;;
    esac
done

# ── Table lists ──────────────────────────────────────────────────────

# 4×4 — both .bin and .state_index for each table.
TABLES_444_BIN=(
    lookup-table-4x4x4-step11-UD-centers-stage
    lookup-table-4x4x4-step12-LR-centers-stage
    lookup-table-4x4x4-step21-highlow-edges-edges
    lookup-table-4x4x4-step22-highlow-edges-centers
    lookup-table-4x4x4-step31-centers
    lookup-table-4x4x4-step32-first-four-edges
    lookup-table-4x4x4-step41-centers
    lookup-table-4x4x4-step42-last-eight-edges
)

# 5×5 — most stages have .bin mirrors; phase 4 is .txt only.
TABLES_555_BIN=(
    lookup-table-5x5x5-step11-LR-centers-stage-t-center-only
    lookup-table-5x5x5-step12-LR-centers-stage-x-center-only
    lookup-table-5x5x5-step21-FB-t-centers-stage
    lookup-table-5x5x5-step22-FB-x-centers-stage
    lookup-table-5x5x5-step902-EO-outer-orbit
    lookup-table-5x5x5-step903-EO-inner-orbit
    lookup-table-5x5x5-step51-phase5-centers
    lookup-table-5x5x5-step53-phase5-high-edge-and-midge
    lookup-table-5x5x5-step54-phase5-low-edge-and-midge
    lookup-table-5x5x5-step56-phase5-fb-centers
    lookup-table-5x5x5-step61-phase6-centers
    lookup-table-5x5x5-step62-phase6-high-edge-midge
    lookup-table-5x5x5-step63-phase6-low-edge-midge
)

# 5×5 — text-only tables (large; binary search via mmap).
TABLES_555_TXT=(
    lookup-table-5x5x5-step40-phase4
)

# ── Build effective download list from --sizes ───────────────────────
# Each entry: "<filename-without-ext>:<ext>" — ext is bin, state_index, or txt.
ENTRIES=()

for sz in $(echo "$SIZES" | tr ',' ' '); do
    case "$sz" in
        4)
            for t in "${TABLES_444_BIN[@]}"; do
                ENTRIES+=("$t:bin")
                ENTRIES+=("$t:state_index")
            done
            ;;
        5)
            for t in "${TABLES_555_BIN[@]}"; do
                ENTRIES+=("$t:bin")
                ENTRIES+=("$t:state_index")
            done
            for t in "${TABLES_555_TXT[@]}"; do
                ENTRIES+=("$t:txt")
            done
            ;;
        3) : ;;     # 3×3 uses cubejs in-browser, no server tables
        *)  log_warn "Unknown size '$sz' — skipping" ;;
    esac
done

if [ ${#ENTRIES[@]} -eq 0 ]; then
    log_err "No tables selected.  Use --sizes 4,5"
    exit 1
fi

# ── Validate prerequisites ───────────────────────────────────────────
for cmd in curl gunzip; do
    if ! command -v $cmd >/dev/null 2>&1; then
        log_err "$cmd is required but not installed"
        exit 1
    fi
done

if [ "$LIST_ONLY" = false ]; then
    mkdir -p "$CACHE_DIR" || { log_err "Cannot create cache dir: $CACHE_DIR"; exit 1; }
    if [ ! -w "$CACHE_DIR" ]; then
        log_err "Cache dir is not writable: $CACHE_DIR"
        exit 1
    fi
fi

# ── Download loop ────────────────────────────────────────────────────
total=${#ENTRIES[@]}
downloaded=0
skipped=0
failed=0
i=0

for entry in "${ENTRIES[@]}"; do
    i=$((i + 1))
    IFS=':' read -r base ext <<< "$entry"
    target="$CACHE_DIR/$base.$ext"
    url="$BASE_URL/$base.$ext.gz"

    if [ "$LIST_ONLY" = true ]; then
        echo "$url -> $target"
        continue
    fi

    if [ "$FORCE" != true ] && [ -s "$target" ]; then
        log_skip "[$i/$total] $base.$ext (cached, $(du -h "$target" | cut -f1))"
        skipped=$((skipped + 1))
        continue
    fi

    log_info "[$i/$total] downloading $base.$ext.gz..."
    tmp="$target.part.$$"
    if curl -sSL --fail "$url" | gunzip > "$tmp" 2>/dev/null; then
        mv "$tmp" "$target"
        size=$(du -h "$target" | cut -f1)
        log_info "         done ($size)"
        downloaded=$((downloaded + 1))
    else
        rm -f "$tmp"
        log_warn "         FAILED — $url"
        failed=$((failed + 1))
    fi
done

# ── Summary ──────────────────────────────────────────────────────────
if [ "$LIST_ONLY" = true ]; then
    echo ""
    echo "$total entries listed (would download to $CACHE_DIR)"
    exit 0
fi

total_size=$(du -sh "$CACHE_DIR" 2>/dev/null | cut -f1)
echo ""
log_info "─────────────────────────────────────────"
log_info "Cube tables ready in $CACHE_DIR"
log_info "  downloaded: $downloaded"
log_info "  skipped:    $skipped (already cached)"
if [ $failed -gt 0 ]; then
    log_warn "  failed:     $failed (see warnings above)"
fi
log_info "  total size: $total_size"
log_info "─────────────────────────────────────────"

if [ $failed -gt 0 ]; then
    log_warn "Some downloads failed.  Re-run to retry, or use --force to re-pull."
    exit 2
fi
exit 0
