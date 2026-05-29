require_relative "lib/shellcheck/gem_version"
puts Shellcheck::VERSION
puts Shellcheck::VERSION.class
puts Shellcheck::VERSION.frozen?
puts Shellcheck::VERSION.split('.').length
puts Shellcheck::VERSION =~ /\A\d+\.\d+\.\d+\z/ ? "valid_semver" : "invalid_semver"
