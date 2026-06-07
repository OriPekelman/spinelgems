# frozen_string_literal: true

# Redir: URL shortener Rack middleware (Mongoid-backed).
# mongoid and rack gems are not available; stub them to exercise pure logic.

# Intercept gem requires that aren't available in this env
module Kernel
  alias_method :_orig_require, :require
  def require(name)
    return true if name == 'mongoid' || name == 'rack'
    _orig_require(name)
  end
end

module Mongoid
  module Document
    def self.included(base)
      base.define_singleton_method(:field) { |*_args, **_kwargs| }
      base.define_singleton_method(:where) { |*_args, **_kwargs| [] }
    end
  end
end

module Rack
  module Utils
    def self.escape(s); s; end
  end
end

# Redirect class-level configuration
require 'model/redirect'

puts Redirect.host
puts Redirect.path
puts Redirect.append_tracking_info.inspect
puts Redirect.append_google_analytics.inspect

Redirect.host = 'http://short.ly'
Redirect.path = 'go'
puts Redirect.host
puts Redirect.path

Redirect.append_tracking_info = true
puts Redirect.append_tracking_info.inspect

Redirect.append_tracking_info = false
puts Redirect.append_tracking_info.inspect

# Rack::Redir URL parameter separator (pure string logic, no DB)
require 'rack/redir'

rr = Rack::Redir.new(nil)
puts rr.append_parameter_separater('http://example.com')
puts rr.append_parameter_separater('http://example.com?q=1')
puts rr.append_parameter_separater('http://example.com/path/to/page')
