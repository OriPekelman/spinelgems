# OrmDev::Error is defined inline in lib/ormdev.rb (no external deps needed)
puts OrmDev::Error.superclass
puts OrmDev::Error.new("test error").message
puts OrmDev::Error.ancestors.include?(StandardError)
