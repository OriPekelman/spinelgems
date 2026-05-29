# Prop smoke: exercise pure API that needs no cache
puts Prop::VERSION
puts Prop::Key.normalize("hello")
puts Prop::Key.normalize(nil)
puts Prop::Key.normalize(42)
puts Prop::Key.normalize([:login, "user", 99])
puts Prop::Key.normalize([[:a, :b], "c"])
puts Prop::Options.leaky_bucket.inspect
