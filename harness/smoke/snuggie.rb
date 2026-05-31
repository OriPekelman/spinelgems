puts Snuggie::Version

cfg = Snuggie::Config.new
cfg.username = "alice"
cfg.password = "s3cr3t"
puts cfg.username
puts cfg.password

err = Snuggie::Errors::MissingArgument.new("oops")
puts err.class
puts err.message
puts err.is_a?(ArgumentError)
