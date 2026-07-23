module Underscore
  module Rails
    if defined?(::Rails)
      puts "guard TRUE"
    else
      puts "guard false"
    end
  end
end
