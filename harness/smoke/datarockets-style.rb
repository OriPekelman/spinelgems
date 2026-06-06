# frozen_string_literal: true

# datarockets-style: RuboCop shared config + custom cops for datarockets.
# The gem defines cop message constants and a custom formatter.
# We stub the minimal RuboCop surface so the cop logic loads and the
# constants can be inspected without the full rubocop gem installed.

module RuboCop
  module Cop
    module Interpolation; end
    module Alignment; end
    module AutoCorrector
      def self.extended(base); end
    end
    class Cop
      def self.inherited(subclass); end
      def self.include(*mods); end
    end
    class Base
      def self.inherited(subclass); end
      def self.include(*mods); end
      def self.extend(*mods); end
    end
    module AlignmentCorrector
      def self.correct(*args); end
    end
  end
  module Formatter
    class ProgressFormatter
      def self.inherited(subclass); end
    end
  end
end

require "datarockets_style/version"
require "datarockets_style/cop/style/nested_interpolation"
require "datarockets_style/cop/layout/array_alignment_extended"

puts DatarocketsStyle::VERSION

puts DatarocketsStyle::Cop::Style::NestedInterpolation::MSG

align_msg = DatarocketsStyle::Cop::Layout::ArrayAlignmentExtended::ALIGN_PARAMS_MSG
fixed_msg = DatarocketsStyle::Cop::Layout::ArrayAlignmentExtended::FIXED_INDENT_MSG
puts align_msg
puts fixed_msg

# Verify the cops are subclasses of the expected base
puts DatarocketsStyle::Cop::Style::NestedInterpolation.ancestors.include?(RuboCop::Cop::Cop)
puts DatarocketsStyle::Cop::Layout::ArrayAlignmentExtended.ancestors.include?(RuboCop::Cop::Base)

# Verify message strings are frozen (frozen_string_literal: true)
puts DatarocketsStyle::Cop::Style::NestedInterpolation::MSG.frozen?
puts DatarocketsStyle::Cop::Layout::ArrayAlignmentExtended::ALIGN_PARAMS_MSG.frozen?
