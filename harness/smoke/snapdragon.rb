require 'snapdragon'
require 'snapdragon/path'  # pulls in FileBase, SpecFile, SpecDirectory, RequireFile

# 1. Plain path (no line number)
p1 = Snapdragon::Path.new('spec/foo_spec.js')
puts p1.path             # spec/foo_spec.js
puts p1.line_number.inspect  # nil
puts p1.has_line_number?     # false

# 2. Path with embedded line number
p2 = Snapdragon::Path.new('spec/bar_spec.js:42')
puts p2.path             # spec/bar_spec.js
puts p2.line_number      # 42
puts p2.has_line_number? # true

# 3. absolute_path expansion
p3 = Snapdragon::Path.new('spec/baz_spec.js')
puts p3.absolute_path.start_with?('/') ? 'absolute' : 'relative'  # absolute

# 4. VERSION constant
puts Snapdragon::VERSION   # 3.0.0

# 5. SpecFile#filtered? based on path with/without line number
sf1 = Snapdragon::SpecFile.new(Snapdragon::Path.new('spec/thing_spec.js:10'))
puts sf1.filtered?   # true

sf2 = Snapdragon::SpecFile.new(Snapdragon::Path.new('spec/thing_spec.js'))
puts sf2.filtered?   # false
