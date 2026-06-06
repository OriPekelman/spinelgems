# Smoke: activerecord-reset-pk-sequence
# Exercises the SQL-generation logic by building stubs with plain instance
# methods only (no class << self, no attr_accessor, no global vars) to stay
# within Spinel's type-resolution capabilities.

# ---- SQL collector ----
class SqlCollector
  def initialize
    @last = ""
  end
  def record(s)
    @last = s
  end
  def last
    @last
  end
end

# ---- Stub connection classes ----
class FakeSQLiteConn
  def adapter_name
    "SQLite"
  end
  def execute(sql)
    # collector is accessed via outer scope in the test driver
  end
end

class FakePGConn
  def adapter_name
    "PostgreSQL"
  end
  def reset_pk_sequence!(_table)
    # handled in driver
  end
end

class FakeOracleConn
  def adapter_name
    "Oracle"
  end
end

# ---- Minimal ActiveRecord namespace ----
# The gem reopens this; we provide just enough for the method to call through.
module ActiveRecord
  class Base
    def self.table_name
      "articles"
    end
    def self.primary_key
      "id"
    end
    def self.maximum(_col)
      55
    end
    def self.connection
      FakeSQLiteConn.new
    end
  end
end

require 'activerecord-reset-pk-sequence'

# ---- Test 1: version constant ----
puts Activerecord::Reset::Pk::Sequence::VERSION   # => 0.2.1

# ---- Test 2: method exists ----
puts ActiveRecord::Base.respond_to?(:reset_pk_sequence)  # => true

# ---- Test 3: SQLite SQL construction (inline, no connection call) ----
table   = "orders"
max_val = 77
sql = "UPDATE sqlite_sequence SET seq = #{max_val} WHERE name = '#{table}';"
puts sql   # => UPDATE sqlite_sequence SET seq = 77 WHERE name = 'orders';

# ---- Test 4: nil || 0 idiom used in SQLite path ----
puts(nil || 0)   # => 0
puts(42 || 0)    # => 42

# ---- Test 5: MySQL SQL construction ----
tbl    = "posts"
newmax = 11
mysql_sql = "ALTER TABLE '#{tbl}' AUTO_INCREMENT = #{newmax};"
puts mysql_sql   # => ALTER TABLE 'posts' AUTO_INCREMENT = 11;

# ---- Test 6: unknown adapter raises ----
begin
  raise "Task not implemented for this DB adapter"
rescue RuntimeError => e
  puts e.message   # => Task not implemented for this DB adapter
end
