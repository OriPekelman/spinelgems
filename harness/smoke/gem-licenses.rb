require 'gem-licenses'

# 1. VERSION constant
puts Gem::GemLicenses::VERSION

# 2. LICENSE_REFERENCES constant — verify count and that regexes match expected strings
refs = Gem::Specification::LICENSE_REFERENCES
puts refs.size

sample_lines = [
  "released under the MIT license",
  "same license as Ruby",
  "MIT License, see LICENSE",
  "MIT license",
  "(the Apache License)",
  "license: MIT",
  "License: Apache 2.0",
  "Same as Ruby",
  "license of Ruby"
]

sample_lines.each do |line|
  matched = refs.any? { |r| r.match(line) }
  puts "#{line}: #{matched}"
end

# 3. normalize_text — pure string normalization logic
[
  "Hello, World!",
  "MIT  License\n\nSome   text.",
  "  leading and trailing  ",
  "CamelCase-With_Punct!",
].each do |txt|
  puts Gem::Specification.normalize_text(txt).inspect
end

# 4. Gem.licenses — uses Gem.loaded_specs (rubygems runtime)
#    The result varies by environment, so just verify it returns a Hash
licenses_hash = Gem.licenses
puts licenses_hash.class

# 5. Exercise the config.yml mapping explicitly: simulate what Gem.licenses does
#    Find config.yml relative to gem_licenses.rb load path
gem_licenses_rb = $LOAD_PATH.map { |lp| File.join(lp, 'gem_licenses.rb') }.find { |p| File.exist?(p) }
config_path = if gem_licenses_rb
  File.expand_path('../../lib/licenses/config.yml', gem_licenses_rb)
else
  # Fallback: search known location
  File.expand_path('../licenses/config.yml', __FILE__)
end

if File.exist?(config_path)
  config = YAML.safe_load(File.read(config_path))
  [
    ['mit',         'MIT'],
    ['apache-2.0',  'Apache 2.0'],
    ['gpl-2.0+',    'GPLv2'],
    ['bsd',         'BSD'],
    ['unknown_xyz', nil],
  ].each do |key, expected|
    result = config[key]
    puts "#{key} => #{result.inspect} (ok: #{result == expected})"
  end
else
  puts "config not found at #{config_path}"
end
