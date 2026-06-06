require 'zipwhip'

# ZipWhip::sms_header builds a URI + Net::HTTP + Net::HTTP::Post
# Exercise it with a realistic (but no-network) URL and inspect what was set up.

token = "sess_" + "abc123"
phone = "+15005550006"
msg   = "Hello+World"

# Build the URI string exactly as send_new_sms would
uri_str = "https://api.zipwhip.com/message/send?session=#{token}&body=#{msg}&contacts=ptn:/#{phone}"

# Call sms_header — it returns the Net::HTTP::Post request object
req = ZipWhip.sms_header(uri_str)

puts req.class
puts req.path.start_with?("/message/send") ? "path_ok" : "path_bad:#{req.path}"

# The @http object is set as a class instance variable; peek via instance_variable_get
http = ZipWhip.instance_variable_get(:@http)
puts http.class
puts http.address
puts http.port
puts http.use_ssl? ? "ssl_on" : "ssl_off"

# Verify @request is the same object returned
req2 = ZipWhip.instance_variable_get(:@request)
puts req.equal?(req2) ? "request_consistent" : "request_mismatch"
