require 'danger_review_requests'

# Stub the minimum from the `danger` gem so we can load the plugin class.
# Under Spinel, plain `require 'danger'` is a no-op (external gem ignored),
# so we provide the necessary types inline.
class String
  def danger_underscore
    gsub(/::/, '/')
      .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
      .gsub(/([a-z\d])([A-Z])/, '\1_\2')
      .tr('-', '_')
      .downcase
  end
end

module Danger
  class Plugin
    def self.all_plugins
      @all_plugins ||= []
    end
    def self.inherited(plugin)
      all_plugins.push(plugin)
    end
    def self.instance_name
      to_s.gsub('Danger', '').danger_underscore.split('/').last
    end
    def initialize(dangerfile)
      @dangerfile = dangerfile
    end
    def method_missing(method_sym, *args, **kwargs, &block)
      @dangerfile.send(method_sym, *args, **kwargs, &block)
    end
  end
end

# Now load the plugin (requires review_requests/review_requests)
require 'review_requests/version'
require 'review_requests/review_requests'

# --- Exercise real public API ---

# 1. Version constant
puts ReviewRequests::VERSION

# 2. Class hierarchy: Danger::ReviewRequests < Danger::Plugin
puts Danger::ReviewRequests.superclass.name

# 3. Plugin self-registration (inherited hook)
registered = Danger::Plugin.all_plugins.include?(Danger::ReviewRequests)
puts registered.to_s

# 4. instance_name (uses danger_underscore string extension)
puts Danger::ReviewRequests.instance_name

# 5. Instantiation and method_missing delegation to a stub dangerfile
stub_dangerfile = Object.new
def stub_dangerfile.pr_number; 42; end

plugin = Danger::ReviewRequests.new(stub_dangerfile)
puts plugin.pr_number
