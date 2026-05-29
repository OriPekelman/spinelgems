puts Kiqstand::VERSION
puts Kiqstand::Middleware.new.class
puts Kiqstand::Middleware.ancestors.include?(Kiqstand::Middleware)
result = nil
Kiqstand::Middleware.new.call { result = "yielded" }
puts result
