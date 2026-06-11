# Stub the Sequel namespace so the plugin file can be loaded without the sequel gem
module Sequel
  module Plugins; end
end
require_relative "lib/sequel_crushyform"

# LABEL_COLUMNS constant — pure data, no DB needed
cols = Sequel::Plugins::Crushyform::ClassMethods::LABEL_COLUMNS
puts cols.length
puts cols.first
puts cols[1]
puts cols.last
puts cols.include?(:name)
puts cols.include?(:email)
