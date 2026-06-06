require 'huginn_agent'
require 'huginn_agent/helper'

# 1. VERSION constant
puts HuginnAgent::VERSION

# 2. branch/remote attr_accessors default to nil
puts HuginnAgent.branch.nil?
puts HuginnAgent.remote.nil?

# 3. Set and read branch/remote
HuginnAgent.branch = 'develop'
HuginnAgent.remote = 'https://example.com/huginn.git'
puts HuginnAgent.branch
puts HuginnAgent.remote

# 4. load() accumulates load paths (tested via send to private reader)
HuginnAgent.load('path/to/lib_a', 'path/to/lib_b')
HuginnAgent.load('path/to/lib_c')
lp = HuginnAgent.send(:load_paths)
puts lp.length
puts lp.first

# 5. register() accumulates agent paths
HuginnAgent.register('agents/my_agent')
HuginnAgent.register('agents/other_agent', 'agents/third_agent')
ap = HuginnAgent.send(:agent_paths)
puts ap.length
puts ap.first

# 6. Helper.open3 — runs a trivial shell command (uses stdlib Open3 only)
status, output = HuginnAgent::Helper.open3('echo hello_open3')
puts status
puts output.strip
