puts RFC822::EMAIL.class
puts ("valid@example.com" =~ RFC822::EMAIL) ? "match" : "no match"
puts ("invalid@@example.com" =~ RFC822::EMAIL) ? "match" : "no match"
puts ("user.name+tag@sub.domain.org" =~ RFC822::EMAIL) ? "match" : "no match"
puts ("notanemail" =~ RFC822::EMAIL) ? "match" : "no match"
puts RFC822::Patterns::ATOM.class
puts RFC822::MXRecord.members.sort.inspect
