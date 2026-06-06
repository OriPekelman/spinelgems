require 'service_caller'

# --- ServiceError ---
err = ServiceError.new(:not_found, error_message: 'item missing', extra: 42)
puts err.key.inspect           # :not_found
puts err.message               # item missing
puts err.error_obj.inspect     # {:extra=>42}

err2 = ServiceError.generate_from_exception(RuntimeError.new('boom'))
puts err2.key.inspect          # :internal_error
puts err2.message.include?('RuntimeError') # true

# --- Successful service ---
class AddService < ServiceCaller
  def initialize(a, b)
    @a = a
    @b = b
  end

  def call
    @result = @a + @b
  end
end

svc = AddService.call(3, 7)
puts svc.success?              # true
puts svc.failed?               # false
puts svc.result                # 10
puts svc.error.nil?            # true

# --- Failing service (raises ServiceError) ---
class FailService < ServiceCaller
  def call
    raise ServiceError.new(:forbidden, error_message: 'not allowed')
  end
end

fsvc = FailService.call
puts fsvc.success?             # false
puts fsvc.failed?              # true
puts fsvc.error.key.inspect    # :forbidden
puts fsvc.result.nil?          # true

# --- Service that raises a generic exception ---
class BoomService < ServiceCaller
  def call
    raise ArgumentError, 'bad arg'
  end
end

bsvc = BoomService.call
puts bsvc.success?             # false
puts bsvc.error.key.inspect    # :internal_error
puts bsvc.error.message.include?('ArgumentError') # true
