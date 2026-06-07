require 'db_fixtures_dump'

# Verify version constant
puts DbFixturesDump::VERSION

# The gem's core logic is a rake task that builds fixture YAML from AR models.
# We replicate the key data-transformation logic from the rake task in isolation:
# building the output hash (keyed as "Model_N") and serialising to YAML.

require 'yaml'

# Simulate the fixture-building loop from db_fixtures_dump.rake
def build_fixtures(model_name, rows)
  output = {}
  increment = 1
  rows.each do |attrs|
    attrs_clean = attrs.reject { |_k, v| v.nil? }
    output["#{model_name}_#{increment}"] = attrs_clean
    increment += 1
  end
  output
end

rows = [
  { "id" => 1, "name" => "Alice", "email" => "alice@example.com", "age" => nil },
  { "id" => 2, "name" => "Bob",   "email" => "bob@example.com",   "age" => 30  },
]

fixtures = build_fixtures("User", rows)
puts fixtures.keys.sort.inspect
puts fixtures["User_1"].inspect
puts fixtures["User_2"]["age"]

# YAML round-trip (the rake task uses to_yaml)
yaml_text = fixtures.to_yaml
reloaded  = YAML.safe_load(yaml_text)
puts reloaded["User_1"]["name"]
puts reloaded["User_2"]["name"]
puts reloaded.keys.sort.inspect
