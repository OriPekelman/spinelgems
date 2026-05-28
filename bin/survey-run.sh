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
# Default to a per-run ledger (clean snapshot). To share across runs (cross-run
# cache-hits — only probe gems not yet seen at this rev), point SPINEL_COMPAT_LEDGER
# at the canonical ledger before invoking, e.g.:
#   SPINEL_COMPAT_LEDGER=$PWD/ledger/compat.jsonl bin/survey-run.sh ...
# Force re-probe even on cache hits with `spinel-compat survey --refresh`.
export SPINEL_COMPAT_LEDGER="${SPINEL_COMPAT_LEDGER:-$OUT/compat.jsonl}"

# Snapshot the Spinel checkout so a parallel rebuild can't mix revs into a long
# run (we hit this once: a `git pull` + `make` in $SPINEL_DIR mid-survey swapped
# the binaries while @engine.rev was cached at the old rev → mislabeled verdicts).
# Hardlink if possible (cheap, same fs); fall back to a full copy. Idempotent —
# a re-run with the same OUTDIR reuses the existing frozen copy.
SP_SRC="${SPINEL_DIR:-$HOME/spinel}"
SP_FROZEN="$OUT/spinel-frozen"
if [ ! -d "$SP_FROZEN" ]; then
  echo "[survey-run] freezing $SP_SRC -> $SP_FROZEN"
  cp -al "$SP_SRC" "$SP_FROZEN" 2>/dev/null || cp -r "$SP_SRC" "$SP_FROZEN"
fi
export SPINEL_DIR="$SP_FROZEN"

echo "[survey-run] spinel: $("$HERE/exe/spinel-compat" engine | sed -n '1,2p' | tr '\n' ' ')"
echo "[survey-run] list=$LIST jobs=$JOBS ledger=$SPINEL_COMPAT_LEDGER"

"$HERE/exe/spinel-compat" survey --list "$LIST" --jobs "$JOBS" --out "$OUT/report.md"

echo "[survey-run] done -> $OUT/report.md  (+ $SPINEL_COMPAT_LEDGER)"
