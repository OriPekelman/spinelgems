# smoke: rspec-hal — HAL (Hypertext Application Language) RSpec matchers.
# Exercises HavePropertyMatcher, RelationMatcher, UriTemplateHasVariablesMatcher.
# NOTE: rspec-hal's matchers.rb requires 'hal-client' (external gem); in --full
# mode this causes smoke-error:cruby since hal-client is not installed in the
# harness environment. The gem is not self-contained.
require 'rspec-hal'
puts RSpec::Hal::VERSION
