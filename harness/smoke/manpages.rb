# frozen_string_literal: true

require 'manpages'
require 'tmpdir'
require 'pathname'

# Build a temporary gem directory with a man/ subdirectory and some fake manpages
Dir.mktmpdir('manpages_smoke') do |tmpdir|
  gem_dir = tmpdir
  man_dir = File.join(gem_dir, 'man')
  man1_dir = File.join(man_dir, 'man1')
  man3_dir = File.join(man_dir, 'man3')
  Dir.mkdir(man_dir)
  Dir.mkdir(man1_dir)
  Dir.mkdir(man3_dir)

  # Create fake man page files
  File.write(File.join(man1_dir, 'foo.1'), '.TH foo 1')
  File.write(File.join(man3_dir, 'bar.3'), '.TH bar 3')
  File.write(File.join(man1_dir, 'baz.1'), '.TH baz 1')
  # A non-manpage file (should be excluded)
  File.write(File.join(man_dir, 'README'), 'not a manpage')

  target_dir = File.join(tmpdir, 'target')
  Dir.mkdir(target_dir)

  mf = Manpages::ManFiles.new(gem_dir, target_dir)

  # Test manpages_present?
  puts "manpages_present?: #{mf.manpages_present?}"

  # Test manpages — should find exactly 3 files with digit extensions
  pages = mf.manpages.map(&:basename).map(&:to_s).sort
  puts "manpages count: #{pages.size}"
  puts "manpages: #{pages.join(', ')}"

  # Test man_file_path for a section-1 file
  p1 = Pathname.new(File.join(man1_dir, 'foo.1'))
  path1 = mf.man_file_path(p1)
  puts "man_file_path foo.1: #{path1.to_s.sub(target_dir, '<target>')}"

  # Test man_file_path for a section-3 file
  p3 = Pathname.new(File.join(man3_dir, 'bar.3'))
  path3 = mf.man_file_path(p3)
  puts "man_file_path bar.3: #{path3.to_s.sub(target_dir, '<target>')}"

  # Test with a gem dir that has NO man/ directory
  empty_gem = File.join(tmpdir, 'empty_gem')
  Dir.mkdir(empty_gem)
  mf2 = Manpages::ManFiles.new(empty_gem, target_dir)
  puts "no-man-dir present?: #{mf2.manpages_present?}"
  puts "no-man-dir pages: #{mf2.manpages.inspect}"
end
