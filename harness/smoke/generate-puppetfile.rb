# Smoke test for generate-puppetfile 1.1.0
# Tests pure-logic methods that don't require puppet, network, or filesystem.
# Stubs out mkmf (missing ruby-dev headers) and colorize (not installed).

module Kernel
  alias_method :_orig_require_gpf, :require
  def require(name)
    return true if name == 'mkmf' || name == 'colorize'
    _orig_require_gpf(name)
  end
end

module MakeMakefile
  module Logging
    def self.instance_variable_set(*args); end
  end
end
def find_executable0(name); nil; end

module ColorizeStub
  def red;   self; end
  def blue;  self; end
  def green; self; end
end
class String; include ColorizeStub; end

require 'generate_puppetfile'
require 'generate_puppetfile/bin'

# --- 1. VERSION constant ---
puts "version=#{GeneratePuppetfile::VERSION}"

# --- 2. Bin#validate: module name validation ---
b = GeneratePuppetfile::Bin.new([])
b.instance_variable_set(:@options, {})

puts "validate puppetlabs/stdlib=#{b.validate('puppetlabs/stdlib') ? 'true' : 'false'}"
puts "validate author-module=#{b.validate('author-module') ? 'true' : 'false'}"
require 'stringio'
# Capture stderr to suppress the "not a valid module name" message for bad input
old_stderr = $stderr; $stderr = StringIO.new
puts "validate invalid=#{b.validate('invalid') ? 'true' : 'false'}"
$stderr = old_stderr

# --- 3. Bin#generate_forge_module_output: formatted module list ---
b.instance_variable_set(:@module_data, {
  'puppetlabs/stdlib'  => '8.5.0',
  'puppet/nginx'       => '3.3.0',
  'saz/sudo'           => '7.0.1'
})
output = b.generate_forge_module_output
# Print each line (strip trailing newline)
output.each_line { |l| print l }

# --- 4. Bin#generate_puppetfile_contents with extras ---
extras = [
  "mod 'mymod',\n",
  "  :git => 'https://github.com/example/puppet-mymod'\n"
]
pf = b.generate_puppetfile_contents(extras)
puts pf.chomp

# --- 5. Bin#generate_puppetfile_contents: ignore_comments strips comment lines ---
b.instance_variable_set(:@options, { ignore_comments: true })
pf_no_comments = b.generate_puppetfile_contents([])
has_comments = pf_no_comments.lines.any? { |l| l.strip.start_with?('#') }
puts "ignore_comments strips headers=#{has_comments ? 'false' : 'true'}"

# --- 6. Regex constants behave correctly ---
mod_line   = "mod 'puppetlabs/apache', '5.0.0'"
forge_line = "forge 'https://forge.puppet.com'"
blank_line = "   "

puts "Module_Regex matches mod=#{GeneratePuppetfile::Bin::Module_Regex.match?(mod_line)}"
puts "Forge_Regex matches forge=#{GeneratePuppetfile::Bin::Forge_Regex.match?(forge_line)}"
puts "Blanks_Regex matches blank=#{GeneratePuppetfile::Bin::Blanks_Regex.match?(blank_line)}"
