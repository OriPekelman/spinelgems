require 'ios-deploy'

# ios-deploy is a thin Ruby wrapper around a Node.js binary.
# Its entire Ruby surface is the IosDeploy module and VERSION constant.
# Verify the module exists and the version string is well-formed.

puts IosDeploy::VERSION
puts IosDeploy::VERSION.split('.').length == 3
puts IosDeploy::VERSION =~ /\A\d+\.\d+\.\d+\z/ ? "semver:ok" : "semver:fail"
puts IosDeploy.is_a?(Module)
puts IosDeploy.name
