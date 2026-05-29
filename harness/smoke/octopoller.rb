puts Octopoller::TimeoutError.ancestors.include?(StandardError)
puts Octopoller::TooManyAttemptsError.ancestors.include?(StandardError)
puts Octopoller::TimeoutError < StandardError
puts Octopoller::TooManyAttemptsError < StandardError
