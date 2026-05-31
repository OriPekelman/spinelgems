puts Service::VERSION

class MyService < Service
  def execute
    stop
  end
end

svc = MyService.new
puts svc.stopped?
puts svc.started?
puts svc.running?
svc.start
puts svc.stopped?
puts svc.started?
puts svc.running?
