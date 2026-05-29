# smoke: samson_secret_puller
# Exercise FOLDER constant and module existence
puts SamsonSecretPuller::FOLDER
puts SamsonSecretPuller.respond_to?(:to_h)
puts SamsonSecretPuller.respond_to?(:replace_ENV!)
puts SamsonSecretPuller.is_a?(Module)
puts SamsonSecretPuller.name
