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
#   candidates.tsv     the full ranked candidate-call list
#   compat.jsonl       the ledger produced (copy of $SPINEL_COMPAT_LEDGER)
#   spinel-frozen/     hardlinked snapshot of $SPINEL_DIR (rev-stable for the run)
#   shards/s-NNN.list  the input partition (round-robin); kept for inspection
#   shards/s-NNN.log   per-shard worker stderr (progress lines)
#
# Parallelism: process-sharded, not thread-pooled.
#
#   Ruby's GIL means a thread pool of N inside one process only ever uses
#   one core for Ruby work (subprocess invocations release the GVL, but the
#   per-gem orchestration — `gem list -r` parsing, ledger I/O, fetch driving
#   — stays single-threaded). We saw this in practice: 20 threads on a
#   20-core box pegged at ~100% (one core's worth) of Ruby and were idle
#   for most of the wall clock waiting on rubygems.org.
#
#   Process sharding (SHARDS env, defaults to nproc) fixes both problems
#   together: each shard is its own Ruby interpreter (own GIL, own core)
#   AND its own TCP connection pool to rubygems.org. They all append to the
#   *same* SPINEL_COMPAT_LEDGER — process-safe because the kernel guarantees
#   O_APPEND writes ≤ PIPE_BUF (4 KiB on Linux, well above our ~300-byte
#   verdict lines) are atomic; concurrent appends interleave cleanly.
#
# Resume:
#
#   Re-running with the same OUTDIR is a resume. Each shard's Survey
#   instance builds a `known_set` from the existing ledger and short-circuits
#   any gem with a verdict at the current engine rev — no `latest_version`
#   call, no fetch, no probe. So a restart only does the work the previous
#   run hadn't completed. Pass `--refresh` to re-probe everything (e.g.
#   after a Spinel rev bump that invalidates verdicts at the old rev).
#
# Cross-run ledger:
#
#   Default ledger is OUTDIR/compat.jsonl (clean per-run snapshot). To share
#   one canonical ledger across many runs (cross-run cache hits — only probe
#   gems not yet seen at *any* run's rev):
#     SPINEL_COMPAT_LEDGER=$PWD/ledger/compat.jsonl bin/survey-run.sh ...
set -euo pipefail

LIST="${1:?usage: survey-run.sh GEMLIST.txt [OUTDIR]}"
OUT="${2:-./survey-out}"
HERE="$(cd "$(dirname "$0")/.." && pwd)"

# Shard count = host CPU count. Override with SHARDS=N to throttle (e.g.
# SHARDS=8 on shared infrastructure, or SHARDS=1 to debug).
if [ -n "${SHARDS:-}" ]; then :
elif command -v nproc >/dev/null 2>&1; then SHARDS="$(nproc)"
else SHARDS="$(sysctl -n hw.ncpu 2>/dev/null || echo 4)"
fi

mkdir -p "$OUT" "$OUT/shards"
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

echo "[survey-run] spinel : $("$HERE/exe/spinel-compat" engine | sed -n '1,2p' | tr '\n' ' ')"
echo "[survey-run] list   : $LIST  shards=$SHARDS  ledger=$SPINEL_COMPAT_LEDGER"

# Partition the gemlist into SHARDS round-robin (balanced, deterministic).
# We could hash for stability across edits, but round-robin gives identical
# resume behaviour (the ledger short-circuit doesn't care which shard a gem
# lands in) and avoids the cost of hashing 193k names.
LIST_ABS="$(cd "$(dirname "$LIST")" && pwd)/$(basename "$LIST")"
rm -f "$OUT/shards/"s-*.list   # don't double-append on restart
SP_OUT="$OUT" SP_SHARDS="$SHARDS" SP_LIST="$LIST_ABS" ruby -e '
  shards = Integer(ENV["SP_SHARDS"]); outdir = ENV["SP_OUT"]
  files = (0...shards).map { |i| File.open("#{outdir}/shards/s-#{format("%03d", i)}.list", "w") }
  count = 0
  File.foreach(ENV["SP_LIST"]) do |line|
    name = line.strip
    next if name.empty? || name.start_with?("#")
    files[count % shards] << "#{name}\n"
    count += 1
  end
  files.each(&:close)
  per = shards.zero? ? 0 : count / shards
  puts "[survey-run] partition: #{count} gems into #{shards} shards (~#{per} each)"
'

# Launch one survey process per shard, in parallel. Each is single-threaded
# (--jobs 1): the shard *is* the parallelism unit.
export HERE OUT
ls "$OUT/shards/"s-*.list \
  | xargs -P "$SHARDS" -I{} bash -c '
      shard="$1"; name=$(basename "$shard" .list)
      exec "$HERE/exe/spinel-compat" survey --list "$shard" --jobs 1 \
        > "$OUT/shards/$name.log" 2>&1
    ' _ {}

# Final report pass: walk the full list (all entries now in the ledger →
# pure aggregation, no network, no probes).
"$HERE/exe/spinel-compat" survey --list "$LIST" --jobs 1 --out "$OUT/report.md"

echo "[survey-run] done -> $OUT/report.md  (+ $SPINEL_COMPAT_LEDGER)"
