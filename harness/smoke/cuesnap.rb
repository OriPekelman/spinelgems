require_relative "lib/cuesnap/version"
puts CueSnap::VERSION
puts CueSnap::VERSION.class
parts = CueSnap::VERSION.split('.')
puts parts.length
puts parts.first
