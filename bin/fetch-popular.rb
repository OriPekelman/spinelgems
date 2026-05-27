#!/usr/bin/env ruby
# Build a *popularity-ordered* gem list from the bestgems.org total-downloads
# ranking — the input for a survey that probes the gems people actually use,
# most-downloaded first (vs fetch-gem-list.rb's name-keyed random sample).
#
#   bin/fetch-popular.rb [--top N] [--out FILE]
#
# bestgems.org paginates the ranking 20/page; rubygems.org's own /stats ignores
# ?page= (returns only the top ~10), which is why we use bestgems here.
require "net/http"
require "uri"

opts = { top: 1000, out: nil }
until ARGV.empty?
  case (a = ARGV.shift)
  when "--top" then opts[:top] = ARGV.shift.to_i
  when "--out" then opts[:out] = ARGV.shift
  else abort "unknown arg: #{a}"
  end
end

PER = 20
pages = (opts[:top].to_f / PER).ceil
names = []
seen = {}

pages.times do |i|
  page = i + 1
  body = Net::HTTP.get(URI("https://bestgems.org/total?page=#{page}"))
  body.scan(%r{/gems/([a-zA-Z0-9_.-]+)}).flatten.each do |n|
    next if seen[n]

    seen[n] = true
    names << n
  end
  warn "[fetch-popular] page #{page}/#{pages} (#{names.size} gems)"
  break if names.size >= opts[:top]

  sleep 0.1 # be polite
end

names = names.first(opts[:top])
io = opts[:out] ? File.open(opts[:out], "w") : $stdout
names.each { |n| io.puts n }
io.close if opts[:out]
warn "[fetch-popular] #{names.size} gems#{opts[:out] ? " -> #{opts[:out]}" : ''}"
