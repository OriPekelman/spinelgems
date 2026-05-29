puts Exec::NonZeroExitCodeException.superclass
puts Exec::CommandNotFoundException.superclass
puts Exec::NonZeroExitCodeException.new.class
puts Exec::CommandNotFoundException.new.class
puts Exec::NonZeroExitCodeException.ancestors.include?(StandardError)
puts Exec::CommandNotFoundException.ancestors.include?(StandardError)
