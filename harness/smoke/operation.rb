require 'operation'

# Test Operations.success and Operations.failure factory methods
op_ok = Operations.success(:created, { object: 'user_42' })
puts op_ok.success?           # true
puts op_ok.failure?           # false
puts op_ok.code               # created
puts op_ok.metadata.inspect   # {:object=>"user_42"}

op_fail = Operations.failure(:not_found, { object: 'user_99' })
puts op_fail.success?         # false
puts op_fail.failure?         # true
puts op_fail.code             # not_found

# Test Operation directly with various success truthy values
op_true = Operation.new(success: true, code: 'ok')
puts op_true.success?         # true
puts op_true.code             # ok

op_one = Operation.new(success: 1, code: :done)
puts op_one.success?          # true

op_str_true = Operation.new(success: 'true', code: nil)
puts op_str_true.success?     # true
puts op_str_true.code.inspect # nil

op_no_code = Operation.new(success: false)
puts op_no_code.code.inspect  # nil
puts op_no_code.failure?      # true

# Test Operation::Defer (Deferrable mixin)
d = Operation::Defer.new
puts d.status          # unknown
puts d.percent         # 0
puts d.succeeded?      # false
puts d.failed?         # false
puts d.started?        # false

results = []
d.on_success { |arg| results << "success:#{arg}" }
d.on_failure { |arg| results << "failure:#{arg}" }
d.on_finish  { results << 'finished' }

d.start!(:begin_arg)
puts d.started?        # true
puts d.status          # started

d.succeed!(:result_val)
puts d.succeeded?      # true
puts d.percent         # 100
puts results.join(',') # success:result_val,finished

# Test a failing defer
d2 = Operation::Defer.new
d2.on_failure { |reason| results << "fail:#{reason}" }
d2.fail!(:timeout)
puts d2.failed?        # true
puts results.last      # fail:timeout

# Test progress!
d3 = Operation::Defer.new
progress_vals = []
d3.on_progress { |op| progress_vals << op.percent }
d3.progress!(25)
d3.progress!(50)
d3.progress!(75)
puts progress_vals.join(',')  # 75,50,25 (unshift ordering)
puts d3.perone                # 0.75
