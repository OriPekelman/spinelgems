puts ItemModels::VERSION
puts ItemModels::VERSION.class
e = ItemModels::Error.new("test error")
puts e.message
puts e.is_a?(StandardError)
puts ItemModels::Error.ancestors.include?(StandardError)
