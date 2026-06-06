# frozen_string_literal: true
require 'loady'
require 'tmpdir'

# --- Exercise AttributeArray directly (no file I/O) ---
aa = Loady::AttributeArray.new(['  Alice ', '  30 ', 'engineer'])

# to_attributes with strip (default)
attrs = aa.to_attributes([:name, :age, :role])
puts attrs[:name]   # "Alice"
puts attrs[:age]    # "30"
puts attrs[:role]   # "engineer"

# to_attributes with strip disabled
attrs_raw = aa.to_attributes([:name, :age], strip: false)
puts attrs_raw[:name].inspect   # "  Alice "

# partial mapping (more names than elements)
aa2 = Loady::AttributeArray.new(['x', 'y'])
attrs2 = aa2.to_attributes([:a, :b, :c])
puts attrs2[:a]          # "x"
puts attrs2[:b]          # "y"
puts attrs2[:c].inspect  # nil

# --- MemoryLogger ---
log = Loady::MemoryLogger.new
log.info("row loaded")
log.warn("skipped something")
log.error("oops")
puts log.messages.length       # 3
puts log.messages.first        # "row loaded"

# --- CsvLoader via temp file ---
csv_data = "name,age\nBob,25\nCarol,40\n"
tmpfile = File.join(Dir.tmpdir, "loady_smoke_#{Process.pid}.csv")
File.write(tmpfile, csv_data)

logger = Loady::MemoryLogger.new
rows = []
Loady.read(tmpfile, headers: true, logger: logger) do |row|
  rows << row.to_attributes([:name, :age])
end
File.delete(tmpfile)

puts rows.length                   # 2
puts rows[0][:name]                # "Bob"
puts rows[1][:name]                # "Carol"
puts logger.messages.last          # Finished. Loaded 2 rows. 0 skipped rows.
