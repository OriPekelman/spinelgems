require_relative 'lib/story_branch/string_utils'

puts StoryBranch::StringUtils.dashed("Hello World 123!")
puts StoryBranch::StringUtils.normalised_branch_name("  My Feature Branch  ")
puts StoryBranch::StringUtils.undashed("my-feature-branch")
puts StoryBranch::StringUtils.truncate("short")
puts StoryBranch::StringUtils.truncate("this is a very long string that should be truncated at forty chars")
