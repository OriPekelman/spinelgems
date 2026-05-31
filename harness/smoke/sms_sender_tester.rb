result = SmsSenderTester.send_sms({user: 'test'}, '1234567890', 'hello', 'SENDER', {raise_error: true})
puts result.class
puts result[:error]
begin
  SmsSenderTester.send_sms({}, '555', 'hi', 'SND', {raise_exception: true})
rescue RuntimeError => e
  puts e.message
end
puts 'done'
