# smoke: red-arrow-flight
# This gem wraps Apache Arrow Flight via GObject Introspection.
# It requires native C libraries (arrow, glib2, gobject-introspection)
# that must be installed on the system. All public API lives in classes
# instantiated by GObjectIntrospection::Loader at require time.
#
# We exercise the pure-Ruby constants/version and demonstrate the
# load-time dependency clearly.

require 'arrow-flight'

# Version constants — pure Ruby, defined before Loader.load
puts ArrowFlight::VERSION
puts ArrowFlight::Version::MAJOR
puts ArrowFlight::Version::MINOR
puts ArrowFlight::Version::MICRO
puts ArrowFlight::Version::STRING

# Location.try_convert — pure Ruby method on the class
loc = ArrowFlight::Location.try_convert("grpc://localhost:9090")
puts loc.class

# Ticket.try_convert — pure Ruby
ticket = ArrowFlight::Ticket.try_convert("my-ticket-data")
puts ticket.class

# CallOptions.try_convert — pure Ruby
opts = ArrowFlight::CallOptions.try_convert({})
puts opts.class
