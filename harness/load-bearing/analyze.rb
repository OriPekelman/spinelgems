#!/usr/bin/env ruby
# Rank gems by how *load-bearing* they are: transitive in-degree — the number of
# distinct gems that pull a gem in directly OR through a dependency-of-a-
# dependency chain ("turtles all the way down"). Direct in-degree (the usual
# "most depended-upon") is reported alongside; the gap between them is the point
# — a tiny gem with few direct dependents can be deeply load-bearing.
#
#   analyze.rb EDGES_TSV [COMPAT_JSONL]
#     EDGES_TSV     : "<gem>\t<dep>" per line (empty <dep> = a known dep-less gem)
#     COMPAT_JSONL  : optional; annotates each gem with its Spinel verdict
#   -> stdout: "<gem>\t<transitive>\t<direct>\t<verdict>" sorted by transitive desc
require "json"

edges_path = ARGV[0] or abort "usage: analyze.rb EDGES_TSV [COMPAT_JSONL]"
compat_path = ARGV[1]

id = {}
rev = Hash.new { |h, k| h[k] = [] }   # dep_id -> [dependent_id...]
direct = Hash.new(0)                  # dep_name -> distinct direct dependents
File.foreach(edges_path) do |line|
  s, d = line.chomp.split("\t", 2)
  next if d.nil? || d.empty?
  sid = (id[s] ||= id.size)
  did = (id[d] ||= id.size)
  rev[did] << sid
  direct[d] += 1
end

# Transitive in-degree via reverse-reachability. Computed for the top-K by direct
# in-degree — the most load-bearing gems are necessarily well-depended-on, so this
# captures the head of the distribution without an all-pairs traversal.
topK = direct.sort_by { |_, v| -v }.first(1000).map(&:first)
seen = Array.new(id.size, 0)
gen = 0
trans = {}
topK.each do |g|
  gen += 1
  start = id[g]
  seen[start] = gen
  stack = rev[start].dup
  cnt = 0
  until stack.empty?
    n = stack.pop
    next if seen[n] == gen
    seen[n] = gen
    cnt += 1
    rev[n]&.each { |m| stack << m if seen[m] != gen }
  end
  trans[g] = cnt
end

verd = {}
if compat_path && File.exist?(compat_path)
  rank = { "rejected" => 0, "risky" => 1, "clean" => 2, "loaded" => 3, "verified" => 4 }
  File.foreach(compat_path) do |l|
    r = JSON.parse(l) rescue next
    g = r["gem"]; v = r["verdict"]
    verd[g] = v if !verd[g] || rank[v].to_i > rank[verd[g]].to_i
  end
end

trans.sort_by { |_, t| -t }.each do |g, t|
  puts "#{g}\t#{t}\t#{direct[g]}\t#{verd[g]}"
end
