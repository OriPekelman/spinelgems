puts Overpunch.parse("{")        # 0 (positive zero)
puts Overpunch.parse("12A")      # 121
puts Overpunch.parse("5J")       # -51
puts Overpunch.parse("007R")     # 79
puts Overpunch.format(0)         # "{"
puts Overpunch.format(121)       # "12A"
puts Overpunch.format(-51)       # "5J"
puts Overpunch.format(79, width: 5)  # "0007R"
