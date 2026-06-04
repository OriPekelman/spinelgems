require 'yrb'

# YRB parses Yahoo Resource Bundle format: key=value lines, # comments
template = <<~YRB
  # This is a comment
  greeting=Hello, World!
  farewell=Goodbye, World!
  count=42
YRB

# Parse a template string
result = YRB.parse(template)
puts result['greeting']
puts result['farewell']
puts result['count']
puts result.size

# comment? method
puts YRB.comment?('# this is a comment')
puts YRB.comment?('key=value').nil?

# key_and_value_from_line
key, val = YRB.key_and_value_from_line('name=Alice')
puts key
puts val

# Empty/blank lines are skipped
k2, v2 = YRB.key_and_value_from_line('')
puts k2.nil?
puts v2.nil?

# Duplicate key raises error with :unique => true
begin
  YRB.parse("foo=bar\nfoo=baz", unique: true)
  puts 'no error'
rescue YRB::DuplicateKeyError => e
  puts 'duplicate error'
end

# Duplicate key allowed with :unique => false
result2 = YRB.parse("foo=bar\nfoo=baz", unique: false)
puts result2['foo']
