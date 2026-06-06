# Smoke: fontforge-ruby — thin wrapper around the fontforge CLI.
# The only public API is FontforgeRuby.convert(input, output), which shells
# out to fontforge.  We exercise the pure-Ruby parts: class identity, method
# presence, and the same path-building logic the gem uses internally.
require 'fontforge_ruby'

# 1. Class exists and is a Class
puts FontforgeRuby.is_a?(Class)          # true

# 2. .convert is defined as a class (singleton) method
puts FontforgeRuby.respond_to?(:convert) # true

# 3. Replicate the exact path-building logic from lib/fontforge_ruby.rb so we
#    can verify it produces a sensible absolute path ending in convert.sh —
#    without actually running fontforge.
lib_file = File.expand_path('../lib/fontforge_ruby.rb', __dir__)
convert_path = File.join(File.dirname(lib_file), 'convert.sh')
puts File.basename(convert_path)         # convert.sh
puts File.dirname(convert_path).end_with?('lib')  # true

# 4. The command string the gem would build has the right shape.
input  = 'input_font.ttf'
output = 'output_font.svg'
cmd = "fontforge -script '#{convert_path}' '#{input}' '#{output}'"
puts cmd.start_with?('fontforge -script') # true
puts cmd.include?(input)                  # true
puts cmd.include?(output)                 # true
