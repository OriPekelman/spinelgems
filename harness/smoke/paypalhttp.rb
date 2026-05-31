# PayPalHttp smoke: Environment and error classes (pure, no network)
env = PayPalHttp::Environment.new("https://api.sandbox.paypal.com")
puts env.base_url

env.base_url = "https://api.paypal.com"
puts env.base_url

err = PayPalHttp::HttpError.new(404, "Not Found", {"content-type" => "text/plain"})
puts err.status_code
puts err.result
puts err.headers["content-type"]

ue = PayPalHttp::UnsupportedEncodingError.new("bad encoding")
puts ue.message
