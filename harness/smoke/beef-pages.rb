# beef-pages smoke: exercises Beef::Pages module structure and
# the pure-Ruby regex + array logic from HelperMethods without Rails.

require 'pages'

# Verify module hierarchy
puts Beef::Pages::HelperMethods.class   # => Module
puts Beef::Pages::UrlHelper.class       # => Module

# Replicate the get_template_names regex logic (the core of this gem's lib)
pattern = /\/([^_][^\/]+)\.html\.erb$/

files = [
  "/app/views/pages/templates/default.html.erb",
  "/app/views/pages/templates/full_width.html.erb",
  "/app/views/pages/templates/_hidden.html.erb",
  "/app/views/pages/templates/sidebar.html.erb",
  "/app/views/pages/templates/index.html.haml",
]

names = []
files.each do |f|
  m = pattern.match(f)
  names << m[1] unless m.nil?
end
# names = ["default", "full_width", "sidebar"]

# Move default to top: separate into default + rest (avoid Array#delete)
default_entry = nil
rest = []
names.each do |n|
  if n == 'default'
    default_entry = n
  else
    rest << n
  end
end
result = default_entry ? [default_entry] + rest : rest

puts result.length           # => 3
puts result.first            # => default
puts result.last             # => sidebar
puts result.include?('full_width')  # => true
puts result.include?('_hidden')     # => false

# Verify UrlHelper is a module with the expected methods
puts Beef::Pages::UrlHelper.instance_methods(false).sort.inspect
