# cocoapods_debug smoke
# This gem is a CocoaPods plugin. `require 'cocoapods_debug'` only loads
# the VERSION constant (gem_version.rb). The real command class
# (Pod::Command::Debug) inherits from Pod::Command, which requires the
# cocoapods / claide ecosystem — unavailable here.
#
# Attempting to exercise Pod::Command::Debug raises NameError: uninitialized
# constant Pod. There is no self-contained logic to smoke beyond VERSION.
# Classification: smoke-error (all real public API requires external gems).

require 'cocoapods_debug'

puts CocoapodsDebug::VERSION
