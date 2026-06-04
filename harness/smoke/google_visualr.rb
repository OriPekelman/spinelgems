require 'json'
require 'google_visualr'

# 1. Build a DataTable with string + number columns
dt = GoogleVisualr::DataTable.new
dt.new_column('string', 'Name')
dt.new_column('number', 'Score')
dt.add_row(['Alice', 95])
dt.add_row(['Bob',   82])
dt.add_row(['Carol', 78])

puts "cols: #{dt.cols.size}"
puts "rows: #{dt.rows.size}"

# 2. get_cell / get_row round-trips
puts "cell(0,0): #{dt.get_cell(0, 0)}"
puts "cell(1,1): #{dt.get_cell(1, 1)}"
puts "row(2): #{dt.get_row(2).inspect}"

# 3. to_js for the DataTable should contain expected fragments
js = dt.to_js
puts "has DataTable: #{js.include?('DataTable()')}"
puts "has Alice: #{js.include?('Alice')}"
puts "has 95: #{js.include?('95')}"

# 4. Build a LineChart and exercise its helper methods
chart = GoogleVisualr::Interactive::LineChart.new(dt, title: 'Test Chart', width: 800, height: 400)
puts "package_name: #{chart.package_name}"
puts "class_name: #{chart.class_name}"
puts "chart_function_name: #{chart.chart_function_name('my-div')}"
puts "version: #{chart.version}"

# 5. to_js for the full chart (load + draw)
chart_js = chart.to_js('my-div')
puts "has script tag: #{chart_js.include?('<script')}"
puts "has linechart: #{chart_js.downcase.include?('linechart')}"
puts "has my-div: #{chart_js.include?('my-div')}"

# 6. PieChart smoke — package name and draw JS
dt2 = GoogleVisualr::DataTable.new
dt2.new_column('string', 'Fruit')
dt2.new_column('number', 'Count')
dt2.add_row(['Apple', 3])
dt2.add_row(['Banana', 7])
pie = GoogleVisualr::Interactive::PieChart.new(dt2)
puts "pie_package: #{pie.package_name}"
pie_js = pie.draw_js('pie-div')
puts "pie_has_fruit: #{pie_js.include?('Apple')}"

# 7. add_listener
chart.add_listener('select', 'function(e){ console.log(e); }')
puts "listeners: #{chart.listeners.size}"
