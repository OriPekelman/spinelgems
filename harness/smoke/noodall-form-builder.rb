# noodall-form-builder smoke
# This gem is a Rails 3 engine; its lib/noodall-form-builder.rb is guarded
# by `defined?(Rails) && Rails::VERSION::MAJOR == 3` and does nothing outside
# Rails. All app/models depend on MongoMapper. The only loadable public artifact
# is the version constant, loaded directly.

require 'noodall/form_builder/version'

puts Noodall::FormBuilder::VERSION
puts Noodall::FormBuilder::VERSION.split('.').map(&:to_i).inspect
puts Noodall::FormBuilder::VERSION == "0.5.4"
