puts Ddr::Antivirus::VERSION
puts Ddr::Antivirus::Error.ancestors.include?(StandardError)
puts Ddr::Antivirus::VirusFoundError.ancestors.include?(Ddr::Antivirus::ResultError)
puts Ddr::Antivirus::ScannerError.ancestors.include?(Ddr::Antivirus::ResultError)
r = Ddr::Antivirus::ScanResult.new("/tmp/test.txt", "OK", scanned_at: Time.at(0).utc, version: "ddr-antivirus 3.0.0")
puts r.file_path
puts r.output
puts r.version
puts r.to_s
