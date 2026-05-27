#!/usr/bin/env ruby
# Extract per-gem metadata from a rubygems.org PostgreSQL dump in one streaming
# pass — downloads, latest version + release date, and description — for ALL
# indexed gems, into a meta.jsonl (same shape as the enricher's). This is the
# offline, no-network alternative to per-gem rubygems.org API calls.
#
#   tar -xOf public_postgresql.tar public_postgresql/databases/PostgreSQL.sql.gz \
#     | zcat | bin/dump-meta.rb > meta.jsonl
#   # or:  zcat .../PostgreSQL.sql.gz | bin/dump-meta.rb --out meta.jsonl
#
# Reads three COPY blocks: rubygems (id→name, indexed only), gem_downloads
# (rubygem_id→total via the version_id=0 row), versions (latest='t' → number,
# created_at, description/summary; ruby platform preferred over native variants).
require "json"

out_path = (i = ARGV.index("--out")) ? ARGV[i + 1] : nil

names = {}            # rubygem_id => name
dl = Hash.new(0)      # rubygem_id => total downloads
ver = {}              # rubygem_id => { num:, created:, desc:, plat: }
cur = nil

# Unescape a PostgreSQL COPY text-format field (\n \t \r \\ ...; \N = NULL).
def unesc(s)
  return nil if s == "\\N"

  s.gsub(/\\(.)/) { { "n" => " ", "t" => " ", "r" => "" }.fetch(::Regexp.last_match(1), ::Regexp.last_match(1)) }
end

STDIN.each_line do |l|
  if l =~ /^COPY (\S+) \(/
    cur = Regexp.last_match(1)
    next
  end

  case cur
  when "public.rubygems"
    if l.start_with?("\\.") then cur = nil; next end

    f = l.split("\t")
    names[f[0]] = f[1] if f[4] == "t" # indexed
  when "public.gem_downloads"
    if l.start_with?("\\.") then cur = nil; next end

    f = l.split("\t")
    dl[f[1]] = f[3].to_i if f[2] == "0" # the per-gem total row
  when "public.versions"
    if l.start_with?("\\.") then cur = nil; next end

    f = l.split("\t")
    next unless f[13] == "t" # latest

    rid = f[4]
    cand = { num: f[3], created: f[9], desc: (unesc(f[2]) || unesc(f[7])), plat: f[8] }
    prev = ver[rid]
    # Prefer the ruby-platform row over native variants (java, x86_64-*, …).
    ver[rid] = cand if prev.nil? || (f[8] == "ruby" && prev[:plat] != "ruby")
  end
end

io = out_path ? File.open(out_path, "w") : $stdout
names.each do |id, name|
  v = ver[id]
  io.puts JSON.generate(
    "gem" => name, "downloads" => dl[id],
    "info" => v && v[:desc], "version" => v && v[:num],
    "updated" => (v && v[:created] && v[:created][0, 10])
  )
end
io.close if out_path
warn "[dump-meta] #{names.size} gems#{out_path ? " -> #{out_path}" : ''}"
