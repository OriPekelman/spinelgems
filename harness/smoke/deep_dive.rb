require 'deep_dive'

# ---- Define a small object graph ----

class Node
  include DeepDive
  attr_accessor :name, :value, :neighbor, :shared

  def initialize(name, value)
    @name  = name
    @value = value
  end
end

class Container
  include DeepDive
  exclude :shared          # shared ref should NOT be deep-copied

  attr_accessor :label, :items, :meta, :shared

  def initialize(label)
    @label = label
  end
end

# Build graph: n1 <-> n2, both point to shared sentinel
sentinel  = Node.new("sentinel", 999)
n1        = Node.new("n1", 1)
n2        = Node.new("n2", 2)
n1.neighbor = n2
n2.neighbor = n1
n1.shared   = sentinel
n2.shared   = sentinel

container        = Container.new("box")
container.items  = [n1, n2, "plain_string"]
container.meta   = { key: n1, extra: "data" }
container.shared = sentinel   # excluded from deep-copy

# ---- 1. dclone: deep copy creates distinct objects ----
cloned = container.dclone

puts "1. dclone creates new container:  #{cloned.object_id != container.object_id}"
puts "2. cloned label equals original:  #{cloned.label == container.label}"
puts "3. items array is new object:     #{cloned.items.object_id != container.items.object_id}"
puts "4. item[0] (n1) deeply cloned:    #{cloned.items[0].object_id != n1.object_id}"
puts "5. item[2] string preserved:      #{cloned.items[2] == 'plain_string'}"

# Circular references: cloned n1's neighbor should be the cloned n2 (same graph copy)
cloned_n1 = cloned.items[0]
cloned_n2 = cloned.items[1]
puts "6. circular ref preserved:        #{cloned_n1.neighbor.object_id == cloned_n2.object_id}"

# Excluded var: shared should remain the SAME object
puts "7. excluded shared is same obj:   #{cloned.shared.object_id == sentinel.object_id}"

# Hash deep-clone: meta[:key] should be a new object
puts "8. meta hash cloned:              #{cloned.meta[:key].object_id != n1.object_id}"
puts "9. meta[:key] name preserved:     #{cloned.meta[:key].name == 'n1'}"

# ---- 2. ddup: also produces distinct objects ----
duped = n1.ddup
puts "10. ddup is distinct object:      #{duped.object_id != n1.object_id}"
puts "11. ddup name preserved:          #{duped.name == 'n1'}"

# ---- 3. patch: override a specific ivar in the copy ----
replacement = Node.new("replacement", 42)
patched = n1.dclone neighbor: replacement
puts "12. patch replaces neighbor:      #{patched.neighbor.object_id == replacement.object_id}"
puts "13. patch name unchanged:         #{patched.name == 'n1'}"

# ---- 4. Array#dclone and Hash#dclone ----
arr   = [n1, n2, "static"]
carr  = arr.dclone
puts "14. Array#dclone new array:       #{carr.object_id != arr.object_id}"
puts "15. Array element cloned:         #{carr[0].object_id != n1.object_id}"
puts "16. Array static element same:    #{carr[2] == 'static'}"

hsh  = { a: n1, b: "text" }
chsh = hsh.dclone
puts "17. Hash#dclone new hash:         #{chsh.object_id != hsh.object_id}"
puts "18. Hash deep-copied node:        #{chsh[:a].object_id != n1.object_id}"
puts "19. Hash string value preserved:  #{chsh[:b] == 'text'}"

# ---- 5. Verbosity flag ----
DeepDive.verbose = true
puts "20. verbose? is true:             #{DeepDive.verbose? == true}"
DeepDive.verbose = false
puts "21. verbose? is false:            #{DeepDive.verbose? == false}"
