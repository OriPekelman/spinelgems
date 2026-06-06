require 'adiwg-mdjson_schemas'
require 'adiwg/mdjson_schemas/utils'

# --- 1. Version ---
puts ADIWG::MdjsonSchemas::VERSION

# --- 2. Path helpers return non-empty strings ending with expected names ---
sp = ADIWG::MdjsonSchemas::Utils.schema_path
puts File.basename(sp)               # schema.json
puts File.exist?(sp)                 # true

sd = ADIWG::MdjsonSchemas::Utils.schema_dir
puts File.basename(sd.chomp('/'))    # schema
puts File.directory?(sd)             # true

ed = ADIWG::MdjsonSchemas::Utils.examples_dir
puts File.basename(ed.chomp('/'))    # examples
puts File.directory?(ed)             # true

# --- 3. load_json reads the top-level schema.json and returns a Hash ---
data = ADIWG::MdjsonSchemas::Utils.load_json(sp)
puts data.class                      # Hash
puts data['version']                 # 2.10.2
puts data['type']                    # object
puts data['required'].sort.inspect   # ["contact", "schema"]

# --- 4. load_strict applies additionalProperties=false to a schema ---
strict = ADIWG::MdjsonSchemas::Utils.load_strict('contact.json')
puts strict.class                    # Hash
puts strict['additionalProperties']  # false
puts strict['required'].include?('contactId')  # true (contact.json has contactId in properties)
