# histogram smoke — exercises BinCounter, BinPacker, and Bin core logic.
#
# histogram depends on terminal-table (not installed here). We stub it in a
# BEGIN block — BEGIN runs before any require_relative the harness prepends,
# so lib/histogram.rb can load successfully on both CRuby and Spinel.
BEGIN {
  # Stub the Terminal::Table namespace just enough for histogram.rb to require
  # without error. We don't call render(), so no method bodies are needed.
  # Terminal::Table is a class (not a module), and UnicodeBorder is nested in it.
  module Terminal
    class Table
      class UnicodeBorder
        def initialize; @data = {}; end
        attr_accessor :top, :left, :right
        def data; @data; end
      end
      def initialize(**opts); end
      def to_s; ""; end
    end
  end
  $LOADED_FEATURES << "terminal-table"
}

# When run standalone for CRuby sanity-check (ruby -Ilib <smoke>), load the
# gem files ourselves. Inside the harness they are prepended as require_relatives.
unless defined?(BinCounter)
  require "histogram/bin"
  require "histogram/bin_counter"
  require "histogram/bin_packer"
end

# --- integer dataset: small range -> per-unit bins ---
values = [1, 2, 2, 3, 3, 3, 4, 4, 5]
bc = BinCounter.evaluate(values)
puts "bin_count: #{bc}"
packer = BinPacker.new(bc, values.min, values.max)
puts "bin_width: #{packer.bin_width}"
packer.bins(values).each { |b| puts "#{b.range}: #{b.count}" }

# --- float dataset: max-min > 1, uses fixed bin count ---
fv = [0.1, 0.5, 0.5, 0.9, 1.5, 2.0, 2.0, 3.7]
fbc = BinCounter.evaluate(fv)
puts "float_bin_count: #{fbc}"
fp = BinPacker.new(fbc, fv.min, fv.max)
fp.bins(fv).each { |b| puts "#{b.range.min.round(4)}..#{b.range.max.round(4)}: #{b.count}" }

# --- large integer dataset: bin_count capped at sqrt or 12 ---
large = (1..100).to_a
puts "large_bin_count: #{BinCounter.evaluate(large)}"
lp = BinPacker.new(BinCounter.evaluate(large), large.min, large.max)
puts "large_bin_width: #{lp.bin_width}"
lp.bins(large).each { |b| puts "#{b.range}: #{b.count}" }
