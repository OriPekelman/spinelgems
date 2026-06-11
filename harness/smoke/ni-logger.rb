# Smoke: NI_LOGGER constants and setup/options
puts NI_LOGGER::SEVERITY_TYPES.inspect
puts NI_LOGGER::SEVERITY_TYPES.length
puts NI_LOGGER::SEVERITY_TYPES.include?(:info)
puts NI_LOGGER::SEVERITY_TYPES.include?(:fatal)
NI_LOGGER.setup(context: :my_app, message: 'test message')
opts = NI_LOGGER.options
puts opts[:context]
puts opts[:message]
