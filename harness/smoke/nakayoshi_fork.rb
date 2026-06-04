require 'nakayoshi_fork'

# 1. VERSION constant is accessible
puts NakayoshiFork::VERSION

# 2. The Behavior module is prepended to Object
puts Object.ancestors.include?(NakayoshiFork::Behavior)

# 3. Object (and by extension every object) now has the overridden fork method
# We verify the method is present and comes from NakayoshiFork::Behavior
owner = Object.instance_method(:fork).owner rescue nil
puts owner == NakayoshiFork::Behavior

# 4. GC.stat returns a Hash with the keys the module expects
h = {}
GC.stat(h)
has_live_slots = h.key?(:heap_live_slots) || h.key?(:heap_live_slot)
puts has_live_slots

# 5. Exercise the GC loop logic directly (mirrors what fork does internally):
#    Run up to 4 minor GC cycles while young_objects >= live_slots/10
h2 = {}
4.times do |i|
  GC.stat(h2)
  live_slots   = h2[:heap_live_slots] || h2[:heap_live_slot]
  old_objects  = h2[:old_objects]     || h2[:old_object]
  remwb        = h2[:remembered_wb_unprotected_objects] || h2[:remembered_shady_object]
  young_objects = live_slots - old_objects - remwb

  if young_objects < live_slots / 10
    puts "gc_loop_early_exit_at_#{i}"
    break
  end

  GC.start(full_mark: false)
end

# 6. fork with nakayoshi: false skips the GC loop — use a pipe to capture
#    child output without letting the child write to the parent's stdout.
rd, wr = IO.pipe
pid = fork(nakayoshi: false) do
  wr.close
  # child: just signal we ran
  rd.close
  # write via the write-end we kept open before reassigning
end
# This branch only reached in parent
wr.close
Process.waitpid(pid)
rd.close
puts "fork_nakayoshi_false_ok"

# 7. fork with default (nakayoshi: true) — same pattern
rd2, wr2 = IO.pipe
pid2 = fork do
  wr2.close
  rd2.close
end
wr2.close
Process.waitpid(pid2)
rd2.close
puts "fork_nakayoshi_true_ok"
