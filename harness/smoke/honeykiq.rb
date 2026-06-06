require 'honeykiq'

# Stub sidekiq/api before any autoload triggers it
$LOADED_FEATURES << 'sidekiq/api'
module Sidekiq
  class Stats; end
  class ProcessSet; end
  class Queue; end
  class JobRecord; end
end

# Stub honeycomb-beeline before BeelineSpan autoload
$LOADED_FEATURES << 'honeycomb-beeline'
module Honeycomb
  module PropagationParser; end
end

# 1. VERSION constant
puts Honeykiq::VERSION

# 2. LibhoneySpan — pure timing logic, no external deps
span = Honeykiq::LibhoneySpan.allocate
puts span.class.name
puts span.private_methods.include?(:duration_ms) ? "has_duration_ms" : "no_duration_ms"
puts span.private_methods.include?(:now) ? "has_now" : "no_now"

# 3. BeelineSpan initializer — stores tracing_mode
bs = Honeykiq::BeelineSpan.new(:link)
puts bs.class.name
puts bs.instance_variable_get(:@tracing_mode).inspect

bs2 = Honeykiq::BeelineSpan.new(:child)
puts bs2.instance_variable_get(:@tracing_mode).inspect

bs3 = Honeykiq::BeelineSpan.new(nil)
puts bs3.instance_variable_get(:@tracing_mode).inspect

# 4. ServerMiddleware initializer — stores libhoney + tracing_mode
sm = Honeykiq::ServerMiddleware.new(tracing_mode: :link)
puts sm.class.name
puts sm.instance_variable_get(:@tracing_mode).inspect
puts sm.instance_variable_get(:@libhoney).inspect

sm2 = Honeykiq::ServerMiddleware.new(libhoney: :fake_client, tracing_mode: :child)
puts sm2.instance_variable_get(:@libhoney).inspect
puts sm2.instance_variable_get(:@tracing_mode).inspect

# 5. ServerMiddleware#extra_fields (public, pure default — returns {})
puts sm.extra_fields.inspect

# 6. PeriodicReporter#hashify_info — pure string parsing, no deps
pr = Honeykiq::PeriodicReporter.allocate
reply = "# Server\r\nredis_version:7.0.0\r\n# Clients\r\nconnected_clients:42\r\nblocked_clients:0\r\n"
result = pr.send(:hashify_info, reply)
puts result.class.name
puts result["redis_version"]
puts result["connected_clients"]
puts result["blocked_clients"]
puts result.key?("# Server") ? "bad_comment_key" : "comment_stripped"
puts result.key?("") ? "bad_empty_key" : "empty_stripped"

# 7. call_extra_fields arity dispatch (arity-0 branch)
class MyMiddleware < Honeykiq::ServerMiddleware
  def extra_fields
    { custom: "yes" }
  end
end
mm = MyMiddleware.new
puts mm.send(:call_extra_fields, :ignored_job).inspect

# 8. call_extra_fields arity dispatch (arity-1 branch)
class MyMiddlewareWithJob < Honeykiq::ServerMiddleware
  def extra_fields(job)
    { job_class: job.to_s }
  end
end
mm2 = MyMiddlewareWithJob.new
puts mm2.send(:call_extra_fields, "SomeWorker").inspect
