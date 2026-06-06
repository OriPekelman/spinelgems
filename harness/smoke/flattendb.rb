# smoke: flattendb — relational DB flattener
# Tests Version module, Base column_to_element, MySQL flatten_tables! (in-memory)
# builder/libxml/nuggets are runtime deps not in Spinel load path; stub them.

# Stub 'builder' so flattendb/base can load
$LOADED_FEATURES << 'builder'
module Builder
  class XmlMarkup
    def initialize(opts = {}); end
  end
end

# Stub MySQL-specific deps so flattendb/types/mysql can load
$LOADED_FEATURES << 'libxml'
$LOADED_FEATURES << 'nuggets/mysql'
module LibXML; end
module Nuggets; module MySQL; end; end

require 'flattendb'
require 'flattendb/base'
require 'flattendb/types/mysql'

# --- Version ---
puts FlattenDB::VERSION
puts FlattenDB::Version.to_a.inspect
puts FlattenDB::Version.to_s

# --- Base.column_to_element ---
class TestBase < FlattenDB::Base
  public :column_to_element
  def flatten!; self; end
  def to_xml; ''; end
end

tb = TestBase.new('root' => nil, input: nil, output: nil)
puts tb.column_to_element('valid_column')   # unchanged
puts tb.column_to_element('123starts_num')  # gets leading underscore
puts tb.column_to_element('col-name.sub')   # dash and dot allowed
puts tb.column_to_element('bad chars!@#')   # non-word chars stripped

# --- Base type registry ---
puts FlattenDB::Base.types.keys.sort.map(&:to_s).inspect

# --- MySQL flatten_tables!: join two tables via foreign key ---
m = FlattenDB::MySQL.allocate
m.instance_variable_set(:@root,   'orders')
m.instance_variable_set(:@config, { 'customers' => ['customer_id', 'id'] })
m.instance_variable_set(:@type,   :xml)

tables = {
  'orders'    => [
    { 'id' => '1', 'customer_id' => '10', 'amount' => '42.00' },
    { 'id' => '2', 'customer_id' => '20', 'amount' => '7.50' },
    { 'id' => '3', 'customer_id' => '10', 'amount' => '15.00' },
  ],
  'customers' => [
    { 'id' => '10', 'name' => 'Alice' },
    { 'id' => '20', 'name' => 'Bob' },
  ]
}
m.instance_variable_set(:@tables, tables)
m.send(:flatten_tables!, tables, 'orders', m.instance_variable_get(:@config))

# After flatten, only primary table survives
puts tables.keys.inspect
tables['orders'].sort_by { |r| r['id'] }.each do |row|
  cust = row['customers']
  name = cust ? cust.first['name'] : 'MISSING'
  puts "#{row['id']}: #{name} #{row['amount']}"
end

# --- MySQL flatten_tables!: no matching foreign key → no injection ---
tables2 = {
  'items'    => [{ 'id' => '9', 'tag_id' => '99', 'label' => 'X' }],
  'tags'     => [{ 'id' => '1', 'color' => 'red' }],
}
m2 = FlattenDB::MySQL.allocate
m2.instance_variable_set(:@root,   'items')
m2.instance_variable_set(:@config, { 'tags' => ['tag_id', 'id'] })
m2.instance_variable_set(:@type,   :xml)
m2.instance_variable_set(:@tables, tables2)
m2.send(:flatten_tables!, tables2, 'items', m2.instance_variable_get(:@config))

row = tables2['items'].first
puts row.key?('tags') ? 'injected' : 'not_injected'
