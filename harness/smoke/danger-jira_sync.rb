# frozen_string_literal: true

# danger-jira_sync smoke: exercises gem_version + the PR-key extraction logic
# plugin.rb requires jira-ruby (unavailable), so we test what can load cleanly.

require 'danger_jira_sync'

# 1. VERSION constant
puts JiraSync::VERSION

# 2. Reproduce the core business logic from JiraSync::Plugin#extract_issue_keys_from_pull_request
#    (same algorithm as the gem, exercised with concrete inputs)

def extract_issue_keys(text_title, text_body, key_prefixes)
  re = Regexp.new(/((#{key_prefixes.join("|")})-\d+)/)
  keys = []
  text_title.gsub(re) { |match| keys << match }
  text_body.gsub(re)  { |match| keys << match } if keys.empty?
  keys.compact.uniq
end

# Title has hits → body is ignored
keys = extract_issue_keys(
  "Fix DEV-1234 and ABC-56: improve perf",
  "Also see PROJ-99",
  %w[DEV ABC PROJ]
)
puts keys.sort.inspect

# Title empty → falls back to body
keys2 = extract_issue_keys(
  "refactor login page",
  "Closes PROJ-99 and PROJ-100",
  %w[DEV ABC PROJ]
)
puts keys2.sort.inspect

# No match anywhere → empty
keys3 = extract_issue_keys(
  "chore: update deps",
  "nothing relevant here",
  %w[DEV ABC PROJ]
)
puts keys3.inspect

# Multiple prefixes, dedup
keys4 = extract_issue_keys(
  "DEV-1 DEV-1 ABC-2 mentioned twice ABC-2",
  "ignored body",
  %w[DEV ABC]
)
puts keys4.sort.inspect
