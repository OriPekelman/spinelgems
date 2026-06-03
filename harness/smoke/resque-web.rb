# smoke: resque-web (gem loads as resque_web)
# resque-web is a Rails engine; its direct require pulls in twitter-bootstrap-rails,
# jquery-rails (unavailable), and Rails::Engine. We stub those to reach the gem's
# own logic: ResqueWeb::Plugins registry and pure helper methods in
# FailuresHelper / QueuesHelper that have no Redis/Resque runtime dependency.

$LOADED_FEATURES << 'twitter-bootstrap-rails'
$LOADED_FEATURES << 'jquery-rails'

module Rails
  class Engine
    def self.isolate_namespace(mod); end
  end
end

require 'resque_web'
require 'resque_web/version'

# Stub resque/failure/redis_multi_queue so queues_helper loads cleanly
$LOADED_FEATURES << 'resque/failure/redis_multi_queue'
module Resque; module Failure; class RedisMultiQueue; end; end; end

# Load helper files from the gem's app/helpers directory
gem_lib = $LOAD_PATH.find { |p| File.exist?(File.join(p, 'resque_web.rb')) }
app_helpers = File.join(gem_lib, '../app/helpers/resque_web')
load File.join(app_helpers, 'failures_helper.rb')
load File.join(app_helpers, 'queues_helper.rb')

# 1. VERSION constant
puts ResqueWeb::VERSION

# 2. Plugins registry — constants added under ResqueWeb::Plugins are discovered
module ResqueWeb::Plugins
  module Scheduler; end
  module Retry; end
end
plugins = ResqueWeb::Plugins.plugins
puts plugins.length
puts plugins.map { |p| p.name.split('::').last }.sort.inspect

# 3. FailuresHelper pure logic (no Resque.* calls needed)
class FailureCtx
  include ResqueWeb::FailuresHelper
  def params; {}; end
  def failure_size; 55; end
  def failure_per_page; 20; end
  def failure_start_at; 0; end
end

fc = FailureCtx.new
puts fc.failure_date_format
puts fc.failure_end_at           # min(0+20, 55) => 20
puts fc.failure_per_page         # 20

# job_arguments with a real payload
job = { 'payload' => { 'args' => [42, 'hello', nil] } }
puts fc.job_arguments(job)

# job with no payload
puts fc.job_arguments({})

# 4. QueuesHelper pure helpers
puts ResqueWeb::QueuesHelper.instance_method(:queue_per_page).bind_call(Object.new)
puts ResqueWeb::QueuesHelper.instance_method(:failed_queue_name).bind_call(Object.new, 'critical')
