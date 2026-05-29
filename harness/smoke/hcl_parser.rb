puts HclParser::Error.superclass
e = HclParser::Error.new("boom")
puts e.message
puts HclParser::Error.ancestors.include?(StandardError)
