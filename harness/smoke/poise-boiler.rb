# Smoke test for poise-boiler 1.18.1
# Exercises: VERSION, Error class hierarchy, module structure, raise/rescue

require 'poise-boiler'
require 'poise_boiler/version'
require 'poise_boiler/error'

# 1. Version constant
puts "VERSION: #{PoiseBoiler::VERSION}"

# 2. Error class hierarchy — PoiseBoiler::Error < Exception
puts "Error superclass: #{PoiseBoiler::Error.superclass}"

# 3. Instantiate an Error and inspect it
err = PoiseBoiler::Error.new('deployment failed')
puts "Error class: #{err.class}"
puts "Error message: #{err.message}"
puts "Is Exception: #{err.is_a?(Exception)}"

# 4. raise / rescue round-trip
begin
  raise PoiseBoiler::Error, 'something went wrong'
rescue PoiseBoiler::Error => e
  puts "Rescued: #{e.message}"
end

# 5. PoiseBoiler module structure
puts "Helpers is Module: #{PoiseBoiler::Helpers.is_a?(Module)}"
puts "Kitchen responds to instance: #{PoiseBoiler::Kitchen.respond_to?(:instance)}"

# 6. Kitchen.instance is nil before any .kitchen call
puts "Kitchen.instance before call: #{PoiseBoiler::Kitchen.instance.inspect}"

# 7. PoiseBoiler top-level delegates .kitchen to Kitchen module
puts "PoiseBoiler responds to kitchen: #{PoiseBoiler.respond_to?(:kitchen)}"
