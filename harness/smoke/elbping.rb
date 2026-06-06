require 'elbping'
require 'elbping/latency_bucket'
require 'elbping/stats'
require 'elbping/display'

# Exercise LatencyBucket: sum, mean
lb = LatencyBucket.new
puts lb.sum    # 0 when empty
puts lb.mean   # 0 when empty

lb << 100
lb << 200
lb << 300
puts lb.sum    # 600
puts lb.mean   # 200
puts lb.min    # 100
puts lb.max    # 300

# Exercise Stats: add_node, register, total_loss, node_loss
stats = ElbPing::Stats.new
stats.add_node('10.0.0.1')
stats.add_node('10.0.0.2')

# Simulate successful pings for node 1
stats.register({ node: '10.0.0.1', code: 200, duration: 50 })
stats.register({ node: '10.0.0.1', code: 200, duration: 100 })

# Simulate one timeout (loss) for node 2
stats.register({ node: '10.0.0.2', code: 200, duration: 80 })
stats.register({ node: '10.0.0.2', code: :timeout, duration: 0 })

puts stats.total[:requests]           # 4
puts stats.total[:responses]          # 3
puts stats.node_loss('10.0.0.2')      # 0.5
puts (stats.total_loss * 100).to_i    # 25

# Exercise Display.response with a plain status hash
status = { node: '10.0.0.1', code: 200, duration: 50 }
ElbPing::Display.response(status)

# Exercise Display.summary
ElbPing::Display.summary(stats)
