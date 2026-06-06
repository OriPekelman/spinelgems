# Smoke for activerecord-mysql-adapter-flags 0.0.3
# Patches ActiveRecord::ConnectionAdapters::MysqlAdapter with MySQL client
# flag support (from database.yml) and adds session_status method.
#
# The gem requires 'active_record/connection_adapters/mysql_adapter' at load
# time. Under CRuby without ActiveRecord this raises LoadError; the smoke
# stubs that require so the gem body can be evaluated, matching what Spinel
# does (external requires are no-ops).

require 'pathname'

# Stub the external mysql_adapter require so the gem loads without ActiveRecord
module Kernel
  alias_method :_orig_require, :require
  def require(path)
    return false if path == 'active_record/connection_adapters/mysql_adapter'
    _orig_require(path)
  end
end

require 'activerecord-mysql-adapter-flags'

# The monkey-patch should have added session_status to MysqlAdapter
puts ActiveRecord::ConnectionAdapters::MysqlAdapter
  .instance_methods(false)
  .include?(:session_status)
# => true

# initialize is private so won't appear in instance_methods; verify via
# instance_method which works on private methods too
puts ActiveRecord::ConnectionAdapters::MysqlAdapter
  .instance_method(:initialize)
  .arity
# => 4  (connection, logger, connection_options, config)

# Exercise the flag-parsing logic (replicated from initialize body):
# config[:flags] is split by comma, stripped, upcased, then ORed together
flags_str = 'CLIENT_COMPRESS, CLIENT_FOUND_ROWS'
flag_strings = flags_str.split(',').map { |f| f.to_s.strip.upcase }
puts flag_strings.inspect
# => ["CLIENT_COMPRESS", "CLIENT_FOUND_ROWS"]

# inject/reduce bit-OR of flag integer values
values = [64, 2]
result = values.inject(0) { |val, i| val | i }
puts result
# => 66

# Four flags combined
all_values = [1, 4, 16, 64]
puts all_values.inject(0) { |acc, v| acc | v }
# => 85
