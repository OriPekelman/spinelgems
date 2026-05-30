# smoke: rubysl-find
puts Find.respond_to?(:find)
puts Find.respond_to?(:prune)
puts Find.is_a?(Module)
puts defined?(Find)
