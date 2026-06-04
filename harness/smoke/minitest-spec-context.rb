require 'minitest-spec-context'

# minitest-spec-context adds `context` as an alias for `describe` on
# Minitest::Spec subclasses, enabling nested context blocks in spec style.

# 1. Verify context method is available on Minitest::Spec subclasses
outer = describe('Calculator') {}
puts outer.superclass.name          # => Minitest::Spec
puts outer.respond_to?(:context, true)  # => true

# 2. context creates nested spec subclasses (same as describe)
nested1 = outer.instance_eval { context('when adding') {} }
nested2 = outer.instance_eval { context('when subtracting') {} }
puts nested1.name                   # => when adding
puts nested2.name                   # => when subtracting
puts nested1.superclass.name        # => Calculator
puts nested2.superclass.name        # => Calculator

# 3. context and describe produce equivalent class hierarchies
via_describe = outer.instance_eval { describe('via describe') {} }
via_context  = outer.instance_eval { context('via context') {} }
puts via_describe.superclass == via_context.superclass   # => true
puts via_describe.class      == via_context.class        # => true

# 4. context works recursively (nested inside a context block)
nested3 = nested1.instance_eval { context('with positive numbers') {} }
puts nested3.name                   # => with positive numbers
puts nested3.superclass.name        # => when adding
puts nested3.respond_to?(:context, true)  # => true

# 5. Verify context is defined on Minitest::Spec's singleton (the gem's contribution)
#    and that it produces the same result as an equivalent describe call
puts Minitest::Spec.respond_to?(:context, true)   # => true
nested_via_ctx  = outer.instance_eval { context('ctx-branch') {} }
nested_via_desc = outer.instance_eval { describe('desc-branch') {} }
puts nested_via_ctx.superclass  == nested_via_desc.superclass  # => true
puts nested_via_ctx.ancestors[1] == nested_via_desc.ancestors[1]  # => true
