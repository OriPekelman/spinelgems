require 'with_env'

# Test with_env: temporarily sets environment variables
ENV['ORIG_VAR'] = 'original'

result = nil
WithEnv.with_env('TEST_VAR' => 'hello', 'ORIG_VAR' => 'overridden') do
  result = ENV['TEST_VAR']
  puts "inside with_env TEST_VAR=#{ENV['TEST_VAR']}"
  puts "inside with_env ORIG_VAR=#{ENV['ORIG_VAR']}"
end

puts "after with_env TEST_VAR=#{ENV['TEST_VAR'].inspect}"
puts "after with_env ORIG_VAR=#{ENV['ORIG_VAR']}"

# Test without_env: temporarily removes environment variables
ENV['TO_REMOVE'] = 'present'
ENV['TO_KEEP'] = 'kept'

WithEnv.without_env('TO_REMOVE') do
  puts "inside without_env TO_REMOVE=#{ENV['TO_REMOVE'].inspect}"
  puts "inside without_env TO_KEEP=#{ENV['TO_KEEP']}"
end

puts "after without_env TO_REMOVE=#{ENV['TO_REMOVE']}"
puts "after without_env TO_KEEP=#{ENV['TO_KEEP']}"

# Test without_env with multiple keys
ENV['KEY1'] = 'val1'
ENV['KEY2'] = 'val2'

WithEnv.without_env('KEY1', 'KEY2') do
  puts "inside without_env multi KEY1=#{ENV['KEY1'].inspect} KEY2=#{ENV['KEY2'].inspect}"
end

puts "after without_env multi KEY1=#{ENV['KEY1']} KEY2=#{ENV['KEY2']}"

# Test nesting: with_env inside with_env
WithEnv.with_env('NEST' => 'outer') do
  puts "nest outer NEST=#{ENV['NEST']}"
  WithEnv.with_env('NEST' => 'inner') do
    puts "nest inner NEST=#{ENV['NEST']}"
  end
  puts "nest restored NEST=#{ENV['NEST']}"
end

puts "nest gone NEST=#{ENV['NEST'].inspect}"
