# frozen_string_literal: true
require 'identikal'

# 1. VERSION constant
puts Identikal::VERSION

# 2. COMPARE_METHODS constant
puts Identikal::Compare::COMPARE_METHODS.inspect

# 3. Error classes are proper ArgumentError subclasses
puts Identikal::Error::FileNotFound.ancestors.include?(ArgumentError)
puts Identikal::Error::InvalidComparisonMethod.ancestors.include?(ArgumentError)

# 4. FileNotFound has the right message
puts Identikal::Error::FileNotFound.new.to_s

# 5. InvalidComparisonMethod message lists valid methods
puts Identikal::Error::InvalidComparisonMethod.new.to_s

# 6. files_same? raises FileNotFound for non-existent files
begin
  Identikal.files_same?('/no/such/a.pdf', '/no/such/b.pdf')
  puts 'no error raised'
rescue Identikal::Error::FileNotFound => e
  puts "FileNotFound: #{e}"
end

# 7. files_same? raises InvalidComparisonMethod for bad method
# (validate_arguments is called before file check, so use real temp files)
require 'tempfile'
fa = Tempfile.new(['a', '.pdf'])
fb = Tempfile.new(['b', '.pdf'])
begin
  Identikal::Compare.files_same?(fa.path, fb.path, compare_method: :bad)
  puts 'no error raised'
rescue Identikal::Error::InvalidComparisonMethod => e
  puts "InvalidComparisonMethod: #{e}"
ensure
  fa.close!
  fb.close!
end
