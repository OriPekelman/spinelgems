rows = LTSV.parse("host:web1\tstatus:200\nhost:web2\tstatus:404\n")
rows.each { |r| puts r.map { |k, v| "#{k}=#{v}" }.join(",") }
