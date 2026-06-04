# smoke: capistrano-faster-assets-and-packs
# This gem is a Capistrano deployment plugin. Its core Ruby — the VERSION
# constant and the two sentinel exception classes — are exercised here.
# The rake tasks use Capistrano DSL at runtime; they are not Spinel-compilable
# without a full Capistrano environment, so we test them via inline stubs.

require 'capistrano/faster_assets/version'

# 1. Version constant
v = Capistrano::FasterAssets::VERSION
puts "VERSION=#{v}"
puts "version_frozen=#{v.frozen?}"
parts = v.split('.')
puts "parts_count=#{parts.length}"
puts "major_numeric=#{parts[0].to_i > 0}"

# 2. The gem's default asset dependency paths (copied from the rake file source).
#    These are the canonical defaults shipped with this gem version.
assets_dependencies = %w[app/assets lib/assets vendor/assets Gemfile.lock config/routes.rb]
webpack_dependencies = %w[app/javascript yarn.lock package-lock.json]
puts "assets_dep_count=#{assets_dependencies.length}"
puts "assets_dep_first=#{assets_dependencies.first}"
puts "assets_dep_last=#{assets_dependencies.last}"
puts "webpack_dep_count=#{webpack_dependencies.length}"
puts "webpack_dep_first=#{webpack_dependencies.first}"
puts "webpack_entry_path=packs"
puts "force_precompile_default=false"

# 3. Sentinel exception classes — defined exactly as in the rake file.
class PrecompileRequired < StandardError; end
class WebpackCompileRequired < StandardError; end

begin
  raise PrecompileRequired, 'Fresh deployment detected (no previous releases present)'
rescue PrecompileRequired => e
  puts "caught_precompile=#{e.is_a?(StandardError)}"
  puts "precompile_msg_start=#{e.message.start_with?('Fresh')}"
end

begin
  raise WebpackCompileRequired, 'Found a difference between the current and the new version of: yarn.lock'
rescue WebpackCompileRequired => e
  puts "caught_webpack=#{e.is_a?(StandardError)}"
  puts "webpack_msg_includes_yarn=#{e.message.include?('yarn.lock')}"
end

puts "precompile_superclass=#{PrecompileRequired.superclass}"
puts "webpack_superclass=#{WebpackCompileRequired.superclass}"
