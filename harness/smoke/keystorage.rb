require 'keystorage'
require 'keystorage/manager'
require 'tmpdir'
require 'fileutils'

# Use a temp file so the smoke is self-contained and leaves no residue
tmpdir = Dir.mktmpdir('keystorage_smoke')
tmpfile = File.join(tmpdir, 'test.keystorage')

begin
  secret = 'Sm0k3T3st!'
  ks = Keystorage::Manager.new(file: tmpfile, secret: secret)

  # set stores an AES-encrypted entry and returns the encoded blob (non-empty)
  encoded = ks.set('mygroup', 'mykey', 'hello world')
  puts "set returns non-empty: #{!encoded.nil? && encoded.length > 0}"

  # get round-trips through decrypt
  val = ks.get('mygroup', 'mykey')
  puts "round-trip: #{val}"

  # groups lists group names (excludes internal '@' root)
  ks.set('anothergroup', 'token', 'secret42')
  grps = ks.groups.sort
  puts "groups: #{grps.join(',')}"

  # keys within a group
  ks.set('mygroup', 'anotherkey', 'value2')
  ks_keys = ks.keys('mygroup').sort
  puts "keys in mygroup: #{ks_keys.join(',')}"

  # render_text with array
  arr_out = ks.render(%w[alpha beta gamma])
  puts "render array: #{arr_out}"

  # render_text with string
  str_out = ks.render('just a string')
  puts "render string: #{str_out}"

  # RejectGroupName raised when '@' used as group
  begin
    ks.set('@', 'k', 'v')
    puts "no error raised"
  rescue Keystorage::RejectGroupName => e
    puts "RejectGroupName raised: #{e.message.include?('@')}"
  end
ensure
  FileUtils.rm_rf(tmpdir)
end
