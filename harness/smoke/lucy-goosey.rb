puts Lucy::Goosey::VERSION
puts Lucy::Goosey.flag?("--foo").class
puts Lucy::Goosey.flag?("bar").inspect
puts Lucy::Goosey.deflag("--verbose")
puts Lucy::Goosey.deflag("-x")
opts = Lucy::Goosey.parse(["--name=Alice", "--verbose", "-n", "42"])
puts opts["name"]
puts opts["verbose"]
puts opts["n"]
