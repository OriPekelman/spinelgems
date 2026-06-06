# frozen_string_literal: true
# smoke: midwire_common — BottomlessHash, TimeTool, NumberBehavior

require 'midwire_common'
require 'midwire_common/hash'
require 'midwire_common/time_tool'
require 'midwire_common/number_behavior'

# --- BottomlessHash ---
bh = MidwireCommon::BottomlessHash.new
bh[:a][:b][:c] = 42
puts bh[:a][:b][:c]          # 42
puts bh[:x][:y].class        # MidwireCommon::BottomlessHash
puts bh[:a][:b].is_a?(Hash)  # true

h2 = MidwireCommon::BottomlessHash.from_hash({ name: 'Alice', score: 100 })
puts h2[:name]   # Alice
puts h2[:score]  # 100

# --- TimeTool ---
puts MidwireCommon::TimeTool.time_to_seconds('01:30:00')  # 5400
puts MidwireCommon::TimeTool.time_to_seconds('00:02:30')  # 150
puts MidwireCommon::TimeTool.time_to_seconds('')          # -1
puts MidwireCommon::TimeTool.seconds_to_time(5400)        # 01:30:00
puts MidwireCommon::TimeTool.seconds_to_time(150)         # 00:02:30
puts MidwireCommon::TimeTool.seconds_to_time(nil)         # unknown

# --- NumberBehavior (commify) via a wrapper object ---
class MyNum
  include MidwireCommon::NumberBehavior
  def initialize(v); @v = v; end
  def to_s; @v.to_s; end
end

puts MyNum.new(1234567).commify  # 1,234,567
puts MyNum.new(1000).commify     # 1,000
puts MyNum.new(999).commify      # 999
