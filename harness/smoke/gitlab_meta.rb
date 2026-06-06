require 'gitlab_meta'

# gitlab_meta is an intentionally empty meta-gem (its only purpose is
# declaring gem dependencies). The sole public artifact is the GitlabMeta
# class itself; we verify it is defined and that class-level introspection works.

puts GitlabMeta.name
puts GitlabMeta.superclass.name
puts GitlabMeta.instance_methods(false).length
puts GitlabMeta.ancestors.include?(Object)
puts GitlabMeta.is_a?(Class)
