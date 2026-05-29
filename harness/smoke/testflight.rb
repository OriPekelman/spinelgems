puts Testflight.name
puts Testflight.is_a?(Module)
puts Testflight.respond_to?(:name)
puts Testflight.constants.sort.join(",")
