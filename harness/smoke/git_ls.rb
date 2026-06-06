# frozen_string_literal: true

require 'git_ls'

# Test 1: read files from a real git repo (spinelgems itself)
repo_path = '/home/oripekelman/sites/spinelgems'

files = GitLS.files(repo_path)
puts "file_count_positive=#{files.length > 0}"
puts "is_array=#{files.is_a?(Array)}"
puts "strings=#{files.all? { |f| f.is_a?(String) }}"
# Print a few sorted file names to confirm content makes sense
sample = files.sort.first(3)
sample.each { |f| puts "file=#{f}" }

# Test 2: error handling — non-git directory raises GitLS::Error
begin
  GitLS.files('/tmp/nonexistent_git_repo_xyz_abc')
  puts 'error=not_raised'
rescue GitLS::Error => e
  puts "error=#{e.class}"
end

# Test 3: VERSION constant
puts "version=#{GitLS::VERSION}"

# Test 4: build a minimal synthetic git index (version 2) in memory,
# write it to /tmp and parse it with GitLS.files.
# Format: DIRC + 4-byte version(2) + 4-byte entry-count + entries + 20-byte checksum
# Each v2 entry: 40 bytes stat, 20 bytes sha, 2 bytes flags (path-len in low 12 bits),
# path bytes, NUL-padding to 8-byte alignment.
index_dir = '/tmp/git_ls_smoke_test_git'
index_path = "#{index_dir}/index"
Dir.mkdir(index_dir) unless Dir.exist?(index_dir)

path = 'hello.rb'
plen = path.bytesize  # 8

stat  = "\x00" * 40
sha   = "\x00" * 20
flags = [plen].pack('n')   # big-endian uint16: 0x00, 0x08
entry = stat + sha + flags + path

# padding: 8 - ((plen - 2) % 8) = 8 - 6 = 2 NUL bytes
pad_count = 8 - ((plen - 2) % 8)
entry += "\x00" * pad_count

header = "DIRC" + [2, 1].pack('NN')
body   = header + entry

# Minimal 20-byte checksum (all zeros — GitLS doesn't verify the SHA1)
checksum = "\x00" * 20
index_data = body + checksum

File.binwrite(index_path, index_data)

# GitLS.files expects a path to the directory containing .git/
parent_dir = '/tmp/git_ls_smoke_test'
git_dir    = "#{parent_dir}/.git"
Dir.mkdir(parent_dir) unless Dir.exist?(parent_dir)
Dir.mkdir(git_dir)    unless Dir.exist?(git_dir)
File.binwrite("#{git_dir}/index", index_data)

result = GitLS.files(parent_dir)
puts "synthetic_count=#{result.length}"
puts "synthetic_file=#{result.first}"
