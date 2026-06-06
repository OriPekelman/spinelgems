require 'piston'

# 1. Repository handler registry
handlers = Piston::Repository.handlers
puts "handlers_count: #{handlers.length}"
puts "handler_names: #{handlers.map(&:name).join(', ')}"

# 2. Piston::Git::Repository — URL/branch parsing, identity methods
repo = Piston::Git::Repository.new('git://github.com/example/foo.git')
puts "url: #{repo.url}"
puts "basename: #{repo.basename}"
puts "to_s: #{repo.to_s}"
puts "inspect: #{repo.inspect}"

# Branch encoded as query string gets stripped from URL, stored separately
repo_with_branch = Piston::Git::Repository.new('git://github.com/example/bar.git?feature-branch')
puts "branch_url_stripped: #{repo_with_branch.url}"
puts "branchname: #{repo_with_branch.branchname}"
puts "basename_no_git: #{repo_with_branch.basename}"

# 3. Repository equality (== delegates to url)
r1 = Piston::Git::Repository.new('git://github.com/example/foo.git')
r2 = Piston::Git::Repository.new('git://github.com/example/foo.git')
r3 = Piston::Git::Repository.new('git://github.com/example/other.git')
puts "same_url_equal: #{r1 == r2}"
puts "diff_url_equal: #{r1 == r3}"

# 4. Piston::Git::Commit — at(sha) path
commit = repo.at('abcdef1234567890')
puts "commit_class: #{commit.class.name}"
puts "commit_name_7: #{commit.name}"       # truncates to first 7 chars
puts "commit_revision: #{commit.revision}"
puts "commit_branch_name: #{commit.branch_name}"
puts "commit_inspect: #{commit.inspect}"
puts "commit_url: #{commit.url}"

# HEAD aliasing: :head -> 'master' (Commit#initialize normalises HEAD)
head_commit = repo.at(:head)
puts "head_revision: #{head_commit.revision}"

# 5. Commit built from a hash (the recalled-values path)
hash_commit = repo.at({'url' => repo.url, 'commit' => 'deadbeef00000000'})
puts "hash_commit_class: #{hash_commit.class.name}"
puts "hash_commit_revision: #{hash_commit.revision}"
puts "hash_commit_name: #{hash_commit.name}"

# 6. Git module constants
puts "git_url_key: #{Piston::Git::URL}"
puts "git_commit_key: #{Piston::Git::COMMIT}"
puts "git_branch_key: #{Piston::Git::BRANCH}"
puts "git_exclude: #{Piston::Git::EXCLUDE.inspect}"
