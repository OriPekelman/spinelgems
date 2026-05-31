# smoke: colsole — strip_colors, word_wrap (fixed length), ANSI_COLORS constant
puts Colsole.strip_colors("hello world")
puts Colsole.strip_colors("r`red` and g`green` text")
puts Colsole.strip_colors("nb`bold` stuff")
puts Colsole.word_wrap("This is a fairly long string that should wrap at a specific column width", 40)
puts Colsole::ANSI_COLORS.keys.sort.join(",")
puts Colsole::ANSI_STYLES.keys.sort.join(",")
