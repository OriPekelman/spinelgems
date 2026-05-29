require_relative "lib/gitlab_development_kit"
puts GDK::GEM_VERSION
puts GDK::VERSION
puts GDK::GEM_VERSION.class
puts GDK::VERSION.frozen?
