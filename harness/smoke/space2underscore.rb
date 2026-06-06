require 'space2underscore'

# Converter.convert: single argument (space-separated string)
puts Space2underscore::Converter.convert(['foo bar'])
puts Space2underscore::Converter.convert(['hello world baz'])
puts Space2underscore::Converter.convert(['  leading and trailing  '])

# Converter.convert: multiple arguments (joined with underscores)
puts Space2underscore::Converter.convert(['foo', 'bar'])
puts Space2underscore::Converter.convert(['feature', 'my', 'thing'])

# Converter.convert: edge cases
puts Space2underscore::Converter.convert([]).inspect  # empty -> ''

# OptionsParser.parse: basic parse, no flags
opts = Space2underscore::OptionsParser.parse(['hello', 'world'])
puts opts.action.inspect
puts opts.input.inspect
puts opts.downcase.inspect

# OptionsParser.parse: with --create flag
opts2 = Space2underscore::OptionsParser.parse(['--create', 'my branch'])
puts opts2.action.inspect
puts opts2.input.inspect

# OptionsParser.parse: with --raw flag (preserve case)
opts3 = Space2underscore::OptionsParser.parse(['--raw', 'MyBranch'])
puts opts3.downcase.inspect

# ParseError on missing input
begin
  Space2underscore::OptionsParser.parse(['-c'])
rescue Space2underscore::OptionsParser::ParseError => e
  puts e.message
end
