# Smoke test for capistrano-safe-deploy-to 1.1.1
#
# The gem is a Capistrano plugin whose main entry (capistrano-safe-deploy-to.rb)
# is empty. Real logic lives in safe_deploy_to.rb (loads a .rake file) and
# the version module. We exercise:
#   1. VERSION constant from the module
#   2. Module namespace structure
#   3. String interpolation logic mirroring ensure_owner's owner calculation

require 'capistrano/safe_deploy_to/version'

ver = Capistrano::SafeDeployTo::VERSION
puts "VERSION=#{ver}"

# Verify the version string structure (semver X.Y.Z)
parts = ver.split('.').map(&:to_i)
puts "major=#{parts[0]}"
puts "minor=#{parts[1]}"
puts "patch=#{parts[2]}"

# Mirror the owner calculation logic from ensure_owner task:
#   user  = capture :id, '-un'   => returns a username string
#   group = capture :id, '-gn'   => returns a group string
#   set :safe_deploy_to_owner, "#{user}:#{group}"
# We replicate the string composition logic directly.
user  = "deploy"
group = "deploy"
owner = "#{user}:#{group}"
puts "owner=#{owner}"

# Mirror safe_deploy_to_path defaulting to deploy_to:
#   set :safe_deploy_to_path, -> { fetch(:deploy_to) }
deploy_to = "/var/www/myapp"
safe_deploy_to_path = deploy_to
puts "deploy_path=#{safe_deploy_to_path}"

# Test nil-guard logic from ensure_owner:
#   unless fetch(:safe_deploy_to_owner)  ... set owner
stored_owner = nil
unless stored_owner
  stored_owner = "#{user}:#{group}"
end
puts "resolved_owner=#{stored_owner}"

# Verify module is a proper Module (not a Class)
puts "is_module=#{Capistrano::SafeDeployTo.is_a?(Module)}"
puts "is_class=#{Capistrano::SafeDeployTo.is_a?(Class)}"

puts "OK"
