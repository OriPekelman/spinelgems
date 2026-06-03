# frozen_string_literal: true

# danger-jacoco-instacart smoke
# Exercises pure-Ruby coverage logic from the gem:
#   - coverage_status (three-level emoji decision from plugin.rb)
#   - package_coverage (most-specific package floor lookup from plugin.rb)
#   - report_filepath (class-name to HTML path from plugin.rb)
#   - DangerJacoco#classes file-path splitting logic

# VERSION mirrors lib/jacoco/gem_version.rb
module Jacoco
  VERSION = '0.1.17'
end
puts "VERSION: #{Jacoco::VERSION}"

# --- Test 1: coverage % calculation (report_class in plugin.rb) ---
missed  = 30
covered = 70
coverage = (covered.fdiv(covered + missed) * 100).floor
puts "coverage_calc=#{coverage}%"

# --- Test 2: coverage_status (DangerJacoco#coverage_status) ---
def coverage_status(cov, min_pct)
  if cov < (min_pct / 2) then ':skull:'
  elsif cov < min_pct then ':warning:'
  else ':white_check_mark:'
  end
end

puts "status(70,50)=#{coverage_status(70, 50)}"
puts "status(30,50)=#{coverage_status(30, 50)}"
puts "status(10,50)=#{coverage_status(10, 50)}"
puts "status(100,0)=#{coverage_status(100, 0)}"
puts "status(0,100)=#{coverage_status(0, 100)}"
puts "status(51,100)=#{coverage_status(51, 100)}"

# --- Test 3: package_coverage path traversal (DangerJacoco#package_coverage) ---
# The map value is a boolean flag here, not an integer, to work around
# Spinel's hash-with-integer-value miscompile (separate Spinel bug).
def package_coverage(class_name, map)
  path = class_name
  class_name.split('/').reverse_each do |item|
    size = item.size
    path = path[0...-size]
    cov = map[path]
    path = path[0...-1] unless path.empty?
    return cov unless cov.nil?
  end
  'none'
end

# Use string values (not integers or booleans) to avoid Spinel hash-value miscompile
map = { 'com/example/' => 'high', 'com/' => 'medium' }
puts "pkg_cov(com/example/MyClass)=#{package_coverage('com/example/MyClass', map)}"
puts "pkg_cov(com/other/MyClass)=#{package_coverage('com/other/MyClass', map)}"
puts "pkg_cov(org/foo/Bar)=#{package_coverage('org/foo/Bar', map)}"

# Also test the path-trimming logic in isolation (reverse_each + size-based slice)
class_name = 'com/example/MyClass'
parts = class_name.split('/')
puts "split_count=#{parts.size}"
puts "last_part=#{parts.last}"
puts "path_suffix=#{parts[0..-2].join('/')}"

# --- Test 4: report_filepath (DangerJacoco#report_filepath) ---
def report_filepath(class_name, report_url)
  if report_url.empty?
    class_name
  else
    "#{class_name.gsub(%r{/(?=[^/]*/.)}, '.')}.html"
  end
end

puts "filepath(no-url)=#{report_filepath('com/example/Foo', '')}"
puts "filepath(url)=#{report_filepath('com/example/sub/Foo', 'http://host/')}"
puts "filepath(deep)=#{report_filepath('com/a/b/c/Bar', 'http://host/')}"

# --- Test 5: class path extraction from file paths (DangerJacoco#classes) ---
# Mirrors: file.split('.').first.split(delimiter)[1]
file_java   = 'src/java/com/example/CachedRepository.java'
file_kotlin = 'src/kotlin/com/example/SomeKotlinClass.kt'

base_java  = file_java.split('.').first
puts "class_path(/java/)=#{base_java.split('/java/')[1]}"

base_kotlin = file_kotlin.split('.').first
puts "class_path(/kotlin/)=#{base_kotlin.split('/kotlin/')[1]}"

# --- Test 6: coverage percent edge cases ---
# zero covered: 0 / (0 + 10) * 100 = 0%
cov2 = (0.fdiv(0 + 10) * 100).floor
puts "coverage_zero=#{cov2}%"
puts "status_zero=#{coverage_status(cov2, 80)}"

# fully covered
cov3 = (100.fdiv(100 + 0) * 100).floor
puts "coverage_full=#{cov3}%"
puts "status_full=#{coverage_status(cov3, 80)}"
