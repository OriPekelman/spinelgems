# pessimize smoke — exercises Gemfile token parsing + VersionMapper
# The verifier harness is placed at the gem root; require_relative paths
# are relative to the gem root (pessimize-0.5.0/).
# Spinel inlines require_relative, so all these compile; plain require
# to external gems (bundler, optimist) stays off to keep it self-contained.

require_relative 'lib/pessimize/version'
require_relative 'lib/pessimize/gem'
require_relative 'lib/pessimize/gemfile'
require_relative 'lib/pessimize/version_mapper'

# Exercise Gemfile parsing (stdlib Ripper, no external deps)
gemfile_contents = <<~GEMFILE
  source 'https://rubygems.org'

  gem 'rails'
  gem 'rack', '2.0.1'
  gem 'puma', '~> 5.0'
GEMFILE

gemfile = Pessimize::Gemfile.new(gemfile_contents)
puts "Gem count: #{gemfile.gems.length}"
gemfile.gems.each do |g|
  puts "  gem: #{g.name}, version: #{g.version.inspect}"
end

# Exercise VersionMapper with patch constraint
versions = { 'rails' => '7.1.3', 'rack' => '3.0.8', 'puma' => '6.4.2' }
Pessimize::VersionMapper.new.call(gemfile.gems, versions, 'patch')

puts "After patch mapping:"
gemfile.gems.each do |g|
  puts "  #{g.name}: #{g.version}"
end

# Re-parse and apply minor constraint
gemfile2 = Pessimize::Gemfile.new(gemfile_contents)
Pessimize::VersionMapper.new.call(gemfile2.gems, versions, 'minor')

puts "After minor mapping:"
gemfile2.gems.each do |g|
  puts "  #{g.name}: #{g.version}"
end

# Gemfile reconstruction: tokens round-trip
puts "Reconstructed:"
puts gemfile2.to_s.strip

puts "VERSION: #{Pessimize::VERSION}"
