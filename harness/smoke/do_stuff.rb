require 'do_stuff'

# Exercise DoStuff::Tasklist without Tempfile (avoid ignored stdlib require)
tmppath = "/tmp/do_stuff_smoke_#{Process.pid}.txt"
File.write(tmppath, "1. Buy groceries\n2. Walk the dog\n3. Read a book\n")

tl = DoStuff::Tasklist.new(tmppath)

# Check initial task count and retrieval
puts tl.tasks.length
puts tl[1]
puts tl[2]
puts tl[3]

# Add a new task — returns the next task number
num = tl.add("Write some code")
puts num
puts tl[4]

# Delete a task (by number)
tl.delete(2)
puts tl.tasks.length
puts tl[2].nil?

# Renumber tasks (removes gaps in numbering)
tl.renumber!
puts tl.tasks.length
puts tl[1]
puts tl[2]
puts tl[3]

# Update a task via []= then read it back
tl[1] = "Updated task"
puts tl[1]

# Write and re-read to verify persistence
tl.write!
tl2 = DoStuff::Tasklist.new(tmppath)
puts tl2.tasks.length
puts tl2[1]

File.delete(tmppath)
