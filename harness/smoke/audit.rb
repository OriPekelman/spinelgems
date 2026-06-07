require 'audit'
require 'audit/changeset'

# Audit::Log and Audit::Tracking need cassandra/active_support/yajl — skip them.
# Audit::Changeset and Audit::Change are pure-Ruby structs with no external deps.

puts Audit::VERSION

# from_hash: single changeset from an ActiveRecord-style changes hash
cs = Audit::Changeset.from_hash(
  'changes'  => { 'age' => [30, 31], 'name' => ['Alice', 'Bob'] },
  'metadata' => 'deploy-v2'
)
puts cs.class
puts cs.changes.length
cs.changes.each { |c| puts "#{c.attribute}: #{c.old_value} -> #{c.new_value}" }
puts cs.metadata

# from_enumerable with a Hash (delegates to from_hash)
cs2 = Audit::Changeset.from_enumerable(
  'changes'  => { 'score' => [99, 100] },
  'metadata' => nil
)
puts cs2.changes.first.attribute
puts cs2.changes.first.old_value
puts cs2.changes.first.new_value
puts cs2.metadata.inspect

# from_enumerable with an Array of change hashes
list = Audit::Changeset.from_enumerable([
  { 'changes' => { 'level' => [1, 2] },   'metadata' => 'admin' },
  { 'changes' => { 'status' => ['pending', 'active'] }, 'metadata' => nil }
])
puts list.length
list.each { |c| puts c.changes.map { |ch| "#{ch.attribute}:#{ch.old_value}->#{ch.new_value}" }.join(',') }
