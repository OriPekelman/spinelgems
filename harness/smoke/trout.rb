require 'trout'

# Exercise ManagedFile attribute initialization and to_hash
mf = Trout::ManagedFile.new(
  filename:    'config/database.yml',
  git_url:     'https://example.com/repo.git',
  version:     'abc123',
  source_root: '/shared'
)

puts mf.filename
puts mf.git_url
puts mf.version
puts mf.source_root

h = mf.to_hash
puts h[:filename]
puts h[:git_url]
puts h[:version]
puts h[:source_root]

# Default source_root when not provided
mf2 = Trout::ManagedFile.new(
  filename: 'Gemfile',
  git_url:  'https://example.org/other.git'
)
puts mf2.source_root
puts mf2.filename

# Mutate via attr_accessor
mf.version = 'def456'
puts mf.version

# VersionList: test reading from a non-existent path (returns empty structure)
require 'tmpdir'
vl = Trout::VersionList.new('/tmp/trout_smoke_nonexistent.trout')
entry = vl['somefile.rb']
puts entry.class
puts entry.filename

# Add a managed file to the version list, then retrieve it
Dir.mktmpdir do |dir|
  list_path = File.join(dir, '.trout')
  vl2 = Trout::VersionList.new(list_path)
  mf3 = Trout::ManagedFile.new(
    filename:    'lib/helper.rb',
    git_url:     'https://example.com/helper.git',
    version:     'deadbeef',
    source_root: '/src'
  )
  vl2 << mf3

  vl3 = Trout::VersionList.new(list_path)
  retrieved = vl3['lib/helper.rb']
  puts retrieved.filename
  puts retrieved.git_url
  puts retrieved.version
  puts retrieved.source_root
end
