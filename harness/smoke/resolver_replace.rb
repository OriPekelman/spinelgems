# ResolverReplace smoke: exercise class method defined in entrypoint

puts ResolverReplace.name

begin
  ResolverReplace.register!
rescue ArgumentError => e
  puts "ArgumentError caught"
  puts e.message
end
