# springboard — Rails/Elasticsearch Railtie gem
# The gem only defines a Railtie (requires Rails) and a VERSION constant.
# All actual behaviour (generators, tasks) depends on Rails + Rake.
# We smoke the only standalone-accessible constant.
require 'springboard/version'

puts Springboard::VERSION
puts Springboard::VERSION.split('.').map(&:to_i).inspect
puts Springboard::VERSION =~ /\A\d+\.\d+\.\d+\z/ ? "version_format:ok" : "version_format:bad"
