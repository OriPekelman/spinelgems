require_relative "lib/findbugs/gem_version"
puts Findbugs::VERSION
puts Findbugs::VERSION.frozen?
puts Findbugs::VERSION.length > 0
