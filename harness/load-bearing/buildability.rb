#!/usr/bin/env ruby
# Buildability + blocker-flow + impact scoring.
#
# A gem is *buildable* only if it compiles AND its whole transitive dependency
# closure compiles ("green" = any verdict except rejected). A gem that's green
# on its own but has a rejected gem somewhere beneath it is BLOCKED. The rejected
# gems in a blocked gem's closure are its *root blockers*.
#
# We compute, per gem, the set of root blockers (capped at CAP — we only need the
# small cases to find "a single fix turns a whole subtree green"). From that:
#   - buildable / blocked / rejected counts
#   - per-blocker impact: how many green gems flow up to buildable if it is fixed
#       * sole-blocker impact  = gems whose ONLY blocker is this one (guaranteed)
#       * reach impact         = green gems that depend on it at all (upper bound)
#   - per-failure-type counterfactual: fix every gem of a type, Δ buildable
#
#   buildability.rb EDGES_TSV COMPAT_JSONL
require "json"
CAP = 4

edges = ARGV[0]; compat = ARGV[1]
abort "usage: buildability.rb EDGES_TSV COMPAT_JSONL" unless edges && compat

# verdict + coarse failure-type per gem
rank = { "rejected" => 0, "risky" => 1, "clean" => 2, "loaded" => 3, "verified" => 4 }
verdict = {}; ftype = {}
File.foreach(compat) do |l|
  r = JSON.parse(l) rescue next
  g = r["gem"]; v = r["verdict"]
  next if verdict[g] && rank[v].to_i <= rank[verdict[g]].to_i
  verdict[g] = v
  if v == "rejected"
    re = (r["reasons"] || []).first.to_s
    ftype[g] =
      case re
      when /no-entrypoint/        then "no-entrypoint"
      when /c-extension/          then "c-extension"
      when /\bhard\b/             then "hard-feature"
      when /analyze-timeout/      then "analyze-timeout"
      when /analyze-failed/       then "analyze-failed"
      when /unresolved/           then "unresolved-call"
      else "other"
      end
  end
end

# forward deps
deps = Hash.new { |h, k| h[k] = [] }
File.foreach(edges) do |l|
  s, d = l.chomp.split("\t", 2)
  next if d.nil? || d.empty?
  deps[s] << d
end

green = ->(g) { verdict[g] != "rejected" }   # unknown gems treated as green (non-blocking)

# Fixpoint: blockers(g) = (rejected? {g}) ∪ ⋃ blockers(dep), capped at CAP.
# Capped sets keep memory tiny and still resolve the sole-blocker case exactly.
nodes = (verdict.keys | deps.keys)
blockers = {}
nodes.each { |g| blockers[g] = verdict[g] == "rejected" ? [g] : [] }
changed = true
passes = 0
while changed
  changed = false; passes += 1
  deps.each do |g, ds|
    set = blockers[g]
    base = (verdict[g] == "rejected") ? [g] : []
    merged = base.dup
    ds.each { |d| (blockers[d] || []).each { |b| merged << b unless merged.include?(b) } if merged.size <= CAP }
    merged.uniq!
    merged = merged.first(CAP + 1) if merged.size > CAP   # mark ">CAP" via size CAP+1
    if merged.sort != set.sort
      blockers[g] = merged; changed = true
    end
  end
  break if passes > 60
end

buildable = 0; blocked = 0; rejected = 0
sole = Hash.new(0); reach = Hash.new(0)
type_blocked = Hash.new(0)
nodes.each do |g|
  if verdict[g] == "rejected"
    rejected += 1; next
  end
  bset = blockers[g] || []
  if bset.empty?
    buildable += 1
  else
    blocked += 1
    if bset.size == 1
      sole[bset[0]] += 1
    end
    if bset.size <= CAP
      bset.each { |b| reach[b] += 1 }
      bset.each { |b| type_blocked[ftype[b] || "?"] += 1 }
    end
  end
end

puts "=== buildability @ this rev (graph: #{nodes.size} gems) ==="
puts "  buildable (whole closure green) : #{buildable}"
puts "  blocked   (green, rejected dep) : #{blocked}"
puts "  rejected  (doesn't compile)     : #{rejected}"
puts "  fixpoint passes: #{passes}"
puts
puts "=== top blockers by SOLE-blocker impact (fixing this gem ALONE makes N gems buildable) ==="
sole.sort_by { |_, v| -v }.first(25).each do |b, v|
  puts "  %-26s sole=%-6d reach=%-6d  [%s]" % [b, v, reach[b], ftype[b] || "?"]
end
puts
puts "=== blocked gems attributable to each failure TYPE (≤CAP blockers) ==="
type_blocked.sort_by { |_, v| -v }.each { |t, v| puts "  %-18s %d" % [t, v] }

# Achievability: a `c-extension` blocker is native (needs FFI/ext vendoring, a
# separate track); `hard-feature` is heavy metaprogramming (the Rails ecosystem —
# not a first target for tep/spinelgems). The rest are *compiler* issues — the
# fixable-bug class this harness files. Surface the achievable high-impact set.
achiev = ->(t) {
  case t
  when "c-extension"  then "native"
  when "hard-feature" then "metaprog"
  else                     "compiler"
  end
}
# load transitive load-bearing score if available (annotate reach)
transit = {}
lb = File.join(__dir__, "top-load-bearing.tsv")
if File.exist?(lb)
  File.foreach(lb) { |l| g, t = l.split("\t"); transit[g] = t.to_i }
end
rows = sole.map { |b, v| [b, v, reach[b], ftype[b] || "?", achiev.(ftype[b]), transit[b] || 0] }
File.open(File.join(__dir__, "blockers.tsv"), "w") do |f|
  f.puts "gem\tsole_impact\treach_impact\tfailure_type\tachievability\ttransitive_loadbearing"
  rows.sort_by { |r| -r[1] }.each { |r| f.puts r.join("\t") }
end
puts
puts "=== ACHIEVABLE high-impact targets (compiler-fixable: NOT native, NOT metaprogramming) ==="
puts "  %-24s %6s %6s  %s" % ["gem", "sole", "reach", "failure-type"]
rows.select { |r| r[4] == "compiler" }.sort_by { |r| -r[1] }.first(30).each do |b, s, rch, t, _, _|
  puts "  %-24s %6d %6d  %s" % [b, s, rch, t]
end
