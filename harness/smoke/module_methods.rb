# Smoke test for module_methods gem
# Tests the ModuleMethods::Extension mixin that auto-extends ClassMethods

puts ModuleMethods::VERSION

module Greetable
  extend ModuleMethods::Extension

  module ClassMethods
    def greeting
      "Hello from " + name
    end
  end

  def instance_hello
    "instance hello"
  end
end

class Person
  include Greetable
end

puts Person.greeting
puts Person.new.instance_hello

module Nameable
  extend ModuleMethods::Extension
  include Greetable

  module ClassMethods
    def label
      "label:" + name
    end
  end
end

class Robot
  include Nameable
end

puts Robot.greeting
puts Robot.label
puts Robot.new.instance_hello
