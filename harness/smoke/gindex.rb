# gindex: Rails generator for concurrent index migrations
# The gem's only standalone code is the VERSION constant.
# The generator (IndexGenerator) hard-requires rails/generators/active_record
# and activerecord — neither is available outside a Rails context.
# We exercise the string-formatting helpers by stubbing the Rails dependency.

require 'gindex'
puts Gindex::VERSION

# Stub just enough of the Rails/AR namespace to make the generator loadable.
# `argument` in Thor/Rails generators defines an attr_accessor-like method.
module Rails
  module Generators
    class Base
      def self.source_root(path = nil); end
      def self.include(mod); end
      def self.argument(name, **opts)
        attr_accessor name
      end
    end
  end
end

module ActiveRecord
  module Generators
    module Migration; end
  end
  module Tasks
    module DatabaseTasks
      def self.migrations_paths; ["db/migrate"]; end
    end
  end
  module VERSION
    MAJOR = 8
    MINOR = 1
  end
end

# Override require to absorb rails dependencies we've already stubbed
module Kernel
  alias_method :orig_require, :require
  def require(path)
    if path == 'rails/generators/active_record'
      true
    else
      orig_require(path)
    end
  end
end

load '/home/oripekelman/.cache/spinel-compat/gems/gindex-0.6.0/lib/generators/index/index_generator.rb'

# Single-column index
gen = IndexGenerator.new
gen.table = "users"
gen.columns = ["email"]
puts gen.migration_version   # [8.1]
puts gen.table_str           # :users
puts gen.column_str          # :email

# Multi-column index
gen2 = IndexGenerator.new
gen2.table = "deliveries"
gen2.columns = ["store_id", "delivered_at"]
puts gen2.table_str          # :deliveries
puts gen2.column_str         # [:store_id, :delivered_at]
