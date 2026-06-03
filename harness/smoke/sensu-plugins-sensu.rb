# frozen_string_literal: true

# Smoke test for sensu-plugins-sensu 5.0.0
#
# The gem lib only contains SensuPluginsSensu::Version constants.
# lib/sensu-plugins-sensu.rb loads lib/sensu-plugins-sensu/version.rb via a
# plain `require` (not require_relative), so Spinel cannot resolve it — the
# constants will be undeclared under Spinel even when the harness inlines the
# entrypoint with require_relative.
#
# The bin/handler-sensu.rb provides the only real logic (parse_remediations):
# regex + range matching for Sensu remediation scheduling. We test it here
# inline. The hash structure (string → {string → mixed array}) causes Spinel
# to infer StrPolyHash instead of StrStrHash, producing build errors.

require 'sensu-plugins-sensu'

# --- Version constants (available if Spinel can inline the require chain) ---
puts "ver=#{SensuPluginsSensu::Version::VER_STRING}"
puts "major=#{SensuPluginsSensu::Version::MAJOR}"

# --- parse_remediations: occurrence-matching logic from bin/handler-sensu.rb ---
# Input: remediations hash, occurrence count, severity integer
# Output: sorted array of matching remediation check names
def parse_remediations(remediations, occurrences, severity)
  triggered = []
  remediations.each do |check, conditions|
    next unless (conditions['severities'] || []).include?(severity)
    fire = false
    (conditions['occurrences'] || []).each do |val|
      fire = if val.is_a?(Integer) && occurrences == val
               true
             elsif val.to_s =~ /^\d+$/ && occurrences == val.to_s.to_i
               true
             elsif val.to_s =~ /^(\d+)-(\d+)$/
               occurrences >= $~[1].to_i && occurrences <= $~[2].to_i
             elsif val.to_s =~ /^(\d+)\+$/
               occurrences >= $~[1].to_i
             else
               false
             end
      break if fire
    end
    triggered << check if fire
  end
  triggered
end

rems = {
  'light'  => { 'occurrences' => ['1', '2'], 'severities' => [1] },
  'medium' => { 'occurrences' => ['3-10'],   'severities' => [1] },
  'heavy'  => { 'occurrences' => ['1+'],     'severities' => [2] },
}

puts parse_remediations(rems, 1, 1).sort.inspect    # ["light"]
puts parse_remediations(rems, 2, 1).sort.inspect    # ["light"]
puts parse_remediations(rems, 5, 1).sort.inspect    # ["medium"]
puts parse_remediations(rems, 11, 1).sort.inspect   # []
puts parse_remediations(rems, 100, 2).sort.inspect  # ["heavy"]
puts parse_remediations(rems, 0, 2).sort.inspect    # []
puts "done"
