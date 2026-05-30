puts GitPair::VERSION
puts GitPair::NoMatchingAuthorsError.superclass
puts GitPair::MissingConfigurationError.superclass
puts GitPair::NoMatchingAuthorsError.new("bad author").message
puts GitPair::MissingConfigurationError.new("no config").message
puts GitPair::NoMatchingAuthorsError.ancestors.include?(ArgumentError)
puts GitPair::MissingConfigurationError.ancestors.include?(RuntimeError)
