# Smoke: envin — env-var-to-YAML converter
# active_support is not available; stub deep_merge so converter.rb loads.
# Then exercise build_child_split and build_yaml_from_env directly.

# Stub the active_support require so converter.rb can load.
module ActiveSupport; end
$LOADED_FEATURES << 'active_support/core_ext/hash/deep_merge'
class Hash
  def deep_merge(other)
    merge(other) { |_key, old, new_val|
      old.is_a?(Hash) && new_val.is_a?(Hash) ? old.deep_merge(new_val) : new_val
    }
  end
end

require 'envin'
require 'envin/converter'

# --- build_child_split ---
# Single-level nested key: "APP__DB__HOST" splits to ["APP", "DB", "HOST"]
# After stripping prefix the caller passes key_split = ["db", "host"] with value "localhost"
lines1, _coll = Envin::Converter.build_child_split(["db", "host"], "localhost", [], 0)
puts lines1.strip

# Two-level nesting: ["section", "sub", "key"]
lines2, _coll2 = Envin::Converter.build_child_split(["section", "sub", "key"], "42", [], 0)
puts lines2.strip

# --- build_yaml_from_env ---
# Set synthetic env vars with prefix ENVIN_SMOKE_
ENV["ENVIN_SMOKE_PORT"] = "8080"
ENV["ENVIN_SMOKE_DB__HOST"] = "db.local"
ENV["ENVIN_SMOKE_DB__PORT"] = "5432"

result = Envin::Converter.build_yaml_from_env("ENVIN_SMOKE_")
puts result["port"]
puts result["db"]["host"]
puts result["db"]["port"]
