# smoke: capistrano-scm-copy
# Exercise the exclude_dir processing and tar command-building logic
# reproduced verbatim from lib/capistrano/tasks/copy.rake.
# (The main entry point capistrano-scm-copy.rb is empty; the real logic
# lives in the rake file which requires the full Capistrano/Rake DSL at load
# time. We reproduce those exact computations here without the DSL dependency.)

require 'capistrano-scm-copy'  # empty — loads cleanly

# Reproduce the exact variable computations from copy.rake verbatim:

def fetch(key, default = nil)
  {
    include_dir: 'app/src',
    exclude_dir: ['node_modules', '.git', 'tmp'],
    tar_roles:   :web,
    tar_verbose: true
  }[key] || default
end

archive_name = 'archive.tar.gz'
include_dir  = fetch(:include_dir) || '*'
exclude_dir  = Array(fetch(:exclude_dir))
exclude_args = exclude_dir.map { |dir| "--exclude '#{dir}'" }
tar_roles    = fetch(:tar_roles, :all)
tar_verbose  = fetch(:tar_verbose, true) ? 'v' : ''

puts archive_name
puts include_dir
puts exclude_dir.length
puts exclude_args.join(' ')
puts tar_roles.inspect
puts tar_verbose

# Array() coercion corner cases (mirrors Array(fetch(:exclude_dir)) in copy.rake)
puts Array(nil).inspect
puts Array('single').inspect
puts Array(['a', 'b']).inspect

# tar_verbose false branch
tar_verbose_silent = false ? 'v' : ''
puts tar_verbose_silent.inspect
