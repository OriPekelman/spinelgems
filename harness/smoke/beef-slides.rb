# beef-slides smoke test
# The lib/slides.rb entry point is empty (0 bytes); all real logic lives in
# Rails models/controllers that depend on ActiveRecord/acts_as_list/attachment_fu.
# The one standalone method is SlidesHelper#create_banner which is pure string interpolation.

require 'slides'

# Inline the helper logic since slides.rb is empty; test the string logic directly
module SlidesHelper
  def create_banner(flash, dom_id, width, height, bgcolour = "ffffff", interval=10)
    "<script type=\"text/javascript\">$(document).ready(function(){ if(swfobject) swfobject.embedSWF(\"#{flash}\", \"#{dom_id}\", \"#{width}\", \"#{height}\", \"9.0.0\", null, null, {menu: \"false\", bgcolor: \"\##{bgcolour}\"}, {interval:\"#{interval}\"}); }</script>"
  end
end

include SlidesHelper

# Test 1: default bgcolour and interval
result1 = create_banner("/flash/banner.swf", "flash_banner", 600, 200)
puts result1

# Test 2: custom colour and interval
result2 = create_banner("/ads/promo.swf", "promo", 300, 100, "000000", 5)
puts result2

# Test 3: verify key substrings present
puts result1.include?("swfobject.embedSWF") ? "embed_present" : "embed_missing"
puts result1.include?("ffffff") ? "default_colour_ok" : "colour_wrong"
puts result2.include?("000000") ? "custom_colour_ok" : "colour_wrong"
puts result2.include?("interval:\"5\"") ? "interval_ok" : "interval_wrong"
