# Smoke test for atomos - tests ArgumentError raised for invalid call signatures
# The actual atomic_write requires tempfile (stdlib), so we exercise the error guard path

begin
  Atomos.atomic_write('/tmp/atomos_test.txt', 'hello') { |f| f.write('world') }
rescue ArgumentError => e
  puts "ArgumentError: #{e.message}"
end

begin
  Atomos.atomic_write('/tmp/atomos_test.txt')
rescue ArgumentError => e
  puts "ArgumentError: #{e.message}"
end

puts "Atomos module exists: #{Atomos.is_a?(Module)}"
