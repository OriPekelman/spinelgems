gem_maker = MakeMeAGemCalled.new("my_gem")
puts gem_maker.name
puts MakeMeAGemCalled::VERSION
puts gem_maker.command_line?
puts gem_maker.rspec?
puts gem_maker.instructions?
gem_maker.show_instructions
