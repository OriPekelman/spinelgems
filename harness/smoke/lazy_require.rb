require 'lazy_require'
require 'tmpdir'

# Test VERSION constant
puts LazyRequire::VERSION

# Create temp dir with Ruby files that have a dependency ordering issue:
# child.rb references Parent class, parent.rb defines it.
# LazyRequire should handle loading them in any order.
dir = Dir.mktmpdir('lazy_require_smoke')
begin
  parent_file = File.join(dir, 'parent.rb')
  child_file  = File.join(dir, 'child.rb')

  File.write(parent_file, <<~RUBY)
    class SmokeParent
      def self.greet; "hello from parent"; end
    end
  RUBY

  File.write(child_file, <<~RUBY)
    class SmokeChild < SmokeParent
      def self.greet; "hello from child -> " + super; end
    end
  RUBY

  # Test LazyRequire.require with array (dependency-aware retry logic)
  # child.rb is listed first but depends on parent.rb — LazyRequire retries
  result = LazyRequire.require([child_file, parent_file])
  puts result.inspect

  # Both classes should now be defined
  puts SmokeParent.greet
  puts SmokeChild.greet

  # Test require_all with glob
  dir2 = Dir.mktmpdir('lazy_require_smoke2')
  begin
    File.write(File.join(dir2, 'a.rb'), "SMOKE_A = 42\n")
    File.write(File.join(dir2, 'b.rb'), "SMOKE_B = SMOKE_A * 2\n")

    # b.rb depends on a.rb — glob order may list b first
    result2 = LazyRequire.require_all(File.join(dir2, '*.rb'))
    puts result2.inspect
    puts SMOKE_A
    puts SMOKE_B
  ensure
    FileUtils.remove_entry(dir2)
  end
ensure
  FileUtils.remove_entry(dir)
end
