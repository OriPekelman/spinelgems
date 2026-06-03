# frozen_string_literal: true
require 'ione'

# --- Future: resolved / map / flat_map / all / reduce ---

f1 = Ione::Future.resolved(21)
f2 = f1.map { |v| v * 2 }
puts f2.value                          # 42

f3 = Ione::Future.resolved(10)
f4 = f3.flat_map { |v| Ione::Future.resolved(v + 5) }
puts f4.value                          # 15

all = Ione::Future.all(
  Ione::Future.resolved(1),
  Ione::Future.resolved(2),
  Ione::Future.resolved(3)
)
puts all.value.inspect                 # [1, 2, 3]

reduced = Ione::Future.reduce(
  [Ione::Future.resolved(10), Ione::Future.resolved(20), Ione::Future.resolved(12)],
  0
) { |acc, v| acc + v }
puts reduced.value                     # 42

# --- Promise / fulfill / fail / recover ---

p1 = Ione::Promise.new
p1.fulfill('hello')
puts p1.future.value                   # hello

p2 = Ione::Promise.new
p2.fail(RuntimeError.new('oops'))
recovered = p2.future.recover { |e| "recovered: #{e.message}" }
puts recovered.value                   # recovered: oops

# --- Future: resolved? / failed? / completed? ---

rf = Ione::Future.resolved(99)
puts rf.resolved?                      # true
puts rf.failed?                        # false
puts rf.completed?                     # true

ff = Ione::Future.failed(StandardError.new('bad'))
puts ff.resolved?                      # false
puts ff.failed?                        # true

# --- ByteBuffer: append / read / read_int / read_short ---

buf = Ione::ByteBuffer.new
buf.append("\x00\x00\x00\x2A")        # big-endian 42 as 4-byte int
puts buf.length                        # 4
puts buf.read_int                      # 42
puts buf.empty?                        # true

buf2 = Ione::ByteBuffer.new
buf2.append("\x01\x00")               # big-endian 256 as 2-byte short
puts buf2.read_short                   # 256

buf3 = Ione::ByteBuffer.new("hello world")
puts buf3.length                       # 11
chunk = buf3.read(5)
puts chunk                             # hello
puts buf3.length                       # 6
