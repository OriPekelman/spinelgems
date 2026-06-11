# MailRedirector is a Struct subclass — test struct-level API (no Rails needed)
r = MailRedirector.new("admin@example.com")
puts r.destination
puts r.class.name
