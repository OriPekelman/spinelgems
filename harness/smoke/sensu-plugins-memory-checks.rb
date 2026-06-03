# frozen_string_literal: true

require 'sensu-plugins-memory-checks'

# Verify version constants
puts "VERSION: #{SensuPluginsMemoryChecks::Version::VER_STRING}"
puts "MAJOR=#{SensuPluginsMemoryChecks::Version::MAJOR} MINOR=#{SensuPluginsMemoryChecks::Version::MINOR} PATCH=#{SensuPluginsMemoryChecks::Version::PATCH}"

# Exercise the core meminfo parsing logic from metrics-memory.rb / metrics-memory-percent.rb.
# These classes live in bin/ and depend on sensu-plugin (not available), so we inline
# the pure-Ruby parsing + arithmetic here with a deterministic fake /proc/meminfo string.

FAKE_MEMINFO = <<~MEMINFO
  MemTotal:       16384000 kB
  MemFree:         2048000 kB
  MemAvailable:    4096000 kB
  Buffers:          512000 kB
  Cached:          3072000 kB
  SwapTotal:       4096000 kB
  SwapFree:        3276800 kB
  Dirty:             10240 kB
MEMINFO

def parse_meminfo(text)
  mem = {}
  text.each_line do |line|
    mem['total']     = line.split(/\s+/)[1].to_i * 1024 if line =~ /^MemTotal/
    mem['free']      = line.split(/\s+/)[1].to_i * 1024 if line =~ /^MemFree/
    mem['buffers']   = line.split(/\s+/)[1].to_i * 1024 if line =~ /^Buffers/
    mem['cached']    = line.split(/\s+/)[1].to_i * 1024 if line =~ /^Cached/
    mem['swapTotal'] = line.split(/\s+/)[1].to_i * 1024 if line =~ /^SwapTotal/
    mem['swapFree']  = line.split(/\s+/)[1].to_i * 1024 if line =~ /^SwapFree/
    mem['dirty']     = line.split(/\s+/)[1].to_i * 1024 if line =~ /^Dirty/
    mem['available'] = line.split(/\s+/)[1].to_i * 1024 if line =~ /^MemAvailable/
  end

  mem['swapUsed'] = mem['swapTotal'] - mem['swapFree']
  mem['used']     = mem['total'] - mem['free']

  if mem.key?('available')
    mem['usedWOBuffersCaches'] = mem['total'] - mem['available']
    mem['freeWOBuffersCaches'] = mem['available']
  else
    mem['usedWOBuffersCaches'] = mem['used'] - (mem['buffers'] + mem['cached'])
    mem['freeWOBuffersCaches'] = mem['free'] + (mem['buffers'] + mem['cached'])
  end

  mem['swapUsedPercentage'] = 100 * mem['swapUsed'] / mem['swapTotal'] if mem['swapTotal'].positive?
  mem
end

def compute_percentages(mem)
  memp = {}
  swptot = mem['swapTotal'].zero? ? 1 : mem['swapTotal']

  mem.each_key do |k|
    memp[k] = 100.0 * mem[k] / mem['total'] if k != 'total' && k !~ /swap/ && k != 'used'
    memp[k] = 100.0 * mem[k] / swptot       if k != 'swapTotal' && k =~ /swap/ && k != 'swapFree'
  end
  memp
end

mem = parse_meminfo(FAKE_MEMINFO)

# Print raw byte metrics (deterministic)
puts "total_bytes=#{mem['total']}"
puts "free_bytes=#{mem['free']}"
puts "used_bytes=#{mem['used']}"
puts "available_bytes=#{mem['available']}"
puts "swapTotal_bytes=#{mem['swapTotal']}"
puts "swapFree_bytes=#{mem['swapFree']}"
puts "swapUsed_bytes=#{mem['swapUsed']}"
puts "usedWOBuffersCaches_bytes=#{mem['usedWOBuffersCaches']}"
puts "freeWOBuffersCaches_bytes=#{mem['freeWOBuffersCaches']}"
puts "swapUsedPercentage=#{mem['swapUsedPercentage']}"

# Percentage metrics
memp = compute_percentages(mem)
sorted_keys = memp.keys.sort
sorted_keys.each do |k|
  puts "pct_#{k}=#{memp[k].round(4)}"
end
