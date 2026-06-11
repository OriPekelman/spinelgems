# Smoke: github_repo_statistics — VERSION constant and Error class
puts GithubRepoStatistics::VERSION
puts GithubRepoStatistics::Error.superclass
puts GithubRepoStatistics::Error.ancestors.include?(StandardError)
puts GithubRepoStatistics::Error.ancestors.include?(RuntimeError)
begin
  raise GithubRepoStatistics::Error, "test error"
rescue GithubRepoStatistics::Error => e
  puts e.message
  puts e.is_a?(StandardError)
end
