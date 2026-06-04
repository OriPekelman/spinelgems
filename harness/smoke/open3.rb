# frozen_string_literal: true
# Smoke: open3 - exercises capture3, capture2, capture2e, popen3

require 'open3'

# 1. capture3: stdout, stderr, and exit status
stdout, stderr, status = Open3.capture3('echo', 'hello world')
puts "capture3 stdout: #{stdout.chomp}"
puts "capture3 stderr empty: #{stderr.empty?}"
puts "capture3 success: #{status.success?}"

# 2. capture3 with stdin_data via tee
out2, err2, st2 = Open3.capture3('cat', stdin_data: "line1\nline2\n")
puts "capture3 stdin_data lines: #{out2.lines.count}"
puts "capture3 stdin_data success: #{st2.success?}"

# 3. capture2: only stdout
out3, st3 = Open3.capture2('printf', '%s\n', 'alpha', 'beta')
puts "capture2 lines: #{out3.lines.count}"
puts "capture2 success: #{st3.success?}"

# 4. capture2e: merged stdout+stderr
out4, st4 = Open3.capture2e('sh', '-c', 'echo out; echo err >&2')
lines4 = out4.lines.map(&:chomp).sort
puts "capture2e merged: #{lines4.join(',')}"
puts "capture2e success: #{st4.success?}"

# 5. popen3 with block: write to stdin, read stdout
Open3.popen3('sort') do |i, o, e, t|
  i.write("banana\napple\ncherry\n")
  i.close
  result = o.read.chomp
  puts "popen3 sort: #{result}"
  puts "popen3 exit: #{t.value.success?}"
end

# 6. Exit status of a failing command
_, _, st5 = Open3.capture3('sh', '-c', 'exit 42')
puts "capture3 exit code: #{st5.exitstatus}"
