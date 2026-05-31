puts EY::Config::Local.config_path
puts EY::Config::Local.config_path.is_a?(String)
puts EY::Config.singleton_class.const_get(:DEPLOYED_CONFIG_PATH)
puts EY::Config.singleton_class.const_get(:PATHS_TO_CHECK).length
puts EY::Config.singleton_class.const_get(:PATHS_TO_CHECK).first
