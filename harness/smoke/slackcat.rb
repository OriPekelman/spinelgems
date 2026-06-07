# slackcat smoke
# The gem's lib/ only exports Slackcat::VERSION — the real Slack upload
# logic lives in bin/slackcat and requires httmultiparty + trollop (not
# available at smoke time). We exercise what the library actually provides.

require 'slackcat'

puts Slackcat::VERSION
puts Slackcat.class
puts Slackcat.is_a?(Module)
puts Slackcat::VERSION.split('.').map(&:to_i).all? { |n| n >= 0 }
