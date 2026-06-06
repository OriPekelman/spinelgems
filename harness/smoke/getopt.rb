# smoke: getopt-declare — Getopt::Declare argument parsing
# Exercises: Declare.new with pre-supplied argv string, [] accessor,
#             []= setter, size, each iterator, parse method, and :i type.
# NOTE: The spec grammar requires tab(s) as flag/description separator.

require 'Getopt/Declare'

# ── 1. Scalar string parameters ─────────────────────────────────────────────
spec1 = <<'SPEC'
-in <infile>		Input file
-out <outfile>		Output file
SPEC

args1 = Getopt::Declare.new(spec1, '-in foo.txt -out bar.txt')
puts args1['-in']    # foo.txt
puts args1['-out']   # bar.txt
puts args1.size      # 2

# ── 2. Integer parameter type (:i) and boolean flag ─────────────────────────
spec2 = <<'SPEC'
-count <n:i>		An integer count
-verbose		Verbose flag
SPEC

args2 = Getopt::Declare.new(spec2, '-count 42 -verbose')
puts args2['-count']   # 42
puts args2['-count'].class  # Integer (or Fixnum on old Ruby)
puts args2.size        # 2

# ── 3. []= setter and each iterator ─────────────────────────────────────────
spec3 = <<'SPEC'
-x <val>		X value
-y <num:i>		Y integer
SPEC

args3 = Getopt::Declare.new(spec3, '-x hello -y 7')
puts args3['-x']   # hello
puts args3['-y']   # 7

args3['-x'] = 'overridden'
puts args3['-x']   # overridden

keys = []
args3.each { |k, _v| keys << k }
puts keys.sort.inspect   # ["-x", "-y"]

# ── 4. parse method — re-parse with new argument string ──────────────────────
spec4 = <<'SPEC'
-src <path>		Source path
-dst <path>		Destination path
SPEC

args4 = Getopt::Declare.new(spec4, '-src /tmp/a -dst /tmp/b')
puts args4['-src']   # /tmp/a
puts args4['-dst']   # /tmp/b

args4.parse('-src /tmp/c -dst /tmp/d')
puts args4['-src']   # /tmp/c
puts args4['-dst']   # /tmp/d
