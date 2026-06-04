# frozen_string_literal: true

# Smoke test for danger-jacoco (instacart fork)
# Exercises: VERSION, SAXParser event-driven parsing, Counter model,
# coverage_status logic, and package_coverage lookup.
#
# Spinel ignores cross-gem requires (happymapper, nokogiri, danger).
# We pre-stub them so CRuby also runs clean without those native gems installed.

# Pre-stub external gems so require calls are no-ops
%w[happymapper nokogiri].each do |g|
  $LOADED_FEATURES << "#{g}.rb"
end

# Minimal HappyMapper stub — generates real attr_accessors from DSL calls
module HappyMapper
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def tag(_t); end

    def attribute(name, _type, _opts = {})
      attr_accessor name
    end

    def has_many(name, _klass, _opts = {})
      attr_accessor name
    end
  end
end

# Minimal Nokogiri stub (SAX parser superclass)
module Nokogiri
  module XML
    module SAX
      class Document; end

      class Parser
        def initialize(_doc); end
      end
    end
  end
end

# Minimal Danger::Plugin stub
module Danger
  class Plugin
    def self.instance_name
      'danger_jacoco'
    end

    def self.inherited(_base); end
  end
end

require 'danger_jacoco'
require 'jacoco/model/counter'
require 'jacoco/model/class'
require 'jacoco/sax_parser'
require 'jacoco/plugin'

# 1. VERSION constant
puts "version:#{Jacoco::VERSION}"

# 2. Jacoco::Counter model — create and inspect
c = Jacoco::Counter.new
c.type    = 'INSTRUCTION'
c.missed  = 20
c.covered = 80
puts "counter:#{c.type}:missed=#{c.missed}:covered=#{c.covered}"

# 3. SAXParser: event-driven parse of a synthetic class element
parser = Jacoco::SAXParser.new(%w[com/example/Repo com/example/Service])
puts "sax_class_names:#{parser.class_names.sort.join(',')}"

# Push class 'com/example/Repo' with an INSTRUCTION counter
parser.start_element('class', [['name', 'com/example/Repo']])
parser.start_element('counter', [['type', 'INSTRUCTION'], ['missed', '15'], ['covered', '85']])
parser.end_element('counter')
parser.end_element('class')

# Push class 'com/other/Unknown' — not in class_names so should be ignored
parser.start_element('class', [['name', 'com/other/Unknown']])
parser.start_element('counter', [['type', 'INSTRUCTION'], ['missed', '5'], ['covered', '5']])
parser.end_element('counter')
parser.end_element('class')

puts "sax_parsed_count:#{parser.classes.size}"
cls = parser.classes.first
puts "sax_class:#{cls.name}"
puts "sax_counter:#{cls.counters.first.type}:missed=#{cls.counters.first.missed}:covered=#{cls.counters.first.covered}"

# 4. Coverage percentage calculation (as used in DangerJacoco#report_class)
counter = cls.counters.first
coverage = (counter.covered.fdiv(counter.covered + counter.missed) * 100).floor
puts "coverage_pct:#{coverage}"

# 5. coverage_status logic (pure method from DangerJacoco, tested inline)
def coverage_status(coverage, minimum_percentage)
  if coverage < (minimum_percentage / 2)
    ':skull:'
  elsif coverage < minimum_percentage
    ':warning:'
  else
    ':white_check_mark:'
  end
end

puts "status_above:#{coverage_status(85, 60)}"    # 85 >= 60  => :white_check_mark:
puts "status_warn:#{coverage_status(40, 60)}"     # 40 < 60 but >= 30 => :warning:
puts "status_skull:#{coverage_status(10, 60)}"    # 10 < 30 => :skull:

# 6. package_coverage lookup (pure method from DangerJacoco, tested inline)
pkg_map = { 'com/example/' => 75, 'com/' => 50 }

def package_coverage(class_name, pkg_map)
  path = class_name
  class_name.split('/').reverse_each do |item|
    size = item.size
    path = path[0...-size]
    coverage = pkg_map[path]
    path = path[0...-1] unless path.empty?
    return coverage unless coverage.nil?
  end
  nil
end

puts "pkg_cov_example:#{package_coverage('com/example/Repo', pkg_map)}"   # 75
puts "pkg_cov_other:#{package_coverage('com/other/Widget', pkg_map)}"     # 50
puts "pkg_cov_none:#{package_coverage('io/foo/Bar', pkg_map).inspect}"    # nil

# 7. DangerJacoco class is defined
puts "plugin_class:#{Danger::DangerJacoco.name}"

# 8. filtered_files_to_check logic (pure - tested inline)
files = %w[src/main/java/com/A.java src/main/kotlin/com/B.kt src/main/java/com/C.xml ignored.rb]
extensions = ['.kt', '.java']
filtered = files.select { |f| extensions.any? { |e| f.end_with?(e) } }
puts "filtered_files:#{filtered.sort.join(',')}"
