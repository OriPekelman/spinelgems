# Subclass to suppress terminal I/O side effects
class SilentCmdr < Cmdr
  def reveal(c); end
  def cli_update(s=''); end
  def clear_cli(); end
  def display_output(s=''); end
end

c = SilentCmdr.new

result = nil
c.input('a')
c.input('b')
c.input('c')
c.input("\r") { |cmd| result = cmd; cmd }
puts result

result2 = nil
c.input('d')
c.input('e')
c.input("\r") { |cmd| result2 = cmd; cmd }
puts result2

# backspace is : x y <del> z => "xz"
c2 = SilentCmdr.new
c2.input('x')
c2.input('y')
c2.input("")
c2.input('z')
result3 = nil
c2.input("\r") { |cmd| result3 = cmd; cmd }
puts result3

puts "done"
