puts Base64::VERSION
puts Base64.encode64("Hello, World!").strip
puts Base64.decode64("SGVsbG8sIFdvcmxkIQ==")
puts Base64.strict_encode64("foo bar")
puts Base64.strict_decode64("Zm9vIGJhcg==")
puts Base64.urlsafe_encode64("\xFB\xEF\xBE")
puts Base64.urlsafe_encode64("test", padding: false)
puts Base64.urlsafe_decode64("dGVzdA")
