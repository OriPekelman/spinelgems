require 'maestro_plugin'

# Use mock mode so send_workitem_message is skipped
Maestro::MaestroWorker.mock!

# Build a concrete subclass with a simple action
class TestWorker < Maestro::MaestroWorker
  def greet
    name = get_field('name', 'World')
    save_output_value('greeting', "Hello, #{name}!")
  end
end

# Construct a workitem (the hash Maestro passes around)
workitem = {
  'fields' => {
    'name' => 'Spinel',
    Maestro::MaestroWorker::CONTEXT_OUTPUTS_META => {}
  },
  Maestro::MaestroWorker::OUTPUT_META => ''
}

worker = TestWorker.new
worker.workitem = workitem
worker.action   = :greet

# --- get_field / set_field ---
worker.greet
puts worker.get_field(Maestro::MaestroWorker::CONTEXT_OUTPUTS_META).inspect

# as_int / as_boolean reference Fixnum (removed in Ruby 3) in their elsif branches;
# only nil and TrueClass/FalseClass inputs safely skip that path
puts worker.as_int(nil, 7)
puts worker.as_boolean(nil)
puts worker.as_boolean(true)
puts worker.as_boolean(false)

# --- is_json? ---
puts worker.is_json?('{"key":"value"}')
puts worker.is_json?('not json')

# --- add_link ---
worker.add_link('GitHub', 'https://github.com')
worker.add_link('Docs',   'https://example.com/docs')
puts worker.get_field(Maestro::MaestroWorker::LINKS_META).length
puts worker.get_field(Maestro::MaestroWorker::LINKS_META).first['name']

# --- error helpers ---
worker.set_error('something went wrong')
puts worker.error
puts worker.error?

# --- MaestroDev::Plugin exceptions ---
begin
  raise MaestroDev::Plugin::PluginError, 'bad plugin'
rescue MaestroDev::Plugin::PluginError => e
  puts e.message
end

begin
  raise MaestroDev::Plugin::ConfigError, 'bad config'
rescue MaestroDev::Plugin::ConfigError => e
  puts e.message
end

# --- mock? toggle ---
puts Maestro::MaestroWorker.mock?
Maestro::MaestroWorker.unmock!
puts Maestro::MaestroWorker.mock?
