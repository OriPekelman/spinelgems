require 'git-revision'

# 1. Class structure
puts Git::Revision.class                          # => Class
puts Git::Revision.respond_to?(:commit)           # => true
puts Git::Revision.respond_to?(:branch)           # => true
puts Git::Revision.respond_to?(:info)             # => true

# 2. Each method returns a String (even when git is absent / errors)
puts Git::Revision.commit.class                   # => String
puts Git::Revision.branch.class                   # => String
puts Git::Revision.message.class                  # => String
puts Git::Revision.timestamp.class                # => String

# 3. info hash has the right keys (memoised with @info ||= {})
info = Git::Revision.info
expected_keys = [:author, :authored_date, :authored_timestamp, :branch,
                 :commit_hash, :commit_hash_short, :commit_subject,
                 :commit_tag, :long_tag, :repo_last_tag]
puts info.keys.sort == expected_keys.sort         # => true

# 4. Memoisation: calling info twice returns the exact same object
info2 = Git::Revision.info
puts info.equal?(info2)                           # => true

# 5. All values are Strings
puts info.values.all? { |v| v.is_a?(String) }    # => true
