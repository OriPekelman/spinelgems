# frozen_string_literal: true
# smoke: pgdump_scrambler — exercises Column, Table, Config public API
require 'shellwords'
require 'pgdump_scrambler'

# Column: valid scramble methods
col_email  = PgdumpScrambler::Config::Column.new('email', 'email')
col_nop    = PgdumpScrambler::Config::Column.new('id', 'nop')
col_digits = PgdumpScrambler::Config::Column.new('phone', 'digits')
col_null   = PgdumpScrambler::Config::Column.new('secret', 'nullify')
col_unspec = PgdumpScrambler::Config::Column.new('notes')

puts col_email.name           # => email
puts col_email.scramble_method # => email
puts col_nop.unspecifiled?    # => false
puts col_unspec.unspecifiled? # => true

# Column#option: nop/unspecified return nil; others return "name:method"
puts col_nop.option.nil?      # => true
puts col_email.option         # => email:email
puts col_digits.option        # => phone:digits

# Column.valid_scramble_method?
puts PgdumpScrambler::Config::Column.valid_scramble_method?('email')  # => true
puts PgdumpScrambler::Config::Column.valid_scramble_method?('bogus')  # => false
puts PgdumpScrambler::Config::Column.valid_scramble_method?('const[FOO]') # => true

# Table: build a table and check options
table_users = PgdumpScrambler::Config::Table.new('users', [col_email, col_nop, col_digits])
puts table_users.name          # => users
puts table_users.columns.map(&:name).sort.inspect # => ["email", "id", "phone"]
# options string: nop is suppressed; email + digits columns appear
puts table_users.options       # contains -c users:email:email and -c users:phone:digits

# Table with unspecified column (unspecifiled_columns requires ActiveSupport#second, skip)
table_orders = PgdumpScrambler::Config::Table.new('orders', [col_null, col_unspec])
puts table_orders.columns.map(&:name).sort.inspect # => ["notes", "secret"]

# Config: build from Table objects and exercise table_names / table / tables
cfg = PgdumpScrambler::Config.new(
  [table_users, table_orders],
  '/tmp/pgdump_scrambler_test.dump.gz',
  nil,
  [],
  nil
)

puts cfg.table_names.sort.inspect  # => ["orders", "users"]
puts cfg.table('users').name       # => users
puts cfg.tables.size               # => 2
puts cfg.dump_path                 # => /tmp/pgdump_scrambler_test.dump.gz

# Config#obfuscator_options
puts cfg.obfuscator_options        # non-empty string with -c flags

# Config#write to a StringIO and read back
require 'stringio'
io = StringIO.new
cfg.write(io)
io.rewind
yaml_str = io.read
puts yaml_str.include?('dump_path') # => true
puts yaml_str.include?('users')     # => true

# Config.read round-trip
io.rewind
cfg2 = PgdumpScrambler::Config.read(io)
puts cfg2.table_names.sort.inspect  # => ["orders", "users"]
puts cfg2.table('orders').columns.map(&:name).sort.inspect # => ["notes", "secret"]

# unspecified_columns requires ActiveSupport#second — skip
