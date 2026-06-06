# frozen_string_literal: true
require 'log_sweeper'
require 'tmpdir'
require 'logger'
require 'stringio'

# Test 1: VERSION constant
puts "version: #{LogSweeper::VERSION}"

# Test 2: run on an empty directory returns true
Dir.mktmpdir do |dir|
  log = Logger.new(StringIO.new)
  result = LogSweeper.run(dir, logs_lifetime_days_count: 1, logger: log)
  puts "empty dir returns: #{result}"
end

# Test 3: run skips files that are not .log files
Dir.mktmpdir do |dir|
  File.write(File.join(dir, 'readme.txt'), 'hello')
  events = StringIO.new
  log = Logger.new(events)
  LogSweeper.run(dir, logs_lifetime_days_count: 1, logger: log)
  puts "non-log file skipped: #{events.string.include?('skipping')}"
end

# Test 4: run skips recent .log files (created just now, within 1-day threshold)
Dir.mktmpdir do |dir|
  File.write(File.join(dir, 'app.log'), 'some log content')
  events = StringIO.new
  log = Logger.new(events)
  LogSweeper.run(dir, logs_lifetime_days_count: 1, logger: log)
  # File is new so it should be skipped (mtime is ~now, well within 1 day)
  puts "recent log skipped: #{events.string.include?('skipping')}"
end

# Test 5: run deletes old .log files (backdated mtime)
Dir.mktmpdir do |dir|
  path = File.join(dir, 'old.log')
  File.write(path, 'old log')
  # Set mtime to 30 days ago
  old_time = Time.now - (30 * 24 * 3600)
  File.utime(old_time, old_time, path)
  events = StringIO.new
  log = Logger.new(events)
  LogSweeper.run(dir, logs_lifetime_days_count: 10, logger: log)
  puts "old log deleted: #{events.string.include?('deleting')}"
  puts "file removed: #{!File.exist?(path)}"
end
