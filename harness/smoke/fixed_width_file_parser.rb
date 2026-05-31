require 'stringio'

puts FixedWidthFileParser::VERSION

fields = [
  { name: 'first_name', position: 0..9 },
  { name: 'last_name',  position: 10..19 },
  { name: 'age',        position: 20..22 }
]

data = StringIO.new("Alice     Smith     042\nBob       Jones     030\n")

FixedWidthFileParser.parse(data, fields) do |row|
  puts "#{row[:first_name]}|#{row[:last_name]}|#{row[:age]}"
end
