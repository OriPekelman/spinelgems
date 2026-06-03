require 'rchardet'

# Test 1: pure ASCII text
ascii_text = "Hello, world! This is a simple ASCII string.".b
r1 = CharDet.detect(ascii_text)
puts "ASCII: encoding=#{r1['encoding']} confidence=#{r1['confidence']}"

# Test 2: UTF-8 with BOM — detector should immediately recognise it at confidence 1.0
utf8_bom = "\xEF\xBB\xBFHello UTF-8".b
r2 = CharDet.detect(utf8_bom)
puts "UTF-8 BOM: encoding=#{r2['encoding']} confidence=#{r2['confidence']}"

# Test 3: UTF-16 little-endian BOM
utf16le_bom = "\xFF\xFEH\x00e\x00l\x00l\x00o\x00".b
r3 = CharDet.detect(utf16le_bom)
puts "UTF-16LE BOM: encoding=#{r3['encoding']} confidence=#{r3['confidence']}"

# Test 4: UniversalDetector API — feed/close/result cycle
ud = CharDet::UniversalDetector.new
ud.reset
ud.feed("The quick brown fox jumps over the lazy dog.".b)
ud.close
r4 = ud.result
puts "UniversalDetector ASCII: encoding=#{r4['encoding']} confidence=#{r4['confidence']}"

# Test 5: result is a Hash with the expected keys
puts "result keys sorted: #{r4.keys.sort.join(',')}"
