# SimpleCov::Formatter::JSONFormatter is defined in the main entry file.
# instance_methods(false) should include :format which is defined there.
puts SimpleCov::Formatter::JSONFormatter.instance_methods(false).sort.inspect
puts SimpleCov::Formatter::JSONFormatter.new.is_a?(SimpleCov::Formatter::JSONFormatter)
puts SimpleCov::Formatter::JSONFormatter.superclass
