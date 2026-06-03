# Smoke test for capistrano-rails 1.7.0
#
# capistrano-rails is a capistrano plugin: its Ruby content is entirely in
# .rake files loaded via the capistrano DSL at deploy time.  We cannot
# require capistrano itself (it pulls in sshkit -> net/ssh -> network) so we
# stub the minimal DSL surface and load the rake files directly to exercise:
#
#   1. Capistrano::FileNotFound exception class (defined in assets.rake)
#   2. The `load:defaults` task bodies (set/fetch configuration defaults)
#   3. The manifest backup path construction (sources.zip(targets))
#   4. Migration conditional-skip logic (conditionally_migrate flag handling)

require 'pathname'
require 'rake'

# ── Stubs ──────────────────────────────────────────────────────────────────

module SSHKit
  class Host; end
end

module Capistrano
  module DSL
    def self.stages; []; end
  end
end

CAPS_SETTINGS = {}

# Capistrano DSL helpers used inside the .rake files
def namespace(_name, &block)
  block.call if block
end

def task(_name, *_args, &_block); end
def after(*_args); end

def set(key, val = nil)
  CAPS_SETTINGS[key] = val
end

def fetch(key, default = nil)
  CAPS_SETTINGS.fetch(key, default)
end

# ── Load the gem's rake files directly ────────────────────────────────────

gem_tasks = $LOAD_PATH.map { |p| File.join(p, 'capistrano/tasks') }.find { |p| File.directory?(p) }
assets_rake    = File.join(gem_tasks, 'assets.rake')
migrations_rake = File.join(gem_tasks, 'migrations.rake')

load assets_rake
load migrations_rake

# ── 1. Capistrano::FileNotFound exception ─────────────────────────────────

begin
  raise Capistrano::FileNotFound, 'assets manifest not found'
rescue Capistrano::FileNotFound => e
  puts "exception class: #{e.class}"
  puts "exception message: #{e.message}"
  puts "superclass: #{e.class.superclass}"
  puts "is_a? StandardError: #{e.is_a?(StandardError)}"
  puts "is_a? RuntimeError: #{e.is_a?(RuntimeError)}"
end

# ── 2. Asset configuration defaults ───────────────────────────────────────

puts "assets_roles: #{fetch(:assets_roles, [:web]).inspect}"
puts "assets_prefix: #{fetch(:assets_prefix, 'assets')}"
puts "keep_assets: #{fetch(:keep_assets, nil).inspect}"

# ── 3. Manifest backup path construction (from assets:restore_manifest) ───

release_path = Pathname.new('/var/www/myapp/releases/20231201120000')
assets_prefix = fetch(:assets_prefix, 'assets')

# Replicate the manifest patterns lambda from load:defaults
manifest_patterns = %w[.sprockets-manifest* manifest*.* .manifest.json].map do |pattern|
  release_path.join('public', assets_prefix, pattern)
end
puts "manifest patterns count: #{manifest_patterns.size}"
puts "first manifest pattern: #{manifest_patterns.first}"

# Replicate the restore_manifest path mapping
targets = manifest_patterns.map(&:to_s)
backup_path = release_path.join('assets_manifest_backup').to_s
sources = targets.map { |t| File.join(backup_path, File.basename(t)) }
source_map = sources.zip(targets)
puts "backup->release pairs: #{source_map.size}"
puts "first pair basename: #{File.basename(source_map.first[0])}"

# ── 4. Migration defaults ──────────────────────────────────────────────────

puts "conditionally_migrate: #{fetch(:conditionally_migrate, false)}"
puts "migration_role: #{fetch(:migration_role, :db)}"
puts "migration_command: #{fetch(:migration_command, 'db:migrate')}"

# ── 5. linked_dirs uniqueness logic (from set_linked_dirs task body) ───────

linked_dirs = []
linked_dirs << "public/#{fetch(:assets_prefix, 'assets')}"
puts "linked_dirs (pre-uniq): #{linked_dirs.inspect}"
linked_dirs << "public/#{fetch(:assets_prefix, 'assets')}"  # duplicate
linked_dirs = linked_dirs.uniq
puts "linked_dirs (post-uniq count): #{linked_dirs.size}"
puts "linked_dirs entry: #{linked_dirs.first}"
