# lefthook smoke — binary-wrapper gem; lib/lefthook.rb is empty (0 bytes).
# The only Ruby logic is the platform-detection in bin/lefthook.
# We reproduce and test that logic here with concrete inputs.

require 'lefthook'
require 'rubygems'

# --- platform detection (mirrors bin/lefthook) ---
platform = Gem::Platform.new(RUBY_PLATFORM)

cpu = platform.cpu.sub(/\Auniversal\./, '')
arch =
  case cpu
  when /\Aarm64/   then "arm64"
  when /aarch64/   then "arm64"
  when "x86_64"    then "x64"
  when "x64"       then "x64"
  else nil
  end

os =
  case platform.os
  when "linux"   then "linux"
  when "darwin"  then "darwin"
  when "windows" then "windows"
  when "mingw32" then "windows"
  when "mingw"   then "windows"
  when "freebsd" then "freebsd"
  when "openbsd" then "openbsd"
  else nil
  end

puts "os: #{os}"
puts "arch: #{arch}"
puts "binary: lefthook-#{os}-#{arch}" if arch && os

# Gem::Platform parsing exercises
{
  "x86_64-linux"   => ["x86_64", "linux"],
  "aarch64-linux"  => ["aarch64", "linux"],
  "x86_64-darwin"  => ["x86_64", "darwin"],
  "arm64-darwin"   => ["arm64", "darwin"],
}.each do |plat_str, (expected_cpu, expected_os)|
  p = Gem::Platform.new(plat_str)
  puts "#{plat_str}: cpu=#{p.cpu} os=#{p.os} ok=#{p.cpu == expected_cpu && p.os == expected_os}"
end

# String/regex operations used in the detection
["arm64e-darwin", "universal.arm64-darwin", "aarch64-linux", "x86_64-linux", "x64-mingw32"].each do |plat|
  raw_cpu = plat.split("-").first.sub(/\Auniversal\./, '')
  result = case raw_cpu
           when /\Aarm64/  then "arm64"
           when /aarch64/  then "arm64"
           when "x86_64"   then "x64"
           when "x64"      then "x64"
           else "unknown"
           end
  puts "#{plat} -> #{result}"
end

# Windows binary name has .exe suffix
["linux", "darwin", "windows"].each do |target_os|
  name = "lefthook-#{target_os}-arm64"
  name += ".exe" if target_os == "windows"
  puts "#{target_os}_binary: #{name}"
end
