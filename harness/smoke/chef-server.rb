# smoke: chef-server-webui
# Exercises the version constants from the gem's public lib entry point,
# plus the time_difference_in_hms helper (pure arithmetic, no Chef/Merb runtime needed).
require 'chef-server-webui'

# --- version constants ---
puts ChefServerWebui::VERSION
puts CHEF_SERVER_WEBUI_VERSION
puts CHEF_SERVER_WEBUI_ROOT.end_with?('chef-server-webui-10.30.4').inspect
puts ChefServerWebui::VERSION.split('.').map(&:to_i).inject(:+)

# --- status_helper: time_difference_in_hms (pure arithmetic) ---
# The helper lives in app/helpers/status_helper.rb which uses Merb modules
# and a Merb-specific String#/ path-join idiom. We stub just enough to load it.

class String
  def /(other)
    File.join(self, other)
  end
end

module Merb
  module StatusHelper
  end
end

module Kernel
  alias_method :_orig_require_csw, :require
  def require(name)
    return if name.include?('chef')
    _orig_require_csw(name)
  rescue LoadError
    # ignore missing Merb/Chef deps — we only need the method body
  end
end

# Freeze Time.now so output is deterministic
FROZEN_NOW = 1_700_000_000
class << Time
  def now
    at(FROZEN_NOW)
  end
end

gem_root = CHEF_SERVER_WEBUI_ROOT
load File.join(gem_root, 'app', 'helpers', 'status_helper.rb')

class TimeTestObj
  include Merb::StatusHelper
end

t = TimeTestObj.new

# 2h 3m 4s = 7384 seconds
puts t.time_difference_in_hms(FROZEN_NOW - 7384).inspect

# exactly 1 hour
puts t.time_difference_in_hms(FROZEN_NOW - 3600).inspect

# 59m 59s
puts t.time_difference_in_hms(FROZEN_NOW - 3599).inspect

# 0 seconds (same moment)
puts t.time_difference_in_hms(FROZEN_NOW).inspect
