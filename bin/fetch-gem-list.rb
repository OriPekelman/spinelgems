#!/usr/bin/env ruby
# Produce a gem-name list for `spinel-compat survey`, pulled from rubygems.org.
#
#   bin/fetch-gem-list.rb [--sample N | --limit N] [--out FILE]
#
# Source: the Compact Index `/names` endpoint — the authoritative list of every
# gem on rubygems.org (~193k). `--sample N` takes a uniform random sample (a
# representative wholesale review without probing all of them); `--limit N`
# takes the first N. No arg = the whole list.
#
# NOTE: this is name-keyed, not download-ranked. Ranking by popularity needs the
# rubygems.org data dump (https://rubygems.org/pages/data) — heavier, and best
# run where the survey runs (gx10). Left as a follow-up; a full or sampled
# wholesale review is more comprehensive than a top-N anyway.
require "net/http"
require "uri"

NAMES_URL = "https://index.rubygems.org/names"

opts = { mode: :all, n: nil, out: nil }
until ARGV.empty?
  case (a = ARGV.shift)
  when "--sample" then opts[:mode] = :sample; opts[:n] = ARGV.shift.to_i
  when "--limit"  then opts[:mode] = :limit;  opts[:n] = ARGV.shift.to_i
  when "--out"    then opts[:out] = ARGV.shift
  else abort "unknown arg: #{a}"
  end
end

body = Net::HTTP.get(URI(NAMES_URL))
names = body.lines.map(&:strip).reject { |l| l.empty? || l == "---" }

names = case opts[:mode]
        when :sample then names.sample(opts[:n])
        when :limit  then names.first(opts[:n])
        else names
        end

out = opts[:out] ? File.open(opts[:out], "w") : $stdout
names.each { |n| out.puts(n) }
out.close if opts[:out]
warn "[fetch-gem-list] #{names.size} gems#{opts[:out] ? " -> #{opts[:out]}" : ''}"
