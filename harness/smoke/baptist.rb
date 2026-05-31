puts Baptist::VERSION
puts Baptist.generate('Arthur Russell')
puts Baptist.generate('Arthur Russell', :space => '_')
puts Baptist.generate(['Arthur Russell', 'Calling Out of Context'])
puts Baptist.generate(['Rihanna', 'Loud'], :modifier => 'Explicit')
puts Baptist.generate('Hello World')
puts Baptist.generate('foo bar baz', :separator => '-', :space => '_')
