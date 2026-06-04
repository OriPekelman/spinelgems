# frozen_string_literal: true

require 'peach-ruby'

# 1. Version constant
puts Peach::VERSION

# 2. Configuration - set and read api_token and base_url
Peach.configure do |config|
  config.api_token = 'test-token-abc123'
  config.base_url = 'https://example.com/'
end
puts Peach.configuration.api_token
puts Peach.configuration.base_url

# 3. App::Request - init type (no screen required)
init_params = {
  type: 'app_execution.init',
  request: {
    params: { foo: 'bar' },
    context: { lang: 'en' },
    contact: { id: 42, name: 'Alice' }
  }
}
req = Peach::App::Request.new(init_params)
puts req.init?
puts req.in_progress?
puts req.reply_received?
puts req.params[:foo]
puts req.context[:lang]
puts req.contact.name

# 4. App::Request - in_progress type (requires screen)
ip_params = {
  type: 'app_execution.in_progress',
  screen: 'home',
  request: {
    params: { step: 2 },
    context: {},
    contact: { id: 7, name: 'Bob' }
  }
}
req2 = Peach::App::Request.new(ip_params)
puts req2.in_progress?
puts req2.current_screen

# 5. App::Response - navigate action
resp = Peach::App::Response.new(action: 'navigate', screen: 'checkout', data: { total: 99 }, context: { ref: 'x1' })
puts resp.action
puts resp.screen
body = resp.body
parsed = JSON.parse(body)
puts parsed['action']
puts parsed['screen']
puts parsed['data']['total']

# 6. App::Response - end action (no screen, no data)
resp_end = Peach::App::Response.new(action: 'end')
puts resp_end.action
body_end = resp_end.body
parsed_end = JSON.parse(body_end)
puts parsed_end['action']
puts parsed_end.key?('screen')

# 7. Error class hierarchy
puts Peach::BadRequestError.ancestors.include?(StandardError)
puts Peach::BadResponseError.ancestors.include?(StandardError)

# 8. App::Request from JSON string
json_str = JSON.generate({
  type: 'app_execution.reply_received',
  request: {
    params: {},
    context: { attempt: 1 },
    contact: { id: 9, name: 'Carol' }
  }
})
req3 = Peach::App::Request.new(json_str)
puts req3.reply_received?
puts req3.contact.name
