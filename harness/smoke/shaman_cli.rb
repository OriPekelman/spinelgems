# frozen_string_literal: true

# shaman_cli smoke: exercises the internal data model classes
# The entry-point (shaman.rb) pulls in http/git/tty-prompt/commander which are
# unavailable; instead we require the self-contained internal files directly.
# Under Spinel, plain `require` to other gems is ignored, so the same pattern
# applies: internal require_relatives are inlined by Spinel.

$LOAD_PATH.unshift(File.join(__dir__, '../../..'))  # ensure relative paths work

# Manually load the internal hierarchy without the network/CLI deps
require 'shaman/version'
require 'shaman/tryout_apps'
require 'shaman/tryout_apps/resource'
require 'shaman/tryout_apps/resource/project'
require 'shaman/tryout_apps/resource/release'

# 1. Module-level constants (version + URIs)
puts Shaman::VERSION
puts Shaman::TryoutApps::PRODUCTION_BASE_URI
puts Shaman::TryoutApps::STAGING_BASE_URI
puts Shaman::TryoutApps::DEVELOPMENT_BASE_URI

# 2. Project::Project — hash-backed name/id accessors
project_data = { 'id' => 42, 'name' => 'MyApp', 'environments' => [] }
project = Shaman::TryoutApps::Resource::Project::Project.new(project_data)
puts project.name
puts project.id

# 3. Project::Environment — platform/token accessors
env_data = { 'name' => 'production', 'platform' => 'ios', 'token' => 'tok-abc' }
env = Shaman::TryoutApps::Resource::Project::Environment.new(env_data)
puts env.name
puts env.platform
puts env.token

# 4. Project with multiple environments — environments method returns typed objects
env_ios  = { 'name' => 'production', 'platform' => 'ios',     'token' => 'tok-ios' }
env_and  = { 'name' => 'staging',    'platform' => 'android', 'token' => 'tok-and' }
proj2 = Shaman::TryoutApps::Resource::Project::Project.new(
  'id' => 7, 'name' => 'OtherApp', 'environments' => [env_ios, env_and]
)
puts proj2.environments.map(&:platform).sort.inspect

# 5. Release::CreateInput — form hash keys (without HTTP::FormData which needs `http`)
input = Shaman::TryoutApps::Resource::Release::CreateInput.new(
  file: 'app.ipa',
  environment_token: 'env-tok-xyz',
  message: 'v1.2.3 release',
  token: 'user-tok-abc',
  minimum_version: false,
  name: 'MyApp 1.2.3'
)
# The form method calls HTTP::FormData::File — stub it so we can verify the keys
module HTTP
  module FormData
    class File
      def initialize(path); @path = path; end
      def to_s; "FormData::File(#{@path})"; end
    end
  end
end
form = input.form
puts form.keys.sort.inspect
puts form[:message]
puts form[:name]
puts form[:minimum_version]
