require 'rsense/server'
# rsense-server is a JRuby/Java bridge gem (see gemspec: jruby-jars, jruby-parser, rsense-core).
# Its entry point unconditionally requires jruby-parser which is unavailable under MRI/Spinel.
# The gem cannot be loaded on CRuby or Spinel at all — smoke-error by design.
puts Rsense::Server::VERSION
