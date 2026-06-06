require 'mail_address'

# ---- 1. Simple address parsing ----
addrs = MailAddress.parse('user@example.com')
a = addrs.first
puts a.address      # => user@example.com
puts a.user         # => user
puts a.host         # => example.com
puts a.format       # => user@example.com

# ---- 2. Named address parsing ----
addrs2 = MailAddress.parse('"John Doe" <john@example.org>')
b = addrs2.first
puts b.address      # => john@example.org
puts b.name         # => John Doe
puts b.format       # => "John Doe" <john@example.org>

# ---- 3. Multiple addresses (comma separated) ----
list = MailAddress.parse('alice@example.com, Bob <bob@example.net>')
puts list.length    # => 2
puts list[0].user   # => alice
puts list[1].name   # => Bob
puts list[1].host   # => example.net

# ---- 4. parse_first convenience method ----
first = MailAddress.parse_first('carol@example.io, dave@example.io')
puts first.user     # => carol

# ---- 5. Simple parser (Google Closure port) ----
sp = MailAddress.parse_simple('"Eve Smith" <eve@example.com>, frank@example.com')
puts sp.length      # => 2
puts sp[0].address  # => eve@example.com
puts sp[0].name     # => Eve Smith
puts sp[1].address  # => frank@example.com

# ---- 6. quoted_address for unusual local parts ----
tricky = MailAddress::Address.new('', 'dot..dot@example.com', 'dot..dot@example.com')
puts tricky.quoted_address  # => "dot..dot"@example.com

# ---- 7. Invalid address falls back ----
bad = MailAddress.parse('not-an-address')
puts bad.first.address.nil?  # => true
