# Mongoa: RSpec matchers for MongoMapper.
# The top-level lib/mongoa.rb open-classes RSpec::Matchers (unavailable).
# We load only the pure-Ruby matcher files directly.
require 'mongoa/mongo_mapper/associations/all'
require 'mongoa/mongo_mapper/validations/validate_base'
require 'mongoa/mongo_mapper/validations/validate_presence_of'
require 'mongoa/mongo_mapper/validations/validate_inclusion_of'
require 'mongoa/mongo_mapper/validations/validate_length_of'
require 'mongoa/mongo_mapper/matchers'

include Mongoa::MongoMapper::Matchers

# MongoAssociationMatcher: initialisation and description logic
m = Mongoa::MongoMapper::MongoAssociationMatcher.new(:belongs_to, :user)
puts m.macro          # => belongs_to
puts m.name           # => user
puts m.description    # => belong to user

m2 = Mongoa::MongoMapper::MongoAssociationMatcher.new(:has_many, :posts)
puts m2.description   # => have many posts

m3 = Mongoa::MongoMapper::MongoAssociationMatcher.new(:has_one, :profile)
puts m3.description   # => have one profile

# String guard branch in matches?
puts m.matches?("not a model")  # => false

# ValidatePresenceOfMatcher description + messages
vp = validate_presence_of(:name)
puts vp.description              # => require name to be set
puts vp.failure_message          # => Expected name to be a required field ...
puts vp.negative_failure_message # => Expected name to not be a required field ...

# ValidateInclusionOfMatcher description + messages
vi = validate_inclusion_of(:status, ["active", "inactive"])
puts vi.description              # => require status to be within ["active", "inactive"]
puts vi.failure_message          # => Expected status to be within ...
puts vi.negative_failure_message # => Expected status to not be within ...

# ValidateLengthOfMatcher: plain hash path
vl = validate_length_of(:username, { minimum: 3, maximum: 20 })
puts vl.description

# ValidateLengthOfMatcher: Integer-length normalisation path
vl2 = validate_length_of(:bio, { length: 255 })
puts vl2.description

# ValidateLengthOfMatcher: Range-length normalisation path
vl3 = validate_length_of(:slug, { length: (5..50) })
puts vl3.description
