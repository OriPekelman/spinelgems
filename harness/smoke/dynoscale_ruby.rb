puts DynoscaleRuby::Error.superclass
puts DynoscaleRuby::Error.new("test").message
puts DynoscaleRuby::Error.ancestors.include?(StandardError)
puts DynoscaleRuby::Error.ancestors.include?(RuntimeError)
puts DynoscaleRuby.is_a?(Module)
