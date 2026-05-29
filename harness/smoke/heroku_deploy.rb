# heroku_deploy - basic class introspection (tasks.rb needs rake; not triggered here)
puts HerokuDeploy.name
puts HerokuDeploy.superclass.name
puts HerokuDeploy.instance_methods(false).length
puts HerokuDeploy.const_defined?(:Tasks, false)
h = HerokuDeploy.new
puts h.is_a?(HerokuDeploy)
puts h.class.name
