# Smoke: activerecord-fast-import
# Verifies the gem patches ActiveRecord::Base with the expected class methods.
# No DB connection needed — just checks method presence on the patched class.

methods = [:truncate_table, :disable_keys, :enable_keys,
           :with_keys_disabled, :fast_import,
           :load_data_infile_multiple, :load_data_infile]

methods.each do |m|
  puts "#{m}: #{ActiveRecord::Base.respond_to?(m)}"
end

puts ActiveRecord.is_a?(Module)
puts ActiveRecord::Base.is_a?(Class)
