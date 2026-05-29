# logeasy smoke: test top-level module identity
# Sub-requires in logeasy use plain require (not require_relative),
# so Spinel ignores them; only the LogEasy module constant is guaranteed.
puts LogEasy.name
puts LogEasy.is_a?(Module)
puts LogEasy.respond_to?(:name)
puts LogEasy.ancestors.first == LogEasy
