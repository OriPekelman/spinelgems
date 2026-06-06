# File.exists? was removed in Ruby 3.2; patch before loading the gem
class File
  def self.exists?(path)
    exist?(path)
  end
end

require 'svn2git'

# Test 1: DEFAULT_AUTHORS_FILE constant
puts "DEFAULT_AUTHORS_FILE: #{Svn2Git::DEFAULT_AUTHORS_FILE}"

# Test 2: class method escape_quotes
puts Svn2Git::Migration.escape_quotes("it's a \"test\"")
puts Svn2Git::Migration.escape_quotes("no quotes here")
puts Svn2Git::Migration.escape_quotes("mix'n\"match")

# Test 3: class method checkout_svn_branch
puts Svn2Git::Migration.checkout_svn_branch("feature/my-branch")
puts Svn2Git::Migration.checkout_svn_branch("trunk")

# Test 4: parse returns default options (File.exists? on DEFAULT_AUTHORS_FILE will return false
# since ~/.svn2git/authors doesn't exist on this machine, so no authors key in defaults)
m = Svn2Git::Migration.new(["http://svn.example.com/repo"])
opts = m.instance_variable_get(:@options)

puts "verbose: #{opts[:verbose]}"
puts "metadata: #{opts[:metadata]}"
puts "trunk: #{opts[:trunk]}"
puts "rootistrunk: #{opts[:rootistrunk]}"
puts "nominimizeurl: #{opts[:nominimizeurl]}"
puts "branches: #{opts[:branches].inspect}"
puts "tags: #{opts[:tags].inspect}"
puts "exclude: #{opts[:exclude].inspect}"
puts "revision: #{opts[:revision].inspect}"

# Test 5: parse with custom flags
m2 = Svn2Git::Migration.new(["--trunk", "trunk", "--branches", "branches", "--tags", "tags", "http://svn.example.com/repo"])
opts2 = m2.instance_variable_get(:@options)
puts "custom trunk: #{opts2[:trunk]}"
puts "custom branches: #{opts2[:branches].inspect}"
puts "custom tags: #{opts2[:tags].inspect}"

# Test 6: parse with --rootistrunk
m3 = Svn2Git::Migration.new(["--rootistrunk", "http://svn.example.com/repo"])
opts3 = m3.instance_variable_get(:@options)
puts "rootistrunk mode trunk: #{opts3[:trunk].inspect}"
puts "rootistrunk mode branches: #{opts3[:branches].inspect}"
puts "rootistrunk mode tags: #{opts3[:tags].inspect}"

# Test 7: escape_quotes instance method via delegation
puts m.escape_quotes("author's \"name\"")
