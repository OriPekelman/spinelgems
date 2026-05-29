class AnsibleHelper
  include Ansible
end

h = AnsibleHelper.new

# Test strip_escapes - strip ANSI codes from a string
s = "\e[31mHello\e[0m World"
puts h.strip_escapes(s)

# Test with plain string (no escapes)
s2 = "no escapes here"
puts h.strip_escapes(s2)

# Test escape_to_html with plain text
puts h.escape_to_html("plain text")

# Test escape_to_html with color code
puts h.escape_to_html("\e[32mgreen\e[0m")

# Test ansi_escaped with nil-ish empty string
puts h.ansi_escaped("").inspect

# Test ansi_escaped with normal string
puts h.ansi_escaped("hello")
