require_relative 'lib/crunchbase/version'
require_relative 'lib/crunchbase/exception'

puts Crunchbase::VERSION
puts Crunchbase::Exception.superclass
puts Crunchbase::ConfigurationException.superclass
puts Crunchbase::MissingParamsException.superclass
puts Crunchbase::InvalidRequestException.superclass
puts Crunchbase::ResponseTypeException.superclass
puts Crunchbase::CertificateError.superclass
