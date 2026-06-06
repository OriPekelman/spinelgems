# frozen_string_literal: true
# Smoke test for ruby-pwsh — exercises pure-Ruby utility methods and
# code-generation logic without requiring a live PowerShell process.

require 'ruby-pwsh'

# --- Pwsh::Util string-case helpers ---
puts Pwsh::Util.snake_case('FooBarBaz')          # => "foo_bar_baz"
puts Pwsh::Util.snake_case('HTTPSConnection')     # => "https_connection"
puts Pwsh::Util.snake_case(:CamelCase)            # => "camel_case" (Symbol -> Symbol)
puts Pwsh::Util.pascal_case('snake_case_value')  # => "SnakeCaseValue"
puts Pwsh::Util.pascal_case(:foo_bar)             # => "FooBar" (Symbol -> Symbol)

# --- Pwsh::Util format_powershell_value ---
puts Pwsh::Util.format_powershell_value(true)
puts Pwsh::Util.format_powershell_value(false)
puts Pwsh::Util.format_powershell_value(42)
puts Pwsh::Util.format_powershell_value("hello world")
puts Pwsh::Util.format_powershell_value("it's alive")   # quotes escaped
puts Pwsh::Util.format_powershell_value(['a', 'b', 1])
puts Pwsh::Util.format_powershell_value({ 'Key' => 'Value', 'Num' => 7 })

# --- Pwsh::Util custom_powershell_property ---
puts Pwsh::Util.custom_powershell_property('Size', '$_.Length')

# --- Pwsh::Util hash key transformers ---
h = { 'FooBar' => { 'BazQux' => 1 }, 'AnotherKey' => 2 }
snake = Pwsh::Util.snake_case_hash_keys(h)
puts snake.keys.sort.inspect
puts snake['foo_bar'].inspect

pascal_h = { foo_bar: 'v', baz_qux: 'w' }
pc = Pwsh::Util.pascal_case_hash_keys(pascal_h)
puts pc.keys.sort_by(&:to_s).inspect

# --- Pwsh::Util on_windows? (should be false on Linux) ---
puts Pwsh::Util.on_windows?.inspect

# --- Pwsh::Manager class-level helpers (no process needed) ---
puts Pwsh::Manager.default_options.inspect
puts Pwsh::Manager.instance_key('/usr/bin/pwsh', ['-NoProfile'], { debug: false }).inspect
puts Pwsh::Manager.pwsh_args.inspect
puts Pwsh::Manager.instances.class

# --- Manager#make_ps_code (pure string interpolation, no process) ---
mgr = Pwsh::Manager.allocate
code = mgr.make_ps_code('Get-Process', 5000, '/tmp', ['FOO=bar', 'BAZ=qux'])
puts code.include?('Get-Process')
puts code.include?('TimeoutMilliseconds')
puts code.include?("'FOO' = 'bar'")

# --- Manager#length_prefixed_string (pure encoding) ---
packed = mgr.length_prefixed_string('hello')
# First 4 bytes encode length 5 in little-endian
length = packed.byteslice(0, 4).unpack1('V')
puts length
puts packed.byteslice(4, length)

# --- Manager.read_length_prefixed_string! (parse bytes) ---
bytes = [5, 0, 0, 0].pack('C*') + 'world'
result = Pwsh::Manager.read_length_prefixed_string!(bytes)
puts result

# --- Manager.ps_output_to_hash! ---
def encode_str(s)
  [s.length, 0, 0, 0].pack('C*') + s
end
raw = encode_str('exitcode') + encode_str('0') + encode_str('stderr') + encode_str('')
h2 = Pwsh::Manager.ps_output_to_hash!(raw)
puts h2[:exitcode]
puts h2[:stderr].inspect
