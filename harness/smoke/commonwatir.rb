# commonwatir's entry point is lib/watir.rb (not lib/commonwatir.rb).
# It contains only: require 'watir/loader'
# That delegates entirely to the external watir gem — no independent API.
# Smoke: require watir (commonwatir's lib/watir.rb) and catch the LoadError.

begin
  require 'watir'
rescue LoadError => e
  puts "LoadError: #{e.message}"
rescue => e
  puts "#{e.class}: #{e.message}"
end
