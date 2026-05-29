require_relative "lib/cocoapods_try"
puts CocoapodsTry::VERSION
puts CocoapodsTry::VERSION.class
puts CocoapodsTry::VERSION.split(".").length
puts CocoapodsTry::VERSION.frozen?
