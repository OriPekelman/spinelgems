require_relative "lib/singem/version"
puts Singem::VERSION
puts Singem::VERSION.class
puts Singem::VERSION.frozen?
puts Singem::VERSION.split(".").length
puts Singem::VERSION.start_with?("0")
