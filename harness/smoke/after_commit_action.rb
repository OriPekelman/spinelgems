# Smoke test for after_commit_action gem
# Tests module structure without ActiveRecord dependency
puts AfterCommitAction.class
puts AfterCommitAction.is_a?(Module)
puts AfterCommitAction.instance_methods(false).sort.map(&:to_s).inspect
