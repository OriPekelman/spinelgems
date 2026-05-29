puts Ladle::VERSION
puts Ladle::VERSION.class
puts Ladle::VERSION.split('.').length
puts Ladle::VERSION =~ /^\d+\.\d+\.\d+$/ ? "version-ok" : "version-bad"
puts Ladle.name
