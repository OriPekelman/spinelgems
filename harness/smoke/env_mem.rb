require 'env_mem'

# gc_stat_to_shell: parses a GC.stat-like string and produces shell export lines.
# Exercise with a realistic GC stat string (same format GC.stat.inspect produces).
stat_str = "{:heap_live_slots=>12345, :heap_free_slots=>678, :total_allocated_objects=>99999}"
result = EnvMem.gc_stat_to_shell(stat_str)

# Verify heap_live_slots value is extracted and placed correctly
if result.include?("RUBY_GC_HEAP_INIT_SLOTS=12345")
  puts "gc_stat_to_shell: RUBY_GC_HEAP_INIT_SLOTS correctly set to 12345"
else
  puts "gc_stat_to_shell: unexpected result"
  puts result.strip
end

# Verify the static export lines are present
puts "has RUBY_GC_MALLOC_LIMIT: #{result.include?('RUBY_GC_MALLOC_LIMIT')}"
puts "has RUBY_GC_OLDMALLOC_LIMIT: #{result.include?('RUBY_GC_OLDMALLOC_LIMIT')}"

# Edge case: empty string should produce blank slots (no match -> missing key -> 0)
empty_result = EnvMem.gc_stat_to_shell("")
puts "empty stat has RUBY_GC_HEAP_INIT_SLOTS=: #{empty_result.include?('RUBY_GC_HEAP_INIT_SLOTS=')}"

# Second value
stat2 = "{:heap_live_slots=>42, :heap_free_slots=>10}"
result2 = EnvMem.gc_stat_to_shell(stat2)
puts "heap_live_slots=42: #{result2.include?('RUBY_GC_HEAP_INIT_SLOTS=42')}"
