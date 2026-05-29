require_relative "lib/pmd/gem_version"
puts Pmd::VERSION
puts Pmd::VERSION.class
puts Pmd::VERSION.split('.').length
puts Pmd::VERSION.start_with?('1')
puts Pmd::VERSION.split('.').map(&:to_i).first
