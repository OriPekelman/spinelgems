# Smoke: danger-welcome_message
# Tests greeting_words logic (default vs. custom) from DangerWelcomeMessage.
# Uses BEGIN to define the Danger::Plugin stub before any require_relative
# in the harness auto-loads lib/welcome_message/plugin.rb (which inherits Plugin).

BEGIN {
  module Danger
    class Plugin
      def initialize(dangerfile)
        @dangerfile = dangerfile
      end

      def method_missing(method_sym, *args, &block)
        @dangerfile.send(method_sym, *args, &block)
      end
    end
  end
}

require 'danger_welcome_message'
require 'danger_plugin'

GithubStub = Struct.new(:pr_author)
DangerfileStub = Struct.new(:github)

dangerfile = DangerfileStub.new(GithubStub.new("alice"))
plugin = Danger::DangerWelcomeMessage.new(dangerfile)

# Test 1: default greeting uses pr_author name
puts plugin.send(:greeting_words)

# Test 2: custom words override replaces the default entirely
plugin.custom_words = "Hi, alice! Great first PR!"
puts plugin.send(:greeting_words)

# Test 3: custom words with multiline string
plugin.custom_words = "Thanks for contributing!\nWe appreciate your work."
puts plugin.send(:greeting_words).strip
