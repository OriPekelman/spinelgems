require 'clenver'
require 'clenver/logging'
require 'clenver/link'
require 'clenver/command_executor'
require 'clenver/package_manager'

# 1. VERSION constant
puts Clenver::VERSION

# 2. Logging module — configure a logger and use it
class MyWorker
  include Logging
end

w = MyWorker.new
puts w.logger.progname

# 3. Link — accessors and MAX_REPEAT constant
lnk = Link.new('/tmp/clenver_src', ['/tmp/clenver_dst'])
puts lnk.src
puts lnk.dst.inspect
puts Link::MAX_REPEAT

# 4. PackageManger — accessors (do NOT call install; it runs sudo/system cmds)
pm = PackageManger.new('gem', 'rake minitest')
puts pm.pkgs

# 5. CommandExecutor — run a harmless command and capture output
ce = CommandExecutor.new('echo hello_clenver')
# execute calls %x[cmd] and logger.info; redirect stdout to capture it
require 'stringio'
old_stdout = $stdout
$stdout = StringIO.new
ce.execute
$stdout = old_stdout
puts "executor_ok"
