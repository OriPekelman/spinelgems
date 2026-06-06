require 'jsonapi-resources-matchers'

# Exercise the matcher classes directly — constructor, description, and
# failure_message — without needing the full jsonapi-resources runtime.
# The `matches?` methods require JSONAPI::ResourceSerializer (external gem),
# so we test the parts that are self-contained.

puts JSONAPI::Resources::Matchers::VERSION

# HaveAttribute: description and failure_message
attr_matcher = JSONAPI::Resources::Matchers::HaveAttribute.new(:title)
puts attr_matcher.description

# HaveCreatableField
cf_matcher = JSONAPI::Resources::Matchers::HaveCreatableField.new(:name)
puts cf_matcher.description
puts cf_matcher.failure_message_when_negated.gsub(/\n/, '') rescue puts "n/a"

# HaveUpdatableField
uf_matcher = JSONAPI::Resources::Matchers::HaveUpdatableField.new(:email)
puts uf_matcher.description

# HaveSortableField
sf_matcher = JSONAPI::Resources::Matchers::HaveSortableField.new(:created_at)
puts sf_matcher.description

# Filter
filter_matcher = JSONAPI::Resources::Matchers::Filter.new(:status)
puts filter_matcher.description

# Relationship — both have_many and have_one types
rel_many = JSONAPI::Resources::Matchers::Relationship.new(:have_many, :comments)
puts rel_many.description
puts rel_many.humanized_relationship_type

rel_one = JSONAPI::Resources::Matchers::Relationship.new(:have_one, :author)
puts rel_one.description

# HaveModelName
hmn = JSONAPI::Resources::Matchers::HaveModelName.new("Post")
puts hmn.description

# HavePrimaryKey
hpk = JSONAPI::Resources::Matchers::HavePrimaryKey.new(:uuid)
puts hpk.description

# Verify Matchers module methods (factory methods) return correct instances
include JSONAPI::Resources::Matchers

puts have_attribute(:body).class
puts filter(:category).class
puts have_many(:tags).class
puts have_one(:profile).class
puts have_model_name("User").class
puts have_primary_key(:id).class
puts have_creatable_field(:slug).class
puts have_updatable_field(:bio).class
puts have_sortable_field(:updated_at).class

# with_class_name / with_relation_name chaining
chained = have_many(:posts).with_class_name("Post").with_relation_name(:articles)
puts chained.expected_class_name
puts chained.expected_relation_name
puts chained.description
