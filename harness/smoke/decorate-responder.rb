require 'decorate-responder'

# Smoke test: exercise Responders::DecorateResponder#decorate_resource
# which has 3 dispatch paths. We build a small host object that includes
# the module and drive each path directly.

class TestHost
  include Responders::DecorateResponder

  attr_accessor :resource, :controller

  def initialize(ctrl)
    @controller = ctrl
  end
end

# --- Path 1: controller responds to :decorate ---
class ControllerWithDecorate
  def decorate(res)
    "controller_decorated(#{res})"
  end
end

host1 = TestHost.new(ControllerWithDecorate.new)
result1 = host1.decorate_resource("raw_resource")
puts "path1: #{result1}"

# --- Path 2: resource responds to :decorate, no decoration_context ---
class DecorableResource
  def decorate
    "resource_decorated"
  end
end

class PlainController; end

host2 = TestHost.new(PlainController.new)
result2 = host2.decorate_resource(DecorableResource.new)
puts "path2: #{result2}"

# --- Path 3: resource responds to :decorate AND controller has decoration_context ---
class DecorableResourceCtx
  def decorate(context: {})
    "resource_decorated_ctx(#{context.inspect})"
  end
end

class ControllerWithContext
  def decoration_context
    { role: :admin }
  end
end

host3 = TestHost.new(ControllerWithContext.new)
result3 = host3.decorate_resource(DecorableResourceCtx.new)
puts "path3: #{result3}"

# --- Path 4: no decorate on either side — resource returned as-is ---
class BareResource; end

host4 = TestHost.new(PlainController.new)
result4 = host4.decorate_resource(BareResource.new)
puts "path4_class: #{result4.class}"

# --- VERSION from version.rb (DecorateResponder module, no typo there) ---
require 'decorate-responder/version'
puts "version: #{DecorateResponder::VERSION}"
