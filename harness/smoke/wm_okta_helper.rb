# frozen_string_literal: true

puts WmOktaHelper::VERSION
puts WmOktaHelper::VERSION.class
puts WmOktaHelper::VERSION.split('.').length
puts WmOktaHelper::VERSION.split('.').all? { |p| p =~ /\A\d+\z/ }
