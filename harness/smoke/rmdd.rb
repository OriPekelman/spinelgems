# rmdd smoke: exercises Configure, Server, DeployService (no thor/network needed)
require 'rmd/version'
require 'rmd/configure'
require 'rmd/server'
require 'rmd/deploy_service'

# Exercise Configure - set/get config
config = {
  'server' => {
    'production' => {
      'url'    => 'https://prod.example.com',
      'token'  => 'tok_prod',
      'master' => 'prod-master.example.com',
      'nginx'  => 'nginx.prod.example.com'
    },
    'staging' => {
      'url'    => 'https://staging.example.com',
      'token'  => 'tok_stg',
      'master' => 'staging-master.example.com',
      'nginx'  => 'nginx.staging.example.com'
    }
  }
}

Rmd::Configure.set(config)
puts Rmd::Configure.get['server'].keys.sort.inspect

# Exercise Server.all and Server.get
servers = Rmd::Server.all
puts servers.sort.inspect

prod = Rmd::Server.get('production')
puts prod.url
puts prod.token
puts prod.master
puts prod.nginx

stg = Rmd::Server.get('staging')
puts stg.url

# Exercise constants
puts Rmd::NAME
puts Rmd::TYPE.sort.inspect

# VERSION
puts Rmd::VERSION

# ServerNotFound is a StandardError
puts Rmd::ServerNotFound.ancestors.include?(StandardError)

# DeployService raises ServerNotFound for unknown server
begin
  Rmd::DeployService.deploy('unknown')
rescue Rmd::ServerNotFound => e
  puts "caught: #{e.message}"
end
