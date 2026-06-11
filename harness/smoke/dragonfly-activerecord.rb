# Smoke: dragonfly-activerecord
# Tests only the top-level module structure — defined directly in the entry file,
# no external gem deps required.
puts Dragonfly::ActiveRecord.class
puts Dragonfly::ActiveRecord.is_a?(Module)
puts Dragonfly::ActiveRecord.name
