require 'shoulda'
require 'shoulda/whenever/version'

# shoulda-whenever provides ScheduleMatcher — a matcher for whenever schedules.
# It operates on any object that has @jobs (a hash of duration => [job_objects]).
# Each job needs: #at (time), #roles, and @options[:task] (via instance_variable_get).
# We build minimal mock objects to exercise the real matching logic.

# Minimal mock job as a plain class (avoids Struct + ivar collision in Spinel codegen)
class MockJob
  attr_reader :at, :roles

  def initialize(task:, at: nil, roles: nil)
    @task  = task
    @at    = at
    @roles = roles
  end

  # ScheduleMatcher calls job.instance_variable_get("@options")[:task]
  def instance_variable_get(name)
    if name == "@options"
      { task: @task }
    else
      super
    end
  end
end

# Minimal mock schedule with @jobs as a hash keyed by duration
class MockSchedule
  def initialize
    @jobs = {}
  end

  def add_job(duration, job)
    @jobs[duration] ||= []
    @jobs[duration] << job
  end
end

# Include Shoulda::Whenever so schedule() / schedule_rake() helpers are available
include Shoulda::Whenever

# Build a schedule with a few jobs
sched = MockSchedule.new
sched.add_job(3600, MockJob.new(task: 'rake:cleanup', at: '2:00 am', roles: ['app']))
sched.add_job(3600, MockJob.new(task: 'rake:report'))
sched.add_job(:day,  MockJob.new(task: 'runner:sync', at: '3:00 am', roles: ['web', 'app']))

# --- Test 1: basic description ---
m = schedule('rake:cleanup')
puts "description: #{m.description}"

# --- Test 2: matches? with no filters (matches any occurrence of task) ---
m1 = schedule('rake:cleanup')
puts "matches rake:cleanup (no filter): #{m1.matches?(sched)}"

m2 = schedule('rake:report')
puts "matches rake:report (no filter): #{m2.matches?(sched)}"

m3 = schedule('nonexistent')
puts "matches nonexistent: #{m3.matches?(sched)}"

# --- Test 3: filter by duration ---
m4 = schedule('rake:cleanup').every(3600)
puts "rake:cleanup every 3600: #{m4.matches?(sched)}"

m5 = schedule('rake:cleanup').every(999)
puts "rake:cleanup every 999 (miss): #{m5.matches?(sched)}"

# --- Test 4: filter by time ---
m6 = schedule('rake:cleanup').at('2:00 am')
puts "rake:cleanup at 2:00 am: #{m6.matches?(sched)}"

m7 = schedule('rake:cleanup').at('9:00 pm')
puts "rake:cleanup at 9:00 pm (miss): #{m7.matches?(sched)}"

# --- Test 5: filter by roles ---
m8 = schedule('runner:sync').with_roles(['web', 'app'])
puts "runner:sync with roles: #{m8.matches?(sched)}"

m9 = schedule('runner:sync').with_role('db')
puts "runner:sync with role db (miss): #{m9.matches?(sched)}"

# --- Test 6: description and failure messages with chained filters ---
m10 = schedule('rake:cleanup').every(3600).at('2:00 am')
puts "description with filters: #{m10.description}"
puts "failure_message: #{m10.failure_message}"
puts "failure_message_when_negated: #{m10.failure_message_when_negated}"

# --- Test 7: alias methods ---
m11 = schedule_rake('rake:cleanup')
puts "schedule_rake description: #{m11.description}"

m12 = schedule_runner('runner:sync')
puts "schedule_runner description: #{m12.description}"

m13 = schedule_command('some:command')
puts "schedule_command description: #{m13.description}"

# --- Test 8: symbol duration ---
m14 = schedule('runner:sync').every(:day)
puts "runner:sync every :day: #{m14.matches?(sched)}"

puts "VERSION: #{Shoulda::Whenever::VERSION}"
