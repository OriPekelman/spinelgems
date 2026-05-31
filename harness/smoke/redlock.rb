# Smoke test for redlock gem - exercises LockError class
err = Redlock::LockError.new("my-resource")
puts err.message
puts err.is_a?(StandardError)
puts Redlock::LockError.ancestors.include?(StandardError)
