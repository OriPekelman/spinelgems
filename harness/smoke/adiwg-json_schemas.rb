# smoke: adiwg-json_schemas — exercises Utils path helpers and schema file existence
require 'adiwg/json_schemas'

# 1. VERSION constant
puts ADIWG::JsonSchemas::VERSION

# 2. schema_path returns a string ending in schema.json
sp = ADIWG::JsonSchemas::Utils.schema_path
puts sp.end_with?('schema.json') ? 'schema_path:ok' : "schema_path:bad(#{sp})"

# 3. schema_dir returns a directory path ending in /schema/
sd = ADIWG::JsonSchemas::Utils.schema_dir
puts sd.end_with?('/schema/') ? 'schema_dir:ok' : "schema_dir:bad(#{sd})"

# 4. examples_dir returns a directory path ending in /examples/
ed = ADIWG::JsonSchemas::Utils.examples_dir
puts ed.end_with?('/examples/') ? 'examples_dir:ok' : "examples_dir:bad(#{ed})"

# 5. The schema.json file actually exists at the returned path
puts File.exist?(sp) ? 'schema_file:exists' : 'schema_file:missing'

# 6. The schema dir exists
puts File.directory?(sd) ? 'schema_dir:exists' : 'schema_dir:missing'

# 7. Read schema.json and check it parses as JSON with a root key
require 'json'
schema_data = JSON.parse(File.read(sp))
puts schema_data.is_a?(Hash) ? 'schema_json:hash' : "schema_json:unexpected(#{schema_data.class})"
puts schema_data.keys.first(3).sort.inspect
