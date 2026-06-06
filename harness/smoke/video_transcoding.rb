# smoke: video_transcoding
# Exercises pure-computation methods in VideoTranscoding::Crop (no filesystem,
# no external tools) plus VERSION and COPYRIGHT constants.

require 'video_transcoding'

# Version and copyright constants
puts VideoTranscoding::VERSION
puts VideoTranscoding::COPYRIGHT

# Crop::handbrake_string — converts a crop hash to HandBrake format
crop = { top: 10, bottom: 20, left: 30, right: 40 }
puts VideoTranscoding::Crop.handbrake_string(crop)

# Crop::player_string — computes visible-area string for a player
puts VideoTranscoding::Crop.player_string(crop, 1920, 1080)

# Crop::drawbox_string — ffmpeg drawbox filter coordinates
puts VideoTranscoding::Crop.drawbox_string(crop, 1920, 1080)

# Crop::constrain — removes dominated crop axis (pure logic, no I/O)
# delta_x=70 > delta_y=30 → keeps left/right, zeros top/bottom
raw1 = { top: 10, bottom: 20, left: 30, right: 40 }
c1 = VideoTranscoding::Crop.constrain(raw1, 1920, 1080)
puts "constrain1: top=#{c1[:top]} bottom=#{c1[:bottom]} left=#{c1[:left]} right=#{c1[:right]}"

# delta_y=50 > delta_x=10 → keeps top/bottom, zeros left/right
raw2 = { top: 20, bottom: 30, left: 5, right: 5 }
c2 = VideoTranscoding::Crop.constrain(raw2, 1920, 1080)
puts "constrain2: top=#{c2[:top]} bottom=#{c2[:bottom]} left=#{c2[:left]} right=#{c2[:right]}"

# Console log levels are numeric constants
puts VideoTranscoding::Console::OFF
puts VideoTranscoding::Console::ERROR
puts VideoTranscoding::Console::WARN
puts VideoTranscoding::Console::INFO
puts VideoTranscoding::Console::DEBUG

# UsageError is a subclass of RuntimeError
begin
  raise VideoTranscoding::UsageError, "bad usage"
rescue VideoTranscoding::UsageError => e
  puts "caught: #{e.message}"
end
