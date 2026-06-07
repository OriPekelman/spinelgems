require 'itamae-plugin-recipe-daddy'

# Exercise the version constant construction logic:
# each VERSION constant is built by joining a 3-element array with '.'
# This tests real Array#join logic and constant assignment side-effects.

m = ItamaePluginRecipeDaddy::VERSION
puts "VERSION: #{m}"

nginx = ItamaePluginRecipeDaddy::NGINX_VERSION
puts "NGINX_VERSION: #{nginx}"
puts "NGINX_VERSION parts: #{ItamaePluginRecipeDaddy::NGINX_VERSION_MAJOR}.#{ItamaePluginRecipeDaddy::NGINX_VERSION_MINOR}.#{ItamaePluginRecipeDaddy::NGINX_VERSION_PATCH}"

rtmp = ItamaePluginRecipeDaddy::NGINX_RTMP_MODULE_VERSION
puts "NGINX_RTMP_MODULE_VERSION: #{rtmp}"

opencv = ItamaePluginRecipeDaddy::OPENCV_VERSION
puts "OPENCV_VERSION: #{opencv}"

python = ItamaePluginRecipeDaddy::PYTHON_VERSION
puts "PYTHON_VERSION: #{python}"

wk = ItamaePluginRecipeDaddy::WKHTMLTOPDF_VERSION
puts "WKHTMLTOPDF_VERSION: #{wk}"

# Verify the dot-join construction matches manual concatenation
expected_nginx = [
  ItamaePluginRecipeDaddy::NGINX_VERSION_MAJOR,
  ItamaePluginRecipeDaddy::NGINX_VERSION_MINOR,
  ItamaePluginRecipeDaddy::NGINX_VERSION_PATCH
].join('.')
puts "nginx join check: #{nginx == expected_nginx}"

expected_python = [
  ItamaePluginRecipeDaddy::PYTHON_VERSION_MAJOR,
  ItamaePluginRecipeDaddy::PYTHON_VERSION_MINOR,
  ItamaePluginRecipeDaddy::PYTHON_VERSION_PATCH
].join('.')
puts "python join check: #{python == expected_python}"

# Check that WKHTMLTOPDF_VERSION_PATCH contains the '-1' suffix
puts "wkhtmltopdf patch: #{ItamaePluginRecipeDaddy::WKHTMLTOPDF_VERSION_PATCH}"
puts "wkhtmltopdf has dash: #{ItamaePluginRecipeDaddy::WKHTMLTOPDF_VERSION_PATCH.include?('-')}"
