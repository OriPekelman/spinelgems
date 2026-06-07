require 'engineyard-recipes'
require 'engineyard-recipes/fetch_uri'
require 'engineyard-recipes/git_cmd'
require 'tmpdir'
require 'fileutils'

# 1. VERSION
puts Engineyard::Recipes::VERSION

# 2. GitCmd test_mode: in test mode, git commands are logged, not executed
Engineyard::Recipes::GitCmd.test_mode = true
puts Engineyard::Recipes::GitCmd.test_mode.inspect

# 3. FetchUri.normalize_fetched_project with a singular recipe folder
Dir.mktmpdir do |tmpdir|
  # Create a fake recipe directory
  recipe_dir = File.join(tmpdir, 'my-recipe')
  FileUtils.mkdir_p(File.join(recipe_dir, 'recipes'))
  File.write(File.join(recipe_dir, 'recipes', 'default.rb'), 'include_recipe "base"')

  store_path = File.join(tmpdir, 'output')

  # normalize_fetched_project should wrap in cookbooks/<recipe_name>/
  result_path, result_name = Engineyard::Recipes::FetchUri.normalize_fetched_project(recipe_dir, store_path)
  puts result_name
  puts File.directory?(File.join(result_path, 'cookbooks', 'my-recipe')).inspect
  puts File.exist?(File.join(result_path, 'cookbooks', 'my-recipe', 'recipes', 'default.rb')).inspect
end

# 4. FetchUri.normalize_fetched_project with explicit recipe_name override
Dir.mktmpdir do |tmpdir|
  recipe_dir = File.join(tmpdir, 'source-recipe')
  FileUtils.mkdir_p(File.join(recipe_dir, 'attributes'))
  File.write(File.join(recipe_dir, 'attributes', 'default.rb'), 'default[:app] = "myapp"')

  store_path = File.join(tmpdir, 'output2')

  result_path, result_name = Engineyard::Recipes::FetchUri.normalize_fetched_project(recipe_dir, store_path, 'custom-name')
  puts result_name
  puts File.directory?(File.join(result_path, 'cookbooks', 'custom-name')).inspect
  puts File.exist?(File.join(result_path, 'cookbooks', 'custom-name', 'attributes', 'default.rb')).inspect
end

# 5. Exception class hierarchy is correct
puts Engineyard::Recipes::FetchUri::UnknownPath.ancestors.include?(StandardError).inspect
puts Engineyard::Recipes::FetchUri::TargetPathNotGitRepository.ancestors.include?(StandardError).inspect
