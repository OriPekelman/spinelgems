require 'pdftk-heroku'

# Verify the version constant
puts Pdftk::Heroku::VERSION

# The gem's primary purpose: prepend the bundled pdftk binary dir to PATH
# at require-time. Verify PATH now includes the binaries directory.
gem_lib_dir = File.dirname(File.expand_path(__FILE__))
# The binaries live in <gem_root>/lib/pdftk-heroku/binaries
# We can detect the presence by checking PATH for a dir ending in pdftk-heroku/binaries
path_entries = ENV['PATH'].split(':')
has_pdftk_in_path = path_entries.any? { |p| p.end_with?('pdftk-heroku/binaries') }
puts has_pdftk_in_path ? "PATH_CONTAINS_PDFTK_BINARIES" : "PATH_MISSING_PDFTK"

# The LD_LIBRARY_PATH is also set
ldpath_entries = ENV.fetch('LD_LIBRARY_PATH', '').split(':')
has_ldpath = ldpath_entries.any? { |p| p.end_with?('pdftk-heroku/binaries') }
puts has_ldpath ? "LDPATH_CONTAINS_PDFTK" : "LDPATH_MISSING_PDFTK"

# Verify module nesting
puts Pdftk::Heroku.is_a?(Module) ? "MODULE_OK" : "MODULE_ERR"
puts Pdftk.is_a?(Module) ? "OUTER_MODULE_OK" : "OUTER_MODULE_ERR"
