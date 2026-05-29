puts RecentRuby::RUBY_NODE_XPATH
puts RecentRuby::VERSION_XPATH
puts RecentRuby::FILE_XPATH.include?('file')
puts RecentRuby::PATCHLEVEL_VALUE_XPATH.include?('patchlevel')
puts RecentRuby::VERSION_XPATH.start_with?('//')
