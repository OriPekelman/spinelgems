require 'yaml2json'
require 'yaml'
require 'json'

# The gem is a CLI YAML-to-JSON converter. Its library exports only
# Yaml2json::VERSION; the conversion logic lives in bin/yaml2json and
# uses stdlib yaml + json, which we exercise here directly.

puts Yaml2json::VERSION

# Exercise YAML -> JSON round-trip (the gem's sole purpose)
yaml_src = <<~YAML
  name: Alice
  age: 30
  tags:
    - ruby
    - json
  active: true
YAML

data = YAML.safe_load(yaml_src)
puts JSON.dump(data)

# Multi-document YAML stream (what YAML.load_stream handles in bin/yaml2json)
yaml_multi = "---\nfoo: 1\n---\nbar: 2\n"
docs = []
YAML.load_stream(yaml_multi) { |d| docs << JSON.dump(d) }
docs.each { |line| puts line }

# Nested structure
nested_yaml = "matrix:\n  - [1, 2]\n  - [3, 4]\n"
puts JSON.dump(YAML.safe_load(nested_yaml))
