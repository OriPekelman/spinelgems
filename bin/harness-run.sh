#!/usr/bin/env bash
# Parallel-fanout harness runner for Phase 2 only (smokes + require-only).
#
#   bin/harness-run.sh [OUTDIR]    # default OUTDIR = ./harness/out
#
# Why this exists alongside harness/run.sh:
#
# - harness/run.sh runs Phase 1 (Gemfile→lock→vendor→main.bin sanity check)
#   plus Phase 2 sequentially. Fine for ~20 smokes + 250 loaders.
# - This one skips Phase 1 (already proven) and runs Phase 2 in N parallel
#   shards via xargs -P, the same pattern that fixed the survey's GIL
#   bottleneck. With 700+ loaders the speedup matters: ~12s/gem × 700 →
#   2.3h serial, ~7 min at SHARDS=20.
#
# Each shard is one `spinel-compat verify` per gem. The CLI appends one
# verdict per call to SPINEL_COMPAT_LEDGER under O_APPEND — multi-process-
# safe at the kernel level (writes ≤ PIPE_BUF, our verdict lines are well
# under 4 KiB).
#
# Phases:
#   Phase 2a — behaviour smokes (harness/smoke/<gem>.rb): one verify per
#              smoke, with --smoke FILE. Match → `verified`. Mismatch →
#              `rejected:miscompile`.
#   Phase 2b — require-only verifies (harness/loaders.txt): one verify per
#              named gem, no --smoke. Match → `loaded`. No build → `rejected`.
#
# Prereqs:
#   - SPINEL_DIR points to a built Spinel (or `spinel` on PATH).
#   - SPINEL_COMPAT_LEDGER picks the ledger; default = ./ledger/compat.jsonl.
set -euo pipefail

HERE="$(cd "$(dirname "$0")/.." && pwd)"
OUT="${1:-$HERE/harness/out}"
CLI="$HERE/exe/spinel-compat"

# Parallelism. nproc default; override with SHARDS=N.
if [ -n "${SHARDS:-}" ]; then :
elif command -v nproc >/dev/null 2>&1; then SHARDS="$(nproc)"
else SHARDS="$(sysctl -n hw.ncpu 2>/dev/null || echo 4)"
fi

mkdir -p "$OUT"
export SPINEL_COMPAT_LEDGER="${SPINEL_COMPAT_LEDGER:-$HERE/ledger/compat.jsonl}"

echo "[harness-run] spinel : $("$CLI" engine | sed -n '1,2p' | tr '\n' ' ')"
echo "[harness-run] ledger : $SPINEL_COMPAT_LEDGER  shards=$SHARDS"

# -------- Phase 2a: behaviour smokes --------
SMOKES=("$HERE"/harness/smoke/*.rb)
echo "[harness-run] Phase 2a: ${#SMOKES[@]} behaviour smokes"
printf '%s\n' "${SMOKES[@]}" \
  | xargs -P "$SHARDS" -I{} bash -c '
      s="$1"; g="$(basename "$s" .rb)"
      "$0" verify "$g" --smoke "$s" 2>&1 \
        | sed "s|^|  [smoke:$g] |"
    ' "$CLI" {} > "$OUT/phase2a.log" 2>&1 || true
echo "[harness-run] Phase 2a done -> $OUT/phase2a.log"

# -------- Phase 2b: require-only loaders --------
LOADERS_FILE="$HERE/harness/loaders.txt"
LOADER_COUNT=$(grep -cvE '^\s*(#|$)' "$LOADERS_FILE")
echo "[harness-run] Phase 2b: $LOADER_COUNT require-only loaders"
grep -vE '^\s*(#|$)' "$LOADERS_FILE" \
  | xargs -P "$SHARDS" -I{} bash -c '
      g="$1"
      "$0" verify "$g" 2>&1 \
        | sed "s|^|  [load:$g] |"
    ' "$CLI" {} > "$OUT/phase2b.log" 2>&1 || true
echo "[harness-run] Phase 2b done -> $OUT/phase2b.log"

echo "[harness-run] complete. New verdicts appended to $SPINEL_COMPAT_LEDGER"
