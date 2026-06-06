require 'ruby-pgp'

# Patch gem bug: File.exists? removed in Ruby 3.2+
# The gem uses File.exists? in TempPathHelper#delete; patch it to File.exist?
module GPG
  class TempPathHelper
    def self.delete(path)
      File.delete(path) if File.exist?(path)
    end
    private_class_method :delete
  end
end

# 1. VERSION constant
puts "VERSION: #{PGP::VERSION}"

# 2. PGP::Log configuration
PGP::Log.verbose = false
puts "Log.verbose=false: #{PGP::Log.verbose}"
PGP::Log.verbose = true
puts "Log.verbose=true: #{PGP::Log.verbose}"
PGP::Log.verbose = false

# 3. GPG::TempPathHelper - pure Ruby, no gpg needed
captured_path = nil
GPG::TempPathHelper.create do |path|
  captured_path = path
  puts "TempPath generated: #{!path.nil? && path.length > 0}"
  File.write(path, "hello")
  puts "TempPath writable: #{File.exist?(path)}"
end
# After block, file should be cleaned up
puts "TempPath cleaned: #{!File.exist?(captured_path)}"
puts "TempPath in tmpdir: #{captured_path.start_with?(Dir.tmpdir)}"

# 4. Stub runner to exercise Engine and class logic
class StubRunner
  include PGP::LogCapable

  def version_default
    '2.4.4'
  end

  def import_key_from_file(path)
    # Parse recipients from embedded fake output
    fake_output = "sec   rsa4096 2023-01-01 [SC]\n      Key fingerprint = ABCD 1234 5678 90AB CDEF  0123 4567 89AB CDEF 0123\nuid           [ultimate] Test User <test@example.com>\n"
    fake_output.lines
               .map { |l| l.scan(/<(.+)>/m) }
               .flatten
               .reject(&:empty?)
               .uniq
  end

  def encrypt_file(path, out_path, recipients)
    content = File.read(path)
    File.write(out_path, "ENCRYPTED[#{content.strip}]FOR[#{recipients.join(',')}]")
    true
  end

  def decrypt_file(path, out_path, passphrase=nil)
    content = File.read(path)
    if content.start_with?("ENCRYPTED[")
      inner = content[/ENCRYPTED\[(.+)\]FOR/, 1]
      File.write(out_path, inner.to_s)
      true
    else
      false
    end
  end

  def read_public_key_fingerprints; []; end
  def read_private_key_fingerprints; []; end
  def read_public_key_recipients; ['test@example.com']; end
  def read_private_key_recipients; []; end
end

# 5. Exercise Engine#import_key via stub
engine = GPG::Engine.new(StubRunner.new)
recipients = engine.import_key("fake key content")
puts "Engine import_key returns array: #{recipients.is_a?(Array)}"
puts "Extracted recipient: #{recipients.first}"

# 6. Exercise Encryptor with stub engine
enc = PGP::Encryptor.new(nil, engine)
enc.recipients = ['test@example.com']
puts "Encryptor recipients: #{enc.recipients.inspect}"
# encrypt via stub
encrypted = enc.encrypt("hello spinel")
puts "Encryptor#encrypt returns string: #{encrypted.is_a?(String)}"
puts "Encrypted contains expected stub pattern: #{encrypted.include?('ENCRYPTED')}"

# 7. Exercise Decryptor with stub engine
dec = PGP::Decryptor.new(engine)
decrypted = dec.decrypt(encrypted)
puts "Decryptor#decrypt returns string: #{decrypted.is_a?(String)}"
puts "Decrypted content: #{decrypted}"

# 8. Verifier class instantiates
v = PGP::Verifier.new(engine)
puts "Verifier instantiated: #{v.is_a?(PGP::Verifier)}"

# 9. Signer class instantiates and respects passphrase attr
s = PGP::Signer.new(engine)
s.passphrase = "s3cr3t"
puts "Signer passphrase: #{s.passphrase}"

# 10. engine#read_recipients merges pub+priv uniq
recs = engine.read_recipients
puts "engine read_recipients: #{recs.inspect}"

puts "DONE"
