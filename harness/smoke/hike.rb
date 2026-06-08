# Behaviour smoke for hike (Trail#find path resolution) — spinelgems#16.
# Builds a Trail over two roots, asserts find() resolves to the same absolute
# path under CRuby and Spinel, and that a miss returns nil identically.
require "hike"

trail = Hike::Trail.new("/tmp/hikesmoke")
trail.append_paths("roots/a", "roots/b")
trail.append_extensions(".rb")

# hit in the first root
puts trail.find("x").to_s.sub("/tmp/hikesmoke/", "")
# hit in the second root
puts trail.find("y").to_s.sub("/tmp/hikesmoke/", "")
# miss -> nil
puts trail.find("nope").inspect
# find with explicit extension
puts trail.find("x.rb").to_s.sub("/tmp/hikesmoke/", "")
