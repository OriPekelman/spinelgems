require 'database_cleaner-core'

# 1. NullStrategy: concrete no-op strategy — cleaning yields, clean is no-op
ns = DatabaseCleaner::NullStrategy.new
result = nil
ns.cleaning { result = 42 }
puts result  # => 42

# 2. Strategy base class: subclass with db accessor
class MyStrat < DatabaseCleaner::Strategy
  def clean
    "cleaned(#{db})"
  end
end

s = MyStrat.new
puts s.db                # => default
s.db = :secondary
puts s.db                # => secondary
puts s.clean             # => cleaned(secondary)

# 3. Cleaner string helpers: camelize and underscore (private, but we can test via
#    creating a Cleaner with a fake ORM symbol and reading orm back)
c = DatabaseCleaner::Cleaner.new(:my_orm)
puts c.orm               # => my_orm
puts c.db                # => default

# 4. Cleaner#camelize via class method underscore (public class method, private for instance)
puts DatabaseCleaner::Cleaner.send(:underscore, "ActiveRecord")   # => active_record
puts DatabaseCleaner::Cleaner.send(:underscore, "DataMapper")     # => data_mapper
puts DatabaseCleaner::Cleaner.send(:underscore, "Truncation")     # => truncation

# 5. Cleaners < Hash: instantiate, check it's a Hash subclass
cleaners = DatabaseCleaner::Cleaners.new
puts cleaners.is_a?(Hash)    # => true
puts cleaners.empty?         # => true

# 6. UnknownStrategySpecified is an ArgumentError
puts DatabaseCleaner::UnknownStrategySpecified.ancestors.include?(ArgumentError)  # => true

# 7. Strategy#cleaning calls start then clean (via ensure)
class TrackStrat < DatabaseCleaner::Strategy
  attr_reader :log
  def initialize
    @log = []
  end
  def start
    @log << :started
  end
  def clean
    @log << :cleaned
  end
end

ts = TrackStrat.new
ts.cleaning { ts.log << :block }
puts ts.log.inspect   # => [:started, :block, :cleaned]

# 8. Safeguard checks: RemoteDatabaseUrl::LOCAL constant
puts DatabaseCleaner::Safeguard::RemoteDatabaseUrl::LOCAL.sort.inspect  # => ["127.0.0.1", "localhost"]
