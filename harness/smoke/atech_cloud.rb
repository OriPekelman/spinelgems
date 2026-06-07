require 'atech_cloud'

# The gem defines an AtechCloud module (nearly empty - it's a Capistrano recipe gem)
# Exercise the module definition and the string interpolation logic extracted from deploy.rb

puts AtechCloud.class          # Module
puts AtechCloud.name           # AtechCloud
puts AtechCloud.is_a?(Module)  # true

# Reproduce the deploy_to path logic from deploy.rb (standalone)
def deploy_to(application)
  "/opt/apps/#{application}"
end

puts deploy_to("myapp")   # /opt/apps/myapp
puts deploy_to("testapp") # /opt/apps/testapp

# Reproduce the environments logic from deploy.rb (standalone)
def environments(env = nil)
  env || ['production']
end

puts environments.inspect          # ["production"]
puts environments(['staging']).inspect  # ["staging"]

# Reproduce the Codebase repo URL parsing logic from deploy.rb (standalone)
def parse_codebase_url(url)
  if url =~ /git\@codebasehq\.com\:(.+)\/(.+)\/(.+)\.git\z/
    { account: $1, project: $2, repo: $3 }
  else
    nil
  end
end

url = "git" + "@codebasehq.com:myaccount/myproject/myrepo.git"
result = parse_codebase_url(url)
puts result[:account]   # myaccount
puts result[:project]   # myproject
puts result[:repo]      # myrepo

bad_url = "https://github.com/user/repo.git"
puts parse_codebase_url(bad_url).nil?  # true
