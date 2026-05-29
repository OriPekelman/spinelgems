# Smoke: facebook_share - test constants and pure string helpers
puts FacebookShare::INIT_PARAMS.sort.inspect
puts FacebookShare::REMOVE_PARAMS.sort.inspect

# Exercise module methods by including into a test class
class TestHelper
  include FacebookShare
end

obj = TestHelper.new
# facebook_share_code with explicit options to avoid 'request' lookup
code = obj.facebook_share_code(
  app_id: "12345",
  selector: ".share_btn",
  link: "http://example.com",
  locale: "en_US",
  display: "popup",
  framework: :jquery,
  jquery_function: "$"
)
# Print just first non-empty line (the FB.ui call) which is deterministic
first_line = code.strip.lines.first.strip
puts first_line
