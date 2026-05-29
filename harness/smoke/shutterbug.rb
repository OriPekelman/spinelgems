puts Shutterbug::VERSION

cfg = Shutterbug::Configuration.new(
  uri_prefix:   "https://example.com",
  path_prefix:  "/shots",
  resource_dir: "/tmp"
)
puts cfg.url_prefix
puts cfg.use_s3?

cfg2 = Shutterbug::Configuration.new(
  s3_bin: "aws", s3_key: "KEY", s3_secret: "SECRET",
  resource_dir: "/tmp"
)
puts cfg2.use_s3?
puts cfg2.fs_path_for("abc.html")
