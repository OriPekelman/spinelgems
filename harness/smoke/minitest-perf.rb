# smoke: minitest-perf — exercises Run/Test lifecycle with stubbed persistence
require 'minitest-perf'

# Stub out database persistence so no SQLite3 / network needed
module Minitest
  module Perf
    class FakePersistence
      attr_reader :written

      def initialize
        @written = []
      end

      def write(test)
        @written << test
      end
    end

    @persistence = FakePersistence.new

    def self.persistence
      @persistence
    end
  end
end

puts Minitest::Perf::VERSION

# Exercise Run + Test lifecycle
t0 = Time.at(1_700_000_000)
run = Minitest::Perf::Run.new(t0)

run.start('BenchSuite', 'test_alpha', t0)
run.finish('BenchSuite', 'test_alpha', t0 + 0.050)

run.start('BenchSuite', 'test_beta', t0 + 0.050)
run.finish('BenchSuite', 'test_beta', t0 + 0.050 + 0.200)

run.start('OtherSuite', 'test_gamma', t0 + 0.250)
run.finish('OtherSuite', 'test_gamma', t0 + 0.250 + 1.000)

puts run.tests.length

run.tests.each do |t|
  puts "#{t.suite}/#{t.name}: #{t.total.round(3)}"
end

# Verify persistence received the writes
puts Minitest::Perf.persistence.written.length

# Exercise add_test directly (public API)
extra = Minitest::Perf::Test.new(t0, 'ManualSuite', 'test_direct', 0.007)
run.add_test(extra)
puts run.tests.length
puts run.tests.last.name
puts run.tests.last.total
