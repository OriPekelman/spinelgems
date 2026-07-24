# FILED as matz/spinel#3320 (2026-07-24). Still wrong (guard TRUE) at 76cfd099.
module Underscore
  module Rails
    if defined?(::Rails)
      puts "guard TRUE"
    else
      puts "guard false"
    end
  end
end
