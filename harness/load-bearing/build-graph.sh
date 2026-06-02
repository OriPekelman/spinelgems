#!/usr/bin/env bash
# Build the RubyGems dependency graph LOCALLY from the spinel-compat gem cache,
# then rank gems by how load-bearing they are (transitive in-degree — how many
# gems pull them in directly OR as a dependency-of-a-dependency).
#
# Source of truth: each cached gem dir keeps either the original `.gem`
# (metadata.gz → authoritative spec) or a root `<name>.gemspec`. We read runtime
# dependencies from both; in-degree is robust to a gem missing its OWN spec,
# since a gem's load-bearing score comes from its *dependents'* specs.
set -euo pipefail
CACHE="${SPINEL_GEM_CACHE:-/srv/data/scratch/spinel-compat-cache/gems}"
OUT="${1:-/srv/data/scratch/lbg}"; mkdir -p "$OUT"; HERE="$(cd "$(dirname "$0")" && pwd)"

find "$CACHE" -name '*.gem'                  >  "$OUT/paths.txt"
find "$CACHE" -maxdepth 2 -name '*.gemspec'  >> "$OUT/paths.txt"
echo "paths: $(wc -l < "$OUT/paths.txt")"

P=$(( $(nproc) - 2 )); [ "$P" -lt 4 ] && P=4
: > "$OUT/edges_raw.tsv"
cat "$OUT/paths.txt" | xargs -P "$P" -n 80 ruby "$HERE/extract-deps.rb" >> "$OUT/edges_raw.tsv" 2>/dev/null
sort -u "$OUT/edges_raw.tsv" > "$OUT/edges.tsv"
echo "edges: $(wc -l < "$OUT/edges.tsv") | source gems: $(cut -f1 "$OUT/edges.tsv" | sort -u | wc -l)"

ruby "$HERE/analyze.rb" "$OUT/edges.tsv" "$HERE/../../survey-193k/compat.jsonl" > "$OUT/loadbearing.tsv"
echo "ranking -> $OUT/loadbearing.tsv"
