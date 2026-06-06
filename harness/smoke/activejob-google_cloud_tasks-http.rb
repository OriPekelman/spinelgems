# Smoke: activejob-google_cloud_tasks-http
# Exercises module namespace, VERSION, and Adapter initializer logic.
# Stubs out google/cloud/tasks and rack before loading gem files.

require 'json'

# Stub google/cloud/tasks and gapic/grpc so adapter.rb doesn't blow up
$LOADED_FEATURES << 'google/cloud/tasks' unless $LOADED_FEATURES.include?('google/cloud/tasks')
$LOADED_FEATURES << 'gapic/grpc'        unless $LOADED_FEATURES.include?('gapic/grpc')
$LOADED_FEATURES << 'rack'              unless $LOADED_FEATURES.include?('rack')

module Google
  module Cloud
    module Tasks
      def self.cloud_tasks(**_kwargs)
        raise NotImplementedError, "stubbed GCP client"
      end
    end
  end
  module Protobuf
    class Timestamp
      attr_accessor :seconds
      def initialize(seconds: 0)
        @seconds = seconds
      end
    end
  end
end

module Gapic
  module GRPC; end
end

module Rack
  class Request
    def initialize(env); @env = env; end
  end
end

module ActiveJob
  class Base
    def self.execute(_payload); end
  end
end

D = '/home/oripekelman/.cache/spinel-compat/gems/activejob-google_cloud_tasks-http-0.4.0'

require_relative "#{D}/lib/active_job/google_cloud_tasks/http/version"
require_relative "#{D}/lib/active_job/google_cloud_tasks/http/adapter"

# 1. VERSION constant
puts ActiveJob::GoogleCloudTasks::HTTP::VERSION

# 2. Adapter initializer — stores keyword args
adapter = ActiveJob::GoogleCloudTasks::HTTP::Adapter.new(
  project: 'my-project',
  location: 'us-east1',
  url: 'https://example.com/jobs'
)
puts adapter.enqueue_after_transaction_commit?   # false (default)

adapter2 = ActiveJob::GoogleCloudTasks::HTTP::Adapter.new(
  project: 'proj',
  location: 'eu-west1',
  url: 'https://example.com/jobs',
  enqueue_after_transaction_commit: true
)
puts adapter2.enqueue_after_transaction_commit?  # true

# 3. Exercise enqueue → triggers client call → our stub raises NotImplementedError
mock_job = Object.new
def mock_job.queue_name; 'default'; end
def mock_job.serialize; {'job_class' => 'MyJob', 'arguments' => [42]}; end

begin
  adapter.enqueue(mock_job)
rescue NotImplementedError => e
  puts "stub raised: #{e.message}"
end

# 4. build_task is private, but we can test it via the JSON body indirectly:
#    enqueue_at delegates to enqueue, which calls build_task → then client.create_task
begin
  adapter.enqueue_at(mock_job, Time.now)
rescue NotImplementedError => e
  puts "enqueue_at stub raised: #{e.message}"
end

puts "done"
