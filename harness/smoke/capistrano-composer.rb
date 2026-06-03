# Smoke test for capistrano-composer-light
# The gem's main entry point is intentionally empty (it's a Capistrano plugin).
# We exercise the pure Ruby string logic extracted from the rake tasks,
# and verify the default configuration constants defined in defaults.rb.

require 'capistrano-composer-light'
puts "require ok"

# --- PHP ini string-building logic (from composer.rake tasks) ---
# When php_ini is empty, no -c flag is added
def build_php_ini_flag(php_ini_val)
  php_ini = php_ini_val || ''
  if php_ini.length > 0
    php_ini = ' -c ' + php_ini
  end
  php_ini
end

puts build_php_ini_flag('').inspect           # ""  (empty, no flag)
puts build_php_ini_flag(nil).inspect          # ""  (nil treated as empty)
puts build_php_ini_flag('/etc/php.ini')       # " -c /etc/php.ini"

# --- Composer command assembly (simulated from composer.rake :run task) ---
def build_composer_command(php, php_ini_flag, composer_execute, command, options)
  parts = [php]
  parts << php_ini_flag unless php_ini_flag.empty?
  parts << composer_execute.to_s
  parts << command.to_s if command
  parts << options.to_s if options && !options.empty?
  parts.join(' ')
end

puts build_composer_command('php', '', 'composer.phar', :install, nil)
puts build_composer_command('php', ' -c /custom.ini', '/shared/composer.phar', :update, '--no-dev')
puts build_composer_command('php54', '', '/usr/local/bin/composer', :selfupdate, '')

# --- Defaults values (mirrored from defaults.rb) ---
defaults = {
  composer_php:          'php',
  composer_php_ini:      '',
  composer_download_url: 'https://getcomposer.org/installer',
  composer_roles:        :all,
}

defaults.each do |key, val|
  puts "#{key}: #{val.inspect}"
end
