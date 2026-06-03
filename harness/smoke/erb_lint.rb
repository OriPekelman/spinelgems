# frozen_string_literal: true
# Smoke: erb_lint 0.9.0 — CachedOffense data object + Stats tracking.
# Both are pure-Ruby structs with no external gem dependencies.
# NOTE: --full harness loads all lib files; active_support/rubocop/better_html
# are required by several of them and must be installed for CRuby to pass.
require 'erb_lint'

# CachedOffense: construction from a symbol-keyed hash, then serialise.
co = ERBLint::CachedOffense.new(
  message: "Missing a trailing newline at the end of the file.",
  line_number: 42,
  severity: :convention,
  column: 0,
  simple_name: "FinalNewline",
  last_line: 42,
  last_column: 0,
  length: 0,
)
puts "message=#{co.message}"
puts "linter=#{co.simple_name}"
puts "line=#{co.line_number} col=#{co.column} len=#{co.length}"
puts "severity=#{co.severity.inspect}"

h = co.to_h
puts "to_h_keys=#{h.keys.sort.inspect}"
puts "to_h_message=#{h[:message]}"

# String-keyed construction exercises transform_keys(&:to_sym) path.
co2 = ERBLint::CachedOffense.new(
  "message" => "Extra newline detected.",
  "line_number" => 7,
  "severity" => "warning",
  "column" => 3,
  "simple_name" => "ExtraNewline",
  "last_line" => 7,
  "last_column" => 3,
  "length" => 1,
)
puts "co2_message=#{co2.message}"
puts "co2_severity=#{co2.severity.inspect}"
puts "co2_length=#{co2.length}"

# Stats: keyword construction and attribute access.
s = ERBLint::Stats.new(found: 3, corrected: 1, files: 8, linters: 5)
puts "found=#{s.found} corrected=#{s.corrected} files=#{s.files} linters=#{s.linters}"

# Stats: defaults (all zero).
s2 = ERBLint::Stats.new
puts "default_found=#{s2.found} default_ignored=#{s2.ignored}"

puts "version=#{ERBLint::VERSION}"
