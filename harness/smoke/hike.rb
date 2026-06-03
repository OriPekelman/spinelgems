require 'hike'
require 'tmpdir'

# Test Extensions normalization
ext = Hike::Extensions.new
ext.push "rb", ".js", "css"
puts ext.sort.inspect

# Test Paths normalization with explicit root
paths = Hike::Paths.new("/usr/local")
paths.push "lib"
paths.push "/tmp"
puts paths.inspect

# Test Trail#root and collection accessors
trail = Hike::Trail.new("/tmp")
puts trail.root

trail.append_extensions(".rb", ".js")
puts trail.extensions.inspect

# Test alias_extension / unalias_extension
trail2 = Hike::Trail.new("/tmp")
trail2.alias_extension("htm", "html")
trail2.alias_extension("xhtml", "html")
puts trail2.aliases.keys.sort.inspect
trail2.unalias_extension("htm")
puts trail2.aliases.keys.sort.inspect

# Test find / find_all using real temp files on disk
Dir.mktmpdir("hike_smoke") do |dir|
  lib = File.join(dir, "lib")
  Dir.mkdir(lib)
  File.write(File.join(lib, "foo.rb"), "# foo")
  File.write(File.join(lib, "bar.js"), "// bar")

  t = Hike::Trail.new(dir)
  t.append_paths("lib")
  t.append_extensions(".rb", ".js")

  puts t.find("foo")&.end_with?("foo.rb") ? "found foo.rb" : "MISSING foo.rb"
  puts t.find("bar")&.end_with?("bar.js") ? "found bar.js" : "MISSING bar.js"
  puts t.find("missing").nil? ? "nil for missing" : "WRONG"

  all = t.find_all("foo").to_a
  puts all.length == 1 ? "find_all single" : "find_all WRONG"
end
