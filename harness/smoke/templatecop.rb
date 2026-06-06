# frozen_string_literal: true

require 'templatecop'

# Exercise RubyClipper::PrecedingKeywordRemover — strips leading keywords
[
  ['if foo', 'foo'],
  ['unless bar', 'bar'],
  ['while running', 'running'],
  ['else baz', 'baz'],
  ['begin action', 'action'],
  ['just_code', 'just_code']
].each do |input, expected|
  result = Templatecop::RubyClipper::PrecedingKeywordRemover.new(input).call
  status = result[:code].strip == expected ? 'OK' : "FAIL(got=#{result[:code].inspect})"
  puts "PrecedingKeywordRemover #{input.inspect} => #{result[:code].inspect} [#{status}]"
end

# Exercise RubyClipper::TrailingDoRemover
[
  ['items.each do', 'items.each'],
  ['items.each do |x|', 'items.each'],
  ['no_do_here', 'no_do_here']
].each do |input, expected|
  result = Templatecop::RubyClipper::TrailingDoRemover.new(input).call
  status = result[:code].strip == expected ? 'OK' : "FAIL(got=#{result[:code].inspect})"
  puts "TrailingDoRemover #{input.inspect} => #{result[:code].inspect} [#{status}]"
end

# Exercise RubyClipper#call (pipeline: PrecedingKeywordRemover then TrailingDoRemover)
pipeline_cases = [
  'if items.each do',
  'while loop do |item|',
  'plain_code'
]
pipeline_cases.each do |input|
  result = Templatecop::RubyClipper.new(input).call
  puts "RubyClipper pipeline #{input.inspect} => code=#{result[:code].inspect} offset=#{result[:offset]}"
end

puts "Templatecop::VERSION=#{Templatecop::VERSION}"
