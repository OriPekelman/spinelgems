# vulcan 0.8.2 — Heroku build-server CLI gem
# lib/vulcan.rb is an empty module stub; all logic is in Vulcan::CLI < Thor.
# CLI requires: heroku/auth, thor, rest_client, net/http/post/multipart —
# none of which are available in this environment.
# We smoke only what is self-contained: the module namespace and VERSION constant.

require 'vulcan'
require 'vulcan/version'

puts Vulcan::VERSION
puts Vulcan.is_a?(Module)
puts Vulcan::VERSION.split('.').map(&:to_i).length == 3
