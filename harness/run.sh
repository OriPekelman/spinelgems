#!/usr/bin/env bash
# Drive the harness: Phase 1 (structure) + Phase 2 (verify each smoke).
#   SPINEL_DIR=~/sites/spinel ./run.sh
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
CLI="$HERE/../exe/spinel-compat"
BUNDLE="${BUNDLE:-bundle}"
command -v "$BUNDLE" >/dev/null 2>&1 || BUNDLE="bundle3.2" # Debian-style fallback
export SPINEL_COMPAT_LEDGER="${SPINEL_COMPAT_LEDGER:-$HERE/../ledger/compat.jsonl}"

echo "== Phase 1: Gemfile -> lock -> vendor -> compile =="
cd "$HERE"
"$BUNDLE" lock
"$CLI" vendor Gemfile.lock --into vendor/spinel
"${SPINEL_DIR:-$HOME/spinel}/spinel" main.rb -o main.bin
./main.bin

echo "== Phase 2: verify each smoke =="
for s in "$HERE"/smoke/*.rb; do
  g="$(basename "$s" .rb)"
  "$CLI" verify "$g" --smoke "$s" || true
done
