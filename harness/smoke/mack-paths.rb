module Mack
  def self.root
    "/myapp"
  end
end

puts Mack::Paths.public
puts Mack::Paths.images
puts Mack::Paths.javascripts
puts Mack::Paths.stylesheets
puts Mack::Paths.app
puts Mack::Paths.views
puts Mack::Paths.controllers
puts Mack::Paths.models
puts Mack::Paths.config
puts Mack::Paths.db
