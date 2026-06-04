# frozen_string_literal: true
# Smoke: bounded_context
# The gem's Ruby-side API is entirely a module namespace + VERSION constant;
# all generator logic requires Rails (external dep). We exercise:
#   - module identity and constant lookup
#   - VERSION string structure (not just its value)
#   - module ancestry / include? membership
#   - constants defined on the module
require 'bounded_context'

# 1. Module exists and is a Module
puts BoundedContext.class                          # => Module
puts BoundedContext.is_a?(Module)                  # => true

# 2. VERSION is a well-formed semver string
v = BoundedContext::VERSION
parts = v.split('.')
puts parts.length >= 2                             # => true
puts parts.all? { |p| p.match?(/\A\d+/) }         # => true
puts v.frozen?                                     # => true (frozen_string_literal)

# 3. Constants defined on the module
consts = BoundedContext.constants.sort.map(&:to_s)
puts consts.include?('VERSION')                    # => true
puts consts.join(',')                              # => VERSION

# 4. Module does not accidentally include unexpected ancestors
puts BoundedContext.ancestors.first == BoundedContext  # => true

# 5. Namespace nesting: the module name is correct
puts BoundedContext.name                           # => BoundedContext
