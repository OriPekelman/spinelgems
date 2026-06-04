# smoke: carrierwave-processing-dominant_color
# The gem has one runtime dep: miro (image dominant-color extraction).
# `require "miro"` appears at top-level in the main lib file, so the gem
# cannot be loaded at all without miro installed.
# The only standalone file is version.rb — a version-only smoke is rejected
# per spinelgems#4. Marking smoke-error.

require 'carrierwave/processing/dominant_color/version'
puts CarrierWave::Processing::DominantColor::VERSION
