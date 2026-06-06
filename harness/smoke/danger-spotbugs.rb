# frozen_string_literal: true

# Smoke: danger-spotbugs — exercises BugInstance logic directly.
# Loads gem_version and bug_instance via require_relative (Spinel inlines these).
# Does NOT load spotbugs/plugin (needs Danger::Plugin from the danger framework gem).
# No network, no filesystem, no oga dependency.

require_relative "lib/spotbugs/gem_version"
require_relative "lib/spotbugs/entity/bug_instance"

puts "VERSION: #{Spotbugs::VERSION}"
puts "RANK_ERROR_THRESHOLD: #{BugInstance::RANK_ERROR_THRESHOLD}"

# Minimal duck-type mock for oga XML nodes used by BugInstance internals.
# BugInstance calls:
#   bug_instance.attribute('rank')                        → node-set with .value
#   bug_instance.xpath('SourceLine').attribute('start')   → node-set with .value
#   bug_instance.xpath('SourceLine').attribute('sourcepath') → node-set with .value
#   bug_instance.xpath('LongMessage').text                → String
# get_value_safely(arr, default): arr.compact.empty? / arr.compact.first.value

class FakeAttr
  def initialize(val); @val = val.to_s; end
  def value; @val; end
  def compact; self; end
  def empty?; false; end
  def first; self; end
end

class FakeAbsent
  def attribute(_n); self; end
  def xpath(_e);    self; end
  def compact;      self; end
  def empty?;       true;  end
  def first;        nil;   end
  def text;         '';    end
end

class FakeSourceLine
  def initialize(source_path, start_line)
    @source_path = source_path
    @start_line  = start_line.to_s
  end
  def attribute(name)
    case name.to_s
    when 'sourcepath' then FakeAttr.new(@source_path)
    when 'start'      then FakeAttr.new(@start_line)
    else FakeAbsent.new
    end
  end
end

class FakeLongMessage
  def initialize(msg); @msg = msg; end
  def text; @msg; end
end

class FakeBugNode
  def initialize(rank, source_path, start_line, long_message)
    @rank        = rank.to_s
    @source_line = FakeSourceLine.new(source_path, start_line)
    @long_msg    = FakeLongMessage.new(long_message)
  end
  def attribute(name)
    name.to_s == 'rank' ? FakeAttr.new(@rank) : FakeAbsent.new
  end
  def xpath(expr)
    case expr.to_s
    when 'SourceLine'   then @source_line
    when 'LongMessage'  then @long_msg
    else FakeAbsent.new
    end
  end
end

def make_bug(rank:, source_path:, start_line:, long_message:)
  FakeBugNode.new(rank, source_path, start_line, long_message)
end

# Test 1: rank 10 > 4 → :warn; prefix ending with /
b1 = BugInstance.new(
  '/project/',
  ['/project/src/main/java/com/example/Foo.java'],
  make_bug(rank: 10, source_path: 'com/example/Foo.java', start_line: 42, long_message: 'Null pointer dereference')
)
puts "t1.rank=#{b1.rank}"
puts "t1.type=#{b1.type}"
puts "t1.line=#{b1.line}"
puts "t1.description=#{b1.description}"
puts "t1.absolute_path=#{b1.absolute_path}"
puts "t1.relative_path=#{b1.relative_path}"

# Test 2: rank 2 <= 4 → :fail; prefix without trailing /
b2 = BugInstance.new(
  '/repo',
  ['/repo/src/main/java/com/example/Bar.java'],
  make_bug(rank: 2, source_path: 'com/example/Bar.java', start_line: 7, long_message: 'Synchronization on non-final field')
)
puts "t2.rank=#{b2.rank}"
puts "t2.type=#{b2.type}"
puts "t2.line=#{b2.line}"
puts "t2.description=#{b2.description}"
puts "t2.relative_path=#{b2.relative_path}"

# Test 3: rank exactly at threshold (4) → :fail
b3 = BugInstance.new('/x/', ['/x/src/com/ex/X.java'],
                     make_bug(rank: 4, source_path: 'com/ex/X.java', start_line: 1, long_message: 'Edge'))
puts "t3.rank=#{b3.rank} t3.type=#{b3.type}"

# Test 4: rank just above threshold (5) → :warn
b4 = BugInstance.new('/y/', ['/y/src/com/ex/Y.java'],
                     make_bug(rank: 5, source_path: 'com/ex/Y.java', start_line: 99, long_message: 'Minor'))
puts "t4.rank=#{b4.rank} t4.type=#{b4.type}"

# Test 5: absolute_path not under prefix → relative_path equals absolute_path
b5 = BugInstance.new('/project/', ['/external/path/other/File.java'],
                     make_bug(rank: 3, source_path: 'other/File.java', start_line: 1, long_message: 'Issue'))
puts "t5.relative_path=#{b5.relative_path}"

puts "done"
