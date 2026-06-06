require 'timewizard'
require 'timewizard/utils/wizardry'

# Exercise VERSION constant
puts Timewizard::VERSION

# Exercise Wizardry.only_version with various inputs
wiz = Timewizard::Utils::Wizardry

puts wiz.only_version('1.2.3-alpha+build')
puts wiz.only_version('version 2.0.0 released')
puts wiz.only_version('foo 1.2.3.4 bar')
puts wiz.only_version('prefix-10.0.1 suffix')
puts wiz.only_version('no-digits-here').empty? ? 'empty' : 'nonempty'

begin
  wiz.only_version(nil)
  puts 'no error'
rescue ArgumentError => e
  puts "ArgumentError: #{e.message}"
end

# VERSION_REGEX is a public constant — check it matches expected strings
puts wiz::VERSION_REGEX.match?('3.14.159') ? 'regex-ok' : 'regex-fail'
