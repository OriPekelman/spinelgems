require 'open-dock'
require 'yaml'
require 'tmpdir'

# open-dock is a CLI tool for provisioning Docker hosts on cloud providers.
# The main entry point only exposes the version; the Ops module in base.rb
# (no external deps beyond stdlib) contains the real host-management logic.

gem_lib = Gem.find_files('open-dock/base.rb').first
raise 'open-dock/base.rb not found in gem path' unless gem_lib
load gem_lib

# 1. Version constant
puts OpenDock::VERSION

# 2. Ops module constants — directory structure expected by the tool
puts Ops::HOSTS_DIR
puts Ops::CONTAINERS_DIR
puts Ops::PROVIDERS_DIR
puts Ops::NODES_DIR
puts Ops::DEFAULT_USER

# 3. Ops.get_user_for — returns DEFAULT_USER when no host file exists
puts Ops.get_user_for('nonexistent-host')

# 4. Ops.get_user_for — reads 'user' from YAML file when present
Dir.mktmpdir do |tmpdir|
  hosts_dir = File.join(tmpdir, 'hosts')
  Dir.mkdir(hosts_dir)

  # Write a host config with a custom user
  File.write(File.join(hosts_dir, 'web01.yml'), "user: deploy\nregion: nyc3\n")

  # Temporarily override HOSTS_DIR by changing into the tmpdir
  Dir.chdir(tmpdir) do
    puts Ops.get_user_for('web01')
    puts Ops.get_user_for('db01')   # no file -> DEFAULT_USER
  end
end
