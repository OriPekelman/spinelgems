# smoke: gabba-gmp — GabbaGMP::GabbaGMP, Campaign, ParameterMap
# Tests real logic without network. net/http/persistent is an external gem.
# We stub only Net::HTTP::Persistent (not the whole Net::HTTP) after stdlib loads.

require 'net/http'

# Now stub Persistent on top of the already-loaded Net::HTTP
class Net::HTTP
  class Persistent
    def initialize(name = nil, proxy = nil); end
    def request(uri, req); OpenStruct.new(code: "200", body: ""); end
  end
end

# Pre-mark net/http/persistent as already loaded
$LOADED_FEATURES << 'net/http/persistent' unless $LOADED_FEATURES.include?('net/http/persistent')

require 'gabba-gmp'

# 1. VERSION constant
puts GabbaGMP::VERSION

# 2. Campaign: present? and attributes
camp = GabbaGMP::GabbaGMP::Campaign.new
puts camp.present?   # false

camp.name   = "summer_sale"
camp.source = "newsletter"
camp.medium = "email"
puts camp.present?   # true
puts camp.name
puts camp.source
puts camp.medium

# 3. ParameterMap — check a few key GA_PARAMS entries
pm = GabbaGMP::GabbaGMP::ParameterMap::GA_PARAMS
puts pm[:tracking_id]     # tid
puts pm[:client_id]       # cid
puts pm[:hit_type]        # t
puts pm[:event_category]  # ec
puts pm[:dimension_1]     # cd1
puts pm[:dimension_200]   # cd200

# 4. preferred_language logic (private, tested via send)
class FakeRequest
  def host; "example.com"; end
  def remote_ip; "127.0.0.1"; end
  def user_agent; "TestAgent/1.0"; end
  def accept_language; "en-US,en;q=0.9,fr;q=0.8"; end
  def referrer; nil; end
  def protocol; "http://"; end
  def host_with_port; "example.com:80"; end
  def fullpath; "/test/path"; end
end

cookies = { utm_visitor_uuid: "test-uuid-1234" }
req = FakeRequest.new
g = GabbaGMP::GabbaGMP.new("UA-TESTID-1", req, cookies)

puts g.send(:preferred_language, "en-US,en;q=0.9,fr;q=0.8")  # en-us
puts g.send(:preferred_language, "FR,fr;q=0.9")               # fr
puts g.send(:preferred_language, nil).inspect                  # ""

# 5. DIMENSION_MAX constant
puts GabbaGMP::GabbaGMP::DIMENSION_MAX   # 200

# 6. escape private method
puts g.send(:escape, "hello")      # hello
puts g.send(:escape, "it's*fun")  # it'0s'2fun
puts g.send(:escape, nil).inspect  # nil
puts g.send(:escape, 123)          # 123
