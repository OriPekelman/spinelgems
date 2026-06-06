# Smoke test for capistrano-upload-config
# The main entry point (capistrano-upload-config.rb) is empty;
# the real module lives in capistrano/upload-config.rb but that file
# tries to load a .rake file with Capistrano DSL at the top level.
# We load only the pure-Ruby Helpers class by defining the module
# and require-patching to skip the rake load.

# Prevent the `load` call inside upload-config.rb from actually loading
# the rake file (Capistrano rake DSL not available in plain Ruby).
module Kernel
  alias_method :__orig_load__, :load
  def load(path, *args)
    # Skip Capistrano rake task files
    return if path.to_s.end_with?('.rake')
    __orig_load__(path, *args)
  end
end

require 'capistrano/upload-config'

h = CapistranoUploadConfig::Helpers

# Test 1: config with extension, simple path
result = h.get_config_name('config/database.yml', 'production', '.')
puts result
# Expected: config/database.production.yml

# Test 2: config with extension, staging
result2 = h.get_config_name('config/secrets.yml', 'staging', '.')
puts result2
# Expected: config/secrets.staging.yml

# Test 3: config WITHOUT extension
result3 = h.get_config_name('config/env', 'production', '.')
puts result3
# Expected: config/env.production

# Test 4: local_base_dir is different from '.'
result4 = h.get_config_name('shared/database.yml', 'qa', '/apps/myapp')
puts result4
# Expected: /apps/myapp/shared/database.qa.yml

# Test 5: nested path with local_base_dir
result5 = h.get_config_name('config/deploy/credentials.json', 'production', '/var/www')
puts result5
# Expected: /var/www/config/deploy/credentials.production.json
