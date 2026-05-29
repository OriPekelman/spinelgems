#!/usr/bin/env bash
# Re-evaluate the whole gem corpus on a NEW Spinel rev — fast, cache-only.
#
#   SPINEL_DIR=~/sites/spinel bin/reprobe-corpus.sh [GEMLIST] [OUTDIR]
#     GEMLIST  default survey-193k/gemlist.txt
#     OUTDIR   default survey-<rev>/
#
# Why this exists alongside bin/survey-run.sh:
#
#   - survey-run.sh is the *refresh*: for each gem it resolves `latest_version`
#     over the network and fetches new sources. That pulls newer gem versions +
#     newly-published gems, but it's ~193k network round-trips (~hours) and
#     rate-limit-flaky. Do it on an explicit cadence (≈ monthly).
#   - reprobe-corpus.sh is the *re-evaluation*: it re-probes the already-cached
#     (gem, version) sources at the current engine rev — no network, no
#     latest_version. The compiler moved; the gems didn't. Use this after every
#     Spinel bump to re-base the catalog (~14 min at nproc shards). This is the
#     frequent, cheap operation.
#
# Both shard via `xargs -P` over one O_APPEND ledger (kernel-atomic appends).
set -euo pipefail

HERE="$(cd "$(dirname "$0")/.." && pwd)"
LIST="${1:-$HERE/survey-193k/gemlist.txt}"
CLI="$HERE/exe/spinel-compat"

if [ -n "${SHARDS:-}" ]; then :
elif command -v nproc >/dev/null 2>&1; then SHARDS="$(nproc)"
else SHARDS=4; fi

# Freeze the Spinel checkout (rev-stable for the whole run), like survey-run.sh.
SP_SRC="${SPINEL_DIR:-$HOME/spinel}"
SP_REV="$(git -C "$SP_SRC" rev-parse --short HEAD 2>/dev/null || echo unknown)"
SP_FROZEN="$HERE/spinel-frozen-$SP_REV"
if [ ! -d "$SP_FROZEN" ]; then
  echo "[reprobe] freezing $SP_SRC -> $SP_FROZEN"
  cp -al "$SP_SRC" "$SP_FROZEN" 2>/dev/null || cp -r "$SP_SRC" "$SP_FROZEN"
fi
export SPINEL_DIR="$SP_FROZEN"

OUT="${2:-$HERE/survey-$SP_REV}"
mkdir -p "$OUT"
export SPINEL_COMPAT_LEDGER="${SPINEL_COMPAT_LEDGER:-$OUT/compat.jsonl}"
: > "$SPINEL_COMPAT_LEDGER"

echo "[reprobe] spinel : $("$CLI" engine | sed -n '2p')"
echo "[reprobe] list   : $LIST  shards=$SHARDS  ledger=$SPINEL_COMPAT_LEDGER"

# Map each corpus gem to its newest cached source dir (no fetch, no network).
CACHE="$(ruby -e 'require "fileutils"; puts File.expand_path(ENV["SPINEL_COMPAT_CACHE"] || "~/.cache/spinel-compat/gems")')"
TSV="$OUT/cached.tsv"
SP_LIST="$LIST" SP_CACHE="$CACHE" SP_TSV="$TSV" ruby -e '
  require "set"
  corpus = Set.new
  File.foreach(ENV["SP_LIST"]) { |l| n = l.strip; corpus << n unless n.empty? || n.start_with?("#") }
  idx = {}
  Dir.children(ENV["SP_CACHE"]).each do |e|
    p = File.join(ENV["SP_CACHE"], e); next unless File.directory?(p)
    next unless e =~ /\A(.+)-([0-9][0-9A-Za-z.\-]*)\z/
    n, v = $1, $2; next unless corpus.include?(n)
    cur = idx[n]
    idx[n] = [v, p] if cur.nil? || (File.mtime(p) rescue Time.at(0)) > (File.mtime(cur[1]) rescue Time.at(0))
  end
  File.open(ENV["SP_TSV"], "w") { |f| idx.each { |n, vv| f << [n, vv[0], vv[1]].join("\t") << "\n" } }
  warn "[reprobe] corpus=#{corpus.size} cached=#{idx.size}"
'

# Fan out: one `probe --dir` per cached gem, all appending to the ledger.
cat "$TSV" | xargs -P "$SHARDS" -d'\n' -I{} bash -c '
  IFS=$'"'"'\t'"'"' read -r g v d <<< "$1"
  exec "$0" probe "$g" "$v" --dir "$d" >/dev/null 2>&1
' "$CLI" {} || true

# Aggregate report (pure ledger aggregation — no probes, no network).
"$CLI" survey --list "$LIST" --jobs 1 --out "$OUT/report.md" || true
echo "[reprobe] done -> $SPINEL_COMPAT_LEDGER  (+ $OUT/report.md)"
