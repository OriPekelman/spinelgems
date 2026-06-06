# frozen_string_literal: true

require 'paper_trail_hashdiff'

# PaperTrailHashDiff wraps Hashdiff to store incremental diffs in PaperTrail's
# object_changes column. It supports two modes:
#   - default (only_objects: false): always calls Hashdiff.diff on all fields
#   - only_objects: true: calls Hashdiff.diff only for Hash/Array values;
#     scalar fields are returned as raw [before, after] pairs (no Hashdiff dep)

# --- 1. Constructor and attr_reader ---
pt_default = PaperTrailHashDiff.new
pt_only    = PaperTrailHashDiff.new(only_objects: true)
puts pt_default.only_objects.inspect   # false
puts pt_only.only_objects.inspect      # true

# --- 2. only_objects: true with scalar fields (no Hashdiff call) ---
# When both values are scalars (neither Hash nor Array), this path returns
# the raw pair — letting us exercise the class without the Hashdiff runtime dep.
scalar_changes = {
  'name'   => ['Alice', 'Bob'],
  'active' => [false, true],
  'score'  => [0, 42],
  'note'   => [nil, 'added'],
}
result = pt_only.diff(scalar_changes)
result.keys.sort.each do |k|
  puts "#{k}: #{result[k].inspect}"
end

# --- 3. Scalar values where one side is nil (still scalar branch) ---
nil_change = { 'tag' => [nil, nil] }
r2 = pt_only.diff(nil_change)
puts r2['tag'].inspect   # [nil, nil]
