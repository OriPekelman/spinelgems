# cocoapods-expert-difficulty smoke
# This gem is a CocoaPods plugin. Its only standalone code (no cocoapods dep)
# is the VERSION constant. The real logic (Pod::Specification monkey-patching)
# requires 'cocoapods' which is not available in this environment.
# We verify the module and version constant load correctly.

require 'cocoapods-expert-difficulty'

# Verify the module and version constant exist
puts CocoapodsExpertDifficulty::VERSION
puts CocoapodsExpertDifficulty::VERSION.split('.').length == 3
puts CocoapodsExpertDifficulty::VERSION =~ /\A\d+\.\d+\.\d+\z/ ? 'semver-ok' : 'bad-version'
