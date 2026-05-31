puts Libdatadog::LIB_VERSION
puts Libdatadog::VERSION
puts Libdatadog::LIB_VERSION.class
puts Libdatadog::VERSION.start_with?("33.0.0")
puts Libdatadog::VERSION.split(".").first(3).join(".")
