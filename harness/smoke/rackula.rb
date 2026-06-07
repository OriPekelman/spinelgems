# frozen_string_literal: true
# Smoke: rackula
# rackula is a CLI static-site-generator wrapper.
# Its only loadable code (without samovar/rack/falcon) is version.rb.
# We load that and exercise the VERSION string and module identity.
# Attempting to load rackula/command raises LoadError (samovar missing).

require 'rackula/version'

puts Rackula::VERSION
puts Rackula::VERSION.split('.').map(&:to_i).sum
puts Rackula.name
puts Rackula.is_a?(Module)
puts Rackula::VERSION =~ /\A\d+\.\d+\.\d+\z/ ? "version-format:ok" : "version-format:bad"
