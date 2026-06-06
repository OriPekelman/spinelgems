require 'whiskers_es/version'

# whiskers-es is a Rails+Elasticsearch integration gem.
# Its only standalone-accessible code is the VERSION constant
# and the WhiskersEs module (the Railtie requires Rails).
# Exercise what can be loaded without Rails or Elasticsearch.

puts WhiskersEs::VERSION
puts WhiskersEs.name
puts WhiskersEs.is_a?(Module)
puts WhiskersEs.constants.sort.inspect
