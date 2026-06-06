require 'enumerated_constants'

module Color
  extend EnumeratedConstants

  RED   = 'red'.freeze
  GREEN = 'green'.freeze
  BLUE  = 'blue'.freeze

  # Array constant — should be excluded from #all
  PRIMARY = [RED, GREEN, BLUE].freeze
end

module Status
  extend EnumeratedConstants

  ACTIVE   = 'active'.freeze
  INACTIVE = 'inactive'.freeze
  PENDING  = 'pending'.freeze
end

# #all — excludes array constants
puts Color.all.sort.inspect
# => ["blue", "green", "red"]

# #include?
puts Color.include?('red')   # true
puts Color.include?('purple') # false

# #except — pass constant name, returns all minus that value
puts Color.except(:red).sort.inspect
# => ["blue", "green"]

# #map — transform values
puts Color.map { |c| c.upcase }.sort.inspect
# => ["BLUE", "GREEN", "RED"]

# #sort
puts Status.sort.inspect
# => ["active", "inactive", "pending"]

# #each — iterate, collecting into array for deterministic output
collected = []
Status.each { |s| collected << s }
puts collected.sort.inspect
# => ["active", "inactive", "pending"]

# #except with multiple args
puts Status.except(:active, :pending).inspect
# => ["inactive"]
