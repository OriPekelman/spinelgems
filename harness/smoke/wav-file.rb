require 'wav-file'
require 'stringio'

# Build a minimal valid WAV file in memory
# 16-bit mono, 44100 Hz, 4 samples
def build_wav_binary(hz: 44100, channels: 1, bit_per_sample: 16, samples: [0, 32767, -32768, 100])
  fmt = WavFile::Format.new(nil) # skip chunk-based init; set fields directly
  fmt.id            = 1          # PCM
  fmt.channel       = channels
  fmt.hz            = hz
  fmt.bitPerSample  = bit_per_sample
  fmt.blockSize     = channels * (bit_per_sample / 8)
  fmt.bytePerSec    = hz * fmt.blockSize

  pcm = samples.map { |s| [s].pack('s<') }.join  # signed 16-bit LE

  # Build raw chunk for data
  data_chunk = StringIO.new
  data_chunk.write('data')
  data_chunk.write([pcm.size].pack('V'))
  data_chunk.write(pcm)
  data_bin = data_chunk.string

  # Build full WAV: RIFF header + fmt chunk + data chunk
  fmt_bin = fmt.to_bin
  wav = StringIO.new
  wav.write('RIFF')
  wav.write([4 + 8 + fmt_bin.size + data_bin.size].pack('V'))
  wav.write('WAVE')
  wav.write('fmt ')
  wav.write([fmt_bin.size].pack('V'))
  wav.write(fmt_bin)
  wav.write(data_bin)
  wav.string
end

wav_bin = build_wav_binary
f = StringIO.new(wav_bin)
f.binmode

# Read back the format
fmt = WavFile.readFormat(f)
puts "id=#{fmt.id}"
puts "channel=#{fmt.channel}"
puts "hz=#{fmt.hz}"
puts "bytePerSec=#{fmt.bytePerSec}"
puts "bitPerSample=#{fmt.bitPerSample}"
puts "blockSize=#{fmt.blockSize}"

# Read all chunks and verify data chunk
f.rewind
format2, chunks = WavFile.readAll(f)
data_chunk = chunks.find { |c| c.name == 'data' }
puts "data_chunk_name=#{data_chunk.name}"

# Unpack the 4 samples back
samples = data_chunk.data.unpack('s<*')
puts "samples=#{samples.inspect}"

# Verify Format equality
f.rewind
fmt_copy = WavFile.readFormat(f)
puts "formats_equal=#{fmt == fmt_copy}"

# Round-trip: write to a new StringIO and read back
out = StringIO.new
out.binmode
f.rewind
format3, chunks3 = WavFile.readAll(f)
WavFile.write(out, format3, chunks3)
out.rewind
out.binmode
fmt_rt = WavFile.readFormat(out)
puts "roundtrip_hz=#{fmt_rt.hz}"
puts "roundtrip_channels=#{fmt_rt.channel}"
