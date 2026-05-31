puts GitModifiedLines::VERSION

# Test the DIFF_HUNK_REGEX constant by scanning a sample diff hunk string
sample = "@@ -1,3 +10,5 @@ some context"
matches = sample.scan(GitModifiedLines::DIFF_HUNK_REGEX)
puts matches.length
puts matches.first.inspect

# Single line added (no comma in range)
sample2 = "@@ -5 +20 @@ context"
matches2 = sample2.scan(GitModifiedLines::DIFF_HUNK_REGEX)
puts matches2.length
puts matches2.first.inspect

# Multiple hunks
multi = "@@ -1 +1 @@\n@@ -10,3 +20,4 @@ foo"
matches3 = multi.scan(GitModifiedLines::DIFF_HUNK_REGEX)
puts matches3.length
