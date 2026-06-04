require 'screw_driver'

# screw_driver is a Cucumber reporting gem. Its methods require $FILENAME
# (set by Cucumber runtime, read-only in standalone Ruby) and do Windows-path
# filesystem writes. We test: module structure, VERSION, and the core string
# processing logic the gem applies to feature file paths.

# 1. Module and VERSION
puts "version: #{ScrewDriver::VERSION}"
puts "module_defined: #{defined?(ScrewDriver)}"

# 2. Verify the module defines expected instance methods
methods = ScrewDriver.instance_methods(false).sort
puts "methods: #{methods.join(',')}"

# 3. The gem's core string logic: parse feature file path, extract name
#    This is the same pattern used in all ScrewDriver methods.
filenames = [
  "/home/user/features/login.feature",
  "/projects/qa/cucumber/checkout_flow.feature",
  "c:/tests/user_registration.feature",
]

filenames.each do |fn|
  parts = fn.split('/')
  feature_name = parts.last.chomp('.feature')
  puts "parsed: #{feature_name}"
end

# 4. Time formatting — strftime used in make_html
t = Time.new(2024, 6, 15, 14, 30, 0)
formatted = t.strftime("%m/%d/%Y %H:%M")
tsp = formatted.split(' ')
puts "date: #{tsp[0]}"
puts "time: #{tsp[1]}"

# 5. Path construction logic (the Windows-style concatenation the gem uses)
#    Exercise the same string operations without filesystem side effects
pwd_stub = "/home/user"
feature_name = "checkout_flow"
path = pwd_stub + '\Screw Driver Reports\\'
dir_path = path + feature_name
puts "dir_path_suffix: #{dir_path.split('\\').last}"

# 6. HTML template contains feature name interpolation (same as make_html)
feature_name2 = "user_registration"
snippet = "<td>#{feature_name2}</td>"
puts "html_feature: #{snippet}"
