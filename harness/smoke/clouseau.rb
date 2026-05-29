puts Clouseau::VERSION
puts Clouseau::Error.superclass
puts Clouseau::Error.new("test").message
puts Clouseau::Error.new("test").is_a?(StandardError)
puts Clouseau.name
