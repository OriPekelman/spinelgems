puts JustPaginate::VERSION
puts JustPaginate.page_value(nil)
puts JustPaginate.page_value(3)
puts JustPaginate.total_page_number(100, 10)
puts JustPaginate.total_page_number(101, 10)
puts JustPaginate.index_range(1, 10, 100).inspect
puts JustPaginate.index_range(2, 10, 100).inspect
puts JustPaginate.page_out_of_bounds?(0, 10, 100)
puts JustPaginate.page_out_of_bounds?(1, 10, 100)
puts JustPaginate.page_out_of_bounds?(11, 10, 100)
