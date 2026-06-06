# smoke: resque-logger — exercises ResqueLogger::ClassMethods validation logic
# and Resque::Plugins::Logger module behaviour.
#
# Uses require_relative with absolute-style paths so Spinel (no load path) can
# inline the gem files. Resque is stubbed first so the top-level
# Resque.extend in resque_logger.rb succeeds.

require 'logger'

GEM_LIB = "/home/oripekelman/.cache/spinel-compat/gems/resque-logger-0.2.0/lib"

# Stub Resque BEFORE loading the gem (resque_logger.rb extends it immediately)
module Resque
  def self.queue_from_class(klass)
    klass.instance_variable_get(:@queue)
  end
end

require_relative "/home/oripekelman/.cache/spinel-compat/gems/resque-logger-0.2.0/lib/resque_logger/version"
require_relative "/home/oripekelman/.cache/spinel-compat/gems/resque-logger-0.2.0/lib/resque/setup"
require_relative "/home/oripekelman/.cache/spinel-compat/gems/resque-logger-0.2.0/lib/resque/plugins/logger"
require_relative "/home/oripekelman/.cache/spinel-compat/gems/resque-logger-0.2.0/lib/resque_logger"

# --- 1. VERSION ---
puts "version: #{ResqueLogger::VERSION}"

# --- 2. logger_config= validation (ArgumentError on missing keys) ---
begin
  Resque.logger_config = { class_name: ::Logger }
rescue ArgumentError => e
  puts "ArgError folder: #{e.message}"
end

begin
  Resque.logger_config = { folder: '/tmp' }
rescue ArgumentError => e
  puts "ArgError class_name: #{e.message}"
end

# --- 3. Valid config round-trips ---
Resque.logger_config = { folder: '/tmp', class_name: ::Logger, level: ::Logger::INFO }
cfg = Resque.logger_config
puts "folder: #{cfg[:folder]}"
puts "class_name: #{cfg[:class_name]}"
puts "level: #{cfg[:level]}"

# --- 4. Resque::Plugins::Logger: DEFAULT_LOG_NAME constant ---
puts "default_log: #{Resque::Plugins::Logger::DEFAULT_LOG_NAME}"

# --- 5. Plugin creates a Logger pointing at queue-named file ---
class FakeJob
  include Resque::Plugins::Logger
  @queue = :emails
end

Resque.logger_config = { folder: '/tmp', class_name: ::Logger }
job = FakeJob.new
log = job.logger
puts "logger_class: #{log.class}"
puts "logger_level_default: #{log.level == ::Logger::DEBUG}"

# --- 6. Custom level propagates into created logger ---
class FakeJob2
  include Resque::Plugins::Logger
  @queue = :alerts
end
Resque.logger_config = { folder: '/tmp', class_name: ::Logger, level: ::Logger::WARN }
job2 = FakeJob2.new
log2 = job2.logger
puts "logger_level_warn: #{log2.level == ::Logger::WARN}"
