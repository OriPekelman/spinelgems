require 'pupcap'
require 'pupcap/version'
require 'pupcap/lsb_release'

# --- VERSION class ---
v = Pupcap::VERSION
puts "version: #{v.to_s}"
puts "major: #{v::MAJOR}"
puts "minor: #{v::MINOR}"
puts "patch: #{v::PATCH}"

# verify the to_s matches the individual constants
expected = "#{v::MAJOR}.#{v::MINOR}.#{v::PATCH}"
puts "to_s matches parts: #{v.to_s == expected}"

# --- LsbRelease with a mock capistrano handle ---
mock_cap = Object.new

def mock_cap.capture(cmd)
  case cmd
  when /lsb_release -i/
    "Distributor ID:\tDebian"
  when /lsb_release -c/
    "Codename:\tbullseye"
  else
    ":"
  end
end

lsb = Pupcap::LsbRelease.new(mock_cap)
puts "lsb class: #{lsb.class}"
puts "distro name: #{lsb.name}"
puts "codename: #{lsb.codename}"
puts "name memoized: #{lsb.name == lsb.name}"
