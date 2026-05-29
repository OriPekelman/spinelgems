class App
  include AppRoutes

  def initialize
    super()
    get('/hello') { 'hello world' }
    get('/greet/:name') { |name| "hi #{name}" }
    get(%r{^/fixed$}) { 'fixed' }
    post('/submit') { 'submitted' }
  end
end

app = App.new

puts app.run_route('/hello')
puts app.run_route('/greet/alice')
puts app.run_route('/fixed')
puts app.run_route('/submit', 'POST')
puts app.run_route('/missing').inspect
puts app.get_routes.size
puts app.post_routes.size
