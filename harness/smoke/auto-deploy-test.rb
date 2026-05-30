obj = AutoDeployTest.new
puts obj.testable_method.inspect
puts obj.is_a?(AutoDeployTest)
puts AutoDeployTest.instance_methods(false).include?(:testable_method)
