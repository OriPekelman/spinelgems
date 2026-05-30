puts Well::Tempered::Application::Hello.class
puts Well::Tempered::Application::Hello.new.class
puts Well::Tempered.class
puts Well.class
h = Well::Tempered::Application::Hello.new
puts h.respond_to?(:hello)
puts h.respond_to?(:nonexistent)
