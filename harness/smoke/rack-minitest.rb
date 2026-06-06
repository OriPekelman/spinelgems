# Smoke: rack-minitest — exercise Rack::Minitest::Assertions logic directly
# without depending on rack-test or minitest runtime.

require 'rack-minitest'
require 'rack-minitest/assertions'
require 'rack-minitest/version'

# Minimal mock response that quacks like Rack::MockResponse
MockResponse = Struct.new(:status)

# Include Assertions in a plain test context
class HttpChecker
  include Rack::Minitest::Assertions

  def assert(condition, msg = nil)
    raise "Assertion failed: #{msg}" unless condition
  end

  def check_status(mock_status, expected)
    resp = MockResponse.new(mock_status)
    begin
      assert_response_status(resp, expected)
      "PASS #{mock_status}==#{expected}"
    rescue => e
      "FAIL: #{e.message}"
    end
  end
end

checker = HttpChecker.new

# VERSION constant
puts "VERSION=#{Rack::Minitest::VERSION}"

# assert_response_status: matching cases
puts checker.check_status(200, 200)
puts checker.check_status(201, 201)
puts checker.check_status(404, 404)
puts checker.check_status(500, 500)

# assert_response_status: mismatch
resp_400 = MockResponse.new(400)
begin
  checker.assert_response_status(resp_400, 200)
  puts "FAIL: expected raise"
rescue RuntimeError => e
  puts "MISMATCH:#{e.message}"
end

# Named helpers — assert_ok, assert_not_found, assert_bad_request
puts checker.check_status(200, 200)  # assert_ok equivalent

# confirm module inclusion order
puts "Assertions included: #{HttpChecker.ancestors.include?(Rack::Minitest::Assertions)}"
puts "done"
