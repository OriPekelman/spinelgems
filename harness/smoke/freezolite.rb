# frozen_string_literal: true

# Smoke test for freezolite
# Exercises the module-level configuration API.
# The `setup` method is intentionally omitted because it requires the
# `require-hooks` gem (external dep, not available in the harness).

require 'freezolite'

# 1. VERSION constant
puts Freezolite::VERSION

# 2. Initial state: experimental_freeze_constants defaults to false
puts Freezolite.experimental_freeze_constants.inspect

# 3. Setting to `true` should be normalised to :literal
Freezolite.experimental_freeze_constants = true
puts Freezolite.experimental_freeze_constants.inspect

# 4. Setting to false keeps false
Freezolite.experimental_freeze_constants = false
puts Freezolite.experimental_freeze_constants.inspect

# 5. Any non-true value is passed through as-is
Freezolite.experimental_freeze_constants = :experimental_copy
puts Freezolite.experimental_freeze_constants.inspect

# 6. Setting to the literal symbol :literal (same result as true)
Freezolite.experimental_freeze_constants = :literal
puts Freezolite.experimental_freeze_constants.inspect
