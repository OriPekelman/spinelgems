require 'manageiq-style'

# 1. Version and Error class
puts ManageIQ::Style::VERSION

err = ManageIQ::Style::Error.new("test error")
puts err.message
puts err.is_a?(StandardError)

# 2. Exercise CLI#format_gem_source_lines! (pure string manipulation, no external deps)
#    Instantiate CLI bypassing parse_cli_options by passing options directly
cli = ManageIQ::Style::CLI.new({install: false})

# Call private method directly — exercises the real gem formatting logic
lines = [
  "  gem 'rubocop', '~> 1.0'\n",
  "  gem 'manageiq-style'\n",
  "  gem 'rake'\n",
]
result = cli.send(:format_gem_source_lines!, lines)
puts result.length
result.each { |l| puts l.strip }

# 3. Test Gemfile manipulation logic (pure string logic, no file I/O)
#    Exercise update_gemfile internal logic via string operations that mirror it
gemfile_content = <<~RUBY
  source "https://rubygems.org"

  group :development do
    gem "rake"
    gem "rubocop", :require => false
  end
RUBY

lines = gemfile_content.lines
# Find group line using include? (avoiding regex for Spinel compat)
group_index = lines.index { |l| l.include?("group") && l.include?(":development") }
puts "group_index found: #{!group_index.nil?}"
puts "group line: #{lines[group_index].strip}"

# 4. Test gemspec update logic — string detection
gemspec_content = <<~RUBY
  Gem::Specification.new do |spec|
    spec.name = "my-gem"
    spec.add_development_dependency "rake"
    spec.add_development_dependency "rubocop"
  end
RUBY

already_has_style = gemspec_content.include?("manageiq-style")
puts "already_has_style: #{already_has_style}"

lines2 = gemspec_content.lines
dev_lines = lines2.select { |l| l.include?("add_development_dependency") }
puts "dev_lines count: #{dev_lines.length}"
dev_lines.each { |l| puts l.strip }
