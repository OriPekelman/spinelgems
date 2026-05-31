require_relative "lib/jacoco/gem_version"
puts Jacoco::VERSION
puts Jacoco::VERSION.class
puts Jacoco::VERSION.split('.').length
puts Jacoco::VERSION =~ /\A\d+\.\d+\.\d+\z/ ? "semver" : "other"
