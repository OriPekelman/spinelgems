# Test LogfileReader#process directly (pure string-slice method, no file I/O)
reader = LogfileReader.allocate

# Construct a line matching the fixed-width log format expected by #process:
# [2..20]  = 19-char timestamp
# [22..29] = 8-char float string
# [31..80] = 50-char query string
# [82..89] = 8-char integer string
# [92..94] = 3-char integer string
# [96..97] = 2-char integer string
line = " " * 98
line[2,  19] = "2024-01-15 12:00:00"
line[22,  8] = "1.234567"
line[31, 50] = "my_query_term" + " " * 37
line[82,  8] = "00000042"
line[92,  3] = "007"
line[96,  2] = "03"

result = reader.process(line)
puts result[0]           # timestamp string
puts result[1]           # float value
puts result[2]           # stripped query string
puts result[3]           # integer
puts result[4]           # integer
puts result[5]           # integer
