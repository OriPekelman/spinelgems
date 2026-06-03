# Smoke: order_as_specified gem — stub Arel to exercise module logic without ActiveRecord
# Tests: extract_params recursion, case/range/eq branching, Error class, order_as_specified flow

# Minimal Arel stubs so the gem loads and its logic runs
module Arel
  module Nodes
    class Case
      def initialize; @conditions = []; @thens = []; end
      attr_reader :conditions
      def when(cond); @pending = cond; self; end
      def then(val);  @conditions << [@pending, val]; self; end
      def else(val);  @else = val; self; end
      def to_sql
        parts = @conditions.map { |c, v| "WHEN #{c} THEN #{v}" }
        "CASE #{parts.join(' ')} ELSE #{@else} END"
      end
    end
    class Ascending
      def initialize(expr); @expr = expr; end
      def to_sql; "#{@expr.to_sql} ASC"; end
    end
    class DistinctOn
      def initialize(expr); @expr = expr; end
      def to_sql; "DISTINCT ON (#{@expr.to_sql})"; end
    end
  end

  class Attribute
    def initialize(table, name); @table = table; @name = name; end
    def eq(val);      "\"#{@table}\".\"#{@name}\" = #{val.inspect}"; end
    def matches(val); "\"#{@table}\".\"#{@name}\" ILIKE #{val.inspect}"; end
    def between(rng); "\"#{@table}\".\"#{@name}\" BETWEEN #{rng.first} AND #{rng.last}"; end
  end

  class Table
    def initialize(name); @name = name; end
    def [](col); Attribute.new(@name, col); end
    def grouping(node); node; end
    attr_reader :name
  end
end

require 'order_as_specified'

# A minimal ActiveRecord-like host class
class FakeRecord
  extend OrderAsSpecified

  def self.table_name; "records"; end

  def self.order(expr)
    @last_order = expr
    self
  end
  def self.last_order; @last_order; end

  def self.select(sql)
    @last_select = sql
    self
  end
  def self.last_select; @last_select; end

  def self.all; :all_records; end

  def self.connection
    obj = Object.new
    def obj.quote_table_name(n); "\"#{n}\""; end
    obj
  end
end

# --- Test 1: basic ordering by integer values ---
FakeRecord.order_as_specified(id: [3, 1, 2])
sql = FakeRecord.last_order.to_sql
puts "order_sql_contains_CASE: #{sql.include?('CASE')}"
puts "order_sql_contains_ASC: #{sql.include?('ASC')}"
when_count = sql.scan('WHEN').length
puts "when_count: #{when_count}"

# --- Test 2: case_insensitive option uses ILIKE ---
FakeRecord.order_as_specified(name: %w[alice bob], case_insensitive: true)
sql2 = FakeRecord.last_order.to_sql
puts "case_insensitive_uses_ILIKE: #{sql2.include?('ILIKE')}"

# --- Test 3: nested hash (associated table) ---
FakeRecord.order_as_specified(other_records: { id: [10, 20] })
sql3 = FakeRecord.last_order.to_sql
puts "nested_table_in_sql: #{sql3.include?('other_records')}"

# --- Test 4: empty values returns :all ---
result = FakeRecord.order_as_specified(id: [])
puts "empty_values_returns_all: #{result == :all_records}"

# --- Test 5: Error raised for bad params hash (more than 1 key) ---
begin
  FakeRecord.order_as_specified(id: [1], name: [2])
  puts "no_error_raised"
rescue OrderAsSpecified::Error => e
  puts "parse_error: #{e.message}"
end

# --- Test 6: Error raised for descending Range ---
begin
  FakeRecord.order_as_specified(id: [5..1])
  puts "no_range_error"
rescue OrderAsSpecified::Error => e
  puts "range_error: #{e.message}"
end

# --- Test 7: Error class is a StandardError ---
puts "error_is_standard_error: #{OrderAsSpecified::Error.ancestors.include?(StandardError)}"

# --- Test 8: VERSION ---
puts "version: #{OrderAsSpecified::VERSION}"
