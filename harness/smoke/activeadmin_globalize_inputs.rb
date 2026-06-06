# Smoke: activeadmin_globalize_inputs
# The gem reopens Formtastic::FormBuilder and adds globalize_inputs.
# All real logic requires Rails/ActiveAdmin/formtastic at runtime, so we
# exercise what is actually self-contained: the module structure and the
# method definition added by the gem.

# Stub out the heavy deps so the require succeeds
module Formtastic
  class FormBuilder
  end
end

require 'activeadmin_globalize_inputs'

# Verify the method was grafted onto the class
has_method = Formtastic::FormBuilder.method_defined?(:globalize_inputs)
puts "globalize_inputs defined: #{has_method}"

# Verify the module hierarchy
puts "Formtastic::FormBuilder ancestors include Formtastic::FormBuilder: #{Formtastic::FormBuilder.ancestors.include?(Formtastic::FormBuilder)}"

# Verify it's an instance method (not a class method)
class_method = Formtastic::FormBuilder.respond_to?(:globalize_inputs)
puts "globalize_inputs is NOT a class method: #{!class_method}"

# Confirm the method arity (accepts *args and a block)
arity = Formtastic::FormBuilder.instance_method(:globalize_inputs).arity
puts "globalize_inputs arity: #{arity}"
