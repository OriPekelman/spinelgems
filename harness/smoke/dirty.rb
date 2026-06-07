require 'dirty'

# Stub the status method so we don't need a real git repo.
# We inject a realistic git status --porcelain output with a mix of
# spec files, test files, and feature files.
module Dirty
  def status
    [
      " M spec/foo_spec.rb",
      "?? spec/bar_spec.rb",
      " M test/unit_test.rb",
      "?? features/login.feature",
      " D spec/deleted_spec.rb",      # deleted — should be excluded
      " M lib/foo.rb",                # not a test file
    ]
  end
end

# dirty_files should exclude deleted files (those starting with D)
puts "dirty_files count: #{Dirty.dirty_files.length}"

# dirty_specs: matches spec/*_spec.rb
puts "dirty_specs: #{Dirty.dirty_specs.sort.inspect}"

# dirty_tests: matches test/*_test.rb
puts "dirty_tests: #{Dirty.dirty_tests.sort.inspect}"

# dirty_features: matches features/*.feature
puts "dirty_features: #{Dirty.dirty_features.sort.inspect}"

# rspec command built from specs
puts "rspec: #{Dirty.rspec}"

# test command built from tests
puts "test: #{Dirty.test}"

# cucumber command built from features
puts "cucumber: #{Dirty.cucumber}"
