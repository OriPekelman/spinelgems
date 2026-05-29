# UUID class from clarity_tracking_number gem
puts UUID.respond_to?(:random_string)
puts UUID.respond_to?(:random_tracking_number)
puts UUID.respond_to?(:clear_check_tracking_number)
puts UUID.respond_to?(:clear_bank_tracking_number)
puts UUID.random_string(0).length
UUID.random_string(1)
puts UUID.instance_variable_get(:@chars).length
puts UUID.instance_variable_get(:@chars).sort.first
puts UUID.instance_variable_get(:@chars).sort.last
