puts Timecapsule.class
puts Timecapsule.send(:delete_commas, "hello,world")
puts Timecapsule.send(:delete_commas, "no commas here")
puts Timecapsule.send(:delete_commas, 42).inspect
