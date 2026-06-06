# frozen_string_literal: true
# Smoke for barsoom_utils: exercises ExceptionNotifier routing logic and
# FeatureToggle enable/disable with in-memory stubs.
#
# External deps (attr_extras, redis, honeybadger) are stubbed via a
# transient directory on the load path so CRuby can load the gem files.
# Under Spinel, plain `require` for other gems is a no-op — the stubs
# provide the same definitions at the top of this file so both paths work.

require "tmpdir"
require "fileutils"
require "set"

STUB_DIR = Dir.mktmpdir("barsoom_utils_stub_")
at_exit { FileUtils.rm_rf(STUB_DIR) }

# attr_extras: pattr_initialize generates a keyword-args initializer
File.write(File.join(STUB_DIR, "attr_extras.rb"), <<~'RUBY')
  class Module
    def pattr_initialize(required_name, optional_names = [])
      kw_names = Array(optional_names)
      define_method(:initialize) do |req_val, **kw|
        instance_variable_set(:"@#{required_name}", req_val)
        kw_names.each { |n| instance_variable_set(:"@#{n}", kw[n]) }
      end
      ([required_name] + kw_names).each { |n| attr_reader n }
    end
  end
RUBY

File.write(File.join(STUB_DIR, "redis.rb"), "module Redis; end\n")

File.write(File.join(STUB_DIR, "honeybadger.rb"), <<~'RUBY')
  module Honeybadger
    CALLS = []
    def self.notify(exception_or_opts = nil, **kw)
      CALLS << (exception_or_opts || kw)
    end
  end
RUBY

$LOAD_PATH.unshift(STUB_DIR)

# Honeybadger must exist at top-level before exception_notifier is loaded
require "honeybadger"

require "barsoom_utils"
require_relative "/home/oripekelman/.cache/spinel-compat/gems/barsoom_utils-0.2.0.73/lib/barsoom_utils/exception_notifier"
require_relative "/home/oripekelman/.cache/spinel-compat/gems/barsoom_utils-0.2.0.73/lib/barsoom_utils/feature_toggle"

# --- ExceptionNotifier ---

# notify with a non-Exception raises a descriptive error
begin
  BarsoomUtils::ExceptionNotifier.notify("oops")
  puts "notify_non_exc: FAIL"
rescue RuntimeError => e
  puts "notify_non_exc: #{e.message}"
end

# notify with a real Exception is accepted
BarsoomUtils::ExceptionNotifier.notify(StandardError.new("real"))
puts "notify_ok: accepted"

# message(): message only — details defaults to "(no message)"
Honeybadger::CALLS.clear
BarsoomUtils::ExceptionNotifier.message("MyError")
c = Honeybadger::CALLS.last
puts "message_simple: class=#{c[:error_class]} msg=#{c[:error_message]}"

# message(): message + details string
Honeybadger::CALLS.clear
BarsoomUtils::ExceptionNotifier.message("MyError", "bad thing")
c = Honeybadger::CALLS.last
puts "message_detail: class=#{c[:error_class]} msg=#{c[:error_message]}"

# message(): message + context hash (no details)
Honeybadger::CALLS.clear
BarsoomUtils::ExceptionNotifier.message("MyError", { user_id: 42 })
c = Honeybadger::CALLS.last
puts "message_ctx: class=#{c[:error_class]} ctx=#{c[:context]}"

# message(): message + details + context
Honeybadger::CALLS.clear
BarsoomUtils::ExceptionNotifier.message("MyError", "detail", { user_id: 7 })
c = Honeybadger::CALLS.last
puts "message_full: class=#{c[:error_class]} msg=#{c[:error_message]} ctx=#{c[:context]}"

# --- FeatureToggle with in-memory fake Redis ---

class FakeRedis
  def initialize
    @sets = Hash.new { |h, k| h[k] = Set.new }
  end
  def sadd?(key, member) = @sets[key].add?(member)
  def srem?(key, member) = @sets[key].delete?(member)
  def sismember(key, member) = @sets[key].include?(member)
  def smembers(key) = @sets[key].to_a
end

redis = FakeRedis.new
BarsoomUtils::FeatureToggle.redis = redis

# Default: feature ON (nothing disabled in redis)
puts "on_by_default: #{BarsoomUtils::FeatureToggle.on?(:dark_mode, redis: redis)}"

# turn_off disables the feature
BarsoomUtils::FeatureToggle.turn_off(:dark_mode, redis: redis)
puts "off_after_turn_off: #{BarsoomUtils::FeatureToggle.off?(:dark_mode, redis: redis)}"

# turn_on re-enables it
BarsoomUtils::FeatureToggle.turn_on(:dark_mode, redis: redis)
puts "on_after_turn_on: #{BarsoomUtils::FeatureToggle.on?(:dark_mode, redis: redis)}"

# list returns sorted disabled feature names
BarsoomUtils::FeatureToggle.turn_off(:beta_ui, redis: redis)
BarsoomUtils::FeatureToggle.turn_off(:analytics, redis: redis)
puts "disabled_list: #{BarsoomUtils::FeatureToggle.list.sort.inspect}"
