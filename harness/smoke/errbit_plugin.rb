# frozen_string_literal: true

require 'errbit_plugin'

# 1. NoneIssueTracker is auto-registered at require time
puts "registered trackers: #{ErrbitPlugin::Registry.issue_trackers.keys.inspect}"
puts "none label: #{ErrbitPlugin::NoneIssueTracker.label}"
puts "none note starts: #{ErrbitPlugin::NoneIssueTracker.note[0, 30]}"
puts "none fields: #{ErrbitPlugin::NoneIssueTracker.fields.inspect}"

tracker = ErrbitPlugin::NoneIssueTracker.new({})
puts "configured?: #{tracker.configured?}"
puts "errors: #{tracker.errors.inspect}"
puts "url: #{tracker.url.inspect}"
puts "create_issue: #{tracker.create_issue}"

# 2. IssueTrackerValidator: verify a valid custom tracker
class MyTracker < ErrbitPlugin::IssueTracker
  def self.label; "mytracker"; end
  def self.fields; { url: { label: "URL" } }; end
  def self.note; "A test tracker"; end
  def self.icons; {}; end
  def configured?; !options[:url].to_s.empty?; end
  def errors; {}; end
  def url; options[:url].to_s; end
  def create_issue(_problem); "issue-created"; end
end

validator = ErrbitPlugin::IssueTrackerValidator.new(MyTracker)
puts "MyTracker valid?: #{validator.valid?}"
puts "MyTracker errors: #{validator.errors.inspect}"

# 3. Register the custom tracker and check the registry
ErrbitPlugin::Registry.add_issue_tracker(MyTracker)
puts "after add, keys: #{ErrbitPlugin::Registry.issue_trackers.keys.sort.inspect}"

# 4. AlreadyRegisteredError on duplicate registration
begin
  ErrbitPlugin::Registry.add_issue_tracker(MyTracker)
  puts "no error (unexpected)"
rescue ErrbitPlugin::AlreadyRegisteredError => e
  puts "AlreadyRegisteredError: #{e.message}"
end

# 5. IncompatibilityError for a bad tracker
class BadTracker < ErrbitPlugin::IssueTracker
  def self.label; "bad"; end
  # missing: fields, note, icons, configured?, errors, url, create_issue
end

begin
  ErrbitPlugin::Registry.add_issue_tracker(BadTracker)
  puts "no error (unexpected)"
rescue ErrbitPlugin::IncompatibilityError => e
  puts "IncompatibilityError raised: true"
end

# 6. Clear registry
ErrbitPlugin::Registry.clear_issue_trackers
puts "after clear: #{ErrbitPlugin::Registry.issue_trackers.keys.inspect}"
