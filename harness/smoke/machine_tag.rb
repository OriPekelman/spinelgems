require 'machine_tag'

# Exercise Tag creation and accessors
t1 = MachineTag::Tag.new('geo:lat=37.7749')
puts t1.machine_tag?           # true
puts t1.namespace              # geo
puts t1.predicate              # lat
puts t1.value                  # 37.7749
puts t1.namespace_and_predicate # geo:lat

# Tag.machine_tag factory
t2 = MachineTag::Tag.machine_tag('app', 'env', 'production')
puts t2                        # app:env=production
puts t2.namespace              # app
puts t2.predicate              # env
puts t2.value                  # production
puts t2.machine_tag?           # true

# Plain (non-machine) tag
t3 = MachineTag::Tag.new('ruby')
puts t3.machine_tag?           # false
puts t3.namespace.nil?         # true

# Quoted value
t4 = MachineTag::Tag.new('dc:title="Hello World"')
puts t4.value                  # Hello World (quotes stripped)

# MachineTag::Set — add and query by namespace
tags = MachineTag::Set.new(['geo:lat=37.7749', 'geo:lon=-122.4194', 'app:env=production', 'plain'])
puts tags['geo'].size          # 2
puts tags['app', 'env'].size   # 1
puts tags['geo:lat'].size      # 1
puts tags.plain_tags.size      # 1
puts tags.machine_tags.size    # 3

# Regexp lookup
result = tags[/^geo:/]
puts result.size               # 2

# Tag equality / string behaviour (Tag inherits String)
puts t2 == 'app:env=production' # true
