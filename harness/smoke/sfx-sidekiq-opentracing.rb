# Smoke test for sfx-sidekiq-opentracing
# The gem's top-level requires sidekiq + opentracing (not available in Spinel env).
# We load the self-contained sub-files directly: version, constants, commons.
# These contain the real domain logic (span tag building, operation naming).

# Stub the minimum needed so the pure-Ruby files can be required standalone.
module Sidekiq; end

GEM_LIB = '/home/oripekelman/.cache/spinel-compat/gems/sfx-sidekiq-opentracing-0.0.4/lib'
require GEM_LIB + '/sidekiq/tracer/version'
require GEM_LIB + '/sidekiq/tracer/constants'
require GEM_LIB + '/sidekiq/tracer/commons'

# 1. VERSION constant
puts Sidekiq::Tracer::VERSION

# 2. TRACE_CONTEXT_KEY constant
puts Sidekiq::Tracer::TRACE_CONTEXT_KEY

# 3. operation_name — returns job['class']
class CommonsTest
  include Sidekiq::Tracer::Commons
end

helper = CommonsTest.new

job1 = { 'class' => 'HardWorker', 'queue' => 'default', 'jid' => 'abc123', 'retry' => true, 'args' => [1, 2, 3] }
puts helper.operation_name(job1)

# 4. tags — builds a hash with component, span.kind, queue, jid, retry, args
t = helper.tags(job1, 'client')
puts t['component']
puts t['span.kind']
puts t['sidekiq.queue']
puts t['sidekiq.jid']
puts t['sidekiq.retry']
puts t['sidekiq.args']

# 5. tags with a different kind + args truncation boundary (args join to <=1024)
job2 = { 'class' => 'EmailWorker', 'queue' => 'mailer', 'jid' => 'xyz999', 'retry' => false, 'args' => ['hello', 'world'] }
t2 = helper.tags(job2, 'server')
puts t2['span.kind']
puts t2['sidekiq.args']

# 6. operation_name with a namespaced class
job3 = { 'class' => 'Payments::ChargeJob' }
puts helper.operation_name(job3)
