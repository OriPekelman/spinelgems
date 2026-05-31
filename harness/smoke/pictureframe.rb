puts Pictureframe::VERSION
puts Pictureframe.expandLine("| | ", " | |", " ", 20, "hello")
puts Pictureframe.breakText("helloworld", 5).inspect
lines = Pictureframe.frame("hi")
puts lines.length
puts lines[0]
puts lines[2]
