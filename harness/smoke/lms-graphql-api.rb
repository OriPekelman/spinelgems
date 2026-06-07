# lms-graphql-api smoke: exercises GraphQL type definitions for Canvas LMS API
# The harness pre-loads all lib files via require_relative; this smoke body uses
# the already-loaded constants. The require below is for standalone CRuby sanity.
require 'lms_graphql_api'
require 'lms_graphql/version'

# 1. Version
puts LMSGraphQL::VERSION

# 2. Schema class name
puts LMSGraphQL::Types::Canvas::Schema.name

# 3. CanvasAccount type fields (sorted for determinism)
account_fields = LMSGraphQL::Types::Canvas::CanvasAccount.fields.keys.sort
puts account_fields.inspect

# 4. QueryType field count and a few sampled field names
query_type = LMSGraphQL::Types::Canvas::QueryType
puts query_type.fields.size
sample = query_type.fields.keys.sort.first(3)
puts sample.inspect

# 5. CanvasCourse type — check description contains expected text
course_desc = LMSGraphQL::Types::Canvas::CanvasCourse.description
puts course_desc.include?("Course") ? "course_desc_ok" : "course_desc_missing"

# 6. BaseType ancestry
puts LMSGraphQL::Types::Canvas::BaseType.ancestors.include?(::GraphQL::Schema::Object) ? "base_type_ok" : "base_type_missing"
