# frozen_string_literal: true
# Smoke: exercise the VERSION constant (only dep-free part of the gem).
# The main entrypoint needs rubocop/formatter/base_formatter (external gem)
# so we load the version sub-file directly via require_relative.
require_relative "lib/rubocop-github-annotation-formatter/version"

puts RubocopGithubAnnotationFormatter::VERSION
puts RubocopGithubAnnotationFormatter::VERSION.class
puts RubocopGithubAnnotationFormatter::VERSION.split(".").length
puts RubocopGithubAnnotationFormatter::VERSION.frozen?
