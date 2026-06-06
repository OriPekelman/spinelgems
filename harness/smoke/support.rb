# Smoke: support-0.18
# This gem has no lib/support.rb — its sole content is lib/foo.rb which
# just does `puts "hello world"`. There is no public API to exercise.
# The harness (--full) will require_relative "lib/foo" producing that output;
# this body verifies the load completed without error.
puts "smoke-body: ok"
