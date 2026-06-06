require 'hibana'

# VERSION
puts Hibana::VERSION

# Hibana.application attribute_accessor on the module itself
puts Hibana.application.nil?
Hibana.application = :placeholder
puts Hibana.application.inspect
Hibana.application = nil
puts Hibana.application.nil?

# RouterNotSetError: custom error class, pure Ruby, no external deps
err = Hibana::Errors::RouterNotSetError.new
puts err.to_s
puts err.is_a?(RuntimeError)
puts err.is_a?(StandardError)

# Raise and rescue via superclass
begin
  raise Hibana::Errors::RouterNotSetError
rescue RuntimeError => e
  puts e.to_s
end

# Raise and rescue via exact class
begin
  raise Hibana::Errors::RouterNotSetError, 'overridden'
rescue Hibana::Errors::RouterNotSetError => e
  # to_s is overridden (ignores message arg), check it
  puts e.to_s
end
