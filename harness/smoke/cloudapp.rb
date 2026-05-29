puts CloudApp::VERSION
puts CloudApp::VERSION.class
puts CloudApp::VERSION.split('.').length
puts CloudApp::VERSION.split('.').first
puts CloudApp::VERSION =~ /\A\d+\.\d+\.\d+\z/ ? "valid" : "invalid"
