# Smoke: justified gem - Justified module constants (no % formatting)
puts Justified::CAUSED_STR
puts Justified::SKIP_STR
puts Justified::Error.is_a?(Module)
puts Justified.const_defined?(:Error)
