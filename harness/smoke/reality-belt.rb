require 'belt'

# Build a two-scope model: platform and services
Belt.scope(:platform) do |s|
  s.project(:core) do |p|
    p.description = 'Core platform library'
    p.tags = ['tier=backend', 'env=prod', 'lang=ruby']
  end
  s.project(:db_migrations) do |p|
    p.description = 'Database migration scripts'
    p.tags = ['tier=data']
  end
end

Belt.scope(:services) do |s|
  s.project(:auth) do |p|
    p.description = 'Authentication service'
    p.tags = ['env=prod', 'tier=backend', 'owner=security']
  end
  s.project(:notifier)
end

# Enumerate scopes
puts Belt.scope_names.sort.inspect

# Access platform scope
platform = Belt.scope_by_name(:platform)
puts platform.name
puts platform.projects.map(&:name).sort.inspect
puts platform.projects?

core = platform.project_by_name(:core)
puts core.qualified_name
puts core.description
puts core.tag_value('tier')
puts core.tag_value('env')
puts core.tag_value('missing').inspect
puts core.tags.length

db = platform.project_by_name(:db_migrations)
puts db.qualified_name
puts db.description.empty?

# Access services scope
services = Belt.scope_by_name(:services)
auth = services.project_by_name(:auth)
puts auth.qualified_name
puts auth.tag_value('owner')
puts auth.tags.sort.inspect

notifier = services.project_by_name(:notifier)
puts notifier.description.inspect
puts notifier.tags.inspect
puts notifier.tag_value('tier').inspect

# Existence checks
puts Belt.scope_by_name?(:platform)
puts Belt.scope_by_name?(:nonexistent)
puts platform.project_by_name?(:core)
puts platform.project_by_name?(:ghost)
