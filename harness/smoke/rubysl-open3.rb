require 'open3'

# capture2: capture stdout of a command given stdin
out, status = Open3.capture2("cat", stdin_data: "hello open3\n")
puts out.chomp
puts status.success? ? "exit:ok" : "exit:fail"

# capture3: stdout, stderr, status
out2, err2, st2 = Open3.capture3("ruby", "-e", "puts 'computed:' + (6*7).to_s; $stderr.puts 'err-line'")
puts out2.chomp
puts err2.chomp
puts st2.exitstatus == 0 ? "status:0" : "status:nonzero"

# popen3 block form: write to stdin, read stdout
Open3.popen3("cat") do |stdin, stdout, stderr, wait_thr|
  stdin.write("popen3-works\n")
  stdin.close
  puts stdout.read.chomp
  puts wait_thr.value.success? ? "wait:ok" : "wait:fail"
end

# capture2e: merged stdout+stderr
merged, st3 = Open3.capture2e("ruby", "-e", "print 'merged'")
puts merged
puts st3.success? ? "merge:ok" : "merge:fail"
