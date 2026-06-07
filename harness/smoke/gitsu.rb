require 'gitsu'

# Exercise GitSu::User.parse and core accessors
alice = GitSu::User.parse("Alice Smith <alice@example.com>")
puts alice.name
puts alice.email
puts alice.initials
puts alice.to_s

bob = GitSu::User.parse("Bob Jones <bob@example.com>")
puts bob.name
puts bob.email
puts bob.initials

# Combine two users (paired programming scenario)
group_email = "team@example.com"
pair = alice.combine(bob, group_email)
puts pair.name
puts pair.email

# NONE user sentinel
puts GitSu::User::NONE.to_s

# none? predicate
puts alice.none?
puts GitSu::User::NONE.none?

# combine with NONE returns the non-NONE user
puts alice.combine(GitSu::User::NONE, group_email).to_s
puts GitSu::User::NONE.combine(alice, group_email).to_s

# Exercise Array extensions (monkey-patched by gitsu/array)
words = ["apple", "banana", "cherry"]
puts words.to_sentence

puts ["solo"].to_sentence
puts [].to_sentence

puts words.quote.inspect
puts words.pluralize("item")
puts ["x"].pluralize("item")

# Exercise GitSu::Version.parse and arithmetic
v = GitSu::Version.parse("1.2.3")
puts v.to_s
puts v.major
puts v.minor
puts v.patch
puts v.next_minor.to_s
puts v.next_patch.to_s

# current version
cur = GitSu::Version.current
puts cur.to_s

# ParseError raised on bad input
begin
  GitSu::User.parse("bad input")
rescue GitSu::User::ParseError => e
  puts "ParseError: #{e.message}"
end

begin
  GitSu::Version.parse("not-a-version")
rescue GitSu::Version::ParseError => e
  puts "VersionParseError: #{e.message}"
end
