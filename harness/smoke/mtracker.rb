# mtracker smoke: module structure (no VERSION — mtracker/version uses bare require)
puts Mtracker.is_a?(Module)
puts Mtracker.instance_methods(false).sort.inspect
