# frozen_string_literal: true
# dartsass-sprockets: Rails/Sprockets SCSS integration shim.
# The gem's entry point chains: dartsass-sprockets.rb -> sassc/rails.rb
# which immediately does `require 'sassc-embedded'` (a native C ext that
# is NOT in the local gem tree), making the full require unusable here.
#
# What IS self-contained: the module/class scaffolding declared via
# require_relative chains within the gem. We exercise that by requiring
# just the VERSION file (no external deps) and then exercising the
# Importer constant structure — the only logic that can run standalone.
#
# The CSSExtension#import_for path-stripping is real gem logic:
#   '/some/app/assets/style.css' -> '/some/app/assets/style'
# That is what Sprockets calls to resolve `@import "style"` in SCSS.

require 'dartsass-sprockets'

puts SassC::Rails::VERSION
puts SassC::Rails::Importer::PREFIXS.inspect
puts SassC::Rails::Importer::EXTENSIONS.map(&:postfix).inspect
css_ext = SassC::Rails::Importer::CSSExtension.new
import = css_ext.import_for('/app/assets/style.css', '/app/assets', {})
puts import.path
