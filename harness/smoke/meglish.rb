require 'meglish'

# MeglishLog tests
log = MeglishLog.new
log.log("hello from meglish log")   # should print "  >> hello from meglish log"

# Include Meglish in a test class that stubs out Calabash-specific methods
class TestHelper
  include Meglish

  attr_reader :perform_calls

  def initialize
    @perform_calls = []
  end

  # Stub out Calabash/ADB methods used by swipe_down/swipe_up
  def perform_action(*args)
    @perform_calls << args
  end
end

helper = TestHelper.new

# Test build_index: empty/nil vs. real index
puts helper.build_index(nil)    # => " "
puts helper.build_index("")     # => " "
puts helper.build_index(3)      # => " index:3 "
puts helper.build_index("foo")  # => " index:foo "

# Test swipe_down logic (boundary clamping)
helper.swipe_down(1)   # _scroll_amount < 4, clamped to 5 → down=55
call = helper.perform_calls.last
puts call.inspect   # ["drag", 50, 50, 50, 55, 5]

helper.perform_calls.clear
helper.swipe_down(60)  # >= 50, clamped to 49 → down=99
call = helper.perform_calls.last
puts call.inspect   # ["drag", 50, 50, 50, 99, 5]

helper.perform_calls.clear
helper.swipe_down(20)  # no clamping → down=70
call = helper.perform_calls.last
puts call.inspect   # ["drag", 50, 50, 50, 70, 5]

# Test swipe_up logic (boundary clamping)
helper.perform_calls.clear
helper.swipe_up(3)   # < 4, clamped to 5 → up=55
call = helper.perform_calls.last
puts call.inspect   # ["drag", 50, 50, 55, 50, 5]

helper.perform_calls.clear
helper.swipe_up(55)  # >= 50, clamped to 49 → up=99
call = helper.perform_calls.last
puts call.inspect   # ["drag", 50, 50, 99, 50, 5]

# Test MELGISH_CONDITIONS constant
puts Meglish::MELGISH_CONDITIONS[:timeout]       # => 30
puts Meglish::MELGISH_CONDITIONS[:clear_text]    # => true
puts Meglish::MELGISH_CONDITIONS[:confirm_alert] # => true
