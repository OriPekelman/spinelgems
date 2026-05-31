# capistrano-npm: Capistrano/Rake plugin; lib/capistrano-npm.rb is empty.
# The gem defines no standalone module/class — all logic lives in a .rake file
# that depends on the Rake DSL.  We can only confirm the entrypoint loads.
puts "capistrano-npm entrypoint loaded"
puts defined?(Capistrano).inspect
puts defined?(Rake).inspect
