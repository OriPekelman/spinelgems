require 'markdown-tables'

# Test 1: make_table with column-oriented data (is_rows: false)
labels = ['Name', 'Age', 'City']
data = [
  ['Alice', 'Bob', 'Carol'],
  [30, 25, 35],
  ['New York', 'London', 'Paris']
]
table = MarkdownTables.make_table(labels, data, align: 'l', is_rows: false)
puts table
puts "---"

# Test 2: make_table with row-oriented data (is_rows: true)
labels2 = ['Product', 'Price', 'Stock']
data2 = [
  ['Widget', 9.99, 100],
  ['Gadget', 24.99, 50],
  ['Doohickey', 4.99, 200]
]
table2 = MarkdownTables.make_table(labels2, data2, align: ['l', 'r', 'c'], is_rows: true)
puts table2
puts "---"

# Test 3: make_table with center alignment (default)
labels3 = ['A', 'B']
data3 = [['x|y', 'z'], ['1', '2']]
table3 = MarkdownTables.make_table(labels3, data3, is_rows: true)
puts table3
puts "---"

# Test 4: plain_text round-trip
plain = MarkdownTables.plain_text(table)
puts plain
puts "---"

# Test 5: plain_text on the second table
plain2 = MarkdownTables.plain_text(table2)
puts plain2
