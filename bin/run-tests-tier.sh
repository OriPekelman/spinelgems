#!/usr/bin/env bash
# Regenerate test-results.jsonl — the ✪ tests signal (spinelgems#6).
#
# Runs `verify --tests` (own minitest/test-unit suite, translated to a
# Spinel-compilable runner) over the verified gems that ship a self-contained
# suite, against a frozen engine. A gem whose translated suite compiles, runs,
# and matches CRuby earns result:"pass" → the ✪ badge at that rev. Everything
# else is recorded as fail/n-a (and is a free miscompile reproducer).
#
# Usage: bin/run-tests-tier.sh [SPINEL_FROZEN_DIR]   (default: spinel-frozen-f8040f3)
set -euo pipefail
cd "$(dirname "$0")/.."
FROZEN="${1:-$PWD/spinel-frozen-f8040f3}"
CACHE="${SPINEL_GEM_CACHE:-$HOME/.cache/spinel-compat/gems}"
LEDGER=$(mktemp)
export SPINEL_DIR="$FROZEN" SPINEL_COMPAT_LEDGER="$LEDGER"

# verified gems (verify-full) that ship a minitest/test-unit suite in test/
ruby -rjson -e '
  ver={}; File.foreach("survey-193k/compat.jsonl"){|l| r=JSON.parse(l) rescue next
    ver[r["gem"]]=r["version"] if r["verdict"]=="verified" && r["probe"]=="verify-full"}
  c=ENV["CACHE"]||"'"$CACHE"'"
  ver.each{|g,v| d="#{c}/#{g}-#{v}"; td=["test","tests"].map{|x|"#{d}/#{x}"}.find{|x|Dir.exist?(x)}
    next unless td
    next unless Dir.glob("#{td}/**/*.rb").any?{|f| (File.read(f)[/minitest|test\/unit|Test::Unit/i] rescue false)}
    puts "#{g}\t#{v}\t#{d}"}
' CACHE="$CACHE" > /tmp/_tests_cands.tsv
echo "candidates: $(wc -l < /tmp/_tests_cands.tsv)"

while IFS=$'\t' read -r g v d; do
  [ -z "$g" ] && continue
  ./exe/spinel-compat verify "$g" "$v" --dir "$d" --tests >/dev/null 2>&1 || true
done < /tmp/_tests_cands.tsv

REV=$(ruby -rjson -e 'r=JSON.parse(File.readlines(ENV["L"]).last); puts r["rev"]' L="$LEDGER" 2>/dev/null || echo "")
ruby -rjson -e '
  res={}
  File.foreach(ENV["L"]){|l| r=JSON.parse(l) rescue next
    res[r["gem"]]={gem:r["gem"], version:r["version"], rev:r["rev"],
      result:(r["verdict"]=="verified" ? "pass" : "fail"), verdict:r["verdict"],
      note:(r["reasons"]||[]).reject{|x|x=~/^rubric:/}.first(2).join("; ")}}
  File.read("/tmp/_tests_cands.tsv").split("\n").each{|line| g,v,_=line.split("\t"); next if res[g]
    res[g]={gem:g, version:v, rev:ENV["REV"], result:"n/a", verdict:"no-suite",
      note:"TestRunner found no extractable test_* methods (reflective/shared-helper suite)"}}
  File.open("test-results.jsonl","w"){|f| res.values.sort_by{|x|x[:gem]}.each{|x| f<<JSON.generate(x)<<"\n"}}
  pass=res.values.count{|x|x[:result]=="pass"}
  STDERR.puts "test-results.jsonl: #{res.size} gems, #{pass} pass @ #{ENV["REV"]}"
' L="$LEDGER" REV="$REV"
rm -f "$LEDGER" /tmp/_tests_cands.tsv
