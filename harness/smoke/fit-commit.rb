require_relative "lib/fit_commit/line"

# FitCommit::Line basics
line1 = FitCommit::Line.new(1, "Fix the bug")
puts line1.lineno
puts line1.text
puts line1.to_s
puts line1.empty?

line2 = FitCommit::Line.new(2, "")
puts line2.lineno
puts line2.empty?

line3 = FitCommit::Line.new(3, "More details here")
puts line3.lineno
puts line3.text
puts line3.empty?
