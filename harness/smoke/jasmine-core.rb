ENV["SUPPRESS_JASMINE_DEPRECATION"] = "1"

# boot_files and node_boot_files are fixed arrays with no filesystem dependency
puts Jasmine::Core.boot_files.sort.inspect
puts Jasmine::Core.node_boot_files.sort.inspect
puts Jasmine::Core.boot_files.length
puts Jasmine::Core.boot_files.first

# spec_files raises ArgumentError on an unknown type — pure Ruby logic
begin
  Jasmine::Core.spec_files("bogus")
rescue ArgumentError => e
  puts e.message
end
