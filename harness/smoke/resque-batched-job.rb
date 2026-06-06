require 'resque-batched-job'

# 1. VERSION constant
puts Resque::Plugins::BatchedJob::VERSION

# 2. batch(id) -- pure string key computation; no Redis needed
class ReportJob
  extend Resque::Plugins::BatchedJob
end

puts ReportJob.batch('abc123')
puts ReportJob.batch(42)
puts ReportJob.batch('order-99')

# 3. after_batch_hooks pattern -- grep on class methods
class NotifyJob
  extend Resque::Plugins::BatchedJob

  def self.after_batch_notify(id, *args); end
  def self.after_batch_log(id, *args); end
  def self.other_method; end
end

hooks = NotifyJob.methods.grep(/^after_batch/).sort
puts hooks.inspect

# 4. Regex pattern used internally in batched_jobs to filter Redis entries
name   = ReportJob.name
regexp = /\A\{"class":"#{name}","args":\[/
candidates = [
  '{"class":"ReportJob","args":[1,2]}',
  '{"class":"OtherJob","args":[3]}',
  '{"class":"ReportJob","args":[]}',
  '{"class":"ReportJobExtra","args":[]}',
]
matched = candidates.grep(regexp)
puts matched.length
puts matched.first
