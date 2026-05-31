# Smoke: app_revision - exercise ENV_VARS constant only (defined in main file, dep-free)
puts AppRevision::ENV_VARS.length
puts AppRevision::ENV_VARS.first
puts AppRevision::ENV_VARS.last
puts AppRevision::ENV_VARS.include?('HEROKU_SLUG_COMMIT')
puts AppRevision::ENV_VARS.sort.first
