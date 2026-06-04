# frozen_string_literal: true

require 'growthbook'

# 1. FNV hash utility — top-level class, used internally by Util
fnv = FNV.new
h1 = fnv.fnv1a_32("hello")
h2 = fnv.fnv1a_32("world")
puts "fnv1a_32(hello)=#{h1}"
puts "fnv1a_32(world)=#{h2}"
puts "fnv_different=#{h1 != h2}"

# 2. Util: get_hash and bucket ranges
hash_v1 = Growthbook::Util.get_hash(seed: "my-exp", value: "user-123", version: 1)
hash_v2 = Growthbook::Util.get_hash(seed: "my-exp", value: "user-123", version: 2)
puts "hash_v1_in_range=#{hash_v1 >= 0.0 && hash_v1 < 1.0}"
puts "hash_v2_in_range=#{hash_v2 >= 0.0 && hash_v2 < 1.0}"

ranges = Growthbook::Util.get_bucket_ranges(2, 1.0, nil)
puts "ranges_count=#{ranges.length}"
puts "ranges_cover_zero=#{ranges[0][0] == 0.0}"

# 3. Conditions evaluation
attrs = { 'country' => 'US', 'age' => 30, 'premium' => true }
cond1 = Growthbook::Conditions.eval_condition(attrs, { 'country' => 'US' })
puts "cond_country_us=#{cond1}"

cond2 = Growthbook::Conditions.eval_condition(attrs, { 'age' => { '$gt' => 18 } })
puts "cond_age_gt_18=#{cond2}"

cond3 = Growthbook::Conditions.eval_condition(attrs, { 'country' => { '$in' => ['CA', 'UK'] } })
puts "cond_country_not_in=#{cond3}"

cond4 = Growthbook::Conditions.eval_condition(attrs, {
  '$and' => [{ 'country' => 'US' }, { 'premium' => true }]
})
puts "cond_and=#{cond4}"

# 4. Context: feature flags and experiment running
gb = Growthbook::Context.new(
  attributes: { 'id' => 'user-abc', 'country' => 'US' },
  features: {
    'dark_mode' => {
      'defaultValue' => false,
      'rules' => [
        {
          'condition' => { 'country' => 'US' },
          'force' => true
        }
      ]
    },
    'button_color' => {
      'defaultValue' => 'blue',
      'rules' => []
    }
  }
)

puts "dark_mode_on=#{gb.on?('dark_mode')}"
puts "dark_mode_off=#{gb.off?('dark_mode')}"
puts "button_color=#{gb.feature_value('button_color', 'gray')}"
puts "missing_feature=#{gb.feature_value('nonexistent', 'fallback')}"

# 5. Inline experiment running
exp = Growthbook::InlineExperiment.new(
  key: 'color-test',
  variations: ['red', 'blue', 'green'],
  coverage: 1.0
)
result = gb.run(exp)
puts "exp_in_experiment=#{result.in_experiment}"
puts "exp_value_string=#{result.value.is_a?(String)}"
puts "exp_variation_valid=#{[0,1,2].include?(result.variation_id)}"

# 6. Feature eval result has source info
fr = gb.eval_feature('dark_mode')
puts "feature_source=#{fr.source}"
puts "feature_on=#{fr.on}"

# 7. Padded version string comparison (semver logic)
v1 = Growthbook::Conditions.padded_version_string("1.0.0")
v2 = Growthbook::Conditions.padded_version_string("1.0.0-beta")
puts "semver_release_gt_prerelease=#{v1 > v2}"
