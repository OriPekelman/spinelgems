require 'git-storyid'

# Exercise GitStoryid's commit message building logic
# without needing a tracker API connection.

# GitStoryid::SerializedIssue is a Struct with id, type, name
story1 = GitStoryid::SerializedIssue.new("123456", "feature", "Add user authentication")
story2 = GitStoryid::SerializedIssue.new("789012", "bug", "Fix login redirect loop")

# Instantiate GitStoryid bypassing initialize (which calls Configuration.build)
# by using allocate, then set instance vars directly.
g = GitStoryid.allocate
g.instance_variable_set(:@stories, [story1])
g.instance_variable_set(:@finish_stories, false)
g.instance_variable_set(:@deliver_stories, false)

# Test finish_story_prefix for normal (no flags)
puts g.send(:finish_story_prefix, story1)   # => "" (empty string, no prefix)

# Test finish_story_prefix with finish flag
g.instance_variable_set(:@finish_stories, true)
puts g.send(:finish_story_prefix, story1)   # => "Finishes "
puts g.send(:finish_story_prefix, story2)   # => "Fixes " (bug type)

# Test build_commit_message with single story
g.instance_variable_set(:@stories, [story1])
g.instance_variable_set(:@finish_stories, false)
g.instance_variable_set(:@deliver_stories, false)
g.instance_variable_set(:@custom_message, nil)
puts g.send(:build_commit_message)
# => "[#123456] Feature: Add user authentication"

# Test build_commit_message with custom message
g.instance_variable_set(:@custom_message, "Refactored session handling")
puts g.send(:build_commit_message)

# Test build_commit_message with multiple stories + finish flag
g.instance_variable_set(:@stories, [story1, story2])
g.instance_variable_set(:@finish_stories, true)
g.instance_variable_set(:@custom_message, nil)
puts g.send(:build_commit_message)

# Test stories_menu
g.instance_variable_set(:@stories, nil)
g.instance_variable_set(:@tracker, Object.new.tap do |o|
  stories = [story1, story2]
  o.define_singleton_method(:all_stories) { stories }
end)
puts g.send(:stories_menu)

# Test deliver prefix
g2 = GitStoryid.allocate
g2.instance_variable_set(:@deliver_stories, true)
g2.instance_variable_set(:@finish_stories, false)
puts g2.send(:finish_story_prefix, story1)  # => "Delivers "
