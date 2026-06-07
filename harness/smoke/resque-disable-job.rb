# frozen_string_literal: true

# Smoke test for resque-disable-job gem
# Exercises the Rule class which contains pure Ruby logic (no Redis needed)

require 'resque-disable-job'

# --- Rule key/digest computation ---
rule = Resque::Plugins::DisableJob::Rule.new('MyWorker', [1, 'hello'])
puts rule.job_name
puts rule.main_set
puts rule.all_rules_key
puts rule.serialized_arguments
puts rule.digest.length  # SHA1 hex = 40 chars

# --- Digest stability: same args => same digest ---
rule2 = Resque::Plugins::DisableJob::Rule.new('MyWorker', [1, 'hello'])
puts rule.digest == rule2.digest

# --- Rule with no arguments ---
rule_any = Resque::Plugins::DisableJob::Rule.new('AnyJob', [])
puts rule_any.digest.length

# --- match? with exact array args ---
rule_exact = Resque::Plugins::DisableJob::Rule.new('SomeJob', [42, 'foo'])
puts rule_exact.match?([42, 'foo'])    # true: exact match
puts rule_exact.match?([42, 'bar'])    # false: value differs
puts rule_exact.match?([99, 'foo'])    # false: first arg differs

# --- match? with nil wildcard (nil in rule args matches anything) ---
rule_wild = Resque::Plugins::DisableJob::Rule.new('SomeJob', [nil, 'foo'])
puts rule_wild.match?([42, 'foo'])     # true: first arg is nil wildcard
puts rule_wild.match?([42, 'bar'])     # false: second arg must be 'foo'

# --- match? with hash args ---
rule_hash = Resque::Plugins::DisableJob::Rule.new('SomeJob', { 'user_id' => 5, 'action' => nil })
puts rule_hash.match?([{ 'user_id' => 5, 'action' => 'delete' }])   # true: action nil wildcard
puts rule_hash.match?([{ 'user_id' => 9, 'action' => 'delete' }])   # false: user_id differs

# --- Reconstruct rule from serialized args + digest (round-trip) ---
serialized = rule.serialized_arguments
digest     = rule.digest
rule3 = Resque::Plugins::DisableJob::Rule.new('MyWorker', serialized, digest)
puts rule3.arguments == [1, 'hello']
puts rule3.digest == digest

# --- VERSION constant ---
puts Resque::DisableJob::VERSION
