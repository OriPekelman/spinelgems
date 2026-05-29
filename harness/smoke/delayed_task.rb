pt = DelayedTask::PerformableTask.new("db:migrate")
puts pt.task
puts pt.class
pt2 = DelayedTask::PerformableTask.new("test:all")
puts pt2.task
puts pt == pt2
puts pt == DelayedTask::PerformableTask.new("db:migrate")
