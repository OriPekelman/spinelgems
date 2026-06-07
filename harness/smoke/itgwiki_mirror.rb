require 'itgwiki_mirror'
require 'itgwiki_mirror/backuper'

# Test the READ_ONLY_MSG constant from Deployer
# (Don't require deployer because it loads rb-inotify which isn't available)
# Instead verify Backuper initialization stores opts correctly.

b = ITGwikiMirror::Backuper.new(
  verbose:  true,
  db_user:  'wiki_user',
  db_pass:  'wiki_pass',
  db_name:  'itgwiki',
  user:     'deploy',
  host:     'mirror.example.com',
  port:     2222,
  wiki_root: '/srv/wiki',
  rsync:    '/var/mirror'
)

puts b.instance_variable_get(:@verbose).inspect
puts b.instance_variable_get(:@db_user)
puts b.instance_variable_get(:@db_name)
puts b.instance_variable_get(:@host)
puts b.instance_variable_get(:@port)
puts b.instance_variable_get(:@wiki_root)
puts b.instance_variable_get(:@rsync)
puts b.instance_variable_get(:@dumpfile).include?('itgwiki_mirror_mysqldump')
puts b.class.name
puts ITGwikiMirror::Backuper.instance_methods(false).sort.inspect
