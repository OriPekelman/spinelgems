require 'regular_validation'

# Test username regex
username_re = RegularValidation.username
puts username_re.class

valid_usernames = ["alice", "bob123", "user.name", "john_doe42"]
invalid_usernames = ["1bad", "_nope", "no!", ""]

valid_usernames.each do |u|
  puts "#{u}: #{!!(username_re =~ u)}"
end

invalid_usernames.each do |u|
  puts "#{u}: #{!!(username_re =~ u)}"
end

# Test email regex
email_re = RegularValidation.email
puts email_re.class

valid_emails = ["user@example.com", "foo@bar.baz", "test@sub.domain.org"]
invalid_emails = ["notanemail", "@nodomain.com", "missing@", "double@@at.com"]

valid_emails.each do |e|
  puts "#{e}: #{!!(email_re =~ e)}"
end

invalid_emails.each do |e|
  puts "#{e}: #{!!(email_re =~ e)}"
end
