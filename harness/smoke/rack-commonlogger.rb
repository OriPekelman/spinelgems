puts Rack::CommonLogger::VERSION
puts Rack::CommonLogger::FORMAT.class
puts Rack::CommonLogger::FORMAT.include?("%s")
puts Rack::CommonLogger::FORMAT.include?("%d")
puts Rack::CommonLogger::FORMAT.start_with?("%s - %s")
