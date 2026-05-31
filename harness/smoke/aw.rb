result = Aw.fork! { 6 * 7 }
puts result

result2 = Aw.fork! { "hello" + " world" }
puts result2

ok = Aw.fork? { 6 * 7 }
puts ok
