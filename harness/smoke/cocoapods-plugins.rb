require_relative "lib/cocoapods_plugins"
puts CocoapodsPlugins::VERSION
puts CocoapodsPlugins::VERSION.class
puts CocoapodsPlugins.name
puts CocoapodsPlugins.is_a?(Module)
