# keybase-unofficial is a meta-gem: its lib/keybase.rb delegates to subgems
# via plain require "keybase/core" etc. Those subgems are separate installs.
# Only the version constant is available without the subgems.
require "keybase/version"

puts Keybase::VERSION
puts Keybase::VERSION.class
puts Keybase::VERSION.split(".").map(&:to_i).sum
