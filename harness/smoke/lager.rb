class Foo
  extend Lager
  log_to $stdout, :warn
end

puts Foo.log_level.inspect
Foo.log_level = :debug
puts Foo.log_level.inspect
Foo.log_level = :error
puts Foo.log_level.inspect
Foo.log_level = 0
puts Foo.log_level.inspect
