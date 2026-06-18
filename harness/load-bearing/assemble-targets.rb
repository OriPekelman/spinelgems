#!/usr/bin/env ruby
# frozen_string_literal: true
# Assemble the site-facing targets.tsv from the upstream passes.
#
# blockers.tsv (from buildability.rb) carries the impact + failure-type per
# blocker; this joins on the extra columns the Load-bearing page renders:
#   - downloads   : popularity, from survey-193k/meta.jsonl
#   - verdict     : the blocker's OWN verdict, from compat.jsonl (rejected here)
#   - lib_files   : count of lib/**/*.rb in the cached gem (the "small lib -> PR"
#   - lib_loc     :   leverage signal); 0 when the gem isn't cached locally
#
# This used to be a one-off (catalog commit 662aac6); committing it makes the
# Load-bearing refresh reproducible: build-graph.sh -> buildability.rb ->
# assemble-targets.rb -> `build-load-bearing`.
#
#   assemble-targets.rb [BLOCKERS_TSV] [META_JSONL] [COMPAT_JSONL] > targets.tsv
require "json"

here     = __dir__
blockers = ARGV[0] || File.join(here, "blockers.tsv")
meta     = ARGV[1] || File.expand_path("../../survey-193k/meta.jsonl", here)
compat   = ARGV[2] || File.expand_path("../../survey-193k/compat.jsonl", here)
cache    = ENV["SPINEL_GEM_CACHE"] || "/srv/data/scratch/spinel-compat-cache/gems"

# blocker gems we need to annotate
rows = File.readlines(blockers)[1..].map { |l| l.chomp.split("\t") }
want = rows.map { |r| r[0] }.to_h { |g| [g, true] }

downloads = Hash.new(0)
File.foreach(meta) do |l|
  r = JSON.parse(l) rescue next
  g = r["gem"]; next unless want[g]
  downloads[g] = r["downloads"].to_i if r["downloads"].to_i > downloads[g]
end

rank = { "rejected" => 0, "risky" => 1, "clean" => 2, "loaded" => 3, "verified" => 4 }
verdict = {}
File.foreach(compat) do |l|
  r = JSON.parse(l) rescue next
  g = r["gem"]; next unless want[g]
  v = r["verdict"]
  verdict[g] = v if verdict[g].nil? || rank[v].to_i > rank[verdict[g]].to_i
end

# lib_files / lib_loc from the most recent cached version of each blocker.
def lib_stats(cache, gem)
  dir = Dir[File.join(cache, "#{gem}-*")].max_by { |d| File.basename(d) }
  return [0, 0] unless dir && File.directory?(File.join(dir, "lib"))
  files = Dir[File.join(dir, "lib", "**", "*.rb")]
  loc = files.sum { |f| File.foreach(f).count { |ln| ln !~ /\A\s*(#|\z)/ } rescue 0 }
  [files.size, loc]
end

puts %w[gem sole_impact reach_impact transit_loadbearing downloads verdict
        failure_type achievability lib_files lib_loc].join("\t")
rows.sort_by { |r| -r[1].to_i }.each do |r|
  gem, sole, reach, ftype, achiev, transit = r
  files, loc = lib_stats(cache, gem)
  puts [gem, sole, reach, transit, downloads[gem], verdict[gem] || "rejected",
        ftype, achiev, files, loc].join("\t")
end
