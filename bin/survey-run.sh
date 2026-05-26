#!/usr/bin/env bash
# Run a wholesale gem-compatibility survey. Environment-agnostic so it drops
# into the gx10 workflow via gx-sync/gx-run (or runs locally).
#
#   bin/survey-run.sh GEMLIST.txt [OUTDIR]
#
# Prereqs on the host it runs on:
#   - a built `spinel` (set SPINEL_DIR, or have `spinel` on PATH)
#   - ruby + bundler (for `gem fetch` / lockfile parsing)
#   - outbound network (to fetch gem sources)
#
# Output (OUTDIR, default ./survey-out):
#   report.md          the aggregate report (verdict mix + blocker histogram)
#   compat.jsonl       the ledger produced (copy of $SPINEL_COMPAT_LEDGER)
set -euo pipefail

LIST="${1:?usage: survey-run.sh GEMLIST.txt [OUTDIR]}"
OUT="${2:-./survey-out}"
HERE="$(cd "$(dirname "$0")/.." && pwd)"

# Parallelism = host CPU count.
if command -v nproc >/dev/null 2>&1; then JOBS="$(nproc)"; else JOBS="$(sysctl -n hw.ncpu 2>/dev/null || echo 4)"; fi

mkdir -p "$OUT"
export SPINEL_COMPAT_LEDGER="${SPINEL_COMPAT_LEDGER:-$OUT/compat.jsonl}"

echo "[survey-run] spinel: $("$HERE/exe/spinel-compat" engine | sed -n '1,2p' | tr '\n' ' ')"
echo "[survey-run] list=$LIST jobs=$JOBS ledger=$SPINEL_COMPAT_LEDGER"

"$HERE/exe/spinel-compat" survey --list "$LIST" --jobs "$JOBS" --out "$OUT/report.md"

echo "[survey-run] done -> $OUT/report.md  (+ $SPINEL_COMPAT_LEDGER)"
