require 'ezdyn'

# 1. Module-level constants
puts EZDyn::VERSION
puts EZDyn::API_RETRY_MAX_ATTEMPTS
puts EZDyn::API_RETRY_DELAY_SECONDS

# 2. RecordType: valid_type? and find
puts EZDyn::RecordType.valid_type?(:a)
puts EZDyn::RecordType.valid_type?(:cname)
puts EZDyn::RecordType.valid_type?(:bogus)

# 3. RecordType: find by symbol and by string
rt_a = EZDyn::RecordType.find(:a)
puts rt_a.name
puts rt_a.uri_name
puts rt_a.value_key
puts rt_a.to_s

rt_mx = EZDyn::RecordType.find("MX")
puts rt_mx.name
puts rt_mx.uri_name
puts rt_mx.value_key.inspect

rt_txt = EZDyn::RecordType.find("TXTRecord")
puts rt_txt.name
puts rt_txt.value_key

# Find by RecordType instance returns same object
puts EZDyn::RecordType.find(rt_a).equal?(rt_a)

# 4. Response: construct with a mock HTTP response object
MockHTTPResponse = Struct.new(:body)

success_body = JSON.generate({
  "status" => "success",
  "job_id" => nil,
  "msgs" => [
    { "INFO" => "all is well", "LVL" => "INFO", "ERR_CD" => nil, "SOURCE" => "BLL" }
  ],
  "data" => { "zone" => "example.com" }
})

resp = EZDyn::Response.new(MockHTTPResponse.new(success_body))
puts resp.status
puts resp.success?
puts resp.delayed?
puts resp.data.inspect
puts resp.simple_message

# 5. Response: delayed pseudo-response (job URI body)
delayed_resp = EZDyn::Response.new(MockHTTPResponse.new("/REST/Job/42"))
puts delayed_resp.status
puts delayed_resp.delayed?
puts delayed_resp.job_id
