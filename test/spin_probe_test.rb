#!/usr/bin/env ruby
# frozen_string_literal: true
#
# Coverage for SpinProbe — the projection of an internal compat record into the
# spin-index packages/<name>.toml shape (name + [[release]] + [[probe]]) that
# rubys introduced in matz/spin-index#1 (redis) / #2 (pg). Locks the field map
# (rev -> spinel, verdict -> result/tier, at -> date) and TOML rendering so a
# future catalog -> index generator (spinelgems#6) stays a field-rename.
# Hermetic: pure Hash -> String, no ledger, no compiler. Run: `ruby test/spin_probe_test.rb`.
$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "bundler/spinel"

@fails = 0
def check(cond, msg)
  puts((cond ? "  PASS  " : "  FAIL  ") + msg)
  @fails += 1 unless cond
end

S = Bundler::Spinel::SpinProbe

# --- compiler_sha: strip `git:` + `/platform`, reject non-git revs ---
puts "compiler_sha"
check(S.compiler_sha("git:42adf886/aarch64-linux") == "42adf886", "git:sha/plat -> sha")
check(S.compiler_sha("git:42adf886") == "42adf886", "git:sha (no platform)")
check(S.compiler_sha("bin:deadbeef").nil?, "bin:<hash> -> nil (no git provenance)")
check(S.compiler_sha(nil).nil? && S.compiler_sha("").nil?, "blank -> nil")

# --- probe_date ---
puts "\nprobe_date"
check(S.probe_date("2026-07-06T11:37:48Z") == "2026-07-06", "iso timestamp -> date")
check(S.probe_date(nil).nil?, "nil at -> nil")

# --- probe_record: verified -> pass, tier carried; weaker -> fail ---
puts "\nprobe_record"
verified = { "gem" => "2gis", "version" => "0.0.0",
             "rev" => "git:42adf886/aarch64-linux", "verdict" => "verified",
             "at" => "2026-07-06T11:37:48Z" }
p = S.probe_record(verified)
check(p["version"] == "0.0.0", "version copied")
check(p["spinel"] == "42adf886", "rev -> spinel sha")
check(p["result"] == "pass", "verified -> pass")
check(p["tier"] == "verified", "verdict -> tier (roadmap signal)")
check(p["date"] == "2026-07-06", "at -> date")
check(p.keys == %w[version spinel result tier date], "field order stable")

risky = { "gem" => "x", "version" => "1.0", "rev" => "git:abc123/aarch64-linux",
          "verdict" => "risky", "at" => "2026-07-01T00:00:00Z" }
check(S.probe_record(risky)["result"] == "fail", "non-verified -> fail")
check(S.probe_record(risky)["tier"] == "risky", "tier keeps the real verdict")

# strict: only the four blessed fields, no tier
ps = S.probe_record(verified, strict: true)
check(ps.keys == %w[version spinel result date], "strict omits tier")

# date override (bulk reprobe records carry no `at`)
noat = { "gem" => "y", "version" => "2.0", "rev" => "git:abc123/aarch64-linux",
         "verdict" => "clean" }
check(S.probe_record(noat)["date"].nil?, "no at, no date -> date omitted")
check(S.probe_record(noat, date: "2026-07-06")["date"] == "2026-07-06", "date: override")

# a bin: rev has no compiler SHA -> no probe record
check(S.probe_record({ "rev" => "bin:xx", "version" => "1", "verdict" => "clean" }).nil?,
      "bin: rev -> nil record")

# --- render_toml / package_toml ---
puts "\nrender_toml"
# Ported package: name + repo + release + probe (matches rubys' redis.toml shape).
ported = S.package_toml(verified, repo: "https://github.com/rubys/spinel-2gis",
                        ref: "4c2ceaba", date: "2026-07-07", strict: true)
expected = <<~TOML
  name = "2gis"
  repo = "https://github.com/rubys/spinel-2gis"

  [[release]]
  version = "0.0.0"
  ref = "4c2ceaba"

  [[probe]]
  version = "0.0.0"
  spinel = "42adf886"
  result = "pass"
  date = "2026-07-07"
TOML
check(ported == expected, "ported package toml matches rubys' shape")

# Candidate (roadmap) shape: no repo, no release, tier carried.
cand = S.package_toml(risky)
check(!cand.include?("repo ="), "candidate: no repo line")
check(!cand.include?("[[release]]"), "candidate: no release table")
check(cand.include?("[[probe]]") && cand.include?(%(tier = "risky")), "candidate: probe + tier")
check(cand.start_with?(%(name = "x"\n)), "candidate: name first")

# quoting hardens against stray quotes in a name
check(S.quote(%(a"b)) == %("a\\"b"), "quote escapes inner quote")

puts(@fails.zero? ? "\nall checks passed" : "\n#{@fails} check(s) FAILED")
exit(@fails.zero? ? 0 : 1)
