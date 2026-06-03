# frozen_string_literal: true
# Smoke: activerecord-mysql-enum
# Exercises ActiveRecord::Type::Enum (the gem's self-contained type caster)
# and the SQL type parsing regex used to extract enum limit values.
# These parts have no runtime dep on ActiveRecord or ActiveSupport.

require 'activerecord-mysql-enum'

# The version constant is in a separate file not auto-required; load it.
require 'active_record/mysql/enum/version'

puts ActiveRecord::Mysql::Enum::VERSION

# Stub just enough AR::Type::Value so enum_type.rb defines Type::Enum.
module ActiveRecord
  module Type
    class Value
      def type; :value; end
    end
  end
end

require 'active_record/mysql/enum/enum_type'

t = ActiveRecord::Type::Enum.new

# type identifier
puts t.type.inspect

# cast_value: strings → symbols, nil/''/nil → nil
puts t.send(:cast_value, 'pending').inspect
puts t.send(:cast_value, 'active').inspect
puts t.send(:cast_value, :closed).inspect
puts t.send(:cast_value, nil).inspect
puts t.send(:cast_value, '').inspect

# type_cast_for_database: returns the string form (what MySQL stores)
puts t.type_cast_for_database('pending').inspect
puts t.type_cast_for_database(:active).inspect
puts t.type_cast_for_database(nil).inspect
puts t.type_cast_for_database('').inspect

# SQL type parsing regex — extracts limit symbols from MySQL schema DDL
sql_type = "enum('pending','active','closed')"
limit = sql_type.sub(/^enum\('(.+)'\)/i, '\1').split("','").map(&:to_sym)
puts limit.inspect

sql_single = "enum('draft')"
limit2 = sql_single.sub(/^enum\('(.+)'\)/i, '\1').split("','").map(&:to_sym)
puts limit2.inspect
