# frozen_string_literal: true
# Smoke: pulis — RuboCop config distribution gem
# The gem's only Ruby API is the Pulis module and VERSION constant.
# There are no public methods or classes — it ships rubocop.yml only.
require 'pulis'

puts Pulis::VERSION
puts Pulis.is_a?(Module)
puts Pulis.name
puts Pulis::VERSION.split('.').map(&:to_i).sum
