require 'rmail'

# --- 1. Address parsing: simple and display-name forms ---
addrs = RMail::Address.parse('John Doe <john@example.com>, jane@example.org')
puts addrs.length
puts addrs[0].display_name
puts addrs[0].local
puts addrs[0].domain
puts addrs[0].address
puts addrs[1].local
puts addrs[1].domain

# --- 2. Address format round-trip via Address::List helpers ---
a = RMail::Address.new
a.local = 'alice'
a.domain = 'example.net'
a.display_name = 'Alice Liddell'
puts a.format
puts a.address

# --- 3. Address with comment (name fallback) ---
commented = RMail::Address.parse('bob@example.org (Bob Smith)')
puts commented[0].local
puts commented[0].name

# --- 4. Address::List convenience methods ---
list_str = 'alpha@a.example, Beta User <beta@b.example>'
list = RMail::Address.parse(list_str)
puts list.addresses.join(', ')
puts list.locals.join(', ')
puts list.domains.join(', ')

# --- 5. Message construction and multipart check ---
msg = RMail::Message.new
msg.header.add('Subject', 'Hello from RMail')
msg.header.add('From', 'sender@example.com')
msg.body = 'This is the body text.'
puts msg.multipart?
puts msg.body

# Inspect headers via each (avoids Fixnum/Integer[] compat issue)
msg.header.each do |name, value|
  puts "#{name}: #{value}"
end

# --- 6. Multipart message ---
part1 = RMail::Message.new
part1.body = 'Part one'
part2 = RMail::Message.new
part2.body = 'Part two'
multi = RMail::Message.new
multi.add_part(part1)
multi.add_part(part2)
puts multi.multipart?
puts multi.body.length
