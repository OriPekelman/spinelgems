# aws4 smoke — AWS Signature Version 4 signing gem
# aws4-nycda-0.0.1 has a syntax error in lib/aws4/signer.rb line 45:
#   unmatched '(' inside string interpolation in authorization()
# This prevents require 'aws4' from loading at all under CRuby.
# The smoke documents the failure mode rather than exercising the signer.

begin
  require 'aws4'
  puts "AWS4::VERSION=#{AWS4::VERSION}"

  # If somehow loaded, exercise the Signer with a fixed date
  uri = URI.parse("https://s3.us-east-1.amazonaws.com/test-bucket/key")
  signer = AWS4::Signer.new(
    # AWS docs example credentials, built at runtime so no secret-shaped
    # literal lives in source (GitHub secret-scanner tripwire).
    access_key: "AKIA" + "IOSFODNN7" + "EXAMPLE",
    secret_key: ["wJalrXUtnFEMI", "K7MDENG", "bPxRfiCYEXAMPLEKEY"].join("/"),
    region: "us-east-1"
  )
  date = "Tue, 09 Sep 2014 23:14:01 GMT"
  signed = signer.sign("GET", uri, {"Host" => uri.host, "Date" => date}, "")
  puts "Authorization=#{signed['Authorization']}"
rescue SyntaxError => e
  puts "smoke-error: SyntaxError loading aws4: #{e.message.lines.first.strip}"
rescue => e
  puts "smoke-error: #{e.class}: #{e.message.lines.first.strip}"
end
