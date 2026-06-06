require 'lcoveralls'

# 1. VERSION constant is an Array of version components
v = Lcoveralls::VERSION
puts "version class: #{v.class}"
puts "version parts: #{v.length}"
puts "major: #{v[0]}, minor: #{v[1]}, patch: #{v[2]}"

# 2. ColorFormatter — no color mode: plain text, severity routing
fmt = Lcoveralls::ColorFormatter.new(false)

# INFO severity → no prefix, just message + newline
result = fmt.call('INFO', Time.now, nil, 'hello world')
puts "info msg: #{result.chomp}"

# WARN severity → mapped to 'Warning' prefix
result = fmt.call('WARN', Time.now, nil, 'disk full')
puts "warn msg: #{result.chomp}"

# ERROR severity → prefixed
result = fmt.call('ERROR', Time.now, nil, 'connection refused')
puts "error msg: #{result.chomp}"

# FATAL severity → prefixed
result = fmt.call('FATAL', Time.now, nil, 'out of memory')
puts "fatal msg: #{result.chomp}"

# UNKNOWN severity → prefixed
result = fmt.call('UNKNOWN', Time.now, nil, 'mystery')
puts "unknown msg: #{result.chomp}"

# DEBUG severity → no prefix (not in WARNING/ERROR/FATAL/UNKNOWN set)
result = fmt.call('DEBUG', Time.now, nil, 'trace data')
puts "debug msg: #{result.chomp}"

# 3. ColorFormatter — color mode: escape codes present for Warning/Error/Fatal/Unknown
fmt_color = Lcoveralls::ColorFormatter.new(true)

warn_colored = fmt_color.call('WARN', Time.now, nil, 'disk full')
puts "warn colored contains ESC: #{warn_colored.include?("\x1b")}"

info_colored = fmt_color.call('INFO', Time.now, nil, 'hello')
puts "info colored contains ESC: #{info_colored.include?("\x1b")}"

# 4. COLOR_CODES constant check
puts "color code for Warning: #{Lcoveralls::ColorFormatter::COLOR_CODES['Warning']}"
puts "color code for Error: #{Lcoveralls::ColorFormatter::COLOR_CODES['Error']}"
puts "color code for Fatal: #{Lcoveralls::ColorFormatter::COLOR_CODES['Fatal']}"
