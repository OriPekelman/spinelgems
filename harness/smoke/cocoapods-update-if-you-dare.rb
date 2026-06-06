# Smoke: cocoapods-update-if-you-dare
# The gem is a CocoaPods plugin. Its main entry point only loads the VERSION
# constant; the plugin logic (cocoapods_plugin.rb) requires 'colored2' and
# patches Pod::Command::Update. We stub both dependencies so we can exercise
# the real patch logic.

# --- Stub require for colored2 (unavailable runtime dep) ---
module Kernel
  alias_method :_orig_require_cpiyd, :require
  def require(name)
    return true if name == 'colored2'
    _orig_require_cpiyd(name)
  end
end

# --- Stub colored2 String color methods ---
class String
  def yellow; '[y:' + self + ']'; end
  def green;  '[g:' + self + ']'; end
  def magenta; '[m:' + self + ']'; end
  def blue;   '[b:' + self + ']'; end
  def cyan;   '[c:' + self + ']'; end
end

# --- Stub Pod::Command::Update class hierarchy ---
module Pod
  module UI
    # Simulates user choosing 'Yes' (index 0)
    def self.choose_from_array(choices, question)
      0
    end
  end

  class Command
    def initialize; end

    class Update < Command
      def run
        puts 'ORIGINAL_RUN_CALLED'
      end

      def respond_to?(method_name, include_private = false)
        false
      end
    end
  end
end

# --- Load the gem (version constant) ---
require 'cocoapods-update-if-you-dare'

puts "version: " + CocoapodsUpdateIfYouDare::VERSION
puts "semver: " + (CocoapodsUpdateIfYouDare::VERSION.split('.').length == 3 ? "ok" : "bad")

# --- Load and exercise the plugin ---
plugin_path = File.expand_path(
  '../cocoapods-update-if-you-dare/../../lib/cocoapods_plugin.rb',
  __FILE__
)
# Resolve relative to gem lib dir
gem_lib = File.join(File.dirname(File.dirname(File.expand_path(__FILE__))),
                    '.cache/spinel-compat/gems/cocoapods-update-if-you-dare-' +
                    CocoapodsUpdateIfYouDare::VERSION + '/lib/cocoapods_plugin.rb')

# Use $LOAD_PATH to find it instead
$LOAD_PATH.each do |lp|
  candidate = File.join(lp, 'cocoapods_plugin.rb')
  if File.exist?(candidate)
    gem_lib = candidate
    break
  end
end

load gem_lib

# Test 1: @pods is set -> skip warning, call original run directly
puts "--- test1: pods specified ---"
u1 = Pod::Command::Update.new
u1.instance_variable_set(:@pods, ['SomePod'])
u1.run
puts "test1: done"

# Test 2: @pods is nil, dont_talk_to_me flag absent -> show warning, user says Yes
# We override the shell backtick to return empty (no macOS defaults)
module Kernel
  alias_method :_orig_backtick_cpiyd, :`
  def `(cmd)
    return "" if cmd.include?("net.Ashton-W.cocoapods-update-if-you-dare")
    _orig_backtick_cpiyd(cmd)
  end
end

puts "--- test2: no pods, user says yes ---"
u2 = Pod::Command::Update.new
u2.run
puts "test2: done"

# Test 3: verify the alias chain exists on the class
puts "--- test3: alias method present ---"
has_alias = Pod::Command::Update.method_defined?(:run_before_update_if_you_dare)
puts "alias: " + (has_alias ? "present" : "missing")
