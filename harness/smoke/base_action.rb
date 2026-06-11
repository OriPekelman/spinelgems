action = Actions::Base.new(foo: 'bar')
puts action.success?
puts action.error?
puts action.err_msg

action.error(:not_found)
puts action.success?
puts action.error?
puts action.err_msg

action2 = Actions::Base.new
action2.set(:key, 42)
puts action2.get(:key)
puts action2.get(:missing).inspect
