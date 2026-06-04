require 'clean_pagination'

# Stub Rails-like request/response/headers objects so the mixin runs
# without Rails. We exercise the real pagination arithmetic directly.

# ActiveSupport stubs needed by the mixin
class String
  def present?; !empty?; end
end
class NilClass
  def present?; false; end
end

class FakeHeaders
  def initialize; @store = {}; end
  def []=(k, v); @store[k] = v; end
  def [](k); @store[k]; end
  def to_h; @store; end
end

class FakeRequest
  attr_reader :headers, :url
  def initialize(range_unit: nil, range: nil, url: 'http://example.com/items')
    @url = url
    @headers = FakeHeaders.new
    @headers['Range-Unit'] = range_unit if range_unit
    @headers['Range']      = range      if range
  end
end

class FakeResponse
  attr_accessor :status
  def initialize; @status = 200; end
end

class FakeController
  include CleanPagination

  attr_reader :request, :response, :headers, :rendered

  def initialize(range_unit: nil, range: nil)
    @request  = FakeRequest.new(range_unit: range_unit, range: range)
    @response = FakeResponse.new
    @headers  = FakeHeaders.new
    @rendered = nil
  end

  # Rails stub used on invalid range
  def render(text: nil)
    @rendered = text
  end
end

def run_case(label, total_items, max_range_size, range_unit: nil, range: nil)
  ctrl = FakeController.new(range_unit: range_unit, range: range)
  limit_out = nil
  from_out  = nil
  ctrl.paginate(total_items, max_range_size) do |limit, from|
    limit_out = limit
    from_out  = from
  end
  puts "#{label}: status=#{ctrl.response.status} content-range=#{ctrl.headers['Content-Range']} limit=#{limit_out} from=#{from_out} link=#{ctrl.headers['Link'].inspect}"
rescue RangeError => e
  puts "#{label}: RangeError(#{e.message})"
end

# Case 1: rangeless request — full collection fits within max
run_case('full-fit',         100, 100)

# Case 2: rangeless request — collection exceeds max → truncated 206
run_case('truncate',         101, 100)

# Case 3: explicit range that fits
run_case('explicit-range',   101, 100, range_unit: 'items', range: '0-99')

# Case 4: range larger than max → truncated
run_case('oversized-range',  101, 100, range_unit: 'items', range: '0-100')

# Case 5: invalid range (from > to) → 416
run_case('invalid-range',    101, 100, range_unit: 'items', range: '1-0')

# Case 6: range with offset — checks link headers (prev/next/first/last)
run_case('mid-page',         100,  10, range_unit: 'items', range: '20-29')

# Case 7: infinite collection — no last link
run_case('infinite',         Float::INFINITY, 10, range_unit: 'items', range: '0-9')

# Case 8: empty collection
run_case('empty',            0, 10)

# Verify suppress_infinity via direct arithmetic used inside paginate
ctrl = FakeController.new(range_unit: 'items', range: '0-9')
ctrl.paginate(Float::INFINITY, 10) { |_l, _f| }
puts "infinite-content-range: #{ctrl.headers['Content-Range']}"
