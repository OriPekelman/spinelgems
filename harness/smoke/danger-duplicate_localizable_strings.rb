require_relative "lib/duplicate_localizable_strings/gem_version"

puts DuplicateLocalizableStrings::VERSION

# Simulate print_duplicate_entries logic (pure string operations)
entries = [
  { 'file' => 'en.lproj/Localizable.strings', 'key' => '"greeting"' },
  { 'file' => 'fr.lproj/Localizable.strings', 'key' => '"farewell"' }
]

message = "#### Found duplicate entries in Localizable.strings files \n\n"
message << "| File | Key |\n"
message << "| ---- | --- |\n"
entries.each do |entry|
  file = entry['file']
  key = entry['key']
  message << "| #{file} | #{key} | \n"
end

puts message
