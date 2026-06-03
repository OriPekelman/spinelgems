# Smoke: ruby-lsp-rspec
# Exercises: RubyLsp::RSpec::VERSION, DocumentSymbol#generate_name (string/call/nil),
# and RSpecFormatter#adjust_backtrace (pure string logic).
# External deps (ruby_lsp, rspec) are stubbed so Spinel's require-ignore matches CRuby.

require 'ruby-lsp-rspec'
puts RubyLsp::RSpec::VERSION

# -- Stub the deps that the sub-files require, so require_relative loads clean --
module RubyLsp
  module Requests; module Support; module Common; end; end; end
  module Interface
    class DocumentSymbol
      attr_reader :name, :kind, :children
      def initialize(name:, kind:, selection_range:, range:, children: nil)
        @name = name; @kind = kind; @children = children || []
      end
    end
  end
  module Constant
    module SymbolKind; METHOD = 6; MODULE = 2; end
  end
  class LspReporter; end
end

module RSpec
  module Core
    module Formatters
      class ProgressFormatter
        def initialize(output); end
      end
      def self.register(*args); end
    end
  end
end

# Stub Prism node types used by DocumentSymbol#generate_name
module Prism
  class StringNode
    attr_reader :unescaped
    def initialize(s); @unescaped = s; end
  end
  class CallNode
    attr_reader :name
    def initialize(n); @name = n; end
  end
end

# Intercept requires for external gems that Spinel would ignore anyway
module Kernel
  alias_method :_orig_require_rspec_stub, :require
  def require(path)
    return if path.include?('rspec') || path.include?('lsp_reporter') || path.include?('test_reporters') || path == 'ruby_lsp/addon' || path == 'ruby_lsp/internal'
    _orig_require_rspec_stub(path)
  end
end

# Load the files with real logic using require_relative-style paths
# (ruby-lsp-rspec's main entry only loads version.rb; the actual classes live under ruby_lsp/)
require_relative '../../../../.cache/spinel-compat/gems/ruby-lsp-rspec-0.1.29/lib/ruby_lsp/ruby_lsp_rspec/document_symbol'
require_relative '../../../../.cache/spinel-compat/gems/ruby-lsp-rspec-0.1.29/lib/ruby_lsp/ruby_lsp_rspec/rspec_formatter'

# -- Exercise DocumentSymbol#generate_name --
ds = RubyLsp::RSpec::DocumentSymbol.allocate

# Argument helper
class FakeArgs
  def initialize(*items); @items = items; end
  def arguments; @items; end
end
class FakeNode
  attr_reader :message, :receiver, :arguments
  def initialize(msg, *args)
    @message = msg; @arguments = FakeArgs.new(*args); @receiver = nil
  end
end

puts ds.generate_name(FakeNode.new('it', Prism::StringNode.new('does something useful')))
puts ds.generate_name(FakeNode.new('describe', Prism::CallNode.new(:MyClass)))
puts ds.generate_name(FakeNode.new('context', Prism::StringNode.new('when logged in')))

# nil argument list -> nil
class NilArgNode
  def message; 'context'; end
  def receiver; nil; end
  def arguments; nil; end
end
puts ds.generate_name(NilArgNode.new).inspect

# -- Exercise RSpecFormatter#adjust_backtrace --
fmt = RubyLsp::RSpec::RSpecFormatter.allocate

# Relative path -> expanded to file:// URI
result = fmt.adjust_backtrace('./spec/models/user_spec.rb:17:in block (2 levels) in <top>')
# Normalise cwd-dependent part so output is deterministic
puts result.sub(Dir.pwd, '/CWD')

# Absolute path passthrough
puts fmt.adjust_backtrace('/app/spec/services/auth_spec.rb:42:in method_name')

# Short entry (< 2 colons) returned unchanged
puts fmt.adjust_backtrace('no_colons_here')
