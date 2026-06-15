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
# SPINEL_NO_FREEZE=1 skips the self-freeze — set it when SPINEL_DIR already IS
# a frozen copy (e.g. /srv/data/scratch/spinelgems-rp/spinel-frozen-<rev>).
# The in-repo freeze this would otherwise create is exactly the stray nested
# dir that corrupted the 9c0a5f0 freeze; harness-run.sh honors the same flag.
SP_SRC="${SPINEL_DIR:-$HOME/spinel}"
SP_REV="$(git -C "$SP_SRC" rev-parse --short HEAD 2>/dev/null || echo unknown)"
if [ -z "${SPINEL_NO_FREEZE:-}" ]; then
  SP_FROZEN="$HERE/spinel-frozen-$SP_REV"
  if [ ! -d "$SP_FROZEN" ]; then
    echo "[reprobe] freezing $SP_SRC -> $SP_FROZEN"
    cp -al "$SP_SRC" "$SP_FROZEN" 2>/dev/null || cp -r "$SP_SRC" "$SP_FROZEN"
  fi
  # Stamp the rev so the frozen copy reports git:<sha> even though its .git is a
  # worktree pointer (or absent) — keeps the ledger key consistent with the live
  # checkout (engine.rb reads .spinel_rev first).
  [ "$SP_REV" != "unknown" ] && printf '%s\n' "$SP_REV" > "$SP_FROZEN/.spinel_rev"
  export SPINEL_DIR="$SP_FROZEN"
fi

OUT="${2:-$HERE/survey-$SP_REV}"
mkdir -p "$OUT"
export SPINEL_COMPAT_LEDGER="${SPINEL_COMPAT_LEDGER:-$OUT/compat.jsonl}"
: > "$SPINEL_COMPAT_LEDGER"

echo "[reprobe] spinel : $("$CLI" engine | sed -n '2p')"
echo "[reprobe] list   : $LIST  shards=$SHARDS  ledger=$SPINEL_COMPAT_LEDGER"

# Map each corpus gem to its newest cached source dir (no fetch, no network).
# Gems on the analyze-bomb blacklist (survey-193k/analyze-bombs.txt) are NOT
# probed: each makes spinel_analyze OOM/timeout (matz/spinel#1302) and burns the
# full ~120s analyze timeout while only ever producing `rejected`. We emit a
# synthetic `rejected` (probe=blacklist) for them so the catalog still lists
# them, and skip the expensive probe. Remove a gem from the blacklist once
# #1302 lands to re-probe it.
CACHE="$(ruby -e 'require "fileutils"; puts File.expand_path(ENV["SPINEL_COMPAT_CACHE"] || "~/.cache/spinel-compat/gems")')"
TSV="$OUT/cached.tsv"
BLACKLIST="$HERE/survey-193k/analyze-bombs.txt"
FULL_REV="$("$CLI" engine 2>/dev/null | sed -n 's/.*engine rev *: //p')"
SP_LIST="$LIST" SP_CACHE="$CACHE" SP_TSV="$TSV" SP_BLACKLIST="$BLACKLIST" \
SP_REV="$FULL_REV" SP_LEDGER="$SPINEL_COMPAT_LEDGER" ruby -e '
  require "set"; require "json"
  corpus = Set.new
  File.foreach(ENV["SP_LIST"]) { |l| n = l.strip; corpus << n unless n.empty? || n.start_with?("#") }
  bomb = Set.new
  if (bf = ENV["SP_BLACKLIST"]) && File.exist?(bf)
    File.foreach(bf) { |l| n = l.strip; bomb << n unless n.empty? || n.start_with?("#") }
  end
  idx = {}
  Dir.children(ENV["SP_CACHE"]).each do |e|
    p = File.join(ENV["SP_CACHE"], e); next unless File.directory?(p)
    next unless e =~ /\A(.+)-([0-9][0-9A-Za-z.\-]*)\z/
    n, v = $1, $2; next unless corpus.include?(n)
    cur = idx[n]
    idx[n] = [v, p] if cur.nil? || (File.mtime(p) rescue Time.at(0)) > (File.mtime(cur[1]) rescue Time.at(0))
  end
  rev = ENV["SP_REV"].to_s
  probed = 0; skipped = 0
  File.open(ENV["SP_TSV"], "w") do |tf|
    File.open(ENV["SP_LEDGER"], "a") do |lf|
      idx.each do |n, vv|
        if bomb.include?(n)
          lf << JSON.generate("gem" => n, "version" => vv[0], "rev" => rev,
                              "verdict" => "rejected",
                              "reasons" => ["analyze-oom: spinel_analyze OOM/timeout, skipped (matz/spinel#1302)"],
                              "risks" => [], "probe" => "blacklist") << "\n"
          skipped += 1
        else
          tf << [n, vv[0], vv[1]].join("\t") << "\n"
          probed += 1
        end
      end
    end
  end
  warn "[reprobe] corpus=#{corpus.size} cached=#{idx.size} probe=#{probed} blacklisted=#{skipped}"
'

# Fan out: one `probe --dir` per cached gem, all appending to the ledger.
# NB: no `exec` + a trailing `|| true` INSIDE the lambda — a probe exiting 255
# makes xargs abort the ENTIRE fan-out (killed the 57af7f9 run at 13k/189k).
# One bad gem must cost one verdict, never the sweep.
cat "$TSV" | xargs -P "$SHARDS" -d'\n' -I{} bash -c '
  IFS=$'"'"'\t'"'"' read -r g v d <<< "$1"
  ulimit -v 6291456
  "$0" probe "$g" "$v" --dir "$d" >/dev/null 2>&1 || true
' "$CLI" {} || true

# Aggregate report (pure ledger aggregation — no probes, no network).
"$CLI" survey --list "$LIST" --jobs 1 --out "$OUT/report.md" || true
echo "[reprobe] done -> $SPINEL_COMPAT_LEDGER  (+ $OUT/report.md)"
