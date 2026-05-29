#!/usr/bin/env bash
# Move the gem-source cache off the tight root fs onto /srv/data (the 1.9 TB
# volume on gx10) BEFORE a big survey/harness sweep. A full ecosystem cache is
# ~193k gem sources (100s of GB) and the 916 GB root runs out.
#
# Strategy: rsync the cache to /srv/data/scratch, then replace the old dir with
# a symlink. Every absolute ~/.cache/spinel-compat/gems/<gem>-<ver> path that
# tools already recorded (e.g. `verify --dir`) keeps resolving through the
# symlink, and new fetches land on /srv/data. SPINEL_COMPAT_CACHE (honoured by
# GemFetcher) can also point straight at the new location for new runs.
#
# SAFETY: do NOT run while a survey/harness/workflow is in flight — in-flight
# processes hold open paths under the old dir. Run it between sweeps.
#
#   bin/migrate-cache.sh            # rsync + symlink (idempotent; safe to re-run)
#   DRY=1 bin/migrate-cache.sh      # show what it would do
set -euo pipefail

SRC="${SPINEL_COMPAT_CACHE_OLD:-$HOME/.cache/spinel-compat/gems}"
DEST="${SPINEL_COMPAT_CACHE_DEST:-/srv/data/scratch/spinel-compat-cache/gems}"

run() { echo "+ $*"; [ -n "${DRY:-}" ] || "$@"; }

# Already migrated (SRC is a symlink to DEST)? Nothing to do.
if [ -L "$SRC" ]; then
  echo "[migrate-cache] $SRC is already a symlink -> $(readlink "$SRC"). Nothing to do."
  exit 0
fi

if [ ! -d "$SRC" ]; then
  echo "[migrate-cache] no source cache at $SRC — nothing to migrate."
  exit 0
fi

echo "[migrate-cache] src : $SRC ($(du -sh "$SRC" 2>/dev/null | cut -f1))"
echo "[migrate-cache] dest: $DEST"
echo "[migrate-cache] root fs free: $(df -h "$SRC" | awk 'NR==2{print $4}')   /srv/data free: $(df -h "$DEST" 2>/dev/null || df -h /srv/data | awk 'NR==2{print $4}')"

run mkdir -p "$DEST"
# Copy contents (note trailing slash). rsync is resumable — re-run after an
# interruption only ships the delta.
run rsync -a --info=progress2 "$SRC"/ "$DEST"/

# Swap the old dir for a symlink. Keep a one-shot backup of the now-empty dir
# name in case something still holds it.
run rm -rf "$SRC.migrated-bak"
run mv "$SRC" "$SRC.migrated-bak"
run ln -s "$DEST" "$SRC"
echo "[migrate-cache] done. $SRC -> $DEST  (old emptied tree kept at $SRC.migrated-bak)"
echo "[migrate-cache] verify a path, then: rm -rf '$SRC.migrated-bak' to reclaim root space."
echo "[migrate-cache] for new runs you can also export SPINEL_COMPAT_CACHE=$DEST"
