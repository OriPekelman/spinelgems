puts Environment.ancestors.include?(Hash)
puts Environment.new.is_a?(Hash)
puts Environment.new.key?(:home)
puts Environment.new.key?(:machine)
puts Environment.new.key?(:user)
puts Environment.home == ENV["HOME"]
puts Environment.user == ENV["USER"]
