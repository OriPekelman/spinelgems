# smoke: deep_try
# deep_try adds Object#deep_try that chains method calls safely (like ActiveSupport try but chained).
# The gem depends on Object#try from ActiveSupport (undeclared in gemspec).
# We stub try here to isolate and exercise deep_try's own logic.

class Object
  def try(method_sym)
    respond_to?(method_sym) ? public_send(method_sym) : nil
  end
end

class NilClass
  def try(*args)
    nil
  end
end

require 'deep_try'

# 1. Single-step chain on a string
puts 'hello'.deep_try(:upcase).inspect

# 2. Multi-step chain: string -> class -> name -> to_s
puts 'hello'.deep_try(:class, :name, :to_s).inspect

# 3. nil receiver short-circuits immediately
puts nil.deep_try(:upcase, :length).inspect

# 4. Undefined method in chain returns nil
puts 'hello'.deep_try(:nonexistent_method).inspect

# 5. Numeric chain
puts 42.deep_try(:to_s, :length).inspect

# 6. Partial valid chain up to nil-returning method
arr = [1, 2, 3]
puts arr.deep_try(:first, :to_s).inspect
