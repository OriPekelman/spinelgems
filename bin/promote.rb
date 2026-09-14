#!/usr/bin/env ruby
# Promote a measured rev to the canonical catalog.
#
#   bin/promote.rb REV [--survey DIR] [--ledger F] [--out F] [--dry-run]
#
# Writes the canonical one-record-per-gem corpus that `build-site` reads
# (survey-193k/compat.jsonl, "the ledger backing the deploy") by flattening the
# rev's survey verdicts together with its harness verdicts.
#
# THE FLATTENING RULE — recovered from survey-193k and validated byte-for-byte
# against the 55638986 promotion (0 whole-record mismatches over 192,027 gems):
#
#   1. Take every record at REV, from the survey ledger and the harness ledger.
#   2. Partition into BEHAVIOUR records (probe `verify` / `verify-full`, i.e.
#      the harness actually built and ran the gem) and STATIC records (probe
#      `compile+scan` / `static` / `blacklist`).
#   3. If any behaviour record exists, choose among those ALONE; otherwise
#      choose among the static ones.
#   4. Within the chosen set: a `rejected` wins outright (a caught failure is a
#      fact); otherwise the highest VERDICT_RANK wins.
#
# Step 3 is the subtle one and it is deliberate, matching the reasoning in
# Site#rows: a static `compile+scan` verdict is an entrypoint-only LOWER BOUND,
# so a gem the harness ran end-to-end outranks it even when the static verdict
# looks better. That is why a `risky/verify` beats a `clean/compile+scan`, and
# why a `loaded/verify` beats a `rejected/compile+scan`.
#
# The ★ lift (sticky verified across revs, human attestations) is NOT applied
# here — Site#rows applies it at render time from the full ledger history.
require "json"

rev = ARGV.shift
abort "usage: promote.rb REV [--survey DIR] [--ledger F] [--out F] [--dry-run]" unless rev && !rev.start_with?("--")
rev = "git:#{rev}/aarch64-linux" unless rev.start_with?("git:")

opt = ->(name, dflt) { (i = ARGV.index(name)) ? ARGV[i + 1] : dflt }
short   = rev.sub(%r{\Agit:}, "").sub(%r{/.*\z}, "")
survey  = opt.call("--survey", "survey-#{short}/compat.jsonl")
survey  = File.join(survey, "compat.jsonl") if File.directory?(survey)
ledger  = opt.call("--ledger", "ledger/compat.jsonl")
out     = opt.call("--out",    "survey-193k/compat.jsonl")
dry     = ARGV.include?("--dry-run")

RANK  = { "rejected" => 0, "risky" => 1, "clean" => 2, "loaded" => 3, "verified" => 4 }.freeze
BEHAV = %w[verify verify-full].freeze

recs = Hash.new { |h, k| h[k] = [] }
[survey, ledger].each do |f|
  abort "missing #{f}" unless File.exist?(f)
  File.foreach(f) do |l|
    r = (JSON.parse(l) rescue next)
    recs[r["gem"]] << r if r["rev"] == rev
  end
end
abort "no records at #{rev}" if recs.empty?

best = ->(vs) { vs.find { |r| r["verdict"] == "rejected" } || vs.max_by { |r| RANK[r["verdict"]] || -1 } }
picked = recs.transform_values do |vs|
  b = vs.select { |r| BEHAV.include?(r["probe"]) }
  b.empty? ? best.call(vs) : best.call(b)
end

tally = Hash.new(0)
picked.each_value { |r| tally[r["verdict"]] += 1 }
warn "rev #{rev}"
warn "gems #{picked.size}  (behaviour-backed #{picked.count { |_, r| BEHAV.include?(r['probe']) }})"
%w[verified loaded clean risky rejected].each { |k| warn format("  %-9s %7d", k, tally[k]) }

if dry
  warn "(dry run — #{out} not written)"
else
  File.open(out, "w") { |f| picked.keys.sort.each { |g| f.puts JSON.generate(picked[g]) } }
  warn "wrote #{out}"
end
