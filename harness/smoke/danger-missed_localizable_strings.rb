# frozen_string_literal: true

# Stub Danger::Plugin before any require so it is available when
# missed_localizable_strings/plugin.rb is loaded (even in harness --full mode
# where require_relative lines are prepended before the smoke body).
BEGIN {
  module Danger
    class Plugin
      def markdown(msg)
        @_markdown_output = msg
      end
      def _markdown_output; @_markdown_output; end
    end
  end
}

require 'danger_missed_localizable_strings'
require 'danger_plugin'

plugin = Danger::DangerMissedLocalizableStrings.new

# --- Test 1: localizable_strings_missed_entries detects missing key ---
keys_by_file = {
  "en.lproj/Localizable.strings" => ['"login"', '"logout"', '"settings"'],
  "fr.lproj/Localizable.strings" => ['"login"', '"settings"']
}
missed = plugin.send(:localizable_strings_missed_entries, keys_by_file)
puts "missed_count=#{missed.size}"
missed.each { |e| puts "file=#{e['file']} key=#{e['key']}" }

# --- Test 2: print_missed_entries produces markdown table ---
plugin.send(:print_missed_entries, missed)
out = plugin._markdown_output
puts "has_table_header=#{out.include?('| File | Key |')}"
puts "has_logout=#{out.include?('logout')}"
puts "has_fr=#{out.include?('fr.lproj')}"

# --- Test 3: no missed entries when keys match ---
same = {
  "en.lproj/Localizable.strings" => ['"home"', '"profile"'],
  "de.lproj/Localizable.strings" => ['"home"', '"profile"']
}
puts "no_missed=#{plugin.send(:localizable_strings_missed_entries, same).empty?}"

# --- Test 4: extract_keys_from_files parses and filters a real file ---
require 'tmpdir'
Dir.mktmpdir do |dir|
  path = File.join(dir, "Localizable.strings")
  File.write(path, <<~STRINGS)
    /* Comment block */
    // inline comment
    "greeting" = "Hello";
    "farewell" = "Goodbye";

    "thanks" = "Thank you";
  STRINGS
  result = plugin.send(:extract_keys_from_files, [path])
  keys = result[path]
  puts "extracted_count=#{keys.size}"
  puts "has_greeting=#{keys.any? { |k| k.include?('greeting') }}"
  puts "has_farewell=#{keys.any? { |k| k.include?('farewell') }}"
  puts "no_comments=#{keys.none? { |k| k.start_with?('/*') || k.start_with?('//') }}"
end

puts "version=#{MissedLocalizableStrings::VERSION}"
