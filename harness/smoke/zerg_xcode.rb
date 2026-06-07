require 'zerg_xcode'

# Minimal but valid pbxproj content for a round-trip test
MINI_PBX = <<~PBX
// !$*UTF8*$!
{
	archiveVersion = 1;
	classes = {
	};
	objectVersion = 45;
	objects = {
		AABBCC000000000000000001 = {isa = PBXProject; buildConfigurationList = AABBCC000000000000000002; compatibilityVersion = "Xcode 3.2"; developmentRegion = English; hasScannedForEncodings = 0; knownRegions = (en,); mainGroup = AABBCC000000000000000003; name = SmokeTest; projectRoot = ""; targets = (); };
		AABBCC000000000000000002 = {isa = XCConfigurationList; buildConfigurations = (); defaultConfigurationIsVisible = 0; defaultConfigurationName = Release; };
		AABBCC000000000000000003 = {isa = PBXGroup; children = (); name = SmokeTest; sourceTree = "<group>"; };
	};
	rootObject = AABBCC000000000000000001;
}
PBX

# 1. Test Lexer: tokenize a simple PBX fragment and count tokens
tokens = ZergXcode::Lexer.tokenize("{ key = value; }")
bare_strings = tokens.select { |t| t.is_a?(Array) }.map(&:first)
puts "Lexer bare strings: #{bare_strings.sort.join(', ')}"
puts "Lexer token count: #{tokens.length}"

# 2. Test Parser: parse a nested hash structure
hash = ZergXcode::Parser.parse("{ a = 1; b = 2; }")
keys = hash.keys.sort
puts "Parser keys: #{keys.join(', ')}"
puts "Parser a=#{hash['a']} b=#{hash['b']}"

# 3. Test Encoder: encode a hash and verify it contains expected keys
encoded = ZergXcode::Encoder.encode({ 'z' => 'last', 'a' => 'first' })
puts "Encoder starts with header: #{encoded.start_with?('// !$*UTF8*$!')}"
puts "Encoder keys sorted: #{encoded.include?('"a"') && encoded.index('"a"') < encoded.index('"z"')}"

# 4. Test Archiver round-trip: parse a minimal project and inspect root object
project = ZergXcode::Archiver.unarchive(MINI_PBX)
puts "Root isa: #{project.isa}"
puts "Root name: #{project['name']}"
puts "Object version: #{project.version}"

# 5. Test XcodeObject attribute access and xref_key
puts "xref_key[0]: #{project.xref_key[0]}"
puts "xref_name: #{project.xref_name}"
