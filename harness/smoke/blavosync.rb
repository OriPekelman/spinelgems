require 'blavosync'

# ey_logger.rb reopens Capistrano::Logger to alias :log; stub it before loading
module Capistrano
  MAX_LEVEL = 4
  class Logger
    def log(level, message, line_prefix = nil); end
  end
end

require 'blavosync/lib/ey_logger'

# VERSION
puts Blavosync::VERSION

# EYLogger initial state: not set up
puts Capistrano::EYLogger.setup?      # false
puts Capistrano::EYLogger.successful? # false
puts Capistrano::EYLogger.failure?    # true

# setup() stores deploy_type after gsub(":", "_")
# stub config: EYLogger only lazily accesses config[:release_name]; not needed here
stub_config = Object.new
Capistrano::EYLogger.setup(stub_config, "deploy:cold", deploy_log_path: Dir.tmpdir)

puts Capistrano::EYLogger.setup?      # true
puts Capistrano::EYLogger.deploy_type # "deploy_cold"
puts Capistrano::EYLogger.successful? # true
puts Capistrano::EYLogger.failure?    # false

# close() flushes and resets the setup flag
Capistrano::EYLogger.close
puts Capistrano::EYLogger.setup?      # false
