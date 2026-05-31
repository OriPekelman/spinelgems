puts "true".to_bool.inspect
puts "false".to_bool.inspect
begin
  "maybe".to_bool
rescue ArgumentError => e
  puts e.message
end
begin
  "yes".to_bool
rescue ArgumentError => e
  puts e.message
end
