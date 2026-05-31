puts Smbhash::Private.normalize_encoding('UTF-8')
puts Smbhash::Private.normalize_encoding('ISO-8859-1')
puts Smbhash::Private.normalize_encoding('UTF-16LE')
puts Smbhash::Private.same_encoding?('UTF-8', 'utf_8').inspect
puts Smbhash::Private.same_encoding?('UTF-8', 'ISO-8859-1').inspect
puts Smbhash::Private.same_encoding?('utf-8', 'UTF_8').inspect
