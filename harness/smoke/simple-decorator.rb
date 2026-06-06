require 'simple_decorator'

# Define a simple object to decorate
class Coffee
  def cost
    5
  end

  def description
    "Plain coffee"
  end

  def to_s
    "Coffee(cost=#{cost})"
  end
end

# Define decorators
class MilkDecorator < SimpleDecorator
  def cost
    super + 1
  end

  def description
    super + ", milk"
  end
end

class SugarDecorator < SimpleDecorator
  def cost
    super + 2
  end

  def description
    super + ", sugar"
  end
end

# Exercise basic decoration
coffee = Coffee.new
milk_coffee = MilkDecorator.new(coffee)
sugar_milk_coffee = SugarDecorator.new(milk_coffee)

puts milk_coffee.cost
puts milk_coffee.description
puts sugar_milk_coffee.cost
puts sugar_milk_coffee.description

# Exercise #decorated / #source accessors
puts milk_coffee.decorated.equal?(coffee)
puts milk_coffee.source.equal?(coffee)

# Verify delegation: to_s should be delegated from the underlying object
puts milk_coffee.to_s

# Stacked decorator chain: sugar_milk_coffee.decorated is the milk_coffee
puts sugar_milk_coffee.decorated.cost
