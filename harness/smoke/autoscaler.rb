require_relative "lib/autoscaler/binary_scaling_strategy"
require_relative "lib/autoscaler/linear_scaling_strategy"

class FakeSystem
  def initialize(any_work, total_work, workers)
    @any_work   = any_work
    @total_work = total_work
    @workers    = workers
  end
  def any_work?; @any_work; end
  def total_work; @total_work; end
  def workers; @workers; end
end

b = Autoscaler::BinaryScalingStrategy.new
puts b.call(FakeSystem.new(true,  0, 0), 0)
puts b.call(FakeSystem.new(false, 0, 0), 0)

b2 = Autoscaler::BinaryScalingStrategy.new(active_workers: 3)
puts b2.call(FakeSystem.new(true, 0, 0), 10)

l = Autoscaler::LinearScalingStrategy.new(max_workers: 4, worker_capacity: 10)
puts l.call(FakeSystem.new(false, 0,  0), 0)
puts l.call(FakeSystem.new(false, 20, 0), 0)
puts l.call(FakeSystem.new(false, 40, 0), 0)
