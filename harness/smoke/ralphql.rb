# frozen_string_literal: true

require 'ralphql'

# Smoke 1: simple node with attributes
node = Ralphql::Node.new(:user, atts: [:id, :name, :email])
puts node.query

# Smoke 2: node with arguments (integer and string)
node2 = Ralphql::Node.new(:product, args: { id: 42, status: 'active' }, atts: [:title, :price])
puts node2.query

# Smoke 3: nested nodes
parent = Ralphql::Node.new(:orders, atts: [:total_amount])
child = Ralphql::Node.new(:line_items, atts: [:product_id, :quantity])
parent.add(child)
puts parent.query

# Smoke 4: add_node helper
root = Ralphql::Node.new(:company, atts: [:name])
root.add_node(:employees, atts: [:first_name, :last_name, :department])
puts root.query

# Smoke 5: paginated node
paginated = Ralphql::Node.new(:posts, atts: [:title, :body], paginated: true)
puts paginated.query

# Smoke 6: EmptyNodeError for node with no body and no args
begin
  empty = Ralphql::Node.new(:nothing)
  empty.query
rescue Ralphql::EmptyNodeError
  puts "EmptyNodeError raised"
end

# Smoke 7: to_ralphql on core types
puts [1, 2, 3].to_ralphql
puts({ name: 'Alice', age: 30 }.to_ralphql)
