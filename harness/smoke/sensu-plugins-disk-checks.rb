# frozen_string_literal: true

# sensu-plugins-disk-checks smoke
# The gem's lib/ only exports the Version module; real logic lives in bin/
# scripts but depends on sensu-plugin + sys-filesystem (unavailable).
# We smoke the Version module (the actual public lib API) plus inline the
# pure-computation helpers from bin/check-disk-usage.rb which have no
# external deps, to prove Spinel handles the arithmetic and formatting logic.

require 'sensu-plugins-disk-checks'

# --- Version constants ---
puts SensuPluginsDiskChecks::Version::VER_STRING
puts "#{SensuPluginsDiskChecks::Version::MAJOR}.#{SensuPluginsDiskChecks::Version::MINOR}.#{SensuPluginsDiskChecks::Version::PATCH}"

# --- Pure logic extracted from bin/check-disk-usage.rb (no external deps) ---
# to_human: converts bytes to human-readable string
def to_human(size)
  unit = [
    [1_099_511_627_776, 'TiB'],
    [1_073_741_824,     'GiB'],
    [1_048_576,         'MiB'],
    [1024,              'KiB'],
    [0,                 'B']
  ].detect { |u| size >= u[0] }
  format("%.2f #{unit[1]}", (size >= 1024 ? size.to_f / unit[0] : size))
end

# adj_percent: magic-factor threshold adjustment
def adj_percent(size, percent, normal: 20.0, magic: 1.0)
  hsize = (size / (1024.0 * 1024.0)) / normal
  felt  = hsize**magic
  scale = felt / hsize
  100 - ((100 - percent) * scale)
end

# percent_bytes: used bytes as percentage of total
def percent_bytes(bytes_used, bytes_free, bytes_total, ignore_reserved: false, bytes_available: nil)
  if ignore_reserved
    u100 = bytes_used * 100.0
    nonroot_total = bytes_used + bytes_available.to_i
    nonroot_total.zero? ? 0 : (u100 / nonroot_total + (u100 % nonroot_total != 0 ? 1 : 0)).round(2)
  else
    (100.0 - (100.0 * bytes_free / bytes_total)).round(2)
  end
end

# percent_inodes: used inodes as percentage of total
def percent_inodes(inodes_free, inodes_total)
  (100.0 - (100.0 * inodes_free / inodes_total)).round(2)
end

# Exercise to_human with a variety of sizes
puts to_human(512)
puts to_human(2048)
puts to_human(1_500_000)
puts to_human(2_000_000_000)
puts to_human(5_000_000_000_000)

# Exercise adj_percent (magic=1.0 → scale=1, so result == percent; magic!=1 adjusts)
puts adj_percent(20 * 1024 * 1024, 85).round(4)     # normal size, magic=1 → 85.0
puts adj_percent(200 * 1024 * 1024, 85, magic: 0.9).round(4)  # larger fs → threshold raised

# Exercise percent_bytes
puts percent_bytes(8_000_000_000, 2_000_000_000, 10_000_000_000)
puts percent_bytes(500_000_000, 500_000_000, 1_000_000_000, ignore_reserved: true, bytes_available: 500_000_000)

# Exercise percent_inodes
puts percent_inodes(1_500_000, 2_000_000)
puts percent_inodes(0, 1_000_000)
