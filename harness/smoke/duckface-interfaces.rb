# frozen_string_literal: true

require 'duckface'

# Define a simple interface module using ActsAsInterface
module Printable
  extend Duckface::ActsAsInterface

  def print_name
    raise NotImplementedError
  end

  def print_description(prefix)
    raise NotImplementedError
  end
end

# Check which methods the interface requires
methods = Printable.methods_that_should_be_implemented.sort
puts "Interface methods: #{methods.inspect}"

# Define a class that correctly implements the interface
class Document
  implements_interface Printable

  def print_name
    "Document"
  end

  def print_description(prefix)
    "#{prefix}: a document"
  end
end

# Check that it correctly says it implements the interface
puts "Document implements Printable? #{Document.says_it_implements?(Printable)}"

# Run the check session
session = Document.check_it_implements(Printable)
puts "Check successful? #{session.successful?}"
puts "Methods not implemented: #{session.methods_not_implemented.sort.inspect}"
puts "Methods with wrong signature: #{session.methods_with_incorrect_signatures.sort.inspect}"

# Define a class with a missing method
class BadDocument
  implements_interface Printable

  def print_name
    "BadDocument"
  end
  # missing print_description
end

session2 = BadDocument.check_it_implements(Printable)
puts "BadDocument check successful? #{session2.successful?}"
puts "BadDocument missing: #{session2.methods_not_implemented.sort.inspect}"

# Define a class with wrong signature
class WrongSigDocument
  implements_interface Printable

  def print_name
    "WrongSigDocument"
  end

  def print_description  # missing the prefix argument
    "description"
  end
end

session3 = WrongSigDocument.check_it_implements(Printable)
puts "WrongSigDocument check successful? #{session3.successful?}"
puts "WrongSigDocument wrong sig: #{session3.methods_with_incorrect_signatures.sort.inspect}"

# Test NullCheckSession (on a class that has NOT called implements_interface)
class UnrelatedClass
end

null_session = UnrelatedClass.check_it_implements(Printable)
puts "NullCheckSession null? #{null_session.null?}"

# Test exclude_methods_from_interface_enforcement
module SelectiveInterface
  extend Duckface::ActsAsInterface
  exclude_methods_from_interface_enforcement :optional_method

  def required_method
    raise NotImplementedError
  end

  def optional_method
    raise NotImplementedError
  end
end

enforced = SelectiveInterface.methods_that_should_be_implemented.sort
puts "SelectiveInterface enforced methods: #{enforced.inspect}"
