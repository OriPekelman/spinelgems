# frozen_string_literal: true

# bundle-only smoke: exercise BundleOnly::Messages string-formatting logic
# using duck-typed stubs — no Bundler runtime needed.

require 'bundle-only/version'
require 'bundle-only/messages'

puts BundleOnly::VERSION

# Stub objects that quack like Bundler's definition/settings

MockDependency = Struct.new(:name)

class MockDefinition
  def initialize(dep_count, spec_count)
    @dep_count  = dep_count
    @spec_count = spec_count
  end

  def dependencies
    Array.new(@dep_count) { MockDependency.new("gem#{_1}") }
  end

  def specs
    Array.new(@spec_count)
  end
end

# --- Messages::Install ---
defn1 = MockDefinition.new(1, 3)
puts BundleOnly::Messages::Install.dependencies_count_for(defn1)
puts BundleOnly::Messages::Install.gems_installed_for(defn1)

defn5 = MockDefinition.new(5, 7)
puts BundleOnly::Messages::Install.dependencies_count_for(defn5)
puts BundleOnly::Messages::Install.gems_installed_for(defn5)

# --- Messages::Common.without_groups_message ---
# Stub Bundler.settings to avoid loading bundler
module Bundler
  def self.settings
    @settings ||= Hash.new { |h, k| h[k] = nil }
  end
end

# Single group
Bundler.settings[:without] = [:development]
puts BundleOnly::Messages::Common.without_groups_message(:install)

# Multiple groups
Bundler.settings[:without] = [:development, :test]
puts BundleOnly::Messages::Common.without_groups_message(:install)

# Update command
Bundler.settings[:without] = [:staging, :production]
puts BundleOnly::Messages::Common.without_groups_message(:update)
