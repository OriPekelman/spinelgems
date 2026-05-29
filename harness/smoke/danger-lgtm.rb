require_relative "lib/lgtm/version"

puts Lgtm::VERSION
puts Lgtm::VERSION.class
puts Lgtm::VERSION.frozen?
puts Lgtm::VERSION.split(".").length
puts Lgtm::VERSION =~ /\A\d+\.\d+\.\d+\z/ ? "semver" : "other"
