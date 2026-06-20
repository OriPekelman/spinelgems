#!/usr/bin/env ruby
# frozen_string_literal: true
#
# Coverage for version-FLOOR human attestations (Site#attestation_for): a person
# vouching version X carries the 👤/★ signal for X and every LATER release, so a
# corpus reprobe that picks up a newer cached version doesn't silently drop the
# star (the tep 0.11.2 → 0.11.5 regression). Older versions and other gems don't
# match; a fresh behaviour rejection still overrides (checked via #rows).
# Hermetic — a tiny attestations.jsonl + a stub ledger. Run: `ruby test/attestation_floor_test.rb`.
$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "fileutils"
require "tmpdir"
require "json"
require "bundler/spinel"

@fails = 0
def check(cond, msg)
  puts((cond ? "  PASS  " : "  FAIL  ") + msg)
  @fails += 1 unless cond
end

S = Bundler::Spinel::Site

# --- Site#attestation_for: version-floor matching --------------------------
puts "attestation_for matches the attested version and every later one"
Dir.mktmpdir("attfloor") do |dir|
  af = File.join(dir, "att.jsonl")
  File.write(af, [
    { gem: "tep", version: "0.11.2", by: "ori", note: "native framework" },
    { gem: "multi", version: "2.0.0", by: "ori", note: "later pin" },
    { gem: "multi", version: "1.0.0", by: "ori", note: "earlier pin" },
  ].map(&:to_json).join("\n") + "\n")

  s = S.allocate
  s.instance_variable_set(:@attestations_path, af)

  check(s.send(:attestation_for, "tep", "0.11.2")&.dig("version") == "0.11.2", "exact version matches")
  check(s.send(:attestation_for, "tep", "0.11.5")&.dig("version") == "0.11.2", "newer patch inherits (0.11.5 -> 0.11.2)")
  check(s.send(:attestation_for, "tep", "0.12.0")&.dig("version") == "0.11.2", "newer minor inherits (0.12.0 -> 0.11.2)")
  check(s.send(:attestation_for, "tep", "1.0.0")&.dig("version") == "0.11.2", "major bump inherits")
  check(s.send(:attestation_for, "tep", "0.11.1").nil?, "OLDER than attested -> no match")
  check(s.send(:attestation_for, "nope", "1.0.0").nil?, "un-attested gem -> no match")

  # multiple attestations for one gem: pick the highest version that is <= target
  check(s.send(:attestation_for, "multi", "2.5.0")&.dig("version") == "2.0.0", "picks highest floor <= version (2.5 -> 2.0)")
  check(s.send(:attestation_for, "multi", "1.9.9")&.dig("version") == "1.0.0", "below 2.0 falls to the 1.0 floor")
  check(s.send(:attestation_for, "multi", "0.9.0").nil?, "below all floors -> no match")
end

# --- Site#rows: a version-floored attestation lifts a newer catalog row to ★ -
# and a fresh behaviour rejection still overrides it.
puts "\nrows: floored attestation -> verified on a NEWER catalog version; behaviour-reject overrides"
Dir.mktmpdir("attrows") do |dir|
  af = File.join(dir, "att.jsonl")
  File.write(af, { gem: "tep", version: "0.11.2", by: "ori", note: "x" }.to_json + "\n")
  led = File.join(dir, "led.jsonl")
  rev = "git:testrev/x"
  # tep at a NEWER version than the attestation, clean static probe at the rev.
  write = ->(rows) { File.write(led, rows.map(&:to_json).join("\n") + "\n") }

  site = S.new(ledger: Bundler::Spinel::Ledger.new(path: led), meta_path: "/nonexistent")
  site.instance_variable_set(:@attestations_path, af)
  # Force the site's rev to our test rev so current_entries picks the row up.
  site.define_singleton_method(:rev) { rev }

  write.call([{ gem: "tep", version: "0.11.5", rev: rev, verdict: "clean", reasons: [], risks: [], probe: "compile+scan" }])
  tep = site.send(:rows).find { |r| r.gem == "tep" }
  check(tep && tep.verdict == "verified", "tep 0.11.5 lifted to verified by the 0.11.2 floor (got #{tep&.verdict})")
  check(tep && tep.human, "tep carries the 👤 human badge")

  # A fresh behaviour rejection (verify-full) at this rev overrides the human.
  write.call([
    { gem: "tep", version: "0.11.5", rev: rev, verdict: "clean", reasons: [], risks: [], probe: "compile+scan" },
    { gem: "tep", version: "0.11.5", rev: rev, verdict: "rejected", reasons: ["rubric:miscompile"], risks: [], probe: "verify-full" },
  ])
  site2 = S.new(ledger: Bundler::Spinel::Ledger.new(path: led), meta_path: "/nonexistent")
  site2.instance_variable_set(:@attestations_path, af)
  site2.define_singleton_method(:rev) { rev }
  tep2 = site2.send(:rows).find { |r| r.gem == "tep" }
  check(tep2 && tep2.verdict == "rejected", "fresh behaviour rejection overrides the attestation (got #{tep2&.verdict})")
  check(tep2 && !tep2.human, "👤 badge suppressed when behaviour-rejected")
end

puts(@fails.zero? ? "\nall checks passed" : "\n#{@fails} check(s) FAILED")
exit(@fails.zero? ? 0 : 1)
