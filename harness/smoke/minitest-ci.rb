# minitest-ci smoke: exercise pure class-method constants on Minitest::Ci
puts Minitest::Ci.report_dir
puts Minitest::Ci.clean.inspect
puts Minitest::Ci.report?
