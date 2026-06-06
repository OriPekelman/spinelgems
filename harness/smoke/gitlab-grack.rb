# gitlab-grack smoke — exercises Grack::Git (no external deps) +
# inlines the packet-line helpers from Grack::Server (avoids rack).
#
# grack/bundle and grack/server require 'rack/*' (external dep not in
# the harness). We require only the self-contained lib files.

require 'grack/version'
require 'grack/git'

# VERSION
puts Grack::VERSION

# Grack::Git — pure command building, no I/O
git = Grack::Git.new('git', '/tmp/repo')
puts git.repo
puts git.command(%w[status]).inspect
puts git.command(%w[config http.uploadpack]).inspect
puts git.command(%w[rev-parse --git-dir]).inspect
puts git.popen_options.keys.sort.inspect

# Packet-line protocol helpers (inlined from Grack::Server — pure logic)
def pkt_write(str)
  (str.size + 4).to_s(16).rjust(4, '0') + str
end

def pkt_flush
  '0000'
end

def encode_chunk(chunk)
  crlf = "\r\n"
  size_in_hex = chunk.size.to_s(16)
  [size_in_hex, crlf, chunk, crlf].join
end

def terminating_chunk
  crlf = "\r\n"
  [0, crlf, crlf].join
end

line = "# service=git-upload-pack\n"
pkt  = pkt_write(line)
puts pkt
puts pkt.size
puts pkt_flush
puts encode_chunk("hello world").inspect
puts terminating_chunk.inspect
