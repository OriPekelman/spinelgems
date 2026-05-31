# Smoke: bychar - constants and character reading via a simple mock IO
puts Bychar::VERSION
puts Bychar::DEFAULT_BUFFER_SIZE

# Minimal mock IO that responds to #read(n)
class MockIO
  def initialize(str)
    @str = str
    @pos = 0
  end
  def read(n)
    return nil if @pos >= @str.length
    chunk = @str[@pos, n]
    @pos += chunk.length
    chunk
  end
end

wrapper = Bychar.wrap(MockIO.new("abc"))
puts wrapper.read_one_char
puts wrapper.read_one_char
puts wrapper.read_one_char
puts wrapper.read_one_char.nil?
